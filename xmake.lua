option('sections', function ()
    set_default(20)
    set_showmenu(true)
    after_check(function (option)
        option:add('defines', 'SECTIONS=' .. option:value())
    end)
end)

option('duration', function ()
    set_default(600)
    set_showmenu(true)
    after_check(function (option)
        option:add('defines', 'DURATION=' .. option:value())
    end)
end)

target('chirp', function ()
    set_kind('binary')
    add_files('chirp.cpp')
    set_languages('cxx17')
    if get_config('mode') == "debug" then
        set_optimize("none")
    elseif get_config("mode") == "release" then
        set_optimize("fastest")
    end
    set_options(
        'sections',
        'duration'
    )
end)

target('iir-sample', function ()
    set_kind('binary')
    add_files('iir_sample.cpp')
    set_languages('cxx17')
    if get_config('mode') == "debug" then
        set_optimize("none")
    elseif get_config("mode") == "release" then
        set_optimize("fastest")
    end
    set_options('sections')
end)

target('iir-sample-var', function ()
    set_kind("binary")
    add_files("iir_sample_var.cpp")
    set_languages('cxx17')
    if get_config('mode') == "debug" then
        set_optimize("none")
    elseif get_config("mode") == "release" then
        set_optimize("fastest")
    end
    set_options('sections')
end)

target('iir-sample-noinline', function ()
    set_kind('binary')
    add_files('iir_sample_noinline.cpp')
    set_languages('cxx17')
    if get_config('mode') == "debug" then
        set_optimize("none")
    elseif get_config("mode") == "release" then
        set_optimize("fastest")
    end
    set_options('sections')
end)

target('iir-sample-var-noinline', function ()
    set_kind('binary')
    add_files('iir_sample_var_noinline.cpp')
    set_languages('cxx17')
    if get_config('mode') == "debug" then
        set_optimize("none")
    elseif get_config("mode") == "release" then
        set_optimize("fastest")
    end
    set_options('sections')
end)

target('iir-block', function ()
    set_kind('binary')
    add_files('iir_block.cpp')
    set_languages('cxx17')
    if get_config('mode') == "debug" then
        set_optimize("none")
    elseif get_config("mode") == "release" then
        set_optimize("fastest")
    end
    set_options('sections')
end)

target('iir-block-var', function ()
    set_kind('binary')
    add_files('iir_block_var.cpp')
    set_languages('cxx17')
    if get_config('mode') == "debug" then
        set_optimize("none")
    elseif get_config("mode") == "release" then
        set_optimize("fastest")
    end
    set_options('sections')
end)

target('1', function ()
    set_kind('phony')
    add_deps('chirp', 'iir-sample', 'iir-sample-var', 'iir-sample-noinline', 'iir-sample-var-noinline', 'iir-block', 'iir-block-var')
    on_run(function (target)
        import("core.project.config")
        import("core.project.project")
        for _, dep in ipairs(target:get("deps")) do
            if dep == "chirp" then
                os.execv(project.target(dep):targetfile(), { config.get('duration') })
            else
                os.execv(project.target(dep):targetfile(), { '1', config.get('sections') })
            end
        end
    end)
end)

target('2', function ()
    set_kind('phony')
    add_deps('chirp', 'iir-sample', 'iir-sample-var', 'iir-sample-noinline', 'iir-sample-var-noinline', 'iir-block', 'iir-block-var')
    on_run(function (target)
        import("core.project.config")
        import("core.project.project")
        for _, dep in ipairs(target:get("deps")) do
            if dep == "chirp" then
                os.execv(project.target(dep):targetfile(), { config.get('duration') })
            else
                os.execv(project.target(dep):targetfile(), { '2', config.get('sections') })
            end
        end
    end)
end)

target('4', function ()
    set_kind('phony')
    add_deps('chirp', 'iir-sample', 'iir-sample-var', 'iir-sample-noinline', 'iir-sample-var-noinline', 'iir-block', 'iir-block-var')
    on_run(function (target)
        import("core.project.config")
        import("core.project.project")
        for _, dep in ipairs(target:get("deps")) do
            if dep == "chirp" then
                os.execv(project.target(dep):targetfile(), { config.get('duration') })
            else
                os.execv(project.target(dep):targetfile(), { '4', config.get('sections') })
            end
        end
    end)
end)

target('8', function ()
    set_kind('phony')
    add_deps('chirp', 'iir-sample', 'iir-sample-var', 'iir-sample-noinline', 'iir-sample-var-noinline', 'iir-block', 'iir-block-var')
    on_run(function (target)
        import("core.project.config")
        import("core.project.project")
        for _, dep in ipairs(target:get("deps")) do
            if dep == "chirp" then
                os.execv(project.target(dep):targetfile(), { config.get('duration') })
            else
                os.execv(project.target(dep):targetfile(), { '8', config.get('sections') })
            end
        end
    end)
end)

