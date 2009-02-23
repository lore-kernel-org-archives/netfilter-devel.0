From: Jan Engelhardt <jengelh@medozas.de>
Subject: 2.6.29-rc bug near nf_conntrack_tuple_taken
Date: Tue, 24 Feb 2009 00:49:05 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902240044320.8597@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: linux-rt-users@vger.kernel.org
Return-path: <linux-rt-users-owner@vger.kernel.org>
Sender: linux-rt-users-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


2.6.29-rc4-rt2 spuriously locks up after 30 min to 2 h.
First the network dies (no ping either to or from), later it
takes the whole machine down as file I/O is blocked too.

I have also observed this on a no-RT patched 2.6.29-rc4, though
need to get a clean gpl trace there first.

(Note that this -rt dump has not tainted.)

Feb 23 19:15:11 yaguchi kernel: BUG: unable to handle kernel paging request at 00100100
Feb 23 19:15:11 yaguchi kernel: IP: [<f0f305c4>] nf_conntrack_tuple_taken+0xe4/0x112 [nf_conntrack]
Feb 23 19:15:11 yaguchi kernel: *pde = 00000000 
Feb 23 19:15:11 yaguchi kernel: Oops: 0000 [#1] PREEMPT SMP 
Feb 23 19:15:11 yaguchi kernel: last sysfs file: /sys/devices/pci0000:00/0000:00:0d.0/modalias
Feb 23 19:15:11 yaguchi kernel: Modules linked in: nfsd snd_cs46xx af_packet snd_pcm_oss snd_mixer_oss nfs lockd nfs_acl auth_rpcgss sunrpc ip6t_REJECT ip6table_filter ip6_tables ipv6 iptable_raw xt_DELUDE xt_TARPIT ipt_REJECT xt_CHAOS compat_xtables xt_condition xt_tcpudp xt_multiport xt_conntrack iptable_filter xt_MASQUERADE xt_mark iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_connmark xt_CONNMARK nf_conntrack xt_MARK iptable_mangle ip_tables x_tables fuse sha256_generic cbc uhci_hcd dm_crypt nls_iso8859_1 nls_cp437 vfat fat loop aes_i586 aes_generic dm_mod gameport snd_rawmidi snd_seq_device snd_ac97_codec ac97_bus thermal snd_pcm processor ppdev snd_timer i2c_sis96x thermal_sys snd parport_pc shpchp rtc_cmos i2c_core sis900 hwmon 8139too soundcore button sr_mod sis_agp rtc_co
 re pci_hotplug parport snd_page_alloc pcspkr mii rtc_lib cdrom agpgart floppy sg usbhid hid ehci_hcd ohci_hcd usbcore sd_mod crc_t10dif xfs exportfs pata_sis libata scsi_mod [last unloaded: 
 snd_cs46xx]
Feb 23 19:15:11 yaguchi kernel: 
Feb 23 19:15:11 yaguchi kernel: Pid: 7, comm: sirq-net-rx/0 Tainted: G        W  (2.6.29-rc4-jen74-rt #1) L7S7A2
Feb 23 19:15:11 yaguchi kernel: EIP: 0060:[<f0f305c4>] EFLAGS: 00010206 CPU: 0
Feb 23 19:15:11 yaguchi kernel: EIP is at nf_conntrack_tuple_taken+0xe4/0x112 [nf_conntrack]
Feb 23 19:15:11 yaguchi kernel: EAX: ee54f120 EBX: 0000244d ECX: 00100100 EDX: efa7cd00
Feb 23 19:15:11 yaguchi kernel: ESI: ef893d30 EDI: ed65ca2c EBP: ef893d28 ESP: ef893d1c
Feb 23 19:15:11 yaguchi kernel:  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068 preempt:00000001
Feb 23 19:15:11 yaguchi kernel: Process sirq-net-rx/0 (pid: 7, ti=ef892000 task=ef890d30 task.ti=ef892000)
Feb 23 19:15:11 yaguchi kernel: Stack:
Feb 23 19:15:11 yaguchi kernel:  ef893d30 ed65ca2c ef893df4 ef893d60 f184367b a16a0a0a 00000000 00000000
Feb 23 19:15:11 yaguchi kernel:  00000000 0002eddb 420a4c86 00000000 00000000 00000000 0106380c f1844d74
Feb 23 19:15:13 yaguchi kernel:  ef893e1c ef893d88 f1843817 ef893e30 ef893df4 ef893dcc ef893de0 a16a0a0a
Feb 23 19:15:13 yaguchi kernel: Call Trace:
Feb 23 19:15:13 yaguchi kernel:  [<f184367b>] ? nf_nat_used_tuple+0x1f/0x26 [nf_nat]
Feb 23 19:15:13 yaguchi kernel:  [<f1843817>] ? get_unique_tuple+0x195/0x1b6 [nf_nat]
Feb 23 19:15:13 yaguchi kernel:  [<f184391c>] ? nf_nat_setup_info+0xe4/0x2c6 [nf_nat]
Feb 23 19:15:13 yaguchi kernel:  [<f0efb522>] ? ipt_do_table+0x453/0x489 [ip_tables]
Feb 23 19:15:13 yaguchi kernel:  [<f185e115>] ? alloc_null_binding+0x89/0x91 [iptable_nat]
Feb 23 19:15:13 yaguchi kernel:  [<f185e164>] ? nf_nat_rule_find+0x47/0x4f [iptable_nat]
Feb 23 19:15:13 yaguchi kernel:  [<f185e34c>] ? nf_nat_fn+0x13c/0x1aa [iptable_nat]
Feb 23 19:15:13 yaguchi kernel:  [<f185e54b>] ? nf_nat_in+0x1e/0x4f [iptable_nat]
Feb 23 19:15:15 yaguchi kernel:  [<c02de790>] ? ip_rcv_finish+0x0/0x273
Feb 23 19:15:15 yaguchi kernel:  [<c02d949b>] ? nf_iterate+0x2f/0x62
Feb 23 19:15:15 yaguchi kernel:  [<c02de790>] ? ip_rcv_finish+0x0/0x273
Feb 23 19:15:15 yaguchi kernel:  [<c02d95db>] ? nf_hook_slow+0x42/0x9f
Feb 23 19:15:15 yaguchi kernel:  [<c02de790>] ? ip_rcv_finish+0x0/0x273
Feb 23 19:15:15 yaguchi kernel:  [<c02debe1>] ? ip_rcv+0x1de/0x217
Feb 23 19:15:15 yaguchi kernel:  [<c02de790>] ? ip_rcv_finish+0x0/0x273
Feb 23 19:15:15 yaguchi kernel:  [<c02c1f85>] ? netif_receive_skb+0x409/0x42d
Feb 23 19:15:15 yaguchi kernel:  [<c02c233e>] ? napi_gro_receive+0x3b/0x49
Feb 23 19:15:15 yaguchi kernel:  [<c02c23c0>] ? process_backlog+0x74/0xa6
Feb 23 19:15:15 yaguchi kernel:  [<c02c069d>] ? net_rx_action+0x93/0x178
Feb 23 19:15:15 yaguchi kernel:  [<c012fd72>] ? ksoftirqd+0x131/0x212
Feb 23 19:15:15 yaguchi kernel:  [<c012fc41>] ? ksoftirqd+0x0/0x212
Feb 23 19:15:15 yaguchi kernel:  [<c013c1c7>] ? kthread+0x3b/0x61
Feb 23 19:15:15 yaguchi kernel:  [<c013c18c>] ? kthread+0x0/0x61
Feb 23 19:15:15 yaguchi kernel:  [<c0103ff7>] ? kernel_thread_helper+0x7/0x10
Feb 23 19:15:15 yaguchi kernel: Code: 8b 04 82 ff 40 04 e8 54 49 23 cf b8 01 00 00 00 eb 42 8b 15 48 8f 5b c0 64 a1 80 54 51 c0 f7 d2 8b 04 82 ff 00 8b 09 85 c9 74 22 <8b> 01 0f 18 00 90 0f b6 41 2f 89 ca 6b c0 0c 8d 04 85 04 00 00 
Feb 23 19:15:15 yaguchi kernel: EIP: [<f0f305c4>] nf_conntrack_tuple_taken+0xe4/0x112 [nf_conntrack] SS:ESP 0068:ef893d1c
Feb 23 19:15:15 yaguchi kernel: ---[ end trace 4eaa2a86a8e2da24 ]---
Feb 23 19:15:15 yaguchi kernel: BUG: unable to handle kernel paging request at 00100100
Feb 23 19:15:15 yaguchi kernel: IP: [<f0f302a1>] __nf_conntrack_find+0xc4/0xe5 [nf_conntrack]
Feb 23 19:15:15 yaguchi kernel: *pde = 00000000 
Feb 23 19:15:15 yaguchi kernel: Oops: 0000 [#2] PREEMPT SMP 
Feb 23 19:15:15 yaguchi kernel: last sysfs file: /sys/devices/pci0000:00/0000:00:0d.0/modalias
Feb 23 19:15:15 yaguchi kernel: Modules linked in: nfsd snd_cs46xx af_packet snd_pcm_oss snd_mixer_oss nfs lockd nfs_acl auth_rpcgss sunrpc ip6t_REJECT ip6table_filter ip6_tables ipv6 iptable_raw xt_DELUDE xt_TARPIT ipt_REJECT xt_CHAOS compat_xtables xt_condition xt_tcpudp xt_multiport xt_conntrack iptable_filter xt_MASQUERADE xt_mark iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_connmark xt_CONNMARK nf_conntrack xt_MARK iptable_mangle ip_tables x_tables fuse sha256_generic cbc uhci_hcd dm_crypt nls_iso8859_1 nls_cp437 vfat fat loop aes_i586 aes_generic dm_mod gameport snd_rawmidi snd_seq_device snd_ac97_codec ac97_bus thermal snd_pcm processor ppdev snd_timer i2c_sis96x thermal_sys snd parport_pc shpchp rtc_cmos i2c_core sis900 hwmon 8139too soundcore button sr_mod sis_agp rtc_co
 re pci_hotplug parport snd_page_alloc pcspkr mii rtc_lib cdrom agpgart floppy sg usbhid hid ehci_hcd ohci_hcd usbcore sd_mod crc_t10dif xfs exportfs pata_sis libata scsi_mod [last unloaded: 
 snd_cs46xx]
Feb 23 19:15:15 yaguchi kernel: 
Feb 23 19:15:15 yaguchi kernel: Pid: 5, comm: sirq-timer/0 Tainted: G      D W  (2.6.29-rc4-jen74-rt #1) L7S7A2
Feb 23 19:15:15 yaguchi kernel: EIP: 0060:[<f0f302a1>] EFLAGS: 00010206 CPU: 0
Feb 23 19:15:15 yaguchi kernel: EIP is at __nf_conntrack_find+0xc4/0xe5 [nf_conntrack]
Feb 23 19:15:15 yaguchi kernel: EAX: ee54f120 EBX: ef88ddb0 ECX: 00100100 EDX: efa7cd00
Feb 23 19:15:15 yaguchi kernel: ESI: e655922c EDI: c05b8c20 EBP: ef88dd84 ESP: ef88dd78
Feb 23 19:15:15 yaguchi kernel:  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068 preempt:00000001
Feb 23 19:15:15 yaguchi kernel: Process sirq-timer/0 (pid: 5, ti=ef88c000 task=ef88ad10 task.ti=ef88c000)
Feb 23 19:15:15 yaguchi kernel: Stack:
Feb 23 19:15:15 yaguchi kernel:  ef88ddb0 c05b8c20 00000014 ef88dd98 f0f3060a ef88ddb0 f1821024 00000014
Feb 23 19:15:15 yaguchi kernel:  ef88ddf0 f0f31acc 00000003 c05b8c20 00000002 f0f3fc24 a16a0a0a 00000000
Feb 23 19:15:15 yaguchi kernel:  00000000 00000000 0002eddb 420a4c86 00000000 00000000 00000000 0006380c
Feb 23 19:15:15 yaguchi kernel: Call Trace:
Feb 23 19:15:15 yaguchi kernel:  [<f0f3060a>] ? nf_conntrack_find_get+0x18/0x55 [nf_conntrack]
Feb 23 19:15:15 yaguchi kernel:  [<f0f31acc>] ? nf_conntrack_in+0x1ca/0x432 [nf_conntrack]
Feb 23 19:15:19 yaguchi kernel:  [<f181f495>] ? ipv4_conntrack_local+0x2e/0x38 [nf_conntrack_ipv4]
Feb 23 19:15:19 yaguchi kernel:  [<c02d949b>] ? nf_iterate+0x2f/0x62
Feb 23 19:15:19 yaguchi kernel:  [<c02e0b44>] ? dst_output+0x0/0xb
Feb 23 19:15:19 yaguchi kernel:  [<c02d95db>] ? nf_hook_slow+0x42/0x9f
Feb 23 19:15:19 yaguchi kernel:  [<c02e0b44>] ? dst_output+0x0/0xb
Feb 23 19:15:19 yaguchi kernel:  [<c02e22b0>] ? __ip_local_out+0x87/0x91
Feb 23 19:15:19 yaguchi kernel:  [<c02e0b44>] ? dst_output+0x0/0xb
Feb 23 19:15:19 yaguchi kernel:  [<c02e22c5>] ? ip_local_out+0xb/0x1b
Feb 23 19:15:19 yaguchi kernel:  [<c02e2a8e>] ? ip_queue_xmit+0x2b4/0x323
Feb 23 19:15:19 yaguchi kernel:  [<c0116b26>] ? default_spin_lock_flags+0x8/0xe
Feb 23 19:15:21 yaguchi kernel:  [<c0170e76>] ? cpupri_set+0xdd/0xfb
Feb 23 19:15:21 yaguchi kernel:  [<c02f57fa>] ? tcp_v4_send_check+0x7d/0xb7
Feb 23 19:15:21 yaguchi kernel:  [<c02f2255>] ? tcp_transmit_skb+0x59c/0x5d4
Feb 23 19:15:21 yaguchi kernel:  [<c0192ab8>] ? __kmalloc+0x9a/0xcf
Feb 23 19:15:21 yaguchi kernel:  [<c02f2413>] ? tcp_send_ack+0xe2/0xea
Feb 23 19:15:21 yaguchi kernel:  [<c02f4cbf>] ? tcp_delack_timer+0x156/0x1af
Feb 23 19:15:21 yaguchi kernel:  [<c01337c2>] ? run_timer_softirq+0x207/0x298
Feb 23 19:15:21 yaguchi kernel:  [<c02f4b69>] ? tcp_delack_timer+0x0/0x1af
Feb 23 19:15:21 yaguchi kernel:  [<c02f4b69>] ? tcp_delack_timer+0x0/0x1af
Feb 23 19:15:21 yaguchi kernel:  [<c012fd72>] ? ksoftirqd+0x131/0x212
Feb 23 19:15:21 yaguchi kernel:  [<c012fc41>] ? ksoftirqd+0x0/0x212
Feb 23 19:15:21 yaguchi kernel:  [<c013c1c7>] ? kthread+0x3b/0x61
Feb 23 19:15:21 yaguchi kernel:  [<c013c18c>] ? kthread+0x0/0x61
Feb 23 19:15:21 yaguchi kernel:  [<c0103ff7>] ? kernel_thread_helper+0x7/0x10
Feb 23 19:15:21 yaguchi kernel: Code: 8b 97 28 03 00 00 74 10 f7 d2 64 a1 80 54 51 c0 8b 04 82 ff 40 04 eb 2d f7 d2 64 a1 80 54 51 c0 8b 04 82 ff 00 8b 09 85 c9 74 18 <8b> 01 0f 18 00 90 8b 03 89 ce 3b 41 08 0f 85 7b ff ff ff e9 51 
Feb 23 19:15:21 yaguchi kernel: EIP: [<f0f302a1>] __nf_conntrack_find+0xc4/0xe5 [nf_conntrack] SS:ESP 0068:ef88dd78
Feb 23 19:15:21 yaguchi kernel: ---[ end trace 4eaa2a86a8e2da25 ]---
Feb 23 19:15:21 yaguchi kernel: NOHZ: local_softirq_pending 02
Feb 23 19:15:21 yaguchi kernel: NOHZ: local_softirq_pending 02
Feb 23 19:15:21 yaguchi kernel: NOHZ: local_softirq_pending 02
Feb 23 19:15:21 yaguchi kernel: NOHZ: local_softirq_pending 02
Feb 23 19:15:21 yaguchi kernel: NOHZ: local_softirq_pending 02
Feb 23 19:15:21 yaguchi kernel: NOHZ: local_softirq_pending 02
Feb 23 19:15:21 yaguchi kernel: NOHZ: local_softirq_pending 02
Feb 23 19:15:21 yaguchi kernel: NOHZ: local_softirq_pending 02
Feb 23 19:15:21 yaguchi kernel: NOHZ: local_softirq_pending 02
Feb 23 19:15:21 yaguchi kernel: NOHZ: local_softirq_pending 02
