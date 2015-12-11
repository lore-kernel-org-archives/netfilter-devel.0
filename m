From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf] netfilter: conntrack: resched in nf_ct_iterate_cleanup
Date: Fri, 11 Dec 2015 15:43:13 +0100
Message-ID: <20151211144313.GD8811@breakpoint.cc>
References: <1449682209-20330-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:51084 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754412AbbLKOnO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Dec 2015 09:43:14 -0500
Content-Disposition: inline
In-Reply-To: <1449682209-20330-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal <fw@strlen.de> wrote:
> Ulrich reports soft lockup with following (shortened) callchain:
> 
> NMI watchdog: BUG: soft lockup - CPU#1 stuck for 22s!
> __netif_receive_skb_core+0x6e4/0x774
> process_backlog+0x94/0x160
> net_rx_action+0x88/0x178
> call_do_softirq+0x24/0x3c
> do_softirq+0x54/0x6c
> __local_bh_enable_ip+0x7c/0xbc
> nf_ct_iterate_cleanup+0x11c/0x22c [nf_conntrack]
> masq_inet_event+0x20/0x30 [nf_nat_masquerade_ipv6]
> atomic_notifier_call_chain+0x1c/0x2c
> ipv6_del_addr+0x1bc/0x220 [ipv6]
> 
> Problem is that nf_ct_iterate_cleanup can run for a very long time
> since it can be interrupted by softirq processing.
> Moreover, atomic_notifier_call_chain runs with rcu readlock held.

Ulrich just reported another softlockup even with this patch applied.

One explanation would be non-matching iter(), in this case
get_next_corpse can take forever since it will walk the entire conntrack
table, rendering the cond_resched moot.

A V2 patch will be coming to also add a lock break + resched to
get_next_corpse.

I'll mark it as 'changes requested' in patchwork.
