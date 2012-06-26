From: =?ISO-8859-2?Q?Rafa=B3_Fitt?= <rafalf@aplusc.com.pl>
Subject: Problem: soft lockup in nf_conntrack(?)
Date: Tue, 26 Jun 2012 20:14:14 +0200
Message-ID: <4FE9FBF6.8030509@aplusc.com.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from netia.aplusc.com.pl ([87.204.37.214]:50236 "EHLO
	linux.aplusc.com.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756894Ab2FZSWK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Jun 2012 14:22:10 -0400
Received: from [IPv6:2001:0:4137:9e76:28d8:37ea:a832:4c96] ([IPv6:2001:0:4137:9e76:28d8:37ea:a832:4c96])
	(authenticated bits=0)
	by linux.aplusc.com.pl (8.14.5/8.14.5) with ESMTP id q5QIEFix019643
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <netfilter-devel@vger.kernel.org>; Tue, 26 Jun 2012 20:14:17 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi!

I have a lockup problem on my router.
I have enabled "Detect Soft Lockups", hardware watchdog and serial cons=
ole as advised by http://www.av8n.com/computer/htm/kernel-lockup.htm

Today I got the following dump:

BUG: soft lockup - CPU#0 stuck for 22s! [swapper/0:0]
Kernel panic - not syncing: softlockup: hung tasks
Pid: 0, comm: swapper/0 Not tainted 3.3.8 #4
Call Trace:
  <IRQ>  [<ffffffff8136bdd5>] panic+0xb8/0x1c4
  [<ffffffff81071f37>] watchdog_timer_fn+0x139/0x15d
  [<ffffffff81071dfe>] ? __touch_watchdog+0x1f/0x1f
  [<ffffffff81051ea0>] __run_hrtimer.clone.25+0x75/0xeb
  [<ffffffff8105254a>] hrtimer_interrupt+0xd5/0x1a5
  [<ffffffff81018758>] hpet_interrupt_handler+0x25/0x2c
  [<ffffffff81072cad>] handle_irq_event_percpu+0x29/0x11f
  [<ffffffff81072ddf>] handle_irq_event+0x3c/0x5d
  [<ffffffff81075435>] handle_edge_irq+0xc7/0xec
  [<ffffffff81003337>] handle_irq+0x1f/0x27
  [<ffffffff8100324e>] do_IRQ+0x48/0xae
  [<ffffffff8136e9ab>] common_interrupt+0x6b/0x6b
  [<ffffffff8136e700>] ? _raw_spin_lock_bh+0x2e/0x37
  [<ffffffffa0093201>] nf_ct_expect_related_report+0x26/0x5a2 [nf_connt=
rack]
  [<ffffffffa00961a0>] ? tcp_packet+0xd20/0xd4c [nf_conntrack]
  [<ffffffff8103d7f2>] ? local_bh_enable+0x7f/0x9a
  [<ffffffffa00c8667>] help+0x3cf/0x4b5 [nf_conntrack_ftp]
  [<ffffffffa00a4a31>] ipv4_confirm+0xab/0x19f [nf_conntrack_ipv4]
  [<ffffffffa00b3388>] ? nf_nat_fn+0x140/0x155 [iptable_nat]
  [<ffffffff812dc590>] nf_iterate+0x43/0x78
  [<ffffffff812e2ccf>] ? ip_rcv_finish+0x32f/0x32f
  [<ffffffff812dc633>] nf_hook_slow+0x6e/0x10b
  [<ffffffff812e2ccf>] ? ip_rcv_finish+0x32f/0x32f
  [<ffffffff812e29a0>] ? inet_del_protocol+0x37/0x37
  [<ffffffff812e3048>] ip_local_deliver+0x68/0x7c
  [<ffffffff812e2cab>] ip_rcv_finish+0x30b/0x32f
  [<ffffffff812e32bf>] ip_rcv+0x263/0x294
  [<ffffffff812bda0b>] __netif_receive_skb+0x3d8/0x41f
  [<ffffffff812bdc50>] netif_receive_skb+0x86/0x8d
  [<ffffffff81178a61>] ? swiotlb_dma_mapping_error+0x18/0x25
  [<ffffffff812bdd39>] napi_skb_finish+0x24/0x3b
  [<ffffffff812be2cd>] napi_gro_receive+0x105/0x111
  [<ffffffff8124202a>] igb_poll+0x7ca/0xa87
  [<ffffffff812be3d7>] net_rx_action+0x71/0x12d
  [<ffffffff81072d8b>] ? handle_irq_event_percpu+0x107/0x11f
BUG: soft lockup - CPU#2 stuck for 22s! [swapper/2:0]
Modules linked in: ipmi_si ipmi_devintf ipmi_msghandler xt_mac xt_NOTRA=
CK iptable_raw xt_tcpudp xt_TCPMSS xt_string xt_state xt_owner xt_NFQUE=
UE xt_multiport xt_mark xt_length xt_iprange xt_hl xt_hashlimit xt_DSCP=
 xt_dscp xt_conntrack xt_connmark nf_nat_sip nf_nat_pptp nf_nat_proto_g=
re nf_nat_ftp nf_conntrack_sip nf_conntrack_pptp nf_conntrack_proto_gre=
 nf_conntrack_ipv6 nf_defrag_ipv6 nf_conntrack_ftp ipt_REJECT ipt_REDIR=
ECT ipt_LOG xt_addrtype iptable_nat nf_nat nf_conntrack_ipv4 nf_conntra=
ck nf_defrag_ipv4 iptable_mangle iptable_filter ip_tables ip6t_rt ip6t_=
REJECT ip6t_LOG ip6table_mangle ip6table_filter ip6_tables x_tables sit=
 tunnel4 ehci_hcd
CPU 2
Modules linked in: ipmi_si ipmi_devintf ipmi_msghandler xt_mac xt_NOTRA=
CK iptable_raw xt_tcpudp xt_TCPMSS xt_string xt_state xt_owner xt_NFQUE=
UE xt_multiport xt_mark xt_length xt_iprange xt_hl xt_hashlimit xt_DSCP=
 xt_dscp xt_conntrack xt_connmark nf_nat_sip nf_nat_pptp nf_nat_proto_g=
re nf_nat_ftp nf_conntrack_sip nf_conntrack_pptp nf_conntrack_proto_gre=
 nf_conntrack_ipv6 nf_defrag_ipv6 nf_conntrack_ftp ipt_REJECT ipt_REDIR=
ECT ipt_LOG xt_addrtype iptable_nat nf_nat nf_conntrack_ipv4 nf_conntra=
ck nf_defrag_ipv4 iptable_mangle iptable_filter ip_tables ip6t_rt ip6t_=
REJECT ip6t_LOG ip6table_mangle ip6table_filter ip6_tables x_tables sit=
 tunnel4 ehci_hcd

Pid: 0, comm: swapper/2 Not tainted 3.3.8 #4 Dell Inc. PowerEdge T110/0=
V52N7
RIP: 0010:[<ffffffffa0093512>]  [<ffffffffa0093512>] nf_ct_expect_relat=
ed_report+0x337/0x5a2 [nf_conntrack]
RSP: 0018:ffff88013fd03680  EFLAGS: 00000246
RAX: ffff8800b71bc960 RBX: ffff88013fd03610 RCX: 0000000000000001
RDX: ffff880103bde930 RSI: 0000000000000001 RDI: 00000000a17faec9
RBP: ffff88013fd03710 R08: ffff88013fd03670 R09: ffff88013b006918
R10: ffff88013fd03670 R11: ffff88013fd03610 R12: ffff88013fd035f8
R13: ffffffff8136e9ab R14: ffff88013fd03710 R15: ffffffffa00e1530
=46S:  0000000000000000(0000) GS:ffff88013fd00000(0000) knlGS:000000000=
0000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffffffffff600400 CR3: 0000000001605000 CR4: 00000000000006a0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper/2 (pid: 0, threadinfo ffff88013b0dc000, task ffff88013b=
05eb00)
Stack:
  ffff8801440fce7b ffffffff440fce7b 310088013fd036a0 ffff8800b93aa888
  0000000000000000 ffff8800b71bc890 00000000ffffffff 0000000000000000
  ffff88013fd03730 ffffffff812cae56 ffff88013fd03820 ffff88013fd03748
Call Trace:
  <IRQ>
  [<ffffffff812cae56>] ? in4_pton+0x72/0x131
  [<ffffffffa00f46bf>] ip_nat_sdp_media+0x10c/0x185 [nf_nat_sip]
  [<ffffffffa00dfbac>] set_expected_rtp_rtcp+0x33e/0x3ac [nf_conntrack_=
sip]
  [<ffffffffa00dff26>] process_sdp+0x30c/0x3ec [nf_conntrack_sip]
  [<ffffffffa00f4738>] ? ip_nat_sdp_media+0x185/0x185 [nf_nat_sip]
  [<ffffffffa00e0e3f>] process_invite_response+0x49/0x6b [nf_conntrack_=
sip]
  [<ffffffff8116b46c>] ? simple_strtoul+0x9/0xb
  [<ffffffffa00e0593>] process_sip_msg.clone.11+0x1db/0x236 [nf_conntra=
ck_sip]
  [<ffffffff8104290f>] ? mod_timer_pending+0x119/0x129
  [<ffffffffa00e0df6>] ? process_update_response+0x6b/0x6b [nf_conntrac=
k_sip]
  [<ffffffffa00e0898>] sip_help_udp+0x8c/0x97 [nf_conntrack_sip]
  [<ffffffffa00a4a31>] ipv4_confirm+0xab/0x19f [nf_conntrack_ipv4]
  [<ffffffff812dc590>] nf_iterate+0x43/0x78
  [<ffffffff812e60ec>] ? ip_finish_output2+0x217/0x217
  [<ffffffff812dc633>] nf_hook_slow+0x6e/0x10b
  [<ffffffff812e60ec>] ? ip_finish_output2+0x217/0x217
  [<ffffffff812e74e8>] ip_output+0x83/0x97
  [<ffffffff812e29a0>] ? inet_del_protocol+0x37/0x37
  [<ffffffff812e4330>] ip_forward_finish+0x44/0x48
  [<ffffffff812e4606>] ip_forward+0x2d2/0x340
  [<ffffffff812e2cab>] ip_rcv_finish+0x30b/0x32f
  [<ffffffff812e32bf>] ip_rcv+0x263/0x294
  [<ffffffff81359291>] ? packet_rcv_spkt+0x11e/0x129
  [<ffffffff812bda0b>] __netif_receive_skb+0x3d8/0x41f
  [<ffffffff812bdc50>] netif_receive_skb+0x86/0x8d
  [<ffffffff810b1a77>] ? __kmalloc+0x3f/0xbe
  [<ffffffff81178a61>] ? swiotlb_dma_mapping_error+0x18/0x25
  [<ffffffff812bdd39>] napi_skb_finish+0x24/0x3b
  [<ffffffff812be2cd>] napi_gro_receive+0x105/0x111
  [<ffffffff81232982>] tg3_poll_work+0x6cb/0xad4
  [<ffffffff8123597b>] tg3_poll+0x18d/0x320
  [<ffffffff8136e9ab>] ? common_interrupt+0x6b/0x6b
  [<ffffffff812be3d7>] net_rx_action+0x71/0x12d
  [<ffffffff8103d88d>] __do_softirq+0x80/0x10a
  [<ffffffff81072dea>] ? handle_irq_event+0x47/0x5d
  [<ffffffff8137024c>] call_softirq+0x1c/0x30
  [<ffffffff81003372>] do_softirq+0x33/0x69
  [<ffffffff8103db3c>] irq_exit+0x3f/0xa3
  [<ffffffff8100329d>] do_IRQ+0x97/0xae
  [<ffffffff8136e9ab>] common_interrupt+0x6b/0x6b
  <EOI>
  [<ffffffff811c93e0>] ? acpi_idle_enter_bm+0x234/0x274
  [<ffffffff811c93db>] ? acpi_idle_enter_bm+0x22f/0x274
  [<ffffffff812a5ca0>] cpuidle_idle_call+0x8d/0xcd
  [<ffffffff810008c1>] cpu_idle+0x57/0x94
  [<ffffffff8168fe22>] start_secondary+0x1bf/0x1c4
Code: 82 e0 00 00 00 31 f6 48 85 c0 74 0a 31 f6 80 78 10 00 40 0f 95 c6=
 31 d2 85 f6 74 08 0f b6 50 10 48 8d 14 10 48 8b 42 28 45 31 e4 <48> 85=
 c0 74 0f 39 88 d0 00 00 00 4c 0f 44 e0 48 8b 00 eb ec 4d
Call Trace:
  <IRQ>  [<ffffffff812cae56>] ? in4_pton+0x72/0x131
  [<ffffffffa00f46bf>] ip_nat_sdp_media+0x10c/0x185 [nf_nat_sip]
  [<ffffffffa00dfbac>] set_expected_rtp_rtcp+0x33e/0x3ac [nf_conntrack_=
sip]
  [<ffffffffa00dff26>] process_sdp+0x30c/0x3ec [nf_conntrack_sip]
  [<ffffffffa00f4738>] ? ip_nat_sdp_media+0x185/0x185 [nf_nat_sip]
  [<ffffffffa00e0e3f>] process_invite_response+0x49/0x6b [nf_conntrack_=
sip]
  [<ffffffff8116b46c>] ? simple_strtoul+0x9/0xb
  [<ffffffffa00e0593>] process_sip_msg.clone.11+0x1db/0x236 [nf_conntra=
ck_sip]
  [<ffffffff8104290f>] ? mod_timer_pending+0x119/0x129
  [<ffffffffa00e0df6>] ? process_update_response+0x6b/0x6b [nf_conntrac=
k_sip]
  [<ffffffffa00e0898>] sip_help_udp+0x8c/0x97 [nf_conntrack_sip]
  [<ffffffffa00a4a31>] ipv4_confirm+0xab/0x19f [nf_conntrack_ipv4]
  [<ffffffff812dc590>] nf_iterate+0x43/0x78
  [<ffffffff812e60ec>] ? ip_finish_output2+0x217/0x217
  [<ffffffff812dc633>] nf_hook_slow+0x6e/0x10b
  [<ffffffff812e60ec>] ? ip_finish_output2+0x217/0x217
  [<ffffffff812e74e8>] ip_output+0x83/0x97
  [<ffffffff812e29a0>] ? inet_del_protocol+0x37/0x37
  [<ffffffff812e4330>] ip_forward_finish+0x44/0x48
  [<ffffffff812e4606>] ip_forward+0x2d2/0x340
  [<ffffffff812e2cab>] ip_rcv_finish+0x30b/0x32f
  [<ffffffff812e32bf>] ip_rcv+0x263/0x294
  [<ffffffff81359291>] ? packet_rcv_spkt+0x11e/0x129
  [<ffffffff812bda0b>] __netif_receive_skb+0x3d8/0x41f
  [<ffffffff812bdc50>] netif_receive_skb+0x86/0x8d
  [<ffffffff810b1a77>] ? __kmalloc+0x3f/0xbe
  [<ffffffff81178a61>] ? swiotlb_dma_mapping_error+0x18/0x25
  [<ffffffff812bdd39>] napi_skb_finish+0x24/0x3b
  [<ffffffff812be2cd>] napi_gro_receive+0x105/0x111
  [<ffffffff81232982>] tg3_poll_work+0x6cb/0xad4
  [<ffffffff8123597b>] tg3_poll+0x18d/0x320
  [<ffffffff8136e9ab>] ? common_interrupt+0x6b/0x6b
  [<ffffffff812be3d7>] net_rx_action+0x71/0x12d
  [<ffffffff8103d88d>] __do_softirq+0x80/0x10a
  [<ffffffff81072dea>] ? handle_irq_event+0x47/0x5d
  [<ffffffff8137024c>] call_softirq+0x1c/0x30
  [<ffffffff81003372>] do_softirq+0x33/0x69
  [<ffffffff8103db3c>] irq_exit+0x3f/0xa3
  [<ffffffff8100329d>] do_IRQ+0x97/0xae
  [<ffffffff8136e9ab>] common_interrupt+0x6b/0x6b
  <EOI>  [<ffffffff811c93e0>] ? acpi_idle_enter_bm+0x234/0x274
  [<ffffffff811c93db>] ? acpi_idle_enter_bm+0x22f/0x274
  [<ffffffff812a5ca0>] cpuidle_idle_call+0x8d/0xcd
  [<ffffffff810008c1>] cpu_idle+0x57/0x94
  [<ffffffff8168fe22>] start_secondary+0x1bf/0x1c4
  [<ffffffff8103d88d>] __do_softirq+0x80/0x10a
  [<ffffffff81072dea>] ? handle_irq_event+0x47/0x5d
  [<ffffffff8137024c>] call_softirq+0x1c/0x30
  [<ffffffff81003372>] do_softirq+0x33/0x69
  [<ffffffff8103db3c>] irq_exit+0x3f/0xa3
  [<ffffffff8100329d>] do_IRQ+0x97/0xae
  [<ffffffff8136e9ab>] common_interrupt+0x6b/0x6b
  <EOI>  [<ffffffff811c93e0>] ? acpi_idle_enter_bm+0x234/0x274
  [<ffffffff811c93db>] ? acpi_idle_enter_bm+0x22f/0x274
  [<ffffffff812a5ca0>] cpuidle_idle_call+0x8d/0xcd
  [<ffffffff810008c1>] cpu_idle+0x57/0x94
  [<ffffffff8135eb29>] rest_init+0x8d/0x91
  [<ffffffff816629f5>] start_kernel+0x299/0x2a4
  [<ffffffff81662274>] x86_64_start_reservations+0x84/0x89
  [<ffffffff8166236b>] x86_64_start_kernel+0xf2/0xf9
Rebooting in 15 seconds..


Below is the boot output:

Linux version 3.3.8 (root@cerber) (gcc version 4.5.3 (Gentoo Hardened 4=
=2E5.3-r2 p1.1, pie-0.4.7) ) #5 SMP PREEMPT Mon Jun 25 15:14:20 CEST 20=
12
Command line: ro md=3D1,/dev/sda1,/dev/sdb1 root=3D/dev/md1 panic=3D15 =
rootflags=3Ddata=3Djournal,barrier=3D1 console=3DttyS0,115200 console=3D=
tty0
BIOS-provided physical RAM map:
  BIOS-e820: 0000000000000000 - 000000000009d000 (usable)
  BIOS-e820: 0000000000100000 - 00000000bf699000 (usable)
  BIOS-e820: 00000000bf699000 - 00000000bf6af000 (reserved)
  BIOS-e820: 00000000bf6af000 - 00000000bf6ce000 (ACPI data)
  BIOS-e820: 00000000bf6ce000 - 00000000c0000000 (reserved)
  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
  BIOS-e820: 00000000fe000000 - 0000000100000000 (reserved)
  BIOS-e820: 0000000100000000 - 0000000140000000 (usable)
NX (Execute Disable) protection: active
DMI 2.6 present.
No AGP bridge found
last_pfn =3D 0x140000 max_arch_pfn =3D 0x400000000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
last_pfn =3D 0xbf699 max_arch_pfn =3D 0x400000000
init_memory_mapping: 0000000000000000-00000000bf699000
init_memory_mapping: 0000000100000000-0000000140000000
ACPI: RSDP 00000000000f1220 00024 (v02 DELL  )
ACPI: XSDT 00000000000f1320 00094 (v01 DELL   PE_SC3   00000001 DELL 00=
000001)
ACPI: FACP 00000000bf6c3bb4 000F4 (v03 DELL   PE_SC3   00000001 DELL 00=
000001)
ACPI: DSDT 00000000bf6af000 039A4 (v01 DELL   PE_SC3   00000001 INTL 20=
050624)
ACPI: FACS 00000000bf6c6000 00040
ACPI: APIC 00000000bf6c3478 00152 (v01 DELL   PE_SC3   00000001 DELL 00=
000001)
ACPI: SPCR 00000000bf6c35cc 00050 (v01 DELL   PE_SC3   00000001 DELL 00=
000001)
ACPI: HPET 00000000bf6c3620 00038 (v01 DELL   PE_SC3   00000001 DELL 00=
000001)
ACPI: DM__ 00000000bf6c365c 000A8 (v01 DELL   PE_SC3   00000001 DELL 00=
000001)
ACPI: MCFG 00000000bf6c3850 0003C (v01 DELL   PE_SC3   00000001 DELL 00=
000001)
ACPI: WD__ 00000000bf6c3890 00134 (v01 DELL   PE_SC3   00000001 DELL 00=
000001)
ACPI: SLIC 00000000bf6c39c8 00024 (v01 DELL   PE_SC3   00000001 DELL 00=
000001)
ACPI: ERST 00000000bf6b2b24 00270 (v01 DELL   PE_SC3   00000001 DELL 00=
000001)
ACPI: HEST 00000000bf6b2d94 003A8 (v01 DELL   PE_SC3   00000001 DELL 00=
000001)
ACPI: BERT 00000000bf6b29a4 00030 (v01 DELL   PE_SC3   00000001 DELL 00=
000001)
ACPI: EINJ 00000000bf6b29d4 00150 (v01 DELL   PE_SC3   00000001 DELL 00=
000001)
ACPI: TCPA 00000000bf6c3b4c 00064 (v02 DELL   PE_SC3   00000001 DELL 00=
000001)
ACPI: SSDT 00000000bf6c7000 011C4 (v01  INTEL PPM RCM  80000001 INTL 20=
061109)
Zone PFN ranges:
   DMA      0x00000010 -> 0x00001000
   DMA32    0x00001000 -> 0x00100000
   Normal   0x00100000 -> 0x00140000
Movable zone start PFN for each node
Early memory PFN ranges
     0: 0x00000010 -> 0x0000009d
     0: 0x00000100 -> 0x000bf699
     0: 0x00100000 -> 0x00140000
ACPI: PM-Timer IO Port: 0x808
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x24] disabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x25] disabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x26] disabled)
ACPI: LAPIC (acpi_id[0x08] lapic_id[0x27] disabled)
ACPI: LAPIC (acpi_id[0x09] lapic_id[0x28] disabled)
ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x29] disabled)
ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x2a] disabled)
ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x2b] disabled)
ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x2c] disabled)
ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x2d] disabled)
ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x2e] disabled)
ACPI: LAPIC (acpi_id[0x10] lapic_id[0x2f] disabled)
ACPI: LAPIC (acpi_id[0x11] lapic_id[0x30] disabled)
ACPI: LAPIC (acpi_id[0x12] lapic_id[0x31] disabled)
ACPI: LAPIC (acpi_id[0x13] lapic_id[0x32] disabled)
ACPI: LAPIC (acpi_id[0x14] lapic_id[0x33] disabled)
ACPI: LAPIC (acpi_id[0x15] lapic_id[0x34] disabled)
ACPI: LAPIC (acpi_id[0x16] lapic_id[0x35] disabled)
ACPI: LAPIC (acpi_id[0x17] lapic_id[0x36] disabled)
ACPI: LAPIC (acpi_id[0x18] lapic_id[0x37] disabled)
ACPI: LAPIC (acpi_id[0x19] lapic_id[0x38] disabled)
ACPI: LAPIC (acpi_id[0x1a] lapic_id[0x39] disabled)
ACPI: LAPIC (acpi_id[0x1b] lapic_id[0x3a] disabled)
ACPI: LAPIC (acpi_id[0x1c] lapic_id[0x3b] disabled)
ACPI: LAPIC (acpi_id[0x1d] lapic_id[0x3c] disabled)
ACPI: LAPIC (acpi_id[0x1e] lapic_id[0x3d] disabled)
ACPI: LAPIC (acpi_id[0x1f] lapic_id[0x3e] disabled)
ACPI: LAPIC (acpi_id[0x20] lapic_id[0x3f] disabled)
ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a701 base: 0xfed00000
SMP: Allowing 4 CPUs, 0 hotplug CPUs
Allocating PCI resources starting at c0000000 (gap: c0000000:20000000)
setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
PERCPU: Embedded 25 pages/cpu @ffff88013fc00000 s70016 r8192 d24192 u52=
4288
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 10=
25572
Kernel command line: ro md=3D1,/dev/sda1,/dev/sdb1 root=3D/dev/md1 pani=
c=3D15 rootflags=3Ddata=3Djournal,barrier=3D1 console=3DttyS0,115200 co=
nsole=3Dtty0
md: Will configure md1 (super-block) from /dev/sda1,/dev/sdb1, below.
PID hash table entries: 4096 (order: 3, 32768 bytes)
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Checking aperture...
No AGP bridge found
Memory: 4038340k/5242880k available (3575k kernel code, 1058664k absent=
, 145876k reserved, 2885k data, 460k init)
SLUB: Genslabs=3D15, HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D=
4, Nodes=3D1
Preemptible hierarchical RCU implementation.
NR_IRQS:4352 nr_irqs:712 16
Extended CMOS year: 2000
Console: colour VGA+ 80x25
console [tty0] enabled
console [ttyS0] enabled
=46ast TSC calibration using PIT
Detected 2393.968 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequenc=
y.. 4787.93 BogoMIPS (lpj=3D23939680)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 256
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
using mwait in idle threads.
=46reeing SMP alternatives: 20k freed
ACPI: Core revision 20120111
=2E.TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D-1
CPU0: Intel(R) Xeon(R) CPU           X3430  @ 2.40GHz stepping 05
Performance Events: PEBS fmt1+, Nehalem events, Intel PMU driver.
CPU erratum AAJ80 worked around
CPUID marked event: 'bus cycles' unavailable
=2E.. version:                3
=2E.. bit width:              48
=2E.. generic registers:      4
=2E.. value mask:             0000ffffffffffff
=2E.. max period:             000000007fffffff
=2E.. fixed-purpose events:   3
=2E.. event mask:             000000070000000f
NMI watchdog enabled, takes one hw-pmu counter.
Booting Node   0, Processors  #1
NMI watchdog enabled, takes one hw-pmu counter.
  #2
