From: Oliver <olipro@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: Re: [PATCH] death_by_event() does not check IPS_DYING_BIT - race condition against ctnetlink_del_conntrack
Date: Wed, 29 Aug 2012 01:10:29 +0200
Message-ID: <1605551.o4ZNqbFbkc@gentoovm>
References: <7353554.n89QJXU3eh@gentoovm> <20120828105235.GA22669@1984> <9829027.jsWF3AolUh@gentoovm>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart1735493.BrRhXXdo0c"
Content-Transfer-Encoding: 7Bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:36495 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753Ab2H1XKi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 28 Aug 2012 19:10:38 -0400
In-Reply-To: <9829027.jsWF3AolUh@gentoovm>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--nextPart1735493.BrRhXXdo0c
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Tuesday 28 August 2012 19:16:39 Oliver wrote:
> During testing I found that the kernel is indeed solid and does not panic;
> however, I managed to make conntrackd eat 100% of a CPU core on one of the
> pair and conntrack entries remained unevicted from the kernel until I killed
> the conntrackd process.

having conntrackd running while the conntrack table is full is causing a GPF - 
I have attached a dmesg output of the kernel panic resulting from a general 
protection fault.

The first GPF is from the kernel patched with the code provided in my previous 
e-mail (the one for v3.4.10 based on the patch you provided me)

the second is with my only my original patch (the one-liner that checks the 
dying bit in death_by_event) - although that's likely not relevant here since 
that function is not part of the stack.

Kind Regards,
Oliver
--nextPart1735493.BrRhXXdo0c
Content-Disposition: attachment; filename="fw02-lab-general_protection_fault.txt"
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"; name="fw02-lab-general_protection_fault.txt"

