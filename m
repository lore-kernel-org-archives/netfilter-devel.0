From: Jan Engelhardt <jengelh@medozas.de>
Subject: Kernel crash with repeated NF invocation
Date: Thu, 3 Feb 2011 16:19:56 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1102031605330.21536@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


I observe that our machines randomly crash with a big stack trace 
in/around netfilter and bridging.

A bridge interface is grouping a number of TAP interfaces. It is my 
latest impression that the only explanation for this BUG with a (null) 
RIP is that the IRQ stack is exceeded when a packet is received from a 
tap interface and going out another tap interface.

I remember there being a kernel config option 
(CONFIG_DEBUG_STACKOVERFLOW) that would emit messages 
similar to
"process foobar (12345) used greatest stack depth: 2042" --
would that also work for softirqs?


# 2.6.37 x86_64
# Messages are somewhat intermingled due to the unordered transport of 
# UDP netconsole
[44071.880116] BUG: unable to handle kernel 
[44071.880171] IP:
 ip6t_LOG
[44071.880255] last sysfs file: /sys/devices/system/cpu/cpu7/cache/index2/shared_cpu_map
 [<          (null)>]           (null)
[44071.881565] RSP: 0018:ffff8800bf403908  EFLAGS: 00010292
[44071.881593] RAX: ffff88060cb91fd8 RBX: 0000000000000000 RCX: 00000000b0000000
[44071.881624] RDX: 0000000000000062 RSI: ffff8803ee5bc2c0 RDI: ffffffff812e90a6
[44071.881655] RBP: 2400000000000000 R08: 0000000080000000 R09: 0000000000000000
[44071.881686] R10: 0000000000000001 R11: 0000000000000000 R12: ff00000001000000
[44071.881717] R13: 0000ffff88753ca8 R14: 0000000000000000 R15: 0000000000000000
[44071.881749] FS:  00007f8c0433b700(0000) GS:ffff8800bf400000(0000) knlGS:0000000000000000
 [<          (null)>]           (null)
[44071.881796] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[44071.881824] CR2: 0000000000000000 CR3: 00000005fd217000 CR4: 00000000000026f0
[44071.881856] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[44071.881887] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[44071.881918] Process openvpn (pid: 6040, threadinfo ffff88060cb90000, task ffff88060ddfc6c0)
[44071.881965] Stack:
[44071.881986]  0000000000000000
 xt_multiport

 ip6table_filter
 xt_tcpudp
 0000000000000000
 0000000000000000
 0000000000000000

[44071.882043]  0000000000000000
 0000000000000000
 0000000000000000
 0000000000000000

[44071.882099]  0000000000000000
 0000000000000000
 0000000000000000
 0000000000000000

[44071.882155] Call Trace:
[44071.882177] Inexact backtrace:
[44071.882178] 
[44071.882281]  <IRQ> 

 ip6t_REJECT
[44071.880310] Modules linked in:
 ipt_LOG
 nf_nat_ftp

[44071.882309]  [<ffffffff812bf069>] ? nf_iterate+0x43/0x87
[44071.882343]  [<ffffffffa01f426d>] ? br_nf_forward_finish+0x0/0x95 [bridge]
[44071.882375]  [<ffffffff812bf111>] ? nf_hook_slow+0x64/0xd3
[44071.882407]  [<ffffffffa01f426d>] ? br_nf_forward_finish+0x0/0x95 [bridge]
[44071.882439]  [<ffffffffa0624038>] ? nf_ct_zone+0xa/0x18 [nf_nat]
[44071.882472]  [<ffffffffa01f426d>] ? br_nf_forward_finish+0x0/0x95 [bridge]
[44071.882507]  [<ffffffffa01f3c1d>] ? NF_HOOK_THRESH+0x3b/0x55 [bridge]
 iptable_mangle
[44071.882540]  [<ffffffffa01f3bd5>] ? nf_bridge_pull_encap_header+0x1a/0x27 [bridge]
[44071.880202] PGD 0 
 at           (null)
