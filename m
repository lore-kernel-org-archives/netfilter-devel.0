From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: conntrack: resched in nf_ct_iterate_cleanup
Date: Fri, 11 Dec 2015 18:16:59 +0100
Message-ID: <20151211171659.GA1135@salvia>
References: <1449682209-20330-1-git-send-email-fw@strlen.de>
 <20151211144313.GD8811@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49793 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752550AbbLKRRE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Dec 2015 12:17:04 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 974EEB6B90
	for <netfilter-devel@vger.kernel.org>; Fri, 11 Dec 2015 18:17:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 87AE1DA72A
	for <netfilter-devel@vger.kernel.org>; Fri, 11 Dec 2015 18:17:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 9B0C5DA73F
	for <netfilter-devel@vger.kernel.org>; Fri, 11 Dec 2015 18:17:00 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151211144313.GD8811@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 11, 2015 at 03:43:13PM +0100, Florian Westphal wrote:
> Florian Westphal <fw@strlen.de> wrote:
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
> 
> Ulrich just reported another softlockup even with this patch applied.
> 
> One explanation would be non-matching iter(), in this case
> get_next_corpse can take forever since it will walk the entire conntrack
> table, rendering the cond_resched moot.

Probably another reincarnation of 0838aa7fcfcd? Is Ulrich using
conntrack templates?

> A V2 patch will be coming to also add a lock break + resched to
> get_next_corpse.

BTW, the atomic chain notifier in IPv6 seems to be there to handle
this update from the packet path:

 ndisc_rcv()
 ndisc_router_discovery()
 addrconf_prefix_rcv()
 manage_tempaddrs()
 ipv6_add_addr()
 inet6addr_notifier_call_chain()

Probably we can get Hannes have a look into this, I think we can
convert this chain to blocking one through workqueue since
addrconf_prefix_rcv() returns void. The remaining call sites of
inet6addr_notifier_call_chain() that I could tracked come from paths
where I can see ASSERT_RTNL(), so user context is guaranteed.

I'm telling this become I remember that we discussed in netconf'14
Chicago that it would be good to get rid of this kind og asymmetries
between IPv4 and IPv6.
