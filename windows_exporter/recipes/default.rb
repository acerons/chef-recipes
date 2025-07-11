# Se declaran variables para la descarga del servicio
exporter_url = 'https://github.com/prometheus-community/windows_exporter/releases/download/v0.25.1/windows_exporter-0.25.1-amd64.exe'
exporter_path = 'C:\\Program Files\\windows_exporter'
exporter_exe = "#{exporter_path}\\windows_exporter.exe"

# Crea la carpeta destino
directory exporter_path do
  recursive true
  action :create
end

# Descarga el ejecutable desde la ruta
remote_file exporter_exe do
  source exporter_url
  action :create
end

# Registra como servicio de windows
powershell_script 'register_windows_exporter_service' do
  code <<-EOH
    sc.exe create windows_exporter binPath= "#{exporter_exe}" start= auto
    sc.exe start windows_exporter
  EOH
  not_if 'sc.exe query windows_exporter'
end

