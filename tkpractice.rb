require 'tk'
root = TkRoot.new { title "Hello, World!" }
TkLabel.new(root) do
   text 'Hello, World! This is a longer line just to see what happens.'
   pack { padx 15 ; pady 15; side 'left' }
end

button_click = Proc.new {
  Tk.getOpenFile
}

button = TkButton.new(root) do
  text "Click Meh!"
  pack("side" => "left",  "padx"=> "50", "pady"=> "50")
end

button.comman = button_click

Tk.mainloop
