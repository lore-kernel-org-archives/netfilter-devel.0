From: Steffen Nurpmeso <steffen@sdaoden.eu>
Subject: Re: 4.19.{12,[13],14}: RIP:
 0010:nf_conncount_cache_free+0x26/0x2f [nf_conncount]
Date: Fri, 18 Jan 2019 14:10:55 +0100
Message-ID: <20190118131055.RtuE5%steffen@sdaoden.eu>
References: <20190112000517.nQ-CW%steffen@sdaoden.eu>
To: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190112000517.nQ-CW%steffen@sdaoden.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hello.

The problem still persists with v14.19.15, i have reverter to
v4.14.89 again.
I add netfilter-devel because of a hint of someone, somewhere.

Steffen Nurpmeso wrote in <20190112000517.nQ-CW%steffen@sdaoden.eu>:
 |  At the moment i am running AlpineLinux [edge] on both rented
 |  Linux VM and Lpatop(s).  (Note well: i love CRUX Linux!)]
 |
 |They have updated from flawless 4.14.xx to 4.19.xx series in
 |December.  I went with 4.19.12, but after some hours there were
 |problems, the first time the server VM got completely stuck and
 |i had to force a hard shutdown -- the first in 606 days.
 |In the following twelve hours i saw two automatic reboots, i went
 |back to 4.14.89.
 ...

Please find below the new/old (i cannot grasp that anyway) crash
reports of v14.19.15:

crit:
Dec 29 00:15:01 kernel: [23338.689515] BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
Jan 12 00:15:00 kernel: [36690.017115] BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
Jan 18 00:40:00 kernel: [38154.448749] BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
Jan 18 12:40:00 kernel: [37953.963613] BUG: unable to handle kernel NULL pointer dereference at 0000000000000000

messages:
  Jan 18 00:40:00 crond[2043]: USER root pid 4450 cmd run-parts /etc/periodic/12hourly
..yes i have changed invocation time after my last post...
  Jan 18 00:40:00 kernel: [38154.452940] PGD 0 P4D 0 
...
  Jan 18 02:00:00 crond[2043]: USER root pid 4587 cmd run-parts /etc/periodic/hourly
  Jan 18 02:07:44 syslogd started: BusyBox v1.29.3
Automatic reboot for whatever reason, nothing specific runs here?
  Jan 18 12:40:00 crond[2045]: USER root pid 3270 cmd run-parts /etc/periodic/12hourly
  Jan 18 12:40:00 kernel: [37953.969002] PGD 0 P4D 0 

The 12hourly/sysstat does something like

  sort -n < /proc/net/xt_recent/alien_super

with a couple of those, and outputs firewall status.