Aug 28 15:18:06 fw02-lab [  352.508058] testing netconsole, hello!
Aug 28 15:19:59 fw02-lab [  465.619240] nf_conntrack: table full, dropping packet.
Aug 28 15:19:59 fw02-lab [  465.619258] nf_conntrack: table full, dropping packet.
Aug 28 15:19:59 fw02-lab [  465.619272] nf_conntrack: table full, dropping packet.
Aug 28 15:19:59 fw02-lab [  465.619274] nf_conntrack: table full, dropping packet.
Aug 28 15:19:59 fw02-lab [  465.619286] nf_conntrack: table full, dropping packet.
Aug 28 15:19:59 fw02-lab [  465.619288] nf_conntrack: table full, dropping packet.
Aug 28 15:19:59 fw02-lab [  465.619298] nf_conntrack: table full, dropping packet.
Aug 28 15:19:59 fw02-lab [  465.619314] nf_conntrack: table full, dropping packet.
Aug 28 15:19:59 fw02-lab [  465.619338] nf_conntrack: table full, dropping packet.
Aug 28 15:19:59 fw02-lab [  465.619349] nf_conntrack: table full, dropping packet.
Aug 28 15:20:00 fw02-lab [  467.077056] general protection fault: 0000 [#1] 
Aug 28 15:20:00 fw02-lab SMP 
Aug 28 15:20:00 fw02-lab 
Aug 28 15:20:00 fw02-lab [  467.077205] CPU 0 
Aug 28 15:20:00 fw02-lab 
Aug 28 15:20:00 fw02-lab [  467.077254] Modules linked in:
Aug 28 15:20:00 fw02-lab xt_set
Aug 28 15:20:00 fw02-lab ip_set_hash_ipportnet
Aug 28 15:20:00 fw02-lab ip_set_hash_net
Aug 28 15:20:00 fw02-lab ip_set
Aug 28 15:20:00 fw02-lab igb
Aug 28 15:20:00 fw02-lab bnx2
Aug 28 15:20:00 fw02-lab iTCO_wdt
Aug 28 15:20:00 fw02-lab dca
Aug 28 15:20:00 fw02-lab 
Aug 28 15:20:00 fw02-lab [  467.077769] 
Aug 28 15:20:00 fw02-lab [  467.077818] Pid: 2853, comm: conntrackd Not tainted 3.4.11-zerolag+ #1
Aug 28 15:20:00 fw02-lab Dell Inc. PowerEdge R310
Aug 28 15:20:00 fw02-lab /05XKKK
Aug 28 15:20:00 fw02-lab 
Aug 28 15:20:00 fw02-lab [  467.078017] RIP: 0010:[<ffffffff8152d6c7>] 
Aug 28 15:20:00 fw02-lab [<ffffffff8152d6c7>] nf_ct_delete_from_lists+0x57/0x90
Aug 28 15:20:00 fw02-lab [  467.078184] RSP: 0018:ffff88012650f858  EFLAGS: 00010246
Aug 28 15:20:00 fw02-lab [  467.078292] RAX: ffff880132737c28 RBX: ffff880130c4ca20 RCX: ffff88013229d708
Aug 28 15:20:00 fw02-lab [  467.078404] RDX: dead000000200200 RSI: dead000000200200 RDI: ffffffff81bcf580
Aug 28 15:20:00 fw02-lab [  467.078516] RBP: ffffffff81bcd080 R08: 0000000000000170 R09: 0000000000000001
Aug 28 15:20:00 fw02-lab [  467.078630] R10: 0000000000000002 R11: 000000009b0cb868 R12: 0000000000000000
Aug 28 15:20:00 fw02-lab [  467.078746] R13: ffffffff81bcd080 R14: 0000000000000000 R15: 00000000fffffffe
Aug 28 15:20:00 fw02-lab [  467.078864] FS:  00007f8bc707f700(0000) GS:ffff88013fc00000(0000) knlGS:0000000000000000
Aug 28 15:20:00 fw02-lab [  467.079037] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Aug 28 15:20:00 fw02-lab [  467.079148] CR2: 00007f8bc72e6ac0 CR3: 0000000126bc3000 CR4: 00000000000007f0
Aug 28 15:20:00 fw02-lab [  467.079260] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug 28 15:20:00 fw02-lab [  467.079371] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug 28 15:20:00 fw02-lab [  467.079484] Process conntrackd (pid: 2853, threadinfo ffff88012650e000, task ffff8801382eb400)
Aug 28 15:20:00 fw02-lab [  467.079652] Stack:
Aug 28 15:20:00 fw02-lab [  467.079754]  0000000000000286
Aug 28 15:20:00 fw02-lab ffff880130c4ca20
Aug 28 15:20:00 fw02-lab 0000000000000000
Aug 28 15:20:00 fw02-lab ffffffff8152e188
Aug 28 15:20:00 fw02-lab 
Aug 28 15:20:00 fw02-lab [  467.080103]  0000000000000000
Aug 28 15:20:00 fw02-lab 0000000000000000
Aug 28 15:20:00 fw02-lab 0000000000000286
Aug 28 15:20:00 fw02-lab ffffffff81054901
Aug 28 15:20:00 fw02-lab 
Aug 28 15:20:00 fw02-lab [  467.080591]  ffff880130c4ca20
Aug 28 15:20:00 fw02-lab ffffffff81bcd080
Aug 28 15:20:00 fw02-lab 0000000000000000
Aug 28 15:20:00 fw02-lab ffffffff81bcd080
Aug 28 15:20:00 fw02-lab 
Aug 28 15:20:00 fw02-lab [  467.080938] Call Trace:
Aug 28 15:20:00 fw02-lab [  467.081044]  [<ffffffff8152e188>] ? nf_ct_delete+0xe8/0x280
Aug 28 15:20:00 fw02-lab [  467.081155]  [<ffffffff81054901>] ? del_timer+0x61/0x80
Aug 28 15:20:00 fw02-lab [  467.081265]  [<ffffffff8152e684>] ? early_drop+0xf4/0x160
Aug 28 15:20:00 fw02-lab [  467.081376]  [<ffffffff8152ed8f>] ? __nf_conntrack_alloc+0x24f/0x290
Aug 28 15:20:00 fw02-lab [  467.081490]  [<ffffffff815374db>] ? ctnetlink_create_conntrack+0x4b/0x440
Aug 28 15:20:00 fw02-lab [  467.081602]  [<ffffffff815353f7>] ? ctnetlink_parse_tuple+0x147/0x170
Aug 28 15:20:00 fw02-lab [  467.081712]  [<ffffffff8152dadd>] ? ____nf_conntrack_find+0x10d/0x120
Aug 28 15:20:00 fw02-lab [  467.081823]  [<ffffffff8152db39>] ? __nf_conntrack_find_get+0x49/0x170
Aug 28 15:20:00 fw02-lab [  467.081935]  [<ffffffff81538c29>] ? ctnetlink_new_conntrack+0x299/0x3e0
Aug 28 15:20:00 fw02-lab [  467.082047]  [<ffffffff812811b0>] ? nla_parse+0x80/0xd0
Aug 28 15:20:00 fw02-lab [  467.082158]  [<ffffffff8152cbee>] ? nfnetlink_rcv_msg+0x1ee/0x220
Aug 28 15:20:00 fw02-lab [  467.082270]  [<ffffffff8152ca2a>] ? nfnetlink_rcv_msg+0x2a/0x220
Aug 28 15:20:00 fw02-lab [  467.082381]  [<ffffffff8152ca00>] ? nfnl_lock+0x20/0x20
Aug 28 15:20:00 fw02-lab [  467.082491]  [<ffffffff81529639>] ? netlink_rcv_skb+0x99/0xc0
Aug 28 15:20:00 fw02-lab [  467.082602]  [<ffffffff81528fcf>] ? netlink_unicast+0x1af/0x200
Aug 28 15:20:00 fw02-lab [  467.082712]  [<ffffffff81529258>] ? netlink_sendmsg+0x238/0x350
Aug 28 15:20:00 fw02-lab [  467.082824]  [<ffffffff814e5204>] ? sock_sendmsg+0xe4/0x130
Aug 28 15:20:00 fw02-lab [  467.082933]  [<ffffffff814e506d>] ? sock_recvmsg+0xed/0x140
Aug 28 15:20:00 fw02-lab [  467.083044]  [<ffffffff8118001e>] ? ext4_file_write+0x6e/0x2a0
Aug 28 15:20:00 fw02-lab [  467.083155]  [<ffffffff8111a10c>] ? do_path_lookup+0x2c/0xd0
Aug 28 15:20:00 fw02-lab [  467.083264]  [<ffffffff811171ef>] ? getname_flags+0x6f/0x270
Aug 28 15:20:00 fw02-lab [  467.083374]  [<ffffffff8110c447>] ? do_sync_write+0xc7/0x100
Aug 28 15:20:00 fw02-lab [  467.083482]  [<ffffffff814e43f2>] ? sockfd_lookup_light+0x22/0x90
Aug 28 15:20:00 fw02-lab [  467.083592]  [<ffffffff814e710c>] ? sys_sendto+0x13c/0x1a0
Aug 28 15:20:00 fw02-lab [  467.083702]  [<ffffffff81687862>] ? system_call_fastpath+0x16/0x1b
Aug 28 15:20:00 fw02-lab [  467.083810] Code: 
Aug 28 15:20:00 fw02-lab 48 
Aug 28 15:20:00 fw02-lab 8b 
Aug 28 15:20:00 fw02-lab 43 
Aug 28 15:20:00 fw02-lab 08 
Aug 28 15:20:00 fw02-lab 48 
Aug 28 15:20:00 fw02-lab 8b 
Aug 28 15:20:00 fw02-lab 53 
Aug 28 15:20:00 fw02-lab 10 
Aug 28 15:20:00 fw02-lab a8 
Aug 28 15:20:00 fw02-lab 01 
Aug 28 15:20:00 fw02-lab 48 
Aug 28 15:20:00 fw02-lab 89 
Aug 28 15:20:00 fw02-lab 02 
Aug 28 15:20:00 fw02-lab 75 
Aug 28 15:20:00 fw02-lab 04 
Aug 28 15:20:00 fw02-lab 48 
Aug 28 15:20:00 fw02-lab 89 
Aug 28 15:20:00 fw02-lab 50 
Aug 28 15:20:00 fw02-lab 08 
Aug 28 15:20:00 fw02-lab 48 
Aug 28 15:20:00 fw02-lab 8b 
Aug 28 15:20:00 fw02-lab 43 
Aug 28 15:20:00 fw02-lab 40 
Aug 28 15:20:00 fw02-lab 48 
Aug 28 15:20:00 fw02-lab be 
Aug 28 15:20:00 fw02-lab 00 
Aug 28 15:20:00 fw02-lab 02 
Aug 28 15:20:00 fw02-lab 20 
Aug 28 15:20:00 fw02-lab 00 
Aug 28 15:20:00 fw02-lab 00 
Aug 28 15:20:00 fw02-lab 00 
Aug 28 15:20:00 fw02-lab ad 
Aug 28 15:20:00 fw02-lab de 
Aug 28 15:20:00 fw02-lab 48 
Aug 28 15:20:00 fw02-lab 8b 
Aug 28 15:20:00 fw02-lab 53 
Aug 28 15:20:00 fw02-lab 48 
Aug 28 15:20:00 fw02-lab 48 
Aug 28 15:20:00 fw02-lab 89 
Aug 28 15:20:00 fw02-lab 73 
Aug 28 15:20:00 fw02-lab 10 
Aug 28 15:20:00 fw02-lab a8 
Aug 28 15:20:00 fw02-lab 01 
Aug 28 15:20:00 fw02-lab 
Aug 28 15:20:00 fw02-lab 89 
Aug 28 15:20:00 fw02-lab 02 
Aug 28 15:20:00 fw02-lab 75 
Aug 28 15:20:00 fw02-lab 04 
Aug 28 15:20:00 fw02-lab 48 
Aug 28 15:20:00 fw02-lab 89 
Aug 28 15:20:00 fw02-lab 50 
Aug 28 15:20:00 fw02-lab 08 
Aug 28 15:20:00 fw02-lab 48 
Aug 28 15:20:00 fw02-lab 89 
Aug 28 15:20:00 fw02-lab df 
Aug 28 15:20:00 fw02-lab 48 
Aug 28 15:20:00 fw02-lab b9 
Aug 28 15:20:00 fw02-lab 00 
Aug 28 15:20:00 fw02-lab 02 
Aug 28 15:20:00 fw02-lab 20 
Aug 28 15:20:00 fw02-lab 00 
Aug 28 15:20:00 fw02-lab 00 
Aug 28 15:20:00 fw02-lab 00 
Aug 28 15:20:00 fw02-lab ad 
Aug 28 15:20:00 fw02-lab 
Aug 28 15:20:00 fw02-lab [  467.086984] RIP 
Aug 28 15:20:00 fw02-lab [<ffffffff8152d6c7>] nf_ct_delete_from_lists+0x57/0x90
Aug 28 15:20:00 fw02-lab [  467.087142]  RSP <ffff88012650f858>
Aug 28 15:20:00 fw02-lab [  467.087263] ---[ end trace 71ca302640a71c1f ]---
Aug 28 15:20:00 fw02-lab [  467.087525] Kernel panic - not syncing: Fatal exception in interrupt
Aug 28 15:20:00 fw02-lab [  467.087642] Rebooting in 5 seconds..


<SNIP>


Aug 28 15:50:00 fw02-lab [  220.903447] testing netconsole again, hello!
Aug 28 15:51:28 fw02-lab [  308.589992] nf_conntrack: table full, dropping packet.
Aug 28 15:51:28 fw02-lab [  308.590036] nf_conntrack: table full, dropping packet.
Aug 28 15:51:28 fw02-lab [  308.590061] nf_conntrack: table full, dropping packet.
Aug 28 15:51:28 fw02-lab [  308.590082] nf_conntrack: table full, dropping packet.
Aug 28 15:51:28 fw02-lab [  308.590131] nf_conntrack: table full, dropping packet.
Aug 28 15:51:28 fw02-lab [  308.590139] nf_conntrack: table full, dropping packet.
Aug 28 15:51:28 fw02-lab [  308.590201] nf_conntrack: table full, dropping packet.
Aug 28 15:51:28 fw02-lab [  308.590239] nf_conntrack: table full, dropping packet.
Aug 28 15:51:28 fw02-lab [  308.590352] nf_conntrack: table full, dropping packet.
Aug 28 15:51:28 fw02-lab [  308.590442] nf_conntrack: table full, dropping packet.
Aug 28 15:51:29 fw02-lab [  310.128590] general protection fault: 0000 [#1] 
Aug 28 15:51:29 fw02-lab SMP 
Aug 28 15:51:29 fw02-lab 
Aug 28 15:51:29 fw02-lab [  310.128741] CPU 0 
Aug 28 15:51:29 fw02-lab 
Aug 28 15:51:29 fw02-lab [  310.128791] Modules linked in:
Aug 28 15:51:29 fw02-lab xt_set
Aug 28 15:51:29 fw02-lab ip_set_hash_ipportnet
Aug 28 15:51:29 fw02-lab ip_set_hash_net
Aug 28 15:51:29 fw02-lab ip_set
Aug 28 15:51:29 fw02-lab igb
Aug 28 15:51:29 fw02-lab dca
Aug 28 15:51:29 fw02-lab bnx2
Aug 28 15:51:29 fw02-lab iTCO_wdt
Aug 28 15:51:29 fw02-lab 
Aug 28 15:51:29 fw02-lab [  310.129312] 
Aug 28 15:51:29 fw02-lab [  310.129361] Pid: 2859, comm: conntrackd Not tainted 3.4.10-zerolag+ #2
Aug 28 15:51:29 fw02-lab Dell Inc. PowerEdge R310
Aug 28 15:51:29 fw02-lab /05XKKK
Aug 28 15:51:29 fw02-lab 
Aug 28 15:51:29 fw02-lab [  310.129561] RIP: 0010:[<ffffffff8152d7d7>] 
Aug 28 15:51:29 fw02-lab [<ffffffff8152d7d7>] nf_ct_delete_from_lists+0x57/0x90
Aug 28 15:51:29 fw02-lab [  310.129726] RSP: 0018:ffff880132391858  EFLAGS: 00010202
Aug 28 15:51:29 fw02-lab [  310.129837] RAX: 000000000019a05b RBX: ffff880132b35b00 RCX: 0000000000245675
Aug 28 15:51:29 fw02-lab [  310.129951] RDX: dead000000200200 RSI: dead000000200200 RDI: ffffffff81bcf580
Aug 28 15:51:29 fw02-lab [  310.130064] RBP: ffffffff81bcd080 R08: 0000000000013c70 R09: ffffffff81527493
Aug 28 15:51:29 fw02-lab [  310.130180] R10: ffffffff814ed911 R11: 0000000000000004 R12: ffff880132aefa98
Aug 28 15:51:29 fw02-lab [  310.130293] R13: 0000000000000000 R14: ffff880132b35b04 R15: 00000000fffffffe
Aug 28 15:51:29 fw02-lab [  310.130408] FS:  00007fb285c74700(0000) GS:ffff88013fc00000(0000) knlGS:0000000000000000
Aug 28 15:51:29 fw02-lab [  310.130579] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Aug 28 15:51:29 fw02-lab [  310.130692] CR2: 00007fb2852fe3a0 CR3: 0000000134c54000 CR4: 00000000000007f0
Aug 28 15:51:29 fw02-lab [  310.130804] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug 28 15:51:29 fw02-lab [  310.130917] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug 28 15:51:29 fw02-lab [  310.131029] Process conntrackd (pid: 2859, threadinfo ffff880132390000, task ffff880139b65480)
Aug 28 15:51:29 fw02-lab [  310.131195] Stack:
Aug 28 15:51:29 fw02-lab [  310.131298]  0000000000000000
Aug 28 15:51:29 fw02-lab ffff880132b35b00
Aug 28 15:51:29 fw02-lab ffff880132b35b78
Aug 28 15:51:29 fw02-lab ffffffff8152e530
Aug 28 15:51:29 fw02-lab 
Aug 28 15:51:29 fw02-lab [  310.131649]  0000000000000000
Aug 28 15:51:29 fw02-lab 0000000000000001
Aug 28 15:51:29 fw02-lab ffff880132b35b00
Aug 28 15:51:29 fw02-lab 0000000000000b2a
Aug 28 15:51:29 fw02-lab 
Aug 28 15:51:29 fw02-lab [  310.131994]  ffffffff81bcd080
Aug 28 15:51:29 fw02-lab ffff880132b35b00
Aug 28 15:51:29 fw02-lab 0000000000000000
Aug 28 15:51:29 fw02-lab ffffffff81bcd080
Aug 28 15:51:29 fw02-lab 
Aug 28 15:51:29 fw02-lab [  310.132343] Call Trace:
Aug 28 15:51:29 fw02-lab [  310.132449]  [<ffffffff8152e530>] ? death_by_timeout+0x1c0/0x1e0
Aug 28 15:51:29 fw02-lab [  310.132560]  [<ffffffff8152e7d8>] ? early_drop+0xe8/0x160
Aug 28 15:51:29 fw02-lab [  310.132670]  [<ffffffff8152eecf>] ? __nf_conntrack_alloc+0x24f/0x290
Aug 28 15:51:29 fw02-lab [  310.132783]  [<ffffffff8153762b>] ? ctnetlink_create_conntrack+0x4b/0x440
Aug 28 15:51:29 fw02-lab [  310.132894]  [<ffffffff81535547>] ? ctnetlink_parse_tuple+0x147/0x170
Aug 28 15:51:29 fw02-lab [  310.133005]  [<ffffffff8152dd2d>] ? ____nf_conntrack_find+0x10d/0x120
Aug 28 15:51:29 fw02-lab [  310.133115]  [<ffffffff8152dd89>] ? __nf_conntrack_find_get+0x49/0x170
Aug 28 15:51:29 fw02-lab [  310.133227]  [<ffffffff81538ef1>] ? ctnetlink_new_conntrack+0x2a1/0x3f0
Aug 28 15:51:29 fw02-lab [  310.133339]  [<ffffffff812811b0>] ? nla_parse+0x80/0xd0
Aug 28 15:51:29 fw02-lab [  310.133564]  [<ffffffff8152cbee>] ? nfnetlink_rcv_msg+0x1ee/0x220
Aug 28 15:51:29 fw02-lab [  310.133674]  [<ffffffff8152ca2a>] ? nfnetlink_rcv_msg+0x2a/0x220
Aug 28 15:51:29 fw02-lab [  310.133784]  [<ffffffff8152ca00>] ? nfnl_lock+0x20/0x20
Aug 28 15:51:29 fw02-lab [  310.133892]  [<ffffffff81529639>] ? netlink_rcv_skb+0x99/0xc0
Aug 28 15:51:29 fw02-lab [  310.134000]  [<ffffffff81528fcf>] ? netlink_unicast+0x1af/0x200
Aug 28 15:51:29 fw02-lab [  310.134110]  [<ffffffff81529258>] ? netlink_sendmsg+0x238/0x350
Aug 28 15:51:29 fw02-lab [  310.134221]  [<ffffffff814e5204>] ? sock_sendmsg+0xe4/0x130
Aug 28 15:51:29 fw02-lab [  310.134329]  [<ffffffff814e506d>] ? sock_recvmsg+0xed/0x140
Aug 28 15:51:29 fw02-lab [  310.134439]  [<ffffffff8118001e>] ? ext4_file_write+0x6e/0x2a0
Aug 28 15:51:29 fw02-lab [  310.134551]  [<ffffffff8111a10c>] ? do_path_lookup+0x2c/0xd0
Aug 28 15:51:29 fw02-lab [  310.134659]  [<ffffffff811171ef>] ? getname_flags+0x6f/0x270
Aug 28 15:51:29 fw02-lab [  310.134771]  [<ffffffff8110c447>] ? do_sync_write+0xc7/0x100
Aug 28 15:51:29 fw02-lab [  310.134880]  [<ffffffff814e43f2>] ? sockfd_lookup_light+0x22/0x90
Aug 28 15:51:29 fw02-lab [  310.134990]  [<ffffffff814e710c>] ? sys_sendto+0x13c/0x1a0
Aug 28 15:51:29 fw02-lab [  310.135102]  [<ffffffff81687b62>] ? system_call_fastpath+0x16/0x1b
Aug 28 15:51:29 fw02-lab [  310.135214] Code: 
Aug 28 15:51:29 fw02-lab 48 
Aug 28 15:51:29 fw02-lab 8b 
Aug 28 15:51:29 fw02-lab 43 
Aug 28 15:51:29 fw02-lab 08 
Aug 28 15:51:29 fw02-lab 48 
Aug 28 15:51:29 fw02-lab 8b 
Aug 28 15:51:29 fw02-lab 53 
Aug 28 15:51:29 fw02-lab 10 
Aug 28 15:51:29 fw02-lab a8 
Aug 28 15:51:29 fw02-lab 01 
Aug 28 15:51:29 fw02-lab 48 
Aug 28 15:51:29 fw02-lab 89 
Aug 28 15:51:29 fw02-lab 02 
Aug 28 15:51:29 fw02-lab 75 
Aug 28 15:51:29 fw02-lab 04 
Aug 28 15:51:29 fw02-lab 48 
Aug 28 15:51:29 fw02-lab 89 
Aug 28 15:51:29 fw02-lab 50 
Aug 28 15:51:29 fw02-lab 08 
Aug 28 15:51:29 fw02-lab 48 
Aug 28 15:51:29 fw02-lab 8b 
Aug 28 15:51:29 fw02-lab 43 
Aug 28 15:51:29 fw02-lab 40 
Aug 28 15:51:29 fw02-lab 48 
Aug 28 15:51:29 fw02-lab be 
Aug 28 15:51:29 fw02-lab 00 
Aug 28 15:51:29 fw02-lab 02 
Aug 28 15:51:29 fw02-lab 20 
Aug 28 15:51:29 fw02-lab 00 
Aug 28 15:51:29 fw02-lab 00 
Aug 28 15:51:29 fw02-lab 00 
Aug 28 15:51:29 fw02-lab ad 
Aug 28 15:51:29 fw02-lab de 
Aug 28 15:51:29 fw02-lab 48 
Aug 28 15:51:29 fw02-lab 8b 
Aug 28 15:51:29 fw02-lab 53 
Aug 28 15:51:29 fw02-lab 48 
Aug 28 15:51:29 fw02-lab 48 
Aug 28 15:51:29 fw02-lab 89 
Aug 28 15:51:29 fw02-lab 73 
Aug 28 15:51:29 fw02-lab 10 
Aug 28 15:51:29 fw02-lab a8 
Aug 28 15:51:29 fw02-lab 01 
Aug 28 15:51:29 fw02-lab 
Aug 28 15:51:29 fw02-lab 89 
Aug 28 15:51:29 fw02-lab 02 
Aug 28 15:51:29 fw02-lab 75 
Aug 28 15:51:29 fw02-lab 04 
Aug 28 15:51:29 fw02-lab 48 
Aug 28 15:51:29 fw02-lab 89 
Aug 28 15:51:29 fw02-lab 50 
Aug 28 15:51:29 fw02-lab 08 
Aug 28 15:51:29 fw02-lab 48 
Aug 28 15:51:29 fw02-lab 89 
Aug 28 15:51:29 fw02-lab df 
Aug 28 15:51:29 fw02-lab 48 
Aug 28 15:51:29 fw02-lab b9 
Aug 28 15:51:29 fw02-lab 00 
Aug 28 15:51:29 fw02-lab 02 
Aug 28 15:51:29 fw02-lab 20 
Aug 28 15:51:29 fw02-lab 00 
Aug 28 15:51:29 fw02-lab 00 
Aug 28 15:51:29 fw02-lab 00 
Aug 28 15:51:29 fw02-lab ad 
Aug 28 15:51:29 fw02-lab 
Aug 28 15:51:29 fw02-lab [  310.138394] RIP 
Aug 28 15:51:29 fw02-lab [<ffffffff8152d7d7>] nf_ct_delete_from_lists+0x57/0x90
Aug 28 15:51:29 fw02-lab [  310.138551]  RSP <ffff880132391858>
Aug 28 15:51:29 fw02-lab [  310.138671] ---[ end trace d353ce02b91230e2 ]---
Aug 28 15:51:29 fw02-lab [  310.138784] Kernel panic - not syncing: Fatal exception in interrupt
Aug 28 15:51:29 fw02-lab [  310.138904] Rebooting in 5 seconds..

--nextPart1735493.BrRhXXdo0c--

