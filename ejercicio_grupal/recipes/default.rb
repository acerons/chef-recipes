# Cambiar el wallpaper
registry_key 'HKCU\Control Panel\Desktop' do
  values [{
    name: 'Wallpaper',
    type: :string,
    data: 'C:\Wallpaper\Wallpaper.jpg' # Remmplazar por la ruta del wallpaper
  }]
  action :create
end

# Desabilita el panel de control
registry_key 'HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' do
  values [{
    name: 'NoControlPanel',
    type: :dword,
    data: 1
  }]
  action :create
end

# Opcional, desabilita el menu del clic derecho en el escritorio
registry_key 'HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' do
  values [{
    name: 'NoViewContextMenu',
    type: :dword,
    data: 1
  }]
  action :create
end