warn:
  Jan 18 00:40:00 kernel: [38154.454203] Oops: 0000 [#1] SMP PTI
  Jan 18 00:40:00 kernel: [38154.455455] CPU: 0 PID: 4482 Comm: iptables Not tainted 4.19.15-0-vanilla #1-Alpine
  Jan 18 00:40:00 kernel: [38154.456792] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
  Jan 18 00:40:00 kernel: [38154.458219] RIP: 0010:nf_conncount_cache_free+0x26/0x2f [nf_conncount]
  Jan 18 00:40:00 kernel: [38154.459623] Code: 9c 8e c1 d4 66 66 66 66 90 55 53 48 8b 77 08 48 8d 5f 08 48 8b 2e 48 39 de 74 15 48 8b 3d 05 20 00 00 e8 79 8e c1 d4 48 89 ee <48> 8b 6d 00 eb e6 5b 5d c3 66 66 66 66 90 41 55 41 54 55 53 83 7f
  Jan 18 00:40:00 kernel: [38154.462144] RSP: 0018:ffff9d4c00f93d28 EFLAGS: 00010202
  Jan 18 00:40:00 kernel: [38154.463085] RAX: ffff88c7bb3cee01 RBX: ffff88c7bb7597a0 RCX: 00000000802e001e
  Jan 18 00:40:00 kernel: [38154.464052] RDX: 00000000802e001f RSI: 0000000000000000 RDI: ffff88c7bbc17080
  Jan 18 00:40:00 kernel: [38154.465040] RBP: 0000000000000000 R08: 0000000000000001 R09: ffff88c7bb7c67e8
  Jan 18 00:40:00 kernel: [38154.466027] R10: 0000000000000401 R11: ffff9d4c00374001 R12: ffff88c7bb759780
  Jan 18 00:40:00 kernel: [38154.467017] R13: ffff88c7bb6d1808 R14: ffffffff95ea3e40 R15: ffff88c7b5c6a118
  Jan 18 00:40:00 kernel: [38154.468011] FS:  00007f3b84922b68(0000) GS:ffff88c7bc200000(0000) knlGS:0000000000000000
  Jan 18 00:40:00 kernel: [38154.469046] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  Jan 18 00:40:00 kernel: [38154.470086] CR2: 0000000000000000 CR3: 000000007ece4000 CR4: 00000000000006b0
  Jan 18 00:40:00 kernel: [38154.471165] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  Jan 18 00:40:00 kernel: [38154.472244] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  Jan 18 00:40:00 kernel: [38154.473380] Call Trace:
  Jan 18 00:40:00 kernel: [38154.474507]  nf_conncount_destroy+0x5a/0x82 [nf_conncount]
  Jan 18 00:40:00 kernel: [38154.475651]  cleanup_match+0x45/0x6d [ip_tables]
  Jan 18 00:40:00 kernel: [38154.476775]  cleanup_entry+0x3e/0xa8 [ip_tables]
  Jan 18 00:40:00 kernel: [38154.477906]  __do_replace+0x171/0x203 [ip_tables]
  Jan 18 00:40:00 kernel: [38154.479022]  do_ipt_set_ctl+0x133/0x195 [ip_tables]
  Jan 18 00:40:00 kernel: [38154.480176]  nf_setsockopt+0x4b/0x64
  Jan 18 00:40:00 kernel: [38154.481390]  __sys_setsockopt+0x8b/0xc1
  Jan 18 00:40:00 kernel: [38154.482539]  __x64_sys_setsockopt+0x20/0x23
  Jan 18 00:40:00 kernel: [38154.483689]  do_syscall_64+0x55/0xe4
  Jan 18 00:40:00 kernel: [38154.484857]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
  Jan 18 00:40:00 kernel: [38154.486061] RIP: 0033:0x7f3b848cd8d3
  Jan 18 00:40:00 kernel: [38154.487229] Code: 83 c4 18 48 89 c7 e9 0c 3b fe ff c3 c3 31 c0 c3 49 89 ca 50 48 63 d2 48 63 f6 48 63 ff 45 89 c0 45 31 c9 b8 36 00 00 00 0f 05 <48> 89 c7 e8 e5 3a fe ff 5a c3 48 63 f6 50 48 63 ff 45 31 d2 45 31
  Jan 18 00:40:00 kernel: [38154.489751] RSP: 002b:00007ffde4b23820 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
  Jan 18 00:40:00 kernel: [38154.491043] RAX: ffffffffffffffda RBX: 0000559945b31f40 RCX: 00007f3b848cd8d3
  Jan 18 00:40:00 kernel: [38154.492354] RDX: 0000000000000040 RSI: 0000000000000000 RDI: 0000000000000004
  Jan 18 00:40:00 kernel: [38154.493701] RBP: 0000559945b39b60 R08: 00000000000073d0 R09: 0000000000000000
  Jan 18 00:40:00 kernel: [38154.495023] R10: 0000559945b31f40 R11: 0000000000000246 R12: 00007f3b848907a0
  Jan 18 00:40:00 kernel: [38154.496350] R13: 0000559945b39260 R14: 00007f3b848907a8 R15: 0000000000000082
  Jan 18 00:40:00 kernel: [38154.497742] Modules linked in: jitterentropy_rng sch_sfq sch_htb xt_connlimit nf_conncount nf_log_ipv4 nf_log_common xt_LOG xt_recent xt_limit ipt_REJECT nf_reject_ipv4 xt_tcpudp xt_CLASSIFY xt_connbytes xt_connmark xt_conntr
  Jan 18 00:40:00 kernel: [38154.508926]  sd_mod scsi_mod
  Jan 18 00:40:00 kernel: [38154.510623] CR2: 0000000000000000
  Jan 18 00:40:00 kernel: [38154.512286] ---[ end trace 36a1bc0db0ebbdaf ]---
  Jan 18 00:40:00 kernel: [38154.513923] RIP: 0010:nf_conncount_cache_free+0x26/0x2f [nf_conncount]
  Jan 18 00:40:00 kernel: [38154.515637] Code: 9c 8e c1 d4 66 66 66 66 90 55 53 48 8b 77 08 48 8d 5f 08 48 8b 2e 48 39 de 74 15 48 8b 3d 05 20 00 00 e8 79 8e c1 d4 48 89 ee <48> 8b 6d 00 eb e6 5b 5d c3 66 66 66 66 90 41 55 41 54 55 53 83 7f
  Jan 18 00:40:00 kernel: [38154.518990] RSP: 0018:ffff9d4c00f93d28 EFLAGS: 00010202
  Jan 18 00:40:00 kernel: [38154.520752] RAX: ffff88c7bb3cee01 RBX: ffff88c7bb7597a0 RCX: 00000000802e001e
  Jan 18 00:40:00 kernel: [38154.522419] RDX: 00000000802e001f RSI: 0000000000000000 RDI: ffff88c7bbc17080
  Jan 18 00:40:00 kernel: [38154.524029] RBP: 0000000000000000 R08: 0000000000000001 R09: ffff88c7bb7c67e8
  Jan 18 00:40:00 kernel: [38154.525603] R10: 0000000000000401 R11: ffff9d4c00374001 R12: ffff88c7bb759780
  Jan 18 00:40:00 kernel: [38154.527194] R13: ffff88c7bb6d1808 R14: ffffffff95ea3e40 R15: ffff88c7b5c6a118
  Jan 18 00:40:00 kernel: [38154.528733] FS:  00007f3b84922b68(0000) GS:ffff88c7bc200000(0000) knlGS:0000000000000000
  Jan 18 00:40:00 kernel: [38154.530381] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  Jan 18 00:40:00 kernel: [38154.531958] CR2: 0000000000000000 CR3: 000000007ece4000 CR4: 00000000000006b0
  Jan 18 00:40:00 kernel: [38154.533598] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  Jan 18 00:40:00 kernel: [38154.535164] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  Jan 18 02:07:45 kernel: [   17.713233] xt_connbytes: Forcing CT accounting to be enabled
  ...automatic reboot..
  Jan 18 12:40:00 kernel: [37953.970544] Oops: 0000 [#1] SMP PTI
  Jan 18 12:40:00 kernel: [37953.972129] CPU: 1 PID: 3300 Comm: iptables Not tainted 4.19.15-0-vanilla #1-Alpine
  Jan 18 12:40:00 kernel: [37953.972953] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
  Jan 18 12:40:00 kernel: [37953.973826] RIP: 0010:nf_conncount_cache_free+0x26/0x2f [nf_conncount]
  Jan 18 12:40:00 kernel: [37953.974728] Code: 9c 4e c2 ee 66 66 66 66 90 55 53 48 8b 77 08 48 8d 5f 08 48 8b 2e 48 39 de 74 15 48 8b 3d 05 20 00 00 e8 79 4e c2 ee 48 89 ee <48> 8b 6d 00 eb e6 5b 5d c3 66 66 66 66 90 41 55 41 54 55 53 83 7f
  Jan 18 12:40:00 kernel: [37953.976635] RSP: 0018:ffffbe368079fd28 EFLAGS: 00010202
  Jan 18 12:40:00 kernel: [37953.977591] RAX: ffffa08b7f3be301 RBX: ffffa08b767d5560 RCX: 00000000000006c9
  Jan 18 12:40:00 kernel: [37953.978587] RDX: 00000000000006c8 RSI: 0000000000000000 RDI: 00000000000246e0
  Jan 18 12:40:00 kernel: [37953.979598] RBP: 0000000000000000 R08: 0000000000000001 R09: ffffa08b7b502428
  Jan 18 12:40:00 kernel: [37953.980603] R10: 0000000000000401 R11: ffffbe368037c001 R12: ffffa08b767d5540
  Jan 18 12:40:00 kernel: [37953.981622] R13: ffffa08b7f2e4808 R14: ffffffffafea3e40 R15: ffffa08b7b3ea118
  Jan 18 12:40:00 kernel: [37953.982692] FS:  00007f51d158ab68(0000) GS:ffffa08b7c300000(0000) knlGS:0000000000000000
  Jan 18 12:40:00 kernel: [37953.983746] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  Jan 18 12:40:00 kernel: [37953.984854] CR2: 0000000000000000 CR3: 0000000079f3e000 CR4: 00000000000006a0
  Jan 18 12:40:00 kernel: [37953.985983] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  Jan 18 12:40:00 kernel: [37953.987111] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  Jan 18 12:40:00 kernel: [37953.988242] Call Trace:
  Jan 18 12:40:00 kernel: [37953.989366]  nf_conncount_destroy+0x5a/0x82 [nf_conncount]
  Jan 18 12:40:00 kernel: [37953.990506]  cleanup_match+0x45/0x6d [ip_tables]
  Jan 18 12:40:00 kernel: [37953.991653]  cleanup_entry+0x3e/0xa8 [ip_tables]
  Jan 18 12:40:00 kernel: [37953.992804]  __do_replace+0x171/0x203 [ip_tables]
  Jan 18 12:40:00 kernel: [37953.993963]  do_ipt_set_ctl+0x133/0x195 [ip_tables]
  Jan 18 12:40:00 kernel: [37953.995167]  nf_setsockopt+0x4b/0x64
  Jan 18 12:40:00 kernel: [37953.996367]  __sys_setsockopt+0x8b/0xc1
  Jan 18 12:40:00 kernel: [37953.997553]  __x64_sys_setsockopt+0x20/0x23
  Jan 18 12:40:00 kernel: [37953.998808]  do_syscall_64+0x55/0xe4
  Jan 18 12:40:00 kernel: [37954.000008]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
  Jan 18 12:40:00 kernel: [37954.001288] RIP: 0033:0x7f51d15358d3
  Jan 18 12:40:00 kernel: [37954.002517] Code: 83 c4 18 48 89 c7 e9 0c 3b fe ff c3 c3 31 c0 c3 49 89 ca 50 48 63 d2 48 63 f6 48 63 ff 45 89 c0 45 31 c9 b8 36 00 00 00 0f 05 <48> 89 c7 e8 e5 3a fe ff 5a c3 48 63 f6 50 48 63 ff 45 31 d2 45 31
  Jan 18 12:40:00 kernel: [37954.005261] RSP: 002b:00007fffe5c31710 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
  Jan 18 12:40:00 kernel: [37954.006595] RAX: ffffffffffffffda RBX: 0000560d0ce0ef40 RCX: 00007f51d15358d3
  Jan 18 12:40:00 kernel: [37954.008322] RDX: 0000000000000040 RSI: 0000000000000000 RDI: 0000000000000004
  Jan 18 12:40:00 kernel: [37954.009647] RBP: 0000560d0ce16b60 R08: 00000000000073d0 R09: 0000000000000000
  Jan 18 12:40:00 kernel: [37954.010986] R10: 0000560d0ce0ef40 R11: 0000000000000246 R12: 00007f51d14f87a0
  Jan 18 12:40:00 kernel: [37954.012324] R13: 0000560d0ce16260 R14: 00007f51d14f87a8 R15: 0000000000000082
  Jan 18 12:40:00 kernel: [37954.013681] Modules linked in: sch_sfq sch_htb xt_connlimit nf_conncount nf_log_ipv4 nf_log_common xt_LOG xt_recent xt_limit ipt_REJECT nf_reject_ipv4 xt_tcpudp xt_CLASSIFY xt_connbytes xt_connmark xt_conntrack nf_conntrack n
  Jan 18 12:40:00 kernel: [37954.024781]  sd_mod scsi_mod
  Jan 18 12:40:00 kernel: [37954.026442] CR2: 0000000000000000
  Jan 18 12:40:00 kernel: [37954.028117] ---[ end trace 027a82bdb229a995 ]---
  Jan 18 12:40:00 kernel: [37954.029726] RIP: 0010:nf_conncount_cache_free+0x26/0x2f [nf_conncount]
  Jan 18 12:40:00 kernel: [37954.031467] Code: 9c 4e c2 ee 66 66 66 66 90 55 53 48 8b 77 08 48 8d 5f 08 48 8b 2e 48 39 de 74 15 48 8b 3d 05 20 00 00 e8 79 4e c2 ee 48 89 ee <48> 8b 6d 00 eb e6 5b 5d c3 66 66 66 66 90 41 55 41 54 55 53 83 7f
  Jan 18 12:40:00 kernel: [37954.034814] RSP: 0018:ffffbe368079fd28 EFLAGS: 00010202
  Jan 18 12:40:00 kernel: [37954.036447] RAX: ffffa08b7f3be301 RBX: ffffa08b767d5560 RCX: 00000000000006c9
  Jan 18 12:40:00 kernel: [37954.038068] RDX: 00000000000006c8 RSI: 0000000000000000 RDI: 00000000000246e0
  Jan 18 12:40:00 kernel: [37954.039751] RBP: 0000000000000000 R08: 0000000000000001 R09: ffffa08b7b502428
  Jan 18 12:40:00 kernel: [37954.041354] R10: 0000000000000401 R11: ffffbe368037c001 R12: ffffa08b767d5540
  Jan 18 12:40:00 kernel: [37954.042923] R13: ffffa08b7f2e4808 R14: ffffffffafea3e40 R15: ffffa08b7b3ea118
  Jan 18 12:40:00 kernel: [37954.044508] FS:  00007f51d158ab68(0000) GS:ffffa08b7c300000(0000) knlGS:0000000000000000
  Jan 18 12:40:00 kernel: [37954.046206] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  Jan 18 12:40:00 kernel: [37954.047849] CR2: 0000000000000000 CR3: 0000000079f3e000 CR4: 00000000000006a0
  Jan 18 12:40:00 kernel: [37954.049457] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  Jan 18 12:40:00 kernel: [37954.051028] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

Ciao!

--steffen
|
|Der Kragenbaer,                The moon bear,
|der holt sich munter           he cheerfully and one by one
|einen nach dem anderen runter  wa.ks himself off
|(By Robert Gernhardt)