[44071.882590]  [<ffffffffa01f4559>] ? br_nf_forward_ip+0x1a4/0x1b6 [bridge]
[44071.882622]  [<ffffffff812bf069>] ? nf_iterate+0x43/0x87
[44071.882652]  [<ffffffffa01ef220>] ? br_forward_finish+0x0/0x22 [bridge]
[44071.882683]  [<ffffffff812bf111>] ? nf_hook_slow+0x64/0xd3
[44071.882714]  [<ffffffffa01ef220>] ? br_forward_finish+0x0/0x22 [bridge]
[44071.882748]  [<ffffffffa01eff04>] ? br_handle_frame_finish+0x0/0x1b8 [bridge]
[44071.882782]  [<ffffffffa01ef220>] ? br_forward_finish+0x0/0x22 [bridge]
[44071.882815]  [<ffffffffa01ef15b>] ? NF_HOOK.clone.0+0x3c/0x56 [bridge]
[44071.882848]  [<ffffffffa01f004d>] ? br_handle_frame_finish+0x149/0x1b8 [bridge]
[44071.880302] CPU 0 
 ipt_ah
 ipt_REJECT
[44071.880226] Oops: 0010 [#1] 
 nf_nat_sip
[44071.882896]  [<ffffffffa01eff04>] ? br_handle_frame_finish+0x0/0x1b8 [bridge]
[44071.882931]  [<ffffffffa01f4bf8>] ? br_nf_pre_routing_finish+0x1ee/0x1fb [bridge]
[44071.882979]  [<ffffffff812e4a2e>] ? sock_put+0xd/0x1c
 nf_nat_tftp
 nf_nat_irc
 nf_nat_proto_gre
 nf_nat_proto_dccp
 ip6_tables
 nf_conntrack_netlink
 nf_nat_h323
 nf_nat_pptp
 ip6table_mangle
 ebtables
 xt_physdev
 ebt_dnat
 ebtable_nat
 nf_defrag_ipv6
 iptable_nat
 xt_geoip
 nf_conntrack_proto_dccp
 nfnetlink
 nf_nat_amanda
 nf_nat
 nf_conntrack_pptp
 nf_conntrack_proto_sctp
 nf_conntrack_amanda
 nf_conntrack_slp
 nf_conntrack_sane
 nf_nat_proto_udplite

 nf_conntrack_proto_udplite
 nf_conntrack_irc
 ts_kmp
 nf_conntrack_ipv4
 nf_conntrack_ftp
 nf_conntrack_tftp
 nf_nat_proto_sctp
 act_nat
 ebt_snat
 xt_conntrack
 nf_conntrack
 nf_conntrack_sip
 xt_state
 iptable_filter
 nf_conntrack_netbios_ns
 edd
 ip_tables
 x_tables
 xt_hashlimit
 nf_conntrack_h323
 nf_conntrack_proto_gre
 auth_rpcgss
 bridge
[44071.883009]  [<ffffffffa01f4a0a>] ? br_nf_pre_routing_finish+0x0/0x1fb [bridge]
[44071.886741]  [<ffffffffa01eff04>] ? br_handle_frame_finish+0x0/0x1b8 [bridge]
[44071.886776]  [<ffffffffa01f49f3>] ? br_nf_pre_routing+0x1d7/0x1ee [bridge]
[44071.886808]  [<ffffffff812bf069>] ? nf_iterate+0x43/0x87
[44071.886838]  [<ffffffffa01eff04>] ? br_handle_frame_finish+0x0/0x1b8 [bridge]
[44071.886870]  [<ffffffff812bf111>] ? nf_hook_slow+0x64/0xd3
[44071.886901]  [<ffffffffa01eff04>] ? br_handle_frame_finish+0x0/0x1b8 [bridge]
[44071.886934]  [<ffffffff8129ff1c>] ? napi_gro_receive+0x1f/0x2f
[44071.886963]  [<ffffffff8129fb13>] ? napi_skb_finish+0x1c/0x31
[44071.886995]  [<ffffffffa0183e91>] ? rtl8169_rx_interrupt+0x2d0/0x344 [r8169]
[44071.887029]  [<ffffffffa01eff04>] ? br_handle_frame_finish+0x0/0x1b8 [bridge]
 nf_conntrack_ipv6
[44071.887064]  [<ffffffffa01efeea>] ? NF_HOOK.clone.0+0x3c/0x56 [bridge]
[44071.887097]  [<ffffffffa01f0217>] ? br_handle_frame+0x15b/0x170 [bridge]
[44071.887130]  [<ffffffffa01f00bc>] ? br_handle_frame+0x0/0x170 [bridge]
[44071.887162]  [<ffffffff8129def8>] ? __netif_receive_skb+0x29f/0x43d
 llc
 nfsd
 tun
 af_packet
[44071.887193]  [<ffffffff8129e0f6>] ? process_backlog+0x60/0x13a
[44071.887222]  [<ffffffff812a0032>] ? net_rx_action+0x9b/0x19b
[44071.887253]  [<ffffffff810969bc>] ? handle_IRQ_event+0x4e/0x106
[44071.887283]  [<ffffffff81046f9c>] ? __do_softirq+0xd8/0x1b0
[44071.887312]  [<ffffffff8100384c>] ? call_softirq+0x1c/0x30
[44071.887340]  <EOI> 

[44071.887365]  [<ffffffff81004d7a>] ? do_softirq+0x31/0x67
[44071.887393]  [<ffffffff812a02c5>] ? netif_rx_ni+0x1e/0x27
[44071.887488]  [<ffffffffa01b19b1>] ? tun_get_user+0x3a3/0x3cb [tun]
 sunrpc
 exportfs
 virtio
 autofs4
 nfs
 mperf
 vboxnetadp
 virtio_ring
 stp
 nfs_acl
 configfs
 nf_nat_snmp_basic
[44071.887520]  [<ffffffffa01b1a5c>] ? tun_chr_aio_write+0x5e/0x79 [tun]
[44071.887552]  [<ffffffff810faa0d>] ? do_sync_write+0xb1/0xea
[44071.887582]  [<ffffffff8104611c>] ? timespec_add_safe+0x32/0x62
[44071.887614]  [<ffffffff8117db1a>] ? common_file_perm+0x4f/0x90
[44071.887645]  [<ffffffff8116253d>] ? security_file_permission+0x18/0x33
[44071.887676]  [<ffffffff810fb02e>] ? vfs_write+0xa6/0xf9
[44071.887705]  [<ffffffff810fb223>] ? sys_write+0x45/0x6b
[44071.887734]  [<ffffffff8100298b>] ? system_call_fastpath+0x16/0x1b
[44071.887763] Code: 
 Bad RIP value.

[44071.887793] RIP 
 [<          (null)>]           (null)
[44071.887823]  RSP <ffff8800bf403908>
[44071.887847] CR2: 0000000000000000
 quota_tree
 netconsole
 quota_v2
 lockd
[44071.888227] ---[ end trace 579990abc1945a47 ]---
 i2c_i801
 pcspkr
 nf_defrag_ipv4
 i2c_core
[44071.888287] Kernel panic - not syncing: Fatal exception in interrupt
[44071.888350] Pid: 6040, comm: openvpn Tainted: G      D     2.6.37-jng122-default #1
[44071.888430] Call Trace:
[44071.888491]  [<ffffffff81004e3e>] dump_trace+0x6e/0x280
[44071.888591]  [<ffffffff8134ed6c>] dump_stack+0x69/0x6f
 mousedev
 psmouse
 mbcache
 fscache
[44071.888595]  [<ffffffff8134ee04>] panic+0x92/0x1a5
 virtio_net
 cpufreq_userspace
 edac_core
 i7core_edac
 vboxdrv
 loop
 wmi
 cpufreq_powersave
 vboxnetflt
 async_pq
 ext4
 sg
 async_raid6_recov
 thermal_sys
 acpi_cpufreq
 cpufreq_conservative
 iTCO_wdt
 jbd2
 evdev
 processor
 crc16
 async_memcpy
 raid456
 async_tx
 mii
 iTCO_vendor_support
 raid10
 button
 dm_snapshot
 async_xor
 xor
 uhci_hcd
 raid6_pq
[44071.881445] 
 raid1
 raid0
 pci_hotplug
 md_mod
 shpchp
 dm_mod
[44071.881516] RIP: 0010:[<0000000000000000>] 
[44071.881466] Pid: 6040, comm: openvpn Not tainted 2.6.37-jng122-default #1 MSI X58 Pro-E (MS-7522)/MS-7522
 hwmon
 ehci_hcd
 r8169

 usbcore
 linear
 nls_base