NMI watchdog enabled, takes one hw-pmu counter.
  #3 Ok.
NMI watchdog enabled, takes one hw-pmu counter.
Brought up 4 CPUs
Total of 4 processors activated (19151.74 BogoMIPS).
xor: automatically using best checksumming function: generic_sse
    generic_sse:  8360.400 MB/sec
xor: using function: generic_sse (8360.400 MB/sec)
NET: Registered protocol family 16
ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
ACPI: bus type pci registered
PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff=
] (base 0xe0000000)
PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
raid6: int64x1   2367 MB/s
raid6: int64x2   2573 MB/s
raid6: int64x4   2037 MB/s
raid6: int64x8   1567 MB/s
raid6: sse2x1    5916 MB/s
raid6: sse2x2    6911 MB/s
raid6: sse2x4    8055 MB/s
raid6: using algorithm sse2x4 (8055 MB/s)
ACPI: Added _OSI(Module Device)
ACPI: Added _OSI(Processor Device)
ACPI: Added _OSI(3.0 _SCP Extensions)
ACPI: Added _OSI(Processor Aggregator Device)
[Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: Using host bridge windows from ACPI; if necessary, use "pci=3Dnocr=
s" and report a bug
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xfdffffff]
pci_root PNP0A08:00: host bridge window [mem 0xfed40000-0xfed44fff]
PCI host bridge to bus 0000:00
pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: root bus resource [mem 0xc0000000-0xfdffffff]
pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed44fff]
pci 0000:00:03.0: PCI bridge to [bus 01-01]
pci 0000:00:05.0: PCI bridge to [bus 02-05]
pci 0000:02:00.0: PCI bridge to [bus 03-05]
pci 0000:03:02.0: PCI bridge to [bus 04-04]
pci 0000:03:04.0: PCI bridge to [bus 05-05]
pci 0000:00:1c.0: PCI bridge to [bus 06-09]
pci 0000:06:00.0: PCI bridge to [bus 07-09]
pci 0000:07:02.0: PCI bridge to [bus 08-08]
pci 0000:07:04.0: PCI bridge to [bus 09-09]
pci 0000:00:1c.4: PCI bridge to [bus 0a-0a]
pci 0000:00:1c.5: PCI bridge to [bus 0b-0b]
pci 0000:00:1e.0: PCI bridge to [bus 0c-0c] (subtractive decode)
  pci0000:00: Requesting ACPI _OSC control (0x1d)
  pci0000:00: ACPI _OSC control (0x1d) granted
