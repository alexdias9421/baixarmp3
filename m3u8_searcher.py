#!/usr/bin/env python3
import os
import sys
import urllib.request
import re
import json

# Known public IPTV sources (e.g., iptv-org main playlists or similar curated lists)
DEFAULT_SOURCES = {
    "iptv-org (General)": "https://iptv-org.github.io/iptv/index.m3u",
    "iptv-org (Brazil)": "https://iptv-org.github.io/iptv/countries/br.m3u",
    "iptv-org (Portugal)": "https://iptv-org.github.io/iptv/countries/pt.m3u",
    "iptv-org (Movies)": "https://iptv-org.github.io/iptv/categories/movies.m3u",
    "iptv-org (Sports)": "https://iptv-org.github.io/iptv/categories/sports.m3u",
}

def fetch_playlist(url):
    print(f"[+] Baixando playlist de: {url}")
    try:
        req = urllib.request.Request(
            url,
            headers={'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'}
        )
        with urllib.request.urlopen(req, timeout=15) as response:
            return response.read().decode('utf-8', errors='ignore')
    except Exception as e:
        print(f"[-] Erro ao baixar playlist: {e}")
        return None

def parse_m3u(content):
    channels = []
    lines = content.splitlines()
    current_channel = {}

    for line in lines:
        line = line.strip()
        if line.startswith('#EXTINF:'):
            current_channel = {}
            # Extrair nome do canal (geralmente após a última vírgula)
            match = re.search(r',(.+)$', line)
            if match:
                current_channel['name'] = match.group(1).strip()
            else:
                current_channel['name'] = 'Desconhecido'

            # Extrair atributos se houver (ex: tvg-logo, group-title)
            logo_match = re.search(r'tvg-logo="([^"]+)"', line)
            if logo_match:
                current_channel['logo'] = logo_match.group(1)

            group_match = re.search(r'group-title="([^"]+)"', line)
            if group_match:
                current_channel['group'] = group_match.group(1)

        elif line and not line.startswith('#'):
            if current_channel:
                current_channel['url'] = line
                channels.append(current_channel)
                current_channel = {}

    return channels

def search_channels(channels, query):
    query = query.lower()
    results = [c for c in channels if query in c.get('name', '').lower() or query in c.get('group', '').lower()]
    return results

def main():
    print("=== Buscador de Listas M3U8 (IPTV) ===")
    print("Fontes disponíveis:")
    sources_list = list(DEFAULT_SOURCES.items())
    for idx, (name, url) in enumerate(sources_list, 1):
        print(f"[{idx}] {name}")
    print("[0] Inserir URL personalizada")

    choice = input("\nEscolha uma opção de fonte: ").strip()

    url = ""
    if choice == '0':
        url = input("Digite a URL da lista M3U/M3U8: ").strip()
    else:
        try:
            idx = int(choice) - 1
            if 0 <= idx < len(sources_list):
                url = sources_list[idx][1]
            else:
                print("Opção inválida.")
                return
        except ValueError:
            print("Entrada inválida.")
            return

    content = fetch_playlist(url)
    if not content:
        print("Não foi possível carregar a playlist.")
        return

    print("[+] Analisando canais...")
    channels = parse_m3u(content)
    print(f"[+] Total de canais encontrados: {len(channels)}")

    while True:
        query = input("\nDigite o termo para buscar (ou 'sair' para encerrar): ").strip()
        if query.lower() in ['sair', 'exit', 'q']:
            break

        if not query:
            continue

        results = search_channels(channels, query)
        print(f"\nEncontrados {len(results)} resultados para '{query}':")
        for i, ch in enumerate(results[:30], 1): # Mostrar até 30
            group = f" [{ch.get('group')}]" if 'group' in ch else ""
            print(f"{i}. {ch['name']}{group}")
            print(f"   URL: {ch['url']}")

        if len(results) > 30:
            print(f"... e mais {len(results) - 30} resultados.")

        if results:
            save = input("\nDeseja exportar estes resultados para um arquivo .m3u? (s/n): ").strip().lower()
            if save == 's':
                filename = input("Nome do arquivo (ex: meus_canais.m3u): ").strip()
                if not filename.endswith('.m3u'):
                    filename += '.m3u'
                try:
                    with open(filename, 'w', encoding='utf-8') as f:
                        f.write("#EXTM3U\n")
                        for ch in results:
                            logo = f' tvg-logo="{ch["logo"]}"' if 'logo' in ch else ''
                            group = f' group-title="{ch["group"]}"' if 'group' in ch else ''
                            f.write(f'#EXTINF:-1{logo}{group},{ch["name"]}\n')
                            f.write(f'{ch["url"]}\n')
                    print(f"[+] Salvo com sucesso em {filename}!")
                except Exception as e:
                    print(f"[-] Erro ao salvar arquivo: {e}")

if __name__ == '__main__':
    main()
