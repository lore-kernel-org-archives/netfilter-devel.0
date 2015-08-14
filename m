From: Dave Jones <davej@codemonkey.org.uk>
Subject: ipset triggering kasan warnings.
Date: Thu, 13 Aug 2015 21:13:03 -0400
Message-ID: <20150814011303.GB19621@codemonkey.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from arcturus.aphlor.org ([188.246.204.175]:56214 "EHLO
	arcturus.aphlor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbbHNBNM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Aug 2015 21:13:12 -0400
Received: from [209.6.119.210] (helo=wopr.kernelslacker.org)
	by arcturus.aphlor.org with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
	(Exim 4.84)
	(envelope-from <davej@codemonkey.org.uk>)
	id 1ZQ3YH-0005ow-DY
	for netfilter-devel@vger.kernel.org; Fri, 14 Aug 2015 02:12:59 +0100
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I finally found some time to play with kasan, ad immediately hit some traces
when I add a netmask with ipset.

[   23.139532] ==================================================================
[   23.146130] BUG: KASan: out of bounds access in hash_net4_add_cidr+0x1db/0x220 at addr ffff8800d4844b58
[   23.152937] Write of size 4 by task ipset/457
[   23.159742] =============================================================================
[   23.166672] BUG kmalloc-512 (Not tainted): kasan: bad access detected
[   23.173641] -----------------------------------------------------------------------------
[   23.194668] INFO: Allocated in hash_net_create+0x16a/0x470 age=7 cpu=1 pid=456
[   23.201836] 	__slab_alloc.constprop.66+0x554/0x620
[   23.208994] 	__kmalloc+0x2f2/0x360
[   23.216105] 	hash_net_create+0x16a/0x470
[   23.223238] 	ip_set_create+0x3e6/0x740
[   23.230343] 	nfnetlink_rcv_msg+0x599/0x640
[   23.237454] 	netlink_rcv_skb+0x14f/0x190
[   23.244533] 	nfnetlink_rcv+0x3f6/0x790
[   23.251579] 	netlink_unicast+0x272/0x390
[   23.258573] 	netlink_sendmsg+0x5a1/0xa50
[   23.265485] 	SYSC_sendto+0x1da/0x2c0
[   23.272364] 	SyS_sendto+0xe/0x10
[   23.279168] 	entry_SYSCALL_64_fastpath+0x12/0x6f
[   23.286001] INFO: Freed in load_elf_binary+0x1328/0x28f0 age=17 cpu=0 pid=455
[   23.292906] 	__slab_free+0x15a/0x260
[   23.299826] 	kfree+0x2c5/0x300
[   23.306724] 	load_elf_binary+0x1328/0x28f0
[   23.313662] 	search_binary_handler+0x9d/0x160
[   23.320624] 	do_execveat_common+0xb56/0xf10
[   23.327572] 	SyS_execve+0x2d/0x40
[   23.334436] 	return_from_execve+0x0/0x23
[   23.341231] INFO: Slab 0xffffea0003521100 objects=19 used=14 fp=0xffff8800d48460d0 flags=0x4000000000004080
[   23.348173] INFO: Object 0xffff8800d48449d8 @offset=2520 fp=0xffff8800d48460d0
[   23.362088] Bytes b4 ffff8800d48449c8: c9 93 ff ff 00 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a  ........ZZZZZZZZ
[   23.369152] Object ffff8800d48449d8: 00 80 2f d2 01 88 ff ff 00 00 01 00 01 00 00 00  ../.............
[   23.376266] Object ffff8800d48449e8: 38 bc b1 19 00 00 00 00 00 00 00 00 00 00 00 00  8...............
[   23.383323] Object ffff8800d48449f8: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   23.390330] Object ffff8800d4844a08: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   23.397224] Object ffff8800d4844a18: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   23.404008] Object ffff8800d4844a28: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   23.410698] Object ffff8800d4844a38: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   23.417264] Object ffff8800d4844a48: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   23.423733] Object ffff8800d4844a58: 00 00 00 00 21 00 00 00 00 00 00 00 00 00 00 00  ....!...........
[   23.430143] Object ffff8800d4844a68: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   23.436521] Object ffff8800d4844a78: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   23.442806] Object ffff8800d4844a88: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   23.449007] Object ffff8800d4844a98: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   23.455076] Object ffff8800d4844aa8: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   23.461059] Object ffff8800d4844ab8: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   23.466986] Object ffff8800d4844ac8: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   23.472797] Object ffff8800d4844ad8: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   23.478509] Object ffff8800d4844ae8: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   23.484107] Object ffff8800d4844af8: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   23.489606] Object ffff8800d4844b08: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   23.495004] Object ffff8800d4844b18: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   23.500275] Object ffff8800d4844b28: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   23.505436] Object ffff8800d4844b38: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   23.510471] Object ffff8800d4844b48: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   23.515375] Object ffff8800d4844b58: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   23.520170] Object ffff8800d4844b68: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   23.524898] Object ffff8800d4844b78: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   23.529629] Object ffff8800d4844b88: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   23.534289] Object ffff8800d4844b98: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   23.538861] Object ffff8800d4844ba8: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   23.543352] Object ffff8800d4844bb8: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   23.547675] Object ffff8800d4844bc8: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   23.551801] Redzone ffff8800d4844bd8: cc cc cc cc cc cc cc cc                          ........
[   23.555959] Padding ffff8800d4844d18: 5a 5a 5a 5a 5a 5a 5a 5a                          ZZZZZZZZ
[   23.559934] CPU: 0 PID: 457 Comm: ipset Tainted: G    B           4.2.0-rc6-firewall+ #4 [loadavg: 0.84 0.19 0.06 1/69 457]
[   23.563890]  ffff880037998000 ffff8801d181f108 ffffffffa1c0b4fb 0000000000000053
[   23.567822]  ffff8801d6802b40 ffff8801d181f138 ffffffffa1229e5e ffff8801d6802b40
[   23.571678]  ffffea0003521100 ffff8800d48449d8 ffff8800d48449d8 ffff8801d181f168
[   23.575477] Call Trace:
[   23.579126]  [<ffffffffa1c0b4fb>] dump_stack+0x4f/0x7b
[   23.582781]  [<ffffffffa1229e5e>] print_trailer+0xfe/0x160
[   23.586429]  [<ffffffffa122d77b>] object_err+0x3b/0x50
[   23.590013]  [<ffffffffa12317b3>] kasan_report_error+0x1e3/0x3f0
[   23.593568]  [<ffffffffa10e6bb2>] ? trace_hardirqs_on_caller+0x192/0x2a0
[   23.597143]  [<ffffffffa10e6cce>] ? trace_hardirqs_on+0xe/0x10
[   23.600692]  [<ffffffffa1231a9b>] kasan_report+0x3b/0x40
[   23.604244]  [<ffffffffa1a0bd8b>] ? hash_net4_add_cidr+0x1db/0x220
[   23.607828]  [<ffffffffa1230ea9>] __asan_store4+0x69/0xa0
[   23.611413]  [<ffffffffa1230509>] ? kasan_unpoison_shadow+0x39/0x50
[   23.615035]  [<ffffffffa123074b>] ? kasan_kmalloc+0x6b/0x80
[   23.618642]  [<ffffffffa1a0bd8b>] hash_net4_add_cidr+0x1db/0x220
[   23.622290]  [<ffffffffa122e3b3>] ? __kmalloc+0x133/0x360
[   23.625948]  [<ffffffffa1a148a7>] hash_net4_add+0x497/0xda0
[   23.629619]  [<ffffffffa19d1b80>] ? ip_set_elem_len+0x180/0x180
[   23.633304]  [<ffffffffa1a0d3b1>] hash_net4_uadt+0x541/0x570
[   23.636926]  [<ffffffffa1a14410>] ? hash_net6_add+0xe10/0xe10
[   23.640502]  [<ffffffffa1a0ce70>] ? hash_net6_flush+0x1b0/0x1b0
[   23.644082]  [<ffffffffa10e60e8>] ? mark_lock+0x78/0x8e0
[   23.647654]  [<ffffffffa14c8b87>] ? debug_smp_processor_id+0x17/0x20
[   23.651257]  [<ffffffffa10e2e80>] ? get_lock_stats+0x40/0x90
[   23.654859]  [<ffffffffa10b838a>] ? preempt_count_sub+0x1a/0x130
[   23.658465]  [<ffffffffa19cc752>] call_ad+0x152/0x340
[   23.662065]  [<ffffffffa19cc600>] ? ip_set_protocol+0x230/0x230
[   23.665590]  [<ffffffffa14c8b87>] ? debug_smp_processor_id+0x17/0x20
[   23.669043]  [<ffffffffa10e2e80>] ? get_lock_stats+0x40/0x90
[   23.672446]  [<ffffffffa10b8431>] ? preempt_count_sub+0xc1/0x130
[   23.675776]  [<ffffffffa14a5cc6>] ? strncmp+0x76/0xc0
[   23.679013]  [<ffffffffa14d95bf>] ? validate_nla+0x1ef/0x220
[   23.682267]  [<ffffffffa14d97a6>] ? nla_parse+0xb6/0x140
[   23.685538]  [<ffffffffa19cfda9>] ip_set_uadd+0x359/0x590
[   23.688855]  [<ffffffffa10e60e8>] ? mark_lock+0x78/0x8e0
[   23.692203]  [<ffffffffa19cfa50>] ? ip_set_udel+0x5b0/0x5b0
[   23.695599]  [<ffffffffa10e69f4>] ? mark_held_locks+0xa4/0xd0
[   23.699048]  [<ffffffffa19cfa50>] ? ip_set_udel+0x5b0/0x5b0
[   23.702536]  [<ffffffffa1997039>] nfnetlink_rcv_msg+0x599/0x640
[   23.706078]  [<ffffffffa1996cff>] ? nfnetlink_rcv_msg+0x25f/0x640
[   23.709670]  [<ffffffffa198f01f>] netlink_rcv_skb+0x14f/0x190
[   23.713307]  [<ffffffffa1996aa0>] ? nfnetlink_rcv+0x790/0x790
[   23.716988]  [<ffffffffa1996706>] nfnetlink_rcv+0x3f6/0x790
[   23.720710]  [<ffffffffa198bdf2>] netlink_unicast+0x272/0x390
[   23.724481]  [<ffffffffa198bd67>] ? netlink_unicast+0x1e7/0x390
[   23.728305]  [<ffffffffa191ce45>] ? __alloc_skb+0x215/0x310
[   23.732169]  [<ffffffffa198bb80>] ? netlink_detachskb+0x40/0x40
[   23.736085]  [<ffffffffa14b66d7>] ? copy_from_iter+0x167/0x480
[   23.740051]  [<ffffffffa198ce41>] netlink_sendmsg+0x5a1/0xa50
[   23.744067]  [<ffffffffa198c8a0>] ? netlink_broadcast_filtered+0x480/0x480
[   23.748175]  [<ffffffffa190f09a>] SYSC_sendto+0x1da/0x2c0
[   23.752317]  [<ffffffffa190eec0>] ? sock_write_iter+0x200/0x200
[   23.756517]  [<ffffffffa1c19406>] ? _raw_spin_unlock+0x36/0x60
[   23.760755]  [<ffffffffa12019bc>] ? handle_mm_fault+0xeac/0x1610
[   23.765045]  [<ffffffffa10b8431>] ? preempt_count_sub+0xc1/0x130
[   23.769387]  [<ffffffffa14c8b87>] ? debug_smp_processor_id+0x17/0x20
[   23.773790]  [<ffffffffa10e2e80>] ? get_lock_stats+0x40/0x90
[   23.778242]  [<ffffffffa10b8431>] ? preempt_count_sub+0xc1/0x130
[   23.782751]  [<ffffffffa11f707b>] ? vmacache_find+0x9b/0x150
[   23.787300]  [<ffffffffa10e6974>] ? mark_held_locks+0x24/0xd0
[   23.791898]  [<ffffffffa1c1ab45>] ? retint_swapgs+0x11/0x16
[   23.796540]  [<ffffffffa10e6bb2>] ? trace_hardirqs_on_caller+0x192/0x2a0
[   23.801272]  [<ffffffffa191151e>] SyS_sendto+0xe/0x10
[   23.805928]  [<ffffffffa1c19fd7>] entry_SYSCALL_64_fastpath+0x12/0x6f
[   23.810623] Memory state around the buggy address:
[   23.815212]  ffff8800d4844a00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   23.819780]  ffff8800d4844a80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   23.824293] >ffff8800d4844b00: 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc fc
[   23.828770]                                                     ^
[   23.833191]  ffff8800d4844b80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[   23.837679]  ffff8800d4844c00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[   23.842124] ==================================================================
[   23.858637] ==================================================================
[   23.883341] BUG: KASan: out of bounds access in hash_net4_add_cidr+0xeb/0x220 at addr ffff8800d4844b58
[   23.909216] Read of size 4 by task ipset/458
[   23.935149] =============================================================================
[   23.961867] BUG kmalloc-512 (Tainted: G    B          ): kasan: bad access detected
[   23.988908] -----------------------------------------------------------------------------
[   24.043423] INFO: Allocated in hash_net_create+0x16a/0x470 age=74 cpu=1 pid=456
[   24.071453] 	__slab_alloc.constprop.66+0x554/0x620
[   24.099483] 	__kmalloc+0x2f2/0x360
[   24.127329] 	hash_net_create+0x16a/0x470
[   24.155185] 	ip_set_create+0x3e6/0x740
[   24.182994] 	nfnetlink_rcv_msg+0x599/0x640
[   24.210808] 	netlink_rcv_skb+0x14f/0x190
[   24.238593] 	nfnetlink_rcv+0x3f6/0x790
[   24.266418] 	netlink_unicast+0x272/0x390
[   24.266420] 	netlink_sendmsg+0x5a1/0xa50
[   24.266425] 	SYSC_sendto+0x1da/0x2c0
[   24.266427] 	SyS_sendto+0xe/0x10
[   24.266431] 	entry_SYSCALL_64_fastpath+0x12/0x6f
[   24.266435] INFO: Freed in load_elf_binary+0x1328/0x28f0 age=75 cpu=0 pid=455
[   24.266438] 	__slab_free+0x15a/0x260
[   24.266442] 	kfree+0x2c5/0x300
[   24.266445] 	load_elf_binary+0x1328/0x28f0
[   24.266447] 	search_binary_handler+0x9d/0x160
[   24.266449] 	do_execveat_common+0xb56/0xf10
[   24.266451] 	SyS_execve+0x2d/0x40
[   24.266454] 	return_from_execve+0x0/0x23
[   24.266456] INFO: Slab 0xffffea0003521100 objects=19 used=14 fp=0xffff8800d48453b0 flags=0x4000000000004080
[   24.266458] INFO: Object 0xffff8800d48449d8 @offset=2520 fp=0xffff8800d48460d0
[   24.266461] Bytes b4 ffff8800d48449c8: c9 93 ff ff 00 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a  ........ZZZZZZZZ
[   24.266463] Object ffff8800d48449d8: 00 80 2f d2 01 88 ff ff 00 00 01 00 02 00 00 00  ../.............
[   24.266466] Object ffff8800d48449e8: 38 bc b1 19 00 00 00 00 00 00 00 00 00 00 00 00  8...............
[   24.266468] Object ffff8800d48449f8: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   24.266470] Object ffff8800d4844a08: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   24.266472] Object ffff8800d4844a18: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   24.266474] Object ffff8800d4844a28: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   24.266476] Object ffff8800d4844a38: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   24.266478] Object ffff8800d4844a48: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   24.266480] Object ffff8800d4844a58: 00 00 00 00 21 00 00 00 00 00 00 00 00 00 00 00  ....!...........
[   24.266483] Object ffff8800d4844a68: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   24.266485] Object ffff8800d4844a78: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   24.266487] Object ffff8800d4844a88: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   24.266489] Object ffff8800d4844a98: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   24.266491] Object ffff8800d4844aa8: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   24.266493] Object ffff8800d4844ab8: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   24.266495] Object ffff8800d4844ac8: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   24.266497] Object ffff8800d4844ad8: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   24.266499] Object ffff8800d4844ae8: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   24.266501] Object ffff8800d4844af8: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   24.266503] Object ffff8800d4844b08: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   24.266505] Object ffff8800d4844b18: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   24.266508] Object ffff8800d4844b28: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   24.266510] Object ffff8800d4844b38: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   24.266512] Object ffff8800d4844b48: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   24.266514] Object ffff8800d4844b58: 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   24.266516] Object ffff8800d4844b68: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   24.266518] Object ffff8800d4844b78: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   24.266520] Object ffff8800d4844b88: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   24.266523] Object ffff8800d4844b98: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   24.266525] Object ffff8800d4844ba8: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   24.266527] Object ffff8800d4844bb8: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   24.266529] Object ffff8800d4844bc8: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   24.266531] Redzone ffff8800d4844bd8: cc cc cc cc cc cc cc cc                          ........
[   24.266533] Padding ffff8800d4844d18: 5a 5a 5a 5a 5a 5a 5a 5a                          ZZZZZZZZ
[   24.266540] CPU: 1 PID: 458 Comm: ipset Tainted: G    B           4.2.0-rc6-firewall+ #4 [loadavg: 0.84 0.19 0.06 2/69 458]
[   24.266544]  0000000000000000 ffff8801d19bf108 ffffffffa1c0b4fb 0000000000000053
[   24.266547]  ffff8801d6802b40 ffff8801d19bf138 ffffffffa1229e5e ffff8801d6802b40
[   24.266551]  ffffea0003521100 ffff8800d48449d8 ffffffffffffffff ffff8801d19bf168
[   24.266551] Call Trace:
[   24.266555]  [<ffffffffa1c0b4fb>] dump_stack+0x4f/0x7b
[   24.266558]  [<ffffffffa1229e5e>] print_trailer+0xfe/0x160
[   24.266561]  [<ffffffffa122d77b>] object_err+0x3b/0x50
[   24.266564]  [<ffffffffa12317b3>] kasan_report_error+0x1e3/0x3f0
[   24.266569]  [<ffffffffa10e6a36>] ? trace_hardirqs_on_caller+0x16/0x2a0
[   24.266571]  [<ffffffffa10e6cce>] ? trace_hardirqs_on+0xe/0x10
[   24.266574]  [<ffffffffa1231a9b>] kasan_report+0x3b/0x40
[   24.266577]  [<ffffffffa1a0bc9b>] ? hash_net4_add_cidr+0xeb/0x220
[   24.266579]  [<ffffffffa1230e06>] __asan_load4+0x66/0xa0
[   24.266582]  [<ffffffffa1230509>] ? kasan_unpoison_shadow+0x39/0x50
[   24.266584]  [<ffffffffa123074b>] ? kasan_kmalloc+0x6b/0x80
[   24.266586]  [<ffffffffa1a0bc9b>] hash_net4_add_cidr+0xeb/0x220
[   24.266589]  [<ffffffffa1a148a7>] hash_net4_add+0x497/0xda0
[   24.266592]  [<ffffffffa19d1b80>] ? ip_set_elem_len+0x180/0x180
[   24.266595]  [<ffffffffa1a0d3b1>] hash_net4_uadt+0x541/0x570
[   24.266597]  [<ffffffffa1a14410>] ? hash_net6_add+0xe10/0xe10
[   24.266600]  [<ffffffffa1a0ce70>] ? hash_net6_flush+0x1b0/0x1b0
[   24.266602]  [<ffffffffa19cc710>] ? call_ad+0x110/0x340
[   24.266605]  [<ffffffffa19cc752>] call_ad+0x152/0x340
[   24.266608]  [<ffffffffa19cc600>] ? ip_set_protocol+0x230/0x230
[   24.266610]  [<ffffffffa19140a1>] ? sock_def_readable+0x121/0x1c0
[   24.266613]  [<ffffffffa10e8ff5>] ? __lock_acquire+0xa5/0x2710
[   24.266618]  [<ffffffffa11090cc>] ? debug_lockdep_rcu_enabled+0x2c/0x70
[   24.266621]  [<ffffffffa14a5cc6>] ? strncmp+0x76/0xc0
[   24.266625]  [<ffffffffa14d95bf>] ? validate_nla+0x1ef/0x220
[   24.266627]  [<ffffffffa14d97a6>] ? nla_parse+0xb6/0x140
[   24.266630]  [<ffffffffa19cfb88>] ? ip_set_uadd+0x138/0x590
[   24.266632]  [<ffffffffa19cfda9>] ip_set_uadd+0x359/0x590
[   24.266635]  [<ffffffffa19cfa50>] ? ip_set_udel+0x5b0/0x5b0
[   24.266637]  [<ffffffffa1996e00>] ? nfnetlink_rcv_msg+0x360/0x640
[   24.266641]  [<ffffffffa14d97a6>] ? nla_parse+0xb6/0x140
[   24.266643]  [<ffffffffa1996dd5>] ? nfnetlink_rcv_msg+0x335/0x640
[   24.266645]  [<ffffffffa19cfa50>] ? ip_set_udel+0x5b0/0x5b0
[   24.266648]  [<ffffffffa1997039>] nfnetlink_rcv_msg+0x599/0x640
[   24.266650]  [<ffffffffa1996cff>] ? nfnetlink_rcv_msg+0x25f/0x640
[   24.266653]  [<ffffffffa198f01f>] netlink_rcv_skb+0x14f/0x190
[   24.266656]  [<ffffffffa1996aa0>] ? nfnetlink_rcv+0x790/0x790
[   24.266658]  [<ffffffffa1996706>] nfnetlink_rcv+0x3f6/0x790
[   24.266662]  [<ffffffffa1988930>] ? netlink_lookup.isra.49+0xb0/0x120
[   24.266665]  [<ffffffffa198bdc3>] ? netlink_unicast+0x243/0x390
[   24.266668]  [<ffffffffa198bdf2>] netlink_unicast+0x272/0x390
[   24.266671]  [<ffffffffa198bd67>] ? netlink_unicast+0x1e7/0x390
[   24.266673]  [<ffffffffa191ce45>] ? __alloc_skb+0x215/0x310
[   24.266676]  [<ffffffffa198bb80>] ? netlink_detachskb+0x40/0x40
[   24.266679]  [<ffffffffa14b66d7>] ? copy_from_iter+0x167/0x480
[   24.266683]  [<ffffffffa198ce41>] netlink_sendmsg+0x5a1/0xa50
[   24.266686]  [<ffffffffa198c8a0>] ? netlink_broadcast_filtered+0x480/0x480
[   24.266690]  [<ffffffffa190f09a>] SYSC_sendto+0x1da/0x2c0
[   24.266693]  [<ffffffffa190eec0>] ? sock_write_iter+0x200/0x200
[   24.266696]  [<ffffffffa14c8d12>] ? __list_del_entry+0x62/0x110
[   24.266698]  [<ffffffffa11090cc>] ? debug_lockdep_rcu_enabled+0x2c/0x70
[   24.266702]  [<ffffffffa1205759>] ? validate_mm+0x69/0x4b0
[   24.266704]  [<ffffffffa12057b6>] ? validate_mm+0xc6/0x4b0
[   24.266708]  [<ffffffffa1209d35>] ? do_munmap+0x565/0x780
[   24.266710]  [<ffffffffa120b602>] ? vm_munmap+0x62/0x70
[   24.266713]  [<ffffffffa10ec432>] ? lockdep_sys_exit+0x22/0xb0
[   24.266716]  [<ffffffffa191151e>] SyS_sendto+0xe/0x10
[   24.266719]  [<ffffffffa1c19fd7>] entry_SYSCALL_64_fastpath+0x12/0x6f
[   24.266720] Memory state around the buggy address:
[   24.266722]  ffff8800d4844a00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   24.266724]  ffff8800d4844a80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   24.266726] >ffff8800d4844b00: 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc fc
[   24.266727]                                                     ^
[   24.266729]  ffff8800d4844b80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[   24.266731]  ffff8800d4844c00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[   24.266732] ==================================================================

