From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [pablo@netfilter.org: Re: nft 2.0, NULL pointer dereference in
 3.14.1]
Date: Sun, 4 May 2014 13:34:54 +0200
Message-ID: <20140504113454.GA4006@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37992 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753297AbaEDLfH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 4 May 2014 07:35:07 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Forwarding this reply to nf-devel, it was not included in the CC. Just
for the record.

----- Forwarded message from Pablo Neira Ayuso <pablo@netfilter.org> -----

Date: Sun, 4 May 2014 13:33:57 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Denys Fedoryshchenko <nuclearcat@nuclearcat.com>
Cc: netdev@vger.kernel.org, kaber@trash.net, kadlec@blackhole.kfki.hu
Subject: Re: nft 2.0, NULL pointer dereference in 3.14.1
User-Agent: Mutt/1.5.21 (2010-09-15)

On Sun, May 04, 2014 at 10:25:58AM +0300, Denys Fedoryshchenko wrote:
> Hi
> 
> I bit more debugging and found that problem is happening at:
> 
> >sock = netlink_lookup(sock_net(ssk), ssk->sk_protocol, portid);
> 
> ssk is NULL
> 
> After checking, i noticed in nfnetlink.c
> nfnetlink_rcv_batch() function
> 
> We have
> nskb->sk = oskb->sk;
> skb = nskb;
> 
> I am matching condition
> ss = rcu_dereference_protected(table[subsys_id].subsys,
>        lockdep_is_held(&table[subsys_id].mutex));
> if (!ss) {
> 
> And then
> nfnl_unlock(subsys_id);
> kfree_skb(nskb);
> return netlink_ack(skb, nlh, -EOPNOTSUPP);
> 
> If i am not wrong, nskb same pointer as skb, so we are giving
> netlink_ack freed pointer?
> Is it "use after free()" ?

Right, this is an embarrasing use after free when no nf_tables support
has been selected / modules are not available.

> If yes, then it seems attached patch fixing my issue. Please let me
> know, if it is ok and i should submit it.

I'm going to take this, but please next time use git format-patch and
include your Signed-off-by tag. If you feel the patch is not complete
in some aspect or that you may be missing anything, just include the
RFC tag in the subject.

Thanks Denys!

----- End forwarded message -----
