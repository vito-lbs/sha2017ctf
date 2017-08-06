proj = angr.Project('100',
                    load_options={'auto_load_libs': False})
add_options={simuvex.o.BYPASS_UNSUPPORTED_SYSCALL}
path_group = proj.factory.path_group(threads=1)
path_group.explore(find=0x8049dd3)
