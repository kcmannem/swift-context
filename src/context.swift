@_silgen_name("_ctx_prepare")
func prepareContext(using buffer: UnsafeMutableRawPointer,
                    and stack: UnsafeMutableRawPointer,
                    running fn: ()->Void) -> Int

@_silgen_name("_ctx_switch")
func switchContext(from prev: UnsafeMutableRawPointer,
                   to new: UnsafeMutableRawPointer)