ACPI: PCI Interrupt Link [LK00] (IRQs 3 4 5 6 7 10 11 14 *15)
ACPI: PCI Interrupt Link [LK01] (IRQs 3 4 *5 6 7 10 11 14 15)
ACPI: PCI Interrupt Link [LK02] (IRQs 3 4 5 6 7 *10 11 14 15)
ACPI: PCI Interrupt Link [LK03] (IRQs 3 4 5 *6 7 10 11 14 15)
ACPI: PCI Interrupt Link [LK04] (IRQs 3 4 5 6 7 10 *11 14 15)
ACPI: PCI Interrupt Link [LK05] (IRQs 3 4 5 6 7 10 11 14 15) *0, disabl=
ed.
ACPI: PCI Interrupt Link [LK06] (IRQs 3 4 5 6 7 10 11 *14 15)
ACPI: PCI Interrupt Link [LK07] (IRQs 3 4 5 6 7 10 11 14 15) *0, disabl=
ed.
vgaarb: device added: PCI:0000:0c:03.0,decodes=3Dio+mem,owns=3Dio+mem,l=
ocks=3Dnone
vgaarb: loaded
vgaarb: bridge control possible 0000:0c:03.0
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: Discovered peer bus ff
PCI host bridge to bus 0000:ff
pci_bus 0000:ff: root bus resource [io  0x0000-0xffff]
pci_bus 0000:ff: root bus resource [mem 0x00000000-0xfffffffff]
HPET: 8 timers in total, 4 timers will be used for per-cpu timer
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 40, 41, 42, 43, 0, 0
hpet0: 8 comparators, 64-bit 14.318180 MHz counter
Switching to clocksource hpet
pnp: PnP ACPI init
ACPI: bus type pnp registered
system 00:07: [io  0x0800-0x087f] has been reserved
system 00:07: [io  0x0880-0x08ff] has been reserved
system 00:07: [io  0x0900-0x091f] has been reserved
system 00:07: [io  0x0920-0x0923] has been reserved
system 00:07: [io  0x0924] has been reserved
system 00:07: [io  0x0ca0-0x0ca7] has been reserved
system 00:07: [io  0x0ca9-0x0cab] has been reserved
system 00:07: [io  0x0cad-0x0caf] has been reserved
system 00:08: [io  0x0ca8] has been reserved
system 00:08: [io  0x0cac] has been reserved
system 00:0b: [mem 0xe0000000-0xefffffff] has been reserved
system 00:0d: [mem 0xfed50000-0xfed53fff] has been reserved
pnp: PnP ACPI: found 14 devices
ACPI: ACPI bus type pnp unregistered
pci 0000:00:03.0: PCI bridge to [bus 01-01]
pci 0000:04:00.0: BAR 7: assigned [mem 0xdd400000-0xdd41ffff 64bit]
pci 0000:04:00.0: BAR 10: assigned [mem 0xdd420000-0xdd43ffff 64bit]
pci 0000:04:00.1: BAR 7: assigned [mem 0xdd440000-0xdd45ffff 64bit]
pci 0000:04:00.1: BAR 10: assigned [mem 0xdd460000-0xdd47ffff 64bit]
pci 0000:03:02.0: PCI bridge to [bus 04-04]
pci 0000:03:02.0:   bridge window [io  0xf000-0xffff]
pci 0000:03:02.0:   bridge window [mem 0xdd400000-0xddffffff]
pci 0000:05:00.0: BAR 7: assigned [mem 0xdc800000-0xdc81ffff 64bit]
pci 0000:05:00.0: BAR 10: assigned [mem 0xdc820000-0xdc83ffff 64bit]
pci 0000:05:00.1: BAR 7: assigned [mem 0xdc840000-0xdc85ffff 64bit]
pci 0000:05:00.1: BAR 10: assigned [mem 0xdc860000-0xdc87ffff 64bit]
pci 0000:03:04.0: PCI bridge to [bus 05-05]
pci 0000:03:04.0:   bridge window [io  0xe000-0xefff]
pci 0000:03:04.0:   bridge window [mem 0xdc800000-0xdd3fffff]
pci 0000:02:00.0: PCI bridge to [bus 03-05]
pci 0000:02:00.0:   bridge window [io  0xe000-0xffff]
pci 0000:02:00.0:   bridge window [mem 0xdc800000-0xddffffff]
pci 0000:00:05.0: PCI bridge to [bus 02-05]
pci 0000:00:05.0:   bridge window [io  0xe000-0xffff]
pci 0000:00:05.0:   bridge window [mem 0xdc800000-0xddffffff]
pci 0000:08:00.0: BAR 7: assigned [mem 0xdec00000-0xdec1ffff 64bit]
pci 0000:08:00.0: BAR 10: assigned [mem 0xdec20000-0xdec3ffff 64bit]
pci 0000:08:00.1: BAR 7: assigned [mem 0xdec40000-0xdec5ffff 64bit]
pci 0000:08:00.1: BAR 10: assigned [mem 0xdec60000-0xdec7ffff 64bit]
pci 0000:07:02.0: PCI bridge to [bus 08-08]
pci 0000:07:02.0:   bridge window [io  0xd000-0xdfff]
pci 0000:07:02.0:   bridge window [mem 0xdec00000-0xdf7fffff]
pci 0000:09:00.0: BAR 7: assigned [mem 0xde000000-0xde01ffff 64bit]
pci 0000:09:00.0: BAR 10: assigned [mem 0xde020000-0xde03ffff 64bit]
pci 0000:09:00.1: BAR 7: assigned [mem 0xde040000-0xde05ffff 64bit]
pci 0000:09:00.1: BAR 10: assigned [mem 0xde060000-0xde07ffff 64bit]
pci 0000:07:04.0: PCI bridge to [bus 09-09]
pci 0000:07:04.0:   bridge window [io  0xc000-0xcfff]
pci 0000:07:04.0:   bridge window [mem 0xde000000-0xdebfffff]
pci 0000:06:00.0: PCI bridge to [bus 07-09]
pci 0000:06:00.0:   bridge window [io  0xc000-0xdfff]
pci 0000:06:00.0:   bridge window [mem 0xde000000-0xdf7fffff]
pci 0000:00:1c.0: PCI bridge to [bus 06-09]
pci 0000:00:1c.0:   bridge window [io  0xc000-0xdfff]
pci 0000:00:1c.0:   bridge window [mem 0xde000000-0xdf7fffff]
pci 0000:00:1c.4: PCI bridge to [bus 0a-0a]
pci 0000:00:1c.4:   bridge window [mem 0xdf900000-0xdf9fffff]
pci 0000:00:1c.5: PCI bridge to [bus 0b-0b]
pci 0000:0c:03.0: BAR 6: assigned [mem 0xdb800000-0xdb80ffff pref]
pci 0000:00:1e.0: PCI bridge to [bus 0c-0c]
pci 0000:00:1e.0:   bridge window [mem 0xdb800000-0xdc7fffff]
pci 0000:00:1e.0:   bridge window [mem 0xdb000000-0xdb7fffff 64bit pref=
]
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
UDP hash table entries: 2048 (order: 4, 65536 bytes)
UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
NET: Registered protocol family 1
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing 64MB software IO TLB between ffff8800bb693000 - ffff8800bf69300=
0
software IO TLB at phys 0xbb693000 - 0xbf693000
microcode: CPU0 sig=3D0x106e5, pf=3D0x2, revision=3D0x4
microcode: CPU1 sig=3D0x106e5, pf=3D0x2, revision=3D0x4
microcode: CPU2 sig=3D0x106e5, pf=3D0x2, revision=3D0x4
microcode: CPU3 sig=3D0x106e5, pf=3D0x2, revision=3D0x4
microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>=
, Peter Oruba
Intel AES-NI instructions are not detected.
sha1_ssse3: Using SSSE3 optimized SHA-1 implementation
HugeTLB registered 2 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
msgmni has been set to 7887
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
start plist test
end plist test
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
ACPI: Power Button [PWRF]
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
00:05: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
00:06: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
Non-volatile memory driver v1.3
ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 3 Gbps 0x3f impl SAT=
A mode
ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pmp pio slum part e=
ms sxs apst
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
ata1: SATA max UDMA/133 abar m2048@0xdf8fe000 port 0xdf8fe100 irq 53
ata2: SATA max UDMA/133 abar m2048@0xdf8fe000 port 0xdf8fe180 irq 53
ata3: SATA max UDMA/133 abar m2048@0xdf8fe000 port 0xdf8fe200 irq 53
ata4: SATA max UDMA/133 abar m2048@0xdf8fe000 port 0xdf8fe280 irq 53
ata5: SATA max UDMA/133 abar m2048@0xdf8fe000 port 0xdf8fe300 irq 53
ata6: SATA max UDMA/133 abar m2048@0xdf8fe000 port 0xdf8fe380 irq 53
tg3.c:v3.122 (December 7, 2011)
tg3 0000:0a:00.0: eth0: Tigon3 [partno(BCM95722) rev a200] (PCI Express=
) MAC address b8:ac:6f:99:19:f5
tg3 0000:0a:00.0: eth0: attached PHY is 5722/5756 (10/100/1000Base-T Et=
hernet) (WireSpeed[1], EEE[0])
tg3 0000:0a:00.0: eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[1] TSOcap=
[1]
tg3 0000:0a:00.0: eth0: dma_rwctrl[76180000] dma_mask[64-bit]
igb: Intel(R) Gigabit Ethernet Network Driver - version 3.2.10-k
igb: Copyright (c) 2007-2012 Intel Corporation.
igb 0000:04:00.0: Intel(R) Gigabit Ethernet Network Connection
igb 0000:04:00.0: eth1: (PCIe:2.5Gb/s:Width x4) 00:1b:21:84:34:28
igb 0000:04:00.0: eth1: PBA No: E66339-003
igb 0000:04:00.0: Using MSI-X interrupts. 4 rx queue(s), 4 tx queue(s)
ata3: SATA link down (SStatus 0 SControl 300)
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata4: SATA link down (SStatus 0 SControl 300)
ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata5.00: ATAPI: PLDS DVD-ROM DH-16D5S, VD15, max UDMA/100
ata6: SATA link down (SStatus 0 SControl 300)
ata2.00: ATA-8: WDC WD5003ABYX-18WERA0, 01.01S02, max UDMA/133
ata2.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
ata5.00: configured for UDMA/100
ata1.00: ATA-8: WDC WD5003ABYX-18WERA0, 01.01S02, max UDMA/133
ata1.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
ata2.00: configured for UDMA/133
ata1.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      WDC WD5003ABYX-1 01.0 PQ: 0 AN=
SI: 5
sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 1:0:0:0: Direct-Access     ATA      WDC WD5003ABYX-1 01.0 PQ: 0 AN=
SI: 5
sd 1:0:0:0: [sdb] 976773168 512-byte logical blocks: (500 GB/465 GiB)
sd 1:0:0:0: Attached scsi generic sg1 type 0
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't s=
upport DPO or FUA
scsi 4:0:0:0: CD-ROM            PLDS     DVD-ROM DH-16D5S VD15 PQ: 0 AN=
SI: 5
sr0: scsi3-mmc drive: 48x/48x cd/rw xa/form2 cdda tray
cdrom: Uniform CD-ROM driver Revision: 3.20
sr 4:0:0:0: Attached scsi generic sg2 type 5
  sdb: sdb1 sdb2
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't s=
upport DPO or FUA
sd 1:0:0:0: [sdb] Attached SCSI disk
  sda: sda1 sda2
