From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 3/3] nftables: reject nat hook registration if
 prio is before conntrack
Date: Wed, 13 Dec 2017 17:28:04 +0100
Message-ID: <20171213162804.GA17318@salvia>
References: <20171208160155.968-1-fw@strlen.de>
 <20171208160155.968-4-fw@strlen.de>
 <20171208212257.GA4348@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52980 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753141AbdLMQ2L (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Dec 2017 11:28:11 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 71B7E15C106
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Dec 2017 17:28:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4C334DA86B
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Dec 2017 17:28:09 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171208212257.GA4348@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 08, 2017 at 10:22:57PM +0100, Pablo Neira Ayuso wrote:
> On Fri, Dec 08, 2017 at 05:01:55PM +0100, Florian Westphal wrote:
> > No problem for iptables as priorities are fixed values defined in the
> > nat modules, but in nftables the priority its coming from userspace.
> > 
> > Reject in case we see that such a hook would not work.
> > 
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> > ---
> >  net/netfilter/nf_tables_api.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> > index f000d4399c7a..4ed66f1b40b5 100644
> > --- a/net/netfilter/nf_tables_api.c
> > +++ b/net/netfilter/nf_tables_api.c
> > @@ -1303,6 +1303,11 @@ static int nft_chain_parse_hook(struct net *net,
> >  	}
> >  	if (!(type->hook_mask & (1 << hook->num)))
> >  		return -EOPNOTSUPP;
> > +
> > +	if (type->type == NFT_CHAIN_T_NAT &&
> > +	    hook->priority <= NF_IP_PRI_CONNTRACK)
> > +		return -EINVAL;
> 
> EINVAL is usually for missing netlink attributes, so I'd go for
> EOPNOTSUPP instead. No need to resend I can mangle this here if you
> prefer.

This patch also needs this, otherwise
tests/shell/chains/0006masquerade_0 breaks.

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 1cc1faefed69..2a29a5a58913 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1259,7 +1259,7 @@ static void nf_tables_chain_destroy(struct
nft_chain *chain)
 
 struct nft_chain_hook {
        u32                             num;
-       u32                             priority;
+       s32                             priority;
        const struct nf_chain_type      *type;
        struct net_device               *dev;
 };

I didn't push out this yet, so I'm going to collapse this to your
original patch.

Thanks.
