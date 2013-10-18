From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: fix ordering of jumpstack allocation and
 table update
Date: Fri, 18 Oct 2013 13:15:36 +0200
Message-ID: <20131018111536.GA11132@localhost>
References: <1382016273-21993-1-git-send-email-will.deacon@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Will Deacon <will.deacon@arm.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47069 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752851Ab3JRLPp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Oct 2013 07:15:45 -0400
Content-Disposition: inline
In-Reply-To: <1382016273-21993-1-git-send-email-will.deacon@arm.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 17, 2013 at 02:24:33PM +0100, Will Deacon wrote:
> During kernel stability testing on an SMP ARMv7 system, Yalin Wang
> reported the following panic from the netfilter code:
> 
>   1fe0: 0000001c 5e2d3b10 4007e779 4009e110 60000010 00000032 ff565656 ff545454
>   [<c06c48dc>] (ipt_do_table+0x448/0x584) from [<c0655ef0>] (nf_iterate+0x48/0x7c)
>   [<c0655ef0>] (nf_iterate+0x48/0x7c) from [<c0655f7c>] (nf_hook_slow+0x58/0x104)
>   [<c0655f7c>] (nf_hook_slow+0x58/0x104) from [<c0683bbc>] (ip_local_deliver+0x88/0xa8)
>   [<c0683bbc>] (ip_local_deliver+0x88/0xa8) from [<c0683718>] (ip_rcv_finish+0x418/0x43c)
>   [<c0683718>] (ip_rcv_finish+0x418/0x43c) from [<c062b1c4>] (__netif_receive_skb+0x4cc/0x598)
>   [<c062b1c4>] (__netif_receive_skb+0x4cc/0x598) from [<c062b314>] (process_backlog+0x84/0x158)
>   [<c062b314>] (process_backlog+0x84/0x158) from [<c062de84>] (net_rx_action+0x70/0x1dc)
>   [<c062de84>] (net_rx_action+0x70/0x1dc) from [<c0088230>] (__do_softirq+0x11c/0x27c)
>   [<c0088230>] (__do_softirq+0x11c/0x27c) from [<c008857c>] (do_softirq+0x44/0x50)
>   [<c008857c>] (do_softirq+0x44/0x50) from [<c0088614>] (local_bh_enable_ip+0x8c/0xd0)
>   [<c0088614>] (local_bh_enable_ip+0x8c/0xd0) from [<c06b0330>] (inet_stream_connect+0x164/0x298)
>   [<c06b0330>] (inet_stream_connect+0x164/0x298) from [<c061d68c>] (sys_connect+0x88/0xc8)
>   [<c061d68c>] (sys_connect+0x88/0xc8) from [<c000e340>] (ret_fast_syscall+0x0/0x30)
>   Code: 2a000021 e59d2028 e59de01c e59f011c (e7824103)
>   ---[ end trace da227214a82491bd ]---
>   Kernel panic - not syncing: Fatal exception in interrupt
> 
> This comes about because CPU1 is executing xt_replace_table in response
> to a setsockopt syscall, resulting in:
> 
> 	ret = xt_jumpstack_alloc(newinfo);
> 		--> newinfo->jumpstack = kzalloc(size, GFP_KERNEL);
> 
> 	[...]
> 
> 	table->private = newinfo;
> 	newinfo->initial_entries = private->initial_entries;
> 
> Meanwhile, CPU0 is handling the network receive path and ends up in
> ipt_do_table, resulting in:
> 
> 	private = table->private;
> 
> 	[...]
> 
> 	jumpstack  = (struct ipt_entry **)private->jumpstack[cpu];
> 
> On weakly ordered memory architectures, the writes to table->private
> and newinfo->jumpstack from CPU1 can be observed out of order by CPU0.
> Furthermore, on architectures which don't respect ordering of address
> dependencies (i.e. Alpha), the reads from CPU0 can also be re-ordered.
> 
> This patch adds an smp_wmb() before the assignment to table->private
> (which is essentially publishing newinfo) to ensure that all writes to
> newinfo will be observed before plugging it into the table structure.
> A dependent-read barrier is also added on the consumer side, to ensure
> the same ordering requirement are also respected there.

We also need fixes for net/ipv6/netfilter/ip6_tables.c and
net/ipv4/netfilter/arp_tables.c as well. Could you extend this patch
and resend?

Thanks!
