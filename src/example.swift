@_silgen_name("_ctx_prepare")
func prepareContext(using buffer: UnsafeMutableRawPointer,
                    and stack: UnsafeMutableRawPointer,
                    running fn: ()->Void) -> Int

@_silgen_name("_ctx_switch")
func switchContext(from prev: UnsafeMutableRawPointer,
                   to new: UnsafeMutableRawPointer)
var x = 0
var func_reg_buf = UnsafeMutableRawPointer.allocate(bytes: 100, alignedTo: 4)
var stack_buf = UnsafeMutableRawPointer.allocate(bytes: 8000, alignedTo: 4)
var main_reg_buf = UnsafeMutableRawPointer.allocate(bytes: 100, alignedTo: 4) 

func hello() {
    switchContext(from: func_reg_buf, to: main_reg_buf)
}

for i in 0...100000000 {
    x = prepareContext(using: func_reg_buf, and: stack_buf, running: hello)
    switchContext(from: main_reg_buf, to: func_reg_buf)
}

