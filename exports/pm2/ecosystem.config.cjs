// PM2 ecosystem — autostarts MHC + personal-dam app processes.
// DBs are handled separately by Docker Desktop via `restart: unless-stopped`.
//
// Daily controls:
//   pm2 status                       — show all managed processes
//   pm2 logs mhc-dev                 — tail MHC output
//   pm2 logs personal-dam-dev        — tail personal-dam output
//   pm2 restart mhc-dev              — restart one app
//   pm2 stop personal-dam-dev        — stop one app (survives reboot if saved)
//   pm2 save                         — persist current running list
//
// Re-apply after editing this file:  pm2 reload ecosystem.config.cjs
module.exports = {
  apps: [
    {
      name: 'mhc-dev',
      cwd: `${process.env.HOME}/Development/mhc/code/mhc-cp`,
      script: 'pnpm',
      args: '--parallel -r dev',
      env: { NODE_ENV: 'development' },
      // Wait 8s between crash restarts so the DB has time to come up on boot
      restart_delay: 8000,
      max_restarts: 50,
      autorestart: true,
      // Keep logs readable
      out_file: `${process.env.HOME}/.pm2/logs/mhc-dev-out.log`,
      error_file: `${process.env.HOME}/.pm2/logs/mhc-dev-error.log`,
      time: true,
    },
    {
      name: 'personal-dam-dev',
      cwd: `${process.env.HOME}/Development/refineo/code/personal-dam`,
      script: 'pnpm',
      args: 'dev',
      env: { NODE_ENV: 'development' },
      restart_delay: 8000,
      max_restarts: 50,
      autorestart: true,
      out_file: `${process.env.HOME}/.pm2/logs/personal-dam-dev-out.log`,
      error_file: `${process.env.HOME}/.pm2/logs/personal-dam-dev-error.log`,
      time: true,
    },
  ],
};