sd 0:0:0:0: [sda] Attached SCSI disk
igb 0000:04:00.1: Intel(R) Gigabit Ethernet Network Connection
igb 0000:04:00.1: eth2: (PCIe:2.5Gb/s:Width x4) 00:1b:21:84:34:29
igb 0000:04:00.1: eth2: PBA No: E66339-003
igb 0000:04:00.1: Using MSI-X interrupts. 4 rx queue(s), 4 tx queue(s)
Refined TSC clocksource calibration: 2393.985 MHz.
Switching to clocksource tsc
igb 0000:05:00.0: Intel(R) Gigabit Ethernet Network Connection
igb 0000:05:00.0: eth3: (PCIe:2.5Gb/s:Width x4) 00:1b:21:84:34:2c
igb 0000:05:00.0: eth3: PBA No: E66339-003
igb 0000:05:00.0: Using MSI-X interrupts. 4 rx queue(s), 4 tx queue(s)
igb 0000:05:00.1: Intel(R) Gigabit Ethernet Network Connection
igb 0000:05:00.1: eth4: (PCIe:2.5Gb/s:Width x4) 00:1b:21:84:34:2d
igb 0000:05:00.1: eth4: PBA No: E66339-003
igb 0000:05:00.1: Using MSI-X interrupts. 4 rx queue(s), 4 tx queue(s)
igb 0000:08:00.0: Intel(R) Gigabit Ethernet Network Connection
igb 0000:08:00.0: eth5: (PCIe:2.5Gb/s:Width x4) 00:1b:21:84:84:e0
igb 0000:08:00.0: eth5: PBA No: E66339-003
igb 0000:08:00.0: Using MSI-X interrupts. 4 rx queue(s), 4 tx queue(s)
igb 0000:08:00.1: Intel(R) Gigabit Ethernet Network Connection
igb 0000:08:00.1: eth6: (PCIe:2.5Gb/s:Width x4) 00:1b:21:84:84:e1
igb 0000:08:00.1: eth6: PBA No: E66339-003
igb 0000:08:00.1: Using MSI-X interrupts. 4 rx queue(s), 4 tx queue(s)
igb 0000:09:00.0: Intel(R) Gigabit Ethernet Network Connection
igb 0000:09:00.0: eth7: (PCIe:2.5Gb/s:Width x4) 00:1b:21:84:84:e4
igb 0000:09:00.0: eth7: PBA No: E66339-003
igb 0000:09:00.0: Using MSI-X interrupts. 4 rx queue(s), 4 tx queue(s)
igb 0000:09:00.1: Intel(R) Gigabit Ethernet Network Connection
igb 0000:09:00.1: eth8: (PCIe:2.5Gb/s:Width x4) 00:1b:21:84:84:e5
igb 0000:09:00.1: eth8: PBA No: E66339-003
igb 0000:09:00.1: Using MSI-X interrupts. 4 rx queue(s), 4 tx queue(s)
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usbcore: registered new interface driver libusual
i8042: PNP: No PS/2 controller found. Probing ports directly.
i8042: No controller found
mousedev: PS/2 mouse device common for all mice
input: PC Speaker as /devices/platform/pcspkr/input/input1
rtc_cmos 00:04: RTC can wake from S4
rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one day, y3k, 242 bytes nvram, hpet irqs
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.07
iTCO_wdt: Found a 3420 TCO device (Version=3D2, TCOBASE=3D0x0860)
iTCO_wdt: initialized. heartbeat=3D30 sec (nowayout=3D0)
md: raid1 personality registered for level 1
md: raid10 personality registered for level 10
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
device-mapper: ioctl: 4.22.0-ioctl (2011-10-19) initialised: dm-devel@r=
edhat.com
cpuidle: using governor ladder
cpuidle: using governor menu
dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 10
NET: Registered protocol family 17
NET: Registered protocol family 15
rtc_cmos 00:04: setting system clock to 2012-06-26 16:14:41 UTC (134072=
7281)
md: Waiting for all devices to be available before autodetect
md: If you don't use raid, use raid=3Dnoautodetect
md: Autodetecting RAID arrays.
md: Scanned 4 and added 4 devices.
md: autorun ...
md: considering sda2 ...
md:  adding sda2 ...
md: sda1 has different UUID to sda2
md:  adding sdb2 ...
md: sdb1 has different UUID to sda2
md: created md2
md: bind<sdb2>
md: bind<sda2>
md: running: <sda2><sdb2>
bio: create slab <bio-1> at 1
md/raid1:md2: active with 2 out of 2 mirrors
created bitmap (1 pages) for device md2
md2: bitmap initialized from disk: read 1/1 pages, set 0 of 32 bits
md2: detected capacity change from 0 to 2147418112
md: considering sda1 ...
md:  adding sda1 ...
md:  adding sdb1 ...
md: created md1
md: bind<sdb1>
md: bind<sda1>
md: running: <sda1><sdb1>
md/raid1:md1: active with 2 out of 2 mirrors
created bitmap (4 pages) for device md1
md1: bitmap initialized from disk: read 1/1 pages, set 1 of 7421 bits
md1: detected capacity change from 0 to 497960222720
md: ... autorun DONE.
md: Loading md1: /dev/sda1
  md1: unknown partition table
md: couldn't update array info. -22
md: could not open unknown-block(8,1).
md: md_import_device returned -16
md: could not open unknown-block(8,17).
md: md_import_device returned -16
md: starting md1 failed
EXT3-fs (md1): recovery required on readonly filesystem
EXT3-fs (md1): write access will be enabled during recovery
kjournald starting.  Commit interval 5 seconds
EXT3-fs (md1): orphan cleanup on readonly fs
EXT3-fs (md1): 1 orphan inode deleted
EXT3-fs (md1): recovery complete
EXT3-fs (md1): mounted filesystem with journal data mode
VFS: Mounted root (ext3 filesystem) readonly on device 9:1.
=46reeing unused kernel memory: 460k freed
Write protecting the kernel read-only data: 6144k
=46reeing unused kernel memory: 504k freed
=46reeing unused kernel memory: 820k freed


I suspect some conntrack code (nf_conntrack_sip ?) to be guilty.


Any help from you with this issue?
Thanks in advance :-)

--=20
Best regards,
Rafa=B3 Fitt

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
