From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: conntrack: resched in nf_ct_iterate_cleanup
Date: Mon, 1 Feb 2016 18:38:21 +0100
Message-ID: <20160201173821.GA1247@salvia>
References: <1453285003-21040-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45085 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722AbcBARib (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Feb 2016 12:38:31 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id DD949E6667
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Feb 2016 18:38:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id CBEE9DA807
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Feb 2016 18:38:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C2ACCDA811
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Feb 2016 18:38:26 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1453285003-21040-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 20, 2016 at 11:16:43AM +0100, Florian Westphal wrote:
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
> 
> So lets call cond_resched() in nf_ct_iterate_cleanup and defer
> the call to a work queue for the atomic_notifier_call_chain case.
> 
> We also need another cond_resched in get_next_corpse, since we
> have to deal with iter() always returning false, in that case
> get_next_corpse will walk entire conntrack table.

Applied, thanks.

> Reported-by: Ulrich Weber <uw@ocedo.com>
> Tested-by: Ulrich Weber <uw@ocedo.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
> I had a look at converting the ipv6 notifier to a blocking one
> but I found this too difficult (RTNL held?  How to defer notifier calls
> from packet path)?  Just doing it for masquerade is a lot simpler:
> - we only care about NETDEV_DOWN, so no extra work needed in most cases
> - can just ignore the notification if too much work is already queued

Probably adding a defered notifier chain variant which allows
blocking, ie. moving this code to core infrastructure, just an idea.
