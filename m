From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nftables 3/9] netfilter: nf_tables: atomic rule updates and
 dumps
Date: Thu, 21 Feb 2013 00:10:31 +0100
Message-ID: <20130220231031.GA3875@localhost>
References: <1359590645-4703-1-git-send-email-pablo@netfilter.org>
 <1359590645-4703-3-git-send-email-pablo@netfilter.org>
 <51226244.7060503@linux.intel.com>
 <20130220011221.GA4175@localhost>
 <5124865D.6040206@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from slan-550-85.anhosting.com ([174.127.110.175]:50682 "EHLO
	slan-550-85.anhosting.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751013Ab3BTXKh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Feb 2013 18:10:37 -0500
Content-Disposition: inline
In-Reply-To: <5124865D.6040206@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Tomasz,

On Wed, Feb 20, 2013 at 10:16:29AM +0200, Tomasz Bursztyka wrote:
[...]
> >We can define some container structure to store rules in the dirty
> >list:
> >
> >struct nft_rule_update {
> >         struct list_head head;
> >         uint32_t nl_portid;
> >         struct nft_rule *rule;
> >         struct nft_table *table;
> >         struct nft_chain *chain;
> >}
> >
> >That should allows us to remove the struct list_head dirty_list in
> >struct nft_rule that I needed for this.
> >
> >The nl_portid would be the netlink portid so we know what updates
> >belong to what netlink connection. Still I don't see how to get rid of
> >the commit flag.
> >
> >Could you develop your idea?
> 
> I was exactly thinking about such external list. But it would be
> tighten to the netlink connection more deeply: as a user data to the
> socket, instead of storing the nl_portid.
> I will explain below why.
> 
> To me iptables-nftables is a non-transaction based tool. There is no
> point to start a transaction for one rule.

Agreed, ie. Not for iptables, only for iptables-restore.

> Btw it would then require a  NFT_MSG_START or some sort, to start
> the transaction based manipulation.

What I had in mind is that the transaction is considered to implicitly
start once you open a netlink socket from user-space, you add rule
updates that you want to happen atomically and then you call commit.

> Let's say now you have a software, which require to do rules
> manipulation, very often, which will be always connected through
> netlink to nftables.
> starts a transaction:
>     - manip 1
>     - manip 2
>     - ...
>     - manip n
> Commit or Abort.
> 
> done.
> 
> Now, for whatever reason: the software crashes in the middle of a
> transaction. When it restarts it has no idea what it was doing and
> why.  Here is why we should tight the transaction per netlink
> connection: if the connections breaks, we abort right away. It's
> transparent.

Good point, I have a patch for that as well. We can catch the
NETLINK_URELEASE event to remove all entries in the dirty list for the
program that crashed / exited without committing.

See net/netfilter/nfnetlink_queue_core.c for instance.

> It's consistent also with the fact that you raise a notification
> only when the rule has been activated. Until it comes: no one knows
> about those rules in the transaction but the one who owns the
> transaction.
> 
> We could do that via the struct sock { ... user_data ... }; related
> to the netlink connection, storing the transaction list.
>
> Now, no need of a flag: if the transaction list for the current
> netlink connection is not NULL: you know you are on a
> transaction-based work.
> whatever manipulation comes: it will be part of the transaction. If
> it's NULL, you do as usual: activating the rule right away.

This reminds me that we can use netlink's NLM_F_ATOMIC and remove
that flags.
