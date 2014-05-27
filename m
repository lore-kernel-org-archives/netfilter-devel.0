From: Vincent Tondellier <tondellier+ml.nfdev@dosisoft.fr>
Subject: Re: OOPS NULL pointer dereference in nf_nat_setup_info+0x471 (reproductible, 3.14.4)
Date: Tue, 27 May 2014 11:12:12 +0200
Message-ID: <2804925.t1WkgPfonN@luna>
References: <4667198.VVkvcgzEe7@luna>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from achille.dosisoft.fr ([46.105.6.253]:56085 "EHLO
	achille.dosisoft.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbaE0JWm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 May 2014 05:22:42 -0400
Received: from gaia.dosisoft.fr (unknown [10.16.64.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(Client CN "*.dosisoft.fr", Issuer "DOSIsoft Internal webservices CA" (not verified))
	by achille.dosisoft.fr (Postfix) with ESMTPS id 3gd8ZS5g2Xz7q3Q
	for <netfilter-devel@vger.kernel.org>; Tue, 27 May 2014 11:12:16 +0200 (CEST)
Received: from luna.dosisoft.fr (luna.dosisoft.fr [IPv6:2a01:e35:2e99:9f40:1:0:65:39])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: tondellier)
	by gaia.dosisoft.fr (Postfix) with ESMTPSA id 3gd8ZS3B3cz33
	for <netfilter-devel@vger.kernel.org>; Tue, 27 May 2014 11:12:16 +0200 (CEST)
In-Reply-To: <4667198.VVkvcgzEe7@luna>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,
 
> I got the following OOPS with kernel 3.14.4 (debian backport for wheezy) on
> our internet gateway while trying to establish a new PPTP tunnel from a
> NAT-ed host.

The second part may explain the crash :

crash> foreach bt
PID: 0      TASK: ffffffff81813480  CPU: 0   COMMAND: "swapper/0"
 #0 [ffff8800bfa032f0] machine_kexec at ffffffff8104d1e7
 #1 [ffff8800bfa03350] crash_kexec at ffffffff810dc815
 #2 [ffff8800bfa03420] oops_end at ffffffff814f2538
 #3 [ffff8800bfa03440] no_context at ffffffff814e7e94
 #4 [ffff8800bfa03490] __do_page_fault at ffffffff814f4f16
 #5 [ffff8800bfa035a0] page_fault at ffffffff814f1948
    [exception RIP: nf_nat_setup_info+1137]
    RIP: ffffffffa040ec41  RSP: ffff8800bfa03658  RFLAGS: 00010246
    RAX: 0000000000000000  RBX: ffff880036ce4d48  RCX: 0000000000000000
    RDX: ffff8800bb463ac0  RSI: 00000000feeccf54  RDI: ffffffffa0411430
    RBP: 0000000000003c3a   R8: ffffffff81886f80   R9: ffff8800bb463ac0
    R10: ffff8800bfa03638  R11: ffff880036ac0000  R12: 0000000000000000
    R13: ffff8800bfa036b8  R14: 0000000000000000  R15: 0000000000000000
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
 #6 [ffff8800bfa03740] xt_snat_target_v0 at ffffffffa05250fd [xt_nat]
 #7 [ffff8800bfa03780] ipt_do_table at ffffffffa04a5260 [ip_tables]
 #8 [ffff8800bfa038b0] nf_nat_ipv4_fn at ffffffffa0516214 [iptable_nat]
 #9 [ffff8800bfa03930] nf_nat_ipv4_out at ffffffffa0516488 [iptable_nat]
#10 [ffff8800bfa03950] nf_iterate at ffffffff8142ebf6
#11 [ffff8800bfa039a0] nf_hook_slow at ffffffff8142eca7
#12 [ffff8800bfa03a10] ip_output at ffffffff8143af2a
#13 [ffff8800bfa03a30] __netif_receive_skb_core at ffffffff813fe293
#14 [ffff8800bfa03ab0] br_handle_frame_finish at ffffffffa0456760 [bridge]
#15 [ffff8800bfa03b00] br_nf_pre_routing_finish at ffffffffa045d1a6 [bridge]
#16 [ffff8800bfa03b60] br_nf_pre_routing at ffffffffa045d9df [bridge]
#17 [ffff8800bfa03bb0] nf_iterate at ffffffff8142ebf6
#18 [ffff8800bfa03c00] nf_hook_slow at ffffffff8142eca7
#19 [ffff8800bfa03c70] br_handle_frame at ffffffffa0456b18 [bridge]
#20 [ffff8800bfa03cb0] __netif_receive_skb_core at ffffffff813fdfbd
#21 [ffff8800bfa03d30] napi_gro_receive at ffffffff813fecb5
#22 [ffff8800bfa03d60] tg3_poll_work at ffffffffa023649f [tg3]
#23 [ffff8800bfa03e30] tg3_poll at ffffffffa023f124 [tg3]
#24 [ffff8800bfa03e90] net_rx_action at ffffffff813ff9a9
#25 [ffff8800bfa03ea0] get_next_timer_interrupt at ffffffff81072bfa
#26 [ffff8800bfa03f00] __do_softirq at ffffffff81069a9e
#27 [ffff8800bfa03f70] irq_exit at ffffffff81069ebe
#28 [ffff8800bfa03f80] do_IRQ at ffffffff81017211
--- <IRQ stack> ---
#29 [ffffffff81801df8] ret_from_intr at ffffffff814f162d
    [exception RIP: native_safe_halt+2]
    RIP: ffffffff810512c2  RSP: ffffffff81801ea0  RFLAGS: 00000292
    RAX: ffffffff8101e7f0  RBX: ffff8800bfa0ec80  RCX: ffffffff81840d60
    RDX: ffff8800bfa00000  RSI: 0000000000000000  RDI: 0000000000000096
    RBP: ffffffff818a6980   R8: 0000000000000000   R9: 0000000000000000
    R10: 0000000000000000  R11: 000000010037af38  R12: 0000000000000082
    R13: ffffffff8101d8c5  R14: 000000018101d86d  R15: ffff8800bfa143b8
    ORIG_RAX: ffffffffffffffad  CS: 0010  SS: 0018
#30 [ffffffff81801ea0] default_idle at ffffffff8101e80d
#31 [ffffffff81801ed0] cpu_startup_entry at ffffffff810b7dc3
#32 [ffffffff81801f30] start_kernel at ffffffff818c6f11
#33 [ffffffff81801f80] x86_64_start_kernel at ffffffff818c672b

PID: 0      TASK: ffff8800bc2f09a0  CPU: 1   COMMAND: "swapper/1"
 #0 [ffff8800bfa47e30] crash_nmi_callback at ffffffff81043827
 #1 [ffff8800bfa47e40] nmi_handle at ffffffff814f26e5
 #2 [ffff8800bfa47ec0] do_nmi at ffffffff814f28e0
 #3 [ffff8800bfa47ef0] end_repeat_nmi at ffffffff814f1cb1
    [exception RIP: _raw_spin_lock_bh+40]
    RIP: ffffffff814f10a8  RSP: ffff8800bfa43d90  RFLAGS: 00000297
    RAX: 0000000000000010  RBX: 0000000000000010  RCX: 0000000000000297
    RDX: ffff8800bfa43d90  RSI: 0000000000000018  RDI: 0000000000000001
    RBP: ffffffff814f10a8   R8: ffffffff814f10a8   R9: 0000000000000018
    R10: ffff8800bfa43d90  R11: 0000000000000297  R12: ffffffffffffffff
    R13: ffffffffa0411430  R14: 0000000000000200  R15: 0000000000006d06
    ORIG_RAX: 0000000000006d06  CS: 0010  SS: 0018
--- <NMI exception stack> ---
 #4 [ffff8800bfa43d90] _raw_spin_lock_bh at ffffffff814f10a8
 #5 [ffff8800bfa43d90] nf_nat_cleanup_conntrack at ffffffffa040e09e [nf_nat]
 #6 [ffff8800bfa43da0] __nf_ct_ext_destroy at ffffffffa0314d81 [nf_conntrack]
 #7 [ffff8800bfa43dc0] nf_conntrack_free at ffffffffa030c477 [nf_conntrack]
 #8 [ffff8800bfa43de0] nf_conntrack_destroy at ffffffff8142ea82
 #9 [ffff8800bfa43df0] nf_ct_delete at ffffffffa030cc68 [nf_conntrack]
#10 [ffff8800bfa43e50] call_timer_fn at ffffffff8106ff07
#11 [ffff8800bfa43ea0] run_timer_softirq at ffffffff8107153f
#12 [ffff8800bfa43f20] __do_softirq at ffffffff81069a9e
#13 [ffff8800bfa43f90] irq_exit at ffffffff81069ebe
#14 [ffff8800bfa43fa0] smp_apic_timer_interrupt at ffffffff810466ab
#15 [ffff8800bfa43fb0] apic_timer_interrupt at ffffffff814fa35d
--- <IRQ stack> ---
#16 [ffff8800bc2f5e18] apic_timer_interrupt at ffffffff814fa35d
    [exception RIP: native_safe_halt+2]
    RIP: ffffffff810512c2  RSP: ffff8800bc2f5ec0  RFLAGS: 00000292
    RAX: ffffffff8101e7f0  RBX: ffff8800bfa4ec80  RCX: ffffffff81840d60
    RDX: ffff8800bfa40000  RSI: 0000000000000000  RDI: 0000000000000096
    RBP: ffffffff818a6980   R8: 0000000000000000   R9: 0000000000000000
    R10: 0000000000000000  R11: 000000010037aff9  R12: 0000000000000082
    R13: ffffffff8101d8c5  R14: 000000018101d86d  R15: ffff8800bfa543b8
    ORIG_RAX: ffffffffffffff10  CS: 0010  SS: 0018
#17 [ffff8800bc2f5ec0] default_idle at ffffffff8101e80d
#18 [ffff8800bc2f5ef0] cpu_startup_entry at ffffffff810b7dc3

PID: 1      TASK: ffff8800bc2c71b0  CPU: 1   COMMAND: "init"
 #0 [ffff8800bc2c98b8] __schedule at ffffffff814eddda

[...]

All other processes are in __schedule too


