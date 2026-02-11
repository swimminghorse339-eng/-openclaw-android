"""Kivy Android Remote Control UI
Build with: buildozer.spec (see BUILD.md)
"""
import json
from kivy.app import App
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.gridlayout import GridLayout
from kivy.uix.button import Button
from kivy.uix.textinput import TextInput
from kivy.uix.label import Label
from kivy.uix.popup import Popup
import requests


# Default configuration
DEFAULT_SERVER = "http://192.168.1.100:5000"
DEFAULT_TOKEN = "remote-token-1234"


class RemoteControlApp(App):
    def build(self):
        self.title = "Windows Remote"
        return MainLayout()


class MainLayout(BoxLayout):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.orientation = "vertical"
        self.padding = 10
        self.spacing = 10
        
        # Configuration section
        self.add_widget(Label(text="Server URL:"))
        self.server_input = TextInput(text=DEFAULT_SERVER, multiline=False)
        self.add_widget(self.server_input)
        
        self.add_widget(Label(text="Auth Token:"))
        self.token_input = TextInput(text=DEFAULT_TOKEN, multiline=False, password=True)
        self.add_widget(self.token_input)
        
        # Status label
        self.status_label = Label(text="Ready", size_hint_y=None, height=30)
        self.add_widget(self.status_label)
        
        # Control grid
        controls = GridLayout(cols=2, spacing=10, size_hint_y=None, height=300)
        
        # Row 1
        controls.add_widget(self.make_btn("Lock Screen", self.lock_screen))
        controls.add_widget(self.make_btn("Screenshot", self.take_screenshot))
        
        # Row 2
        controls.add_widget(self.make_btn("Volume Up", self.volume_up))
        controls.add_widget(self.make_btn("Volume Down", self.volume_down))
        
        # Row 3
        controls.add_widget(self.make_btn("Launch Notepad", lambda: self.launch_app("notepad")))
        controls.add_widget(self.make_btn("Launch Browser", lambda: self.launch_app("chrome")))
        
        # Row 4 - Mouse
        controls.add_widget(self.make_btn("Mouse Left", lambda: self.mouse_click("left")))
        controls.add_widget(self.make_btn("Mouse Right", lambda: self.mouse_click("right")))
        
        # Row 5 - Keyboard
        controls.add_widget(self.make_btn("Copy (Ctrl+C)", lambda: self.key_combo("ctrl", "c")))
        controls.add_widget(self.make_btn("Paste (Ctrl+V)", lambda: self.key_combo("ctrl", "v")))
        
        self.add_widget(controls)
        
        # Type section
        self.add_widget(Label(text="Type text:"))
        
        type_row = BoxLayout(size_hint_y=None, height=50)
        self.type_input = TextInput(multiline=False)
        type_row.add_widget(self.type_input)
        type_btn = Button(text="Send", size_hint_x=None, width=80)
        type_btn.bind(on_press=self.send_type)
        type_row.add_widget(type_btn)
        self.add_widget(type_row)
        
        # Test connection button
        test_btn = Button(text="Test Connection", size_hint_y=None, height=40)
        test_btn.bind(on_press=self.test_connection)
        self.add_widget(test_btn)
    
    def make_btn(self, text, callback):
        btn = Button(text=text)
        btn.bind(on_press=callback)
        return btn
    
    def get_headers(self):
        return {"X-Token": self.token_input.text}
    
    def get_url(self, path):
        return f"{self.server_input.text}{path}"
    
    def api_call(self, method, path, data=None):
        try:
            url = self.get_url(path)
            headers = self.get_headers()
            
            if method == "POST":
                r = requests.post(url, json=data, headers=headers, timeout=10)
            else:
                r = requests.get(url, headers=headers, timeout=10)
            
            return {"ok": r.status_code == 200, "data": r.json()}
        except Exception as e:
            return {"ok": False, "error": str(e)}
    
    def lock_screen(self, *args):
        r = self.api_call("POST", "/api/lock")
        self.status_label.text = "Locked!" if r["ok"] else f"Error: {r.get('error')}"
    
    def take_screenshot(self, *args):
        r = self.api_call("GET", "/api/screenshot")
        if r["ok"]:
            self.status_label.text = f"Screenshot: {r['data'].get('width')}x{r['data'].get('height')}"
        else:
            self.status_label.text = f"Error: {r.get('error')}"
    
    def volume_up(self, *args):
        r = self.api_call("POST", "/api/volume", {"volume": 80})
        self.status_label.text = "Volume up" if r["ok"] else f"Error: {r.get('error')}"
    
    def volume_down(self, *args):
        r = self.api_call("POST", "/api/volume", {"volume": 30})
        self.status_label.text = "Volume down" if r["ok"] else f"Error: {r.get('error')}"
    
    def launch_app(self, app_name, *args):
        r = self.api_call("POST", "/api/app", {"app": app_name})
        self.status_label.text = f"Launched {app_name}" if r["ok"] else f"Error: {r.get('error')}"
    
    def mouse_click(self, button, *args):
        r = self.api_call("POST", "/api/mouse/click", {"button": button})
        self.status_label.text = f"Mouse {button}" if r["ok"] else f"Error: {r.get('error')}"
    
    def key_combo(self, mod, key, *args):
        r = self.api_call("POST", "/api/keyboard/key", {"key": key, "modifiers": [mod]})
        self.status_label.text = f"Pressed {mod}+{key}" if r["ok"] else f"Error: {r.get('error')}"
    
    def send_type(self, *args):
        text = self.type_input.text
        if text:
            r = self.api_call("POST", "/api/keyboard/type", {"text": text})
            self.status_label.text = f"Typed {len(text)} chars" if r["ok"] else f"Error: {r.get('error')}"
            self.type_input.text = ""
    
    def test_connection(self, *args):
        self.status_label.text = "Testing..."
        r = self.api_call("GET", "/api/status")
        if r["ok"]:
            self.status_label.text = "Connected!"
            popup = Popup(title="Success", content=Label(text="Connected to server!"), size_hint=(0.6, 0.3))
            popup.open()
        else:
            self.status_label.text = f"Failed: {r.get('error', 'Unknown error')}"
            popup = Popup(title="Error", content=Label(text=f"Connection failed:\n{r.get('error')}"), size_hint=(0.8, 0.4))
            popup.open()


if __name__ == "__main__":
    RemoteControlApp().run()
