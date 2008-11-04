From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netns ct: walk netns list under RTNL
Date: Tue, 04 Nov 2008 14:40:44 +0100
Message-ID: <491050DC.1020405@trash.net>
References: <20081101143215.GB23760@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41596 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbYKDNku (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Nov 2008 08:40:50 -0500
In-Reply-To: <20081101143215.GB23760@x200.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Alexey Dobriyan wrote:
> As was suspected, it's oopsable:
> 
> BUG: unable to handle kernel paging request at 0000000000100100	<===
> IP: [<ffffffffa00984bc>] nf_conntrack_helper_unregister+0x137/0x16c [nf_conntrack]
> PGD 168b48067 PUD 168b47067 PMD 0 
> Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> last sysfs file: /sys/kernel/uevent_seqnum
> CPU 0 
> Modules linked in: nf_conntrack_pptp(-) nf_conntrack_proto_gre af_packet iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter ip_tables xt_tcpudp ip6table_filter ip6_tables x_tables ipv6 sr_mod cdrom [last unloaded: nf_conntrack_pptp]
> Pid: 9110, comm: rmmod Not tainted 2.6.28-rc2-netns-xfrm #2
> RIP: 0010:[<ffffffffa00984bc>]  [<ffffffffa00984bc>] nf_conntrack_helper_unregister+0x137/0x16c [nf_conntrack]
> RSP: 0018:ffff8801689dfea8  EFLAGS: 00010212
> RAX: 0000000000004000 RBX: 0000000000000000 RCX: 0000000000000033
> RDX: 0000000000003fff RSI: ffffffffa0648720 RDI: ffff88017fc2ced8
> RBP: ffff8801689dfed8 R08: 0000000000000002 R09: 0000000000000000
> R10: 0000000000000000 R11: ffff8801689dfd98 R12: 00000000001000f8
> R13: ffffffffa0648720 R14: 0000000000004000 R15: 0000000000000880
> FS:  00007f7ba894d6f0(0000) GS:ffffffff80521580(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000000000100100 CR3: 0000000168b45000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process rmmod (pid: 9110, threadinfo ffff8801689de000, task ffff88017cd81218)
> Stack:
>  ffff8801689dfed8 ffffffffa06487c0 0000000000000000 0000000000000880
>  00007fffb0955330 0000000000000880 ffff8801689dfee8 ffffffffa064771c
>  ffff8801689dff78 ffffffff80253f87 746e6e6f635f666e 7470705f6b636172
> Call Trace:
>  [<ffffffffa064771c>] nf_conntrack_pptp_fini+0x10/0x1e [nf_conntrack_pptp]
>  [<ffffffff80253f87>] sys_delete_module+0x19f/0x1fe
>  [<ffffffff8024cac8>] ? trace_hardirqs_on_caller+0xf0/0x114
>  [<ffffffff803ea8b0>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>  [<ffffffff8020b52b>] system_call_fastpath+0x16/0x1b
> Code: 48 89 df 4c 89 ee 0f 18 08 e8 64 fe ff ff 48 8b 1b eb e5 49 ff c6 44 3b 35 4a bc 00 00 44 89 f0 72 c8 4d 8b 64 24 08 49 83 ec 08 <49> 8b 44 24 08 0f 18 08 49 8d 44 24 08 48 3d 60 4f 50 80 74 08 
> RIP  [<ffffffffa00984bc>] nf_conntrack_helper_unregister+0x137/0x16c [nf_conntrack]
>  RSP <ffff8801689dfea8>
> CR2: 0000000000100100
> Kernel panic - not syncing: Fatal exception in interrupt

This doesn't explain the problem. *How* is it oopsable?
