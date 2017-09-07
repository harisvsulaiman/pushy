project('com.github.harisvsulaiman.pushy', ['vala', 'c'],
        version: '0.0.7')


i18n = import('i18n')
gnome = import('gnome')

conf = configuration_data()
conf.set_quoted('GETTEXT_PACKAGE', meson.project_name())
configure_file(output: 'config.h', configuration: conf)
config_h_dir = include_directories('.')

c_args = [
  '-include', 'config.h'
]

deps = [
  dependency('granite'),
  dependency('gtk+-3.0'),
  dependency('gee-0.8'),
  dependency('libsecret-1')
]


asresources = gnome.compile_resources(
    'as-resources', 'data/' + meson.project_name() + '.gresource.xml',
    source_dir: 'data',
    c_name: 'as'
)

executable(
    meson.project_name(),
    'src/Application.vala',
    'src/MainWindow.vala',
    'src/Dbus.vala',
    'src/views/PushView.vala',
    'src/views/SendView.vala',
    'src/widgets/PushBox.vala',
    asresources,
    c_args: c_args,
    dependencies: [
        deps
    ],
    install : true
)


meson.add_install_script('meson/post_install.py')

subdir('data')

install_subdir('com.github.harisvsulaiman.pushy.node', install_dir : 'bin')