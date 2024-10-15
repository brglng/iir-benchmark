option('sections', {
    default = 20,
    showmenu = true,
    after_check = function (option)
        option:add('defines', 'SECTIONS=' .. option:value())
    end
})

option('duration', {
    default = 600,
    showmenu = true,
    after_check = function (option)
        option:add('defines', 'DURATION=' .. option:value())
    end
})

target('chirp', {
    kind = 'binary',
    files = { 'chirp.cpp' },
    options = {
        'sections',
        'duration'
    }
})

target('iir-sample', {
    kind = 'binary',
    files = { 'iir_sample.cpp' },
    languages = { 'cxx17' },
    options = { 'sections' }
})

target('iir-sample-var', {
    kind = "binary",
    files = { "iir_sample_var.cpp" },
    languages = { 'cxx17' },
    options = { 'sections' }
})

target('iir-sample-noinline', {
    kind = 'binary',
    files = { 'iir_sample_noinline.cpp' },
    languages = { 'cxx17' },
    options = { 'sections' }
})

target('iir-sample-var-noinline', {
    kind = 'binary',
    files = { 'iir_sample_var_noinline.cpp' },
    languages = { 'cxx17' },
    options = { 'sections' }
})

target('iir-block', {
    kind = 'binary',
    files = { 'iir_block.cpp' },
    languages = { 'cxx17' },
    options = { 'sections' }
})

target('iir-block-var', {
    kind = 'binary',
    files = { 'iir_block_var.cpp' },
    languages = { 'cxx17' },
    options = { 'sections' }
})

target('1', {
    kind = 'phony',
    deps = { 'chirp', 'iir-sample', 'iir-sample-var', 'iir-sample-noinline', 'iir-sample-var-noinline', 'iir-block', 'iir-block-var' },
    on_run = function (target)
        import('core.project.project')
        for targetname, target in pairs(project.targets()) do
            os.runv(target:targetfile(), { '1', tostring(option.get('sections')) })
        end
    end
})

target('32', {
    kind = 'phony',
    deps = { 'chirp', 'iir-sample', 'iir-sample-var', 'iir-sample-noinline', 'iir-sample-var-noinline', 'iir-block', 'iir-block-var' },
    on_run = function (target)
        import('core.project.project')
        for targetname, target in pairs(project.targets()) do
            os.runv(target:targetfile(), { '32', tostring(option.get('sections')) })
        end
    end
})

target('256', {
    kind = 'phony',
    deps = { 'chirp', 'iir-sample', 'iir-sample-var', 'iir-sample-noinline', 'iir-sample-var-noinline', 'iir-block', 'iir-block-var' },
    on_run = function (target)
        import('core.project.project')
        for targetname, target in pairs(project.targets()) do
            os.runv(target:targetfile(), { '256', tostring(option.get('sections')) })
        end
    end
})

target('512', {
    kind = 'phony',
    deps = { 'chirp', 'iir-sample', 'iir-sample-var', 'iir-sample-noinline', 'iir-sample-var-noinline', 'iir-block', 'iir-block-var' },
    on_run = function (target)
        import('core.project.project')
        os.runv(project.target('chirp'):targetfile(), option.get('duration'))
        for targetname, target in pairs(project.targets()) do
            os.runv(target:targetfile(), { '512', tostring(option.get('sections')) })
        end
    end
})

target('1024', {
    kind = 'phony',
    deps = { 'chirp', 'iir-sample', 'iir-sample-var', 'iir-sample-noinline', 'iir-sample-var-noinline', 'iir-block', 'iir-block-var' },
    on_run = function (target)
        import('core.project.project')
        for targetname, target in pairs(project.targets()) do
            os.runv(target:targetfile(), { '512', tostring(option.get('sections')) })
        end
    end
})
