import pygtk
pygtk.require('2.0')
import gtk
import webkit
import gobject
import eoq
import os

class Browser:
    default_site = "http://localhost/eoqui"
	
    def delete_event(self, widget, event, data=None):
        return False

    def destroy(self, widget, data=None):
        gtk.main_quit()

    def __init__(self):
        gobject.threads_init()
        self.window = gtk.Window(gtk.WINDOW_TOPLEVEL)
        self.window.set_title('EOQ IDE')
        self.window.maximize()
        self.window.connect("delete_event", self.delete_event)
        self.window.connect("destroy", self.destroy)
        self.web_view = webkit.WebView()
        self.web_view.open(self.default_site)

        toolbar = gtk.Toolbar()
        self.home_button = gtk.ToolButton(gtk.STOCK_HOME)
        self.home_button.connect("clicked", self.go_home)

        self.back_button = gtk.ToolButton(gtk.STOCK_GO_BACK)
        self.back_button.connect("clicked", self.go_back)

        self.forward_button = gtk.ToolButton(gtk.STOCK_GO_FORWARD)
        self.forward_button.connect("clicked", self.go_forward)
        execute_button = gtk.ToolButton(gtk.STOCK_EXECUTE)
        execute_button.connect("clicked", self.execute)

        refresh_button = gtk.ToolButton(gtk.STOCK_REFRESH)
        refresh_button.connect("clicked", self.refresh)

        toolbar.add(self.home_button)
        toolbar.add(self.back_button)
        toolbar.add(self.forward_button)
        toolbar.add(refresh_button)
        toolbar.add(execute_button)

        self.web_view.connect("load_committed", self.update_buttons)

        scroll_window = gtk.ScrolledWindow(None, None)
        scroll_window.add(self.web_view)
        

        vbox = gtk.VBox(False, 0)
        vbox.pack_start(toolbar, False, True, 0)
        vbox.add(scroll_window)

        self.window.add(vbox)
        self.window.show_all()
    def execute(self, widge, data= None):
		method = "Nativo"
		eoq.executeEoq(method)
		if method == "GAMS":
			self.web_view.open("file:///"+os.path.dirname(os.path.realpath(__file__)) + "/output/reportGAMS.html")
		else:
			self.web_view.open("file:///"+os.path.dirname(os.path.realpath(__file__)) + "/output/report.html")

    def go_home(self, widge, data= None):
		self.web_view.open(self.default_site)

    def on_active(self, widge, data=None):
        '''When the user enters an address in the bar, we check to make
           sure they added the http://, if not we add it for them.  Once
           the url is correct, we just ask webkit to open that site.'''
        url = self.default_site
        try:
            url.index("://")
        except:
            url = "http://"+url
        self.url_bar.set_text(url)
        self.web_view.open(url)

    def go_back(self, widget, data=None):
        '''Webkit will remember the links and this will allow us to go
           backwards.'''
        self.web_view.go_back()

    def go_forward(self, widget, data=None):
        '''Webkit will remember the links and this will allow us to go
           forwards.'''
        self.web_view.go_forward()

    def refresh(self, widget, data=None):
        '''Simple makes webkit reload the current back.'''
        self.web_view.reload()

    def update_buttons(self, widget, data=None):
        '''Gets the current url entry and puts that into the url bar.
           It then checks to see if we can go back, if we can it makes the
           back button clickable.  Then it does the same for the foward
           button.'''
        self.back_button.set_sensitive(self.web_view.can_go_back())
        self.forward_button.set_sensitive(self.web_view.can_go_forward())

    def main(self):
        gtk.main()

if __name__ == "__main__":
    browser = Browser()
    browser.main()


