From: Borislav Petkov <bp@alien8.de>
Subject: __nf_register_net_hook jump label splat
Date: Sun, 30 Sep 2018 01:04:09 +0200
Message-ID: <20180929230409.GA27207@zn.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org
To: netdev@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi people,

this is something new I'm triggering with rc5 + tip/master while rc4 +
tip/master is fine. Any ideas?

If I had to guess, it looks like this thing:

#ifdef HAVE_JUMP_LABEL
        static_key_slow_inc(&nf_hooks_needed[pf][reg->hooknum]);
#endif



[   24.472503] bridge: filtering via arp/ip/ip6tables is no longer available by default. Update your scripts to load br_netfilter if you need this.
[   24.497078] Bridge firewalling registered
[   24.507989] BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
[   24.517700] PGD 80284ff51067 P4D 80284ff51067 PUD 80284ff52067 PMD 0 
[   24.525895] Oops: 0000 [#1] PREEMPT SMP NOPTI
[   24.531949] CPU: 121 PID: 4848 Comm: wickedd Not tainted 4.19.0-rc5+ #1
[   24.549787] RIP: 0010:jump_label_update+0xa4/0xd0
[   24.556049] Code: 73 08 48 85 f6 74 31 48 8b 43 10 48 c7 c2 60 01 f0 81 48 85 c0 74 11 8b 90 b8 02 00 00 48 c1 e2 04 48 03 90 b0 02 00 00 31 c9 <83> 38 01 48 89 ef 0f 94 c1 e8 8e fd ff ff 48 8b 1b 48 85 db 75 be
[   24.578102] RSP: 0018:ffffc9000f783c70 EFLAGS: 00010246
[   24.584946] RAX: 0000000000000000 RBX: ffff884045145880 RCX: 0000000000000000
[   24.593679] RDX: ffffffff81f00160 RSI: ffffffff81efff00 RDI: ffffffff8204e220
[   24.601575] usb 3-2.2: device not accepting address 8, error -71
[   24.602418] RBP: ffffffff827ef800 R08: 0000000000000002 R09: 0000000000000000
[   24.602424] R10: ffff88407ea62f48 R11: 0000000000000000 R12: ffff884033dfcdc0
[   24.610307] usb 3-2-port2: unable to enumerate USB device
[   24.619267] R13: ffffffff821078d0 R14: 0000000000000000 R15: 0000000000000000
[   24.619271] FS:  00007f30357a4700(0000) GS:ffff88407ea40000(0000) knlGS:0000000000000000
[   24.619274] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   24.619276] CR2: 0000000000000000 CR3: 0000802853e20000 CR4: 00000000003406e0
[   24.619277] Call Trace:
[   24.619289]  static_key_slow_inc_cpuslocked+0x73/0xa0
[   24.682426]  static_key_slow_inc+0x16/0x20
[   24.682435]  __nf_register_net_hook+0x98/0x100
[   24.682440]  nf_register_net_hook+0x23/0x80
[   24.682445]  nf_register_net_hooks+0x3c/0x90
[   24.682452]  brnf_device_event+0x68/0xb0 [br_netfilter]
[   24.682461]  notifier_call_chain+0x47/0x70
[   24.682470]  register_netdevice+0x352/0x4c0
[   24.682475]  register_netdev+0x1f/0x30
[   24.682485]  br_add_bridge+0x4b/0x70 [bridge]
[   24.682500]  br_ioctl_deviceless_stub+0x112/0x250 [bridge]
[   24.705565] usb 3-2.3: new high-speed USB device number 9 using xhci_hcd
[   24.707752]  sock_ioctl+0x250/0x320
[   24.761176]  do_vfs_ioctl+0x92/0x5e0
[   24.761182]  ? __sys_recvmsg+0x45/0x80
[   24.761186]  ksys_ioctl+0x60/0x90
[   24.761191]  __x64_sys_ioctl+0x16/0x20
[   24.761198]  do_syscall_64+0x4f/0xe0
[   24.761206]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   24.761212] RIP: 0033:0x7f3034f62417
[   24.761216] Code: 00 00 00 48 8b 05 71 8a 2b 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 41 8a 2b 00 f7 d8 64 89 01 48
[   24.761224] RSP: 002b:00007ffecdc9ca08 EFLAGS: 00000246
[   24.793641] usb 3-2.3: device descriptor read/64, error -71
[   24.796390]  ORIG_RAX: 0000000000000010
[   24.796397] RAX: ffffffffffffffda RBX: 0000000001236ff0 RCX: 00007f3034f62417
[   24.854147] RDX: 0000000001236ff0 RSI: 00000000000089a0 RDI: 0000000000000008
[   24.854149] RBP: 00007ffecdc9ca48 R08: 0000000000000000 R09: 0000000001297650
[   24.854150] R10: 000000006829aa3c R11: 0000000000000246 R12: 00000000012385f0
[   24.854152] R13: 000000000129a840 R14: 0000000001205700 R15: 0000000001208fc0
[   24.854156] Modules linked in: br_netfilter bridge stp llc iscsi_ibft iscsi_boot_sysfs msr ipmi_ssif nls_iso8859_1 nls_cp437 joydev amd64_edac_mod vfat edac_mce_amd fat kvm_amd hid_generic usbhid kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc e1000e aesni_intel aes_x86_64 crypto_simd cryptd ptp glue_helper pps_core sp5100_tco pcspkr ipmi_si ccp ipmi_devintf i2c_piix4 k10temp ipmi_msghandler pcc_cpufreq pinctrl_amd acpi_cpufreq button btrfs libcrc32c xor zstd_decompress zstd_compress xxhash ast i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops xhci_pci ttm xhci_hcd raid6_pq crc32c_intel drm usbcore dm_mirror dm_region_hash dm_log sg dm_multipath dm_mod scsi_dh_rdac scsi_dh_emc scsi_dh_alua efivarfs
[   24.890644] CR2: 0000000000000000
[   24.973524] ---[ end trace e5c10bd51bf12555 ]---
[   24.973529] RIP: 0010:jump_label_update+0xa4/0xd0
[   24.973532] Code: 73 08 48 85 f6 74 31 48 8b 43 10 48 c7 c2 60 01 f0 81 48 85 c0 74 11 8b 90 b8 02 00 00 48 c1 e2 04 48 03 90 b0 02 00 00 31 c9 <83> 38 01 48 89 ef 0f 94 c1 e8 8e fd ff ff 48 8b 1b 48 85 db 75 be
[   24.973534] RSP: 0018:ffffc9000f783c70 EFLAGS: 00010246
[   24.973536] RAX: 0000000000000000 RBX: ffff884045145880 RCX: 0000000000000000
[   24.973538] RDX: ffffffff81f00160 RSI: ffffffff81efff00 RDI: ffffffff8204e220
[   24.973539] RBP: ffffffff827ef800 R08: 0000000000000002 R09: 0000000000000000
[   24.973541] R10: ffff88407ea62f48 R11: 0000000000000000 R12: ffff884033dfcdc0
[   24.973542] R13: ffffffff821078d0 R14: 0000000000000000 R15: 0000000000000000
[   24.973545] FS:  00007f30357a4700(0000) GS:ffff88407ea40000(0000) knlGS:0000000000000000
[   24.973546] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   24.973548] CR2: 0000000000000000 CR3: 0000802853e20000 CR4: 00000000003406e0

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
