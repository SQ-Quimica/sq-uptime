# sq-uptime

Monitor externo de disponibilidade dos apps SQ Smart / ADMB hospedados no VPS (EasyPanel).

- **Frequência:** a cada 5 minutos (GitHub Actions — roda fora do VPS).
- **Alvos:** `targets.txt` (URL + códigos HTTP aceitos).
- **Regra:** um endereço só é considerado fora após 2 falhas seguidas (intervalo de 20 s).
- **Alerta:** na primeira falha abre uma issue com rótulo `queda` (o GitHub envia e-mail); enquanto durar, a issue é atualizada sem novo e-mail; quando tudo volta, é fechada (novo e-mail).
- **Keepalive:** `keepalive.yml` faz um commit semanal para o GitHub não desativar o agendamento (regra de 60 dias para repositórios públicos).

## Recuperação automática no VPS

O VPS tem o timer `swarm-autoheal.timer` (2 min após o boot e a cada 10 min), que religa serviços do Swarm parados com saída 0 — causa da queda de 17/10/2026 (desligamento pelo hipervisor da Hostinger + `restart=on-failure` do EasyPanel).

```bash
systemctl list-timers swarm-autoheal.timer
journalctl -t swarm-autoheal -n 50
/usr/local/sbin/swarm-autoheal.sh --dry-run
```

## Manutenção

Novo app publicado → adicionar uma linha em `targets.txt`.