target('16', function ()
    set_kind('phony')
    add_deps('chirp', 'iir-sample', 'iir-sample-var', 'iir-sample-noinline', 'iir-sample-var-noinline', 'iir-block', 'iir-block-var')
    on_run(function (target)
        import("core.project.config")
        import("core.project.project")
        for _, dep in ipairs(target:get("deps")) do
            if dep == "chirp" then
                os.execv(project.target(dep):targetfile(), { config.get('duration') })
            else
                os.execv(project.target(dep):targetfile(), { '16', config.get('sections') })
            end
        end
    end)
end)

target('32', function ()
    set_kind('phony')
    add_deps('chirp', 'iir-sample', 'iir-sample-var', 'iir-sample-noinline', 'iir-sample-var-noinline', 'iir-block', 'iir-block-var')
    on_run(function (target)
        import('core.project.config')
        import('core.project.project')
        for _, dep in ipairs(target:get("deps")) do
            if dep == "chirp" then
                os.execv(project.target(dep):targetfile(), { config.get('duration') })
            else
                os.execv(project.target(dep):targetfile(), { '32', config.get('sections') })
            end
        end
    end)
end)

target('64', function ()
    set_kind('phony')
    add_deps('chirp', 'iir-sample', 'iir-sample-var', 'iir-sample-noinline', 'iir-sample-var-noinline', 'iir-block', 'iir-block-var')
    on_run(function (target)
        import('core.project.config')
        import('core.project.project')
        for _, dep in ipairs(target:get("deps")) do
            if dep == "chirp" then
                os.execv(project.target(dep):targetfile(), { config.get('duration') })
            else
                os.execv(project.target(dep):targetfile(), { '64', config.get('sections') })
            end
        end
    end)
end)

target('128', function ()
    set_kind('phony')
    add_deps('chirp', 'iir-sample', 'iir-sample-var', 'iir-sample-noinline', 'iir-sample-var-noinline', 'iir-block', 'iir-block-var')
    on_run(function (target)
        import('core.project.config')
        import('core.project.project')
        for _, dep in ipairs(target:get("deps")) do
            if dep == "chirp" then
                os.execv(project.target(dep):targetfile(), { config.get('duration') })
            else
                os.execv(project.target(dep):targetfile(), { '128', config.get('sections') })
            end
        end
    end)
end)

target('256', function ()
    set_kind('phony')
    add_deps('chirp', 'iir-sample', 'iir-sample-var', 'iir-sample-noinline', 'iir-sample-var-noinline', 'iir-block', 'iir-block-var')
    on_run(function (target)
        import('core.project.config')
        import('core.project.project')
        for _, dep in ipairs(target:get("deps")) do
            if dep == "chirp" then
                os.execv(project.target(dep):targetfile(), { config.get('duration') })
            else
                os.execv(project.target(dep):targetfile(), { '256', config.get('sections') })
            end
        end
    end)
end)

target('512', function ()
    set_kind('phony')
    add_deps('chirp', 'iir-sample', 'iir-sample-var', 'iir-sample-noinline', 'iir-sample-var-noinline', 'iir-block', 'iir-block-var')
    on_run(function (target)
        import('core.project.config')
        import('core.project.project')
        for _, dep in ipairs(target:get("deps")) do
            if dep == "chirp" then
                os.execv(project.target(dep):targetfile(), { config.get('duration') })
            else
                os.execv(project.target(dep):targetfile(), { '512', config.get('sections') })
            end
        end
    end)
end)

target('1024', function ()
    set_kind('phony')
    add_deps('chirp', 'iir-sample', 'iir-sample-var', 'iir-sample-noinline', 'iir-sample-var-noinline', 'iir-block', 'iir-block-var')
    set_options('sections')
    on_run(function (target)
        import('core.project.config')
        import('core.project.project')
        for _, dep in ipairs(target:get("deps")) do
            if dep == "chirp" then
                os.execv(project.target(dep):targetfile(), { config.get('duration') })
            else
                os.execv(project.target(dep):targetfile(), { '1024', config.get('sections') })
            end
        end
    end)
end)

target('2048', function ()
    set_kind('phony')
    add_deps('chirp', 'iir-sample', 'iir-sample-var', 'iir-sample-noinline', 'iir-sample-var-noinline', 'iir-block', 'iir-block-var')
    set_options('sections')
    on_run(function (target)
        import('core.project.config')
        import('core.project.project')
        for _, dep in ipairs(target:get("deps")) do
            if dep == "chirp" then
                os.execv(project.target(dep):targetfile(), { config.get('duration') })
            else
                os.execv(project.target(dep):targetfile(), { '2048', config.get('sections') })
            end
        end
    end)
end)

target('4096', function ()
    set_kind('phony')
    add_deps('chirp', 'iir-sample', 'iir-sample-var', 'iir-sample-noinline', 'iir-sample-var-noinline', 'iir-block', 'iir-block-var')
    set_options('sections')
    on_run(function (target)
        import('core.project.config')
        import('core.project.project')
        for _, dep in ipairs(target:get("deps")) do
            if dep == "chirp" then
                os.execv(project.target(dep):targetfile(), { config.get('duration') })
            else
                os.execv(project.target(dep):targetfile(), { '4096', config.get('sections') })
            end
        end
    end)
end)
