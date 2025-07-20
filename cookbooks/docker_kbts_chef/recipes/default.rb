#
# Cookbook:: docker_kbts_chef
# Recipe:: default
#
# Copyright:: 2025, The Authors, All Rights Reserved.

require 'json'

# Detectar la arquitectura del sistema
arch = node['kernel']['machine']

# 1. Instalar Rosetta en Apple Silicon para compatibilidad con x86_64
if arch == 'arm64'
    execute 'install rosetta' do
        command '/usr/sbin/softwareupdate --install-rosetta --agree-to-license'
        not_if 'pkgutil --pkgs | grep -i rosetta'
    end
end

# 2. Instalar Docker Desktop via Homebrew Cask (solo si no existe)
homebrew_package 'docker' do
  options '--cask'
  action :install
  not_if { ::File.exist?('/Applications/Docker.app') }
end

# 3. Arrancar Docker.app si no está corriendo
execute 'launch Docker.app' do
    command 'open -a Docker'
    user node['current_user']
    not_if 'pgrep -x Docker'
end

# 4. Esperar hasta que Docker CLI responda
execute 'wait for Docker CLI' do
    command 'until docker info > /dev/null 2>&1; do sleep 1; done'
    user node['current_user']
    retries 10
    retry_delay 2
end

# 5. Habilitar Kubernetes en Docker Desktop
ruby_block 'enable kubernetes in Docker Desktop' do
  block do
    settings_file = File.expand_path('~/Library/Group Containers/group.com.docker/settings.json')
    raise "No se encontró #{settings_file}" unless ::File.exist?(settings_file)

    settings = JSON.parse(::File.read(settings_file))
    settings['kubernetesEnabled'] = true
    ::File.write(settings_file, JSON.pretty_generate(settings))
  end
  notifies :run, 'execute[restart Docker]', :immediately
end

# 6. Reiniciar Docker para aplicar la configuración de Kubernetes
execute 'restart Docker' do
  command <<~CMD
    osascript -e 'tell application "Docker" to quit'
    sleep 3
    open -a Docker
  CMD
  action :nothing
end