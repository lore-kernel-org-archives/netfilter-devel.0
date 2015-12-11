From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf] netfilter: conntrack: resched in nf_ct_iterate_cleanup
Date: Fri, 11 Dec 2015 12:53:56 +0100
Message-ID: <20151211115356.GA8811@breakpoint.cc>
References: <1449682209-20330-1-git-send-email-fw@strlen.de>
 <20151211114241.GA3262@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:50636 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750952AbbLKLx5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Dec 2015 06:53:57 -0500
Content-Disposition: inline
In-Reply-To: <20151211114241.GA3262@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, Dec 09, 2015 at 06:30:09PM +0100, Florian Westphal wrote:
> > Ulrich reports soft lockup with following (shortened) callchain:
> > 
> > NMI watchdog: BUG: soft lockup - CPU#1 stuck for 22s!
> > __netif_receive_skb_core+0x6e4/0x774
> > process_backlog+0x94/0x160
> > net_rx_action+0x88/0x178
> > call_do_softirq+0x24/0x3c
> > do_softirq+0x54/0x6c
> > __local_bh_enable_ip+0x7c/0xbc
> > nf_ct_iterate_cleanup+0x11c/0x22c [nf_conntrack]
> > masq_inet_event+0x20/0x30 [nf_nat_masquerade_ipv6]
> > atomic_notifier_call_chain+0x1c/0x2c
> > ipv6_del_addr+0x1bc/0x220 [ipv6]
> > 
> > Problem is that nf_ct_iterate_cleanup can run for a very long time
> > since it can be interrupted by softirq processing.
> > Moreover, atomic_notifier_call_chain runs with rcu readlock held.
> > 
> > So lets call cond_resched() in nf_ct_iterate_cleanup loop and defer
> > the call to a work queue for the atomic_notifier_call_chain case.
> 
> Don't we potentially have the same problem in IPv4?

No, the inet notifier appears to be fine (blocking notifier).

The only nf_ct_iterate_cleanup callsite that I found to be problematic
(i.e., not preemptible) is the ipv6 address
deletion notifier in ipv6 masquarading.

I also tried with nf-next + CONFIG_DEBUG_ATOMIC_SLEEP + this patch
and I saw no error on ipv4 address deletion w. ip4 masquerade
module loaded.
