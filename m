From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nat: remove incorrect debug assert
Date: Fri, 3 Mar 2017 12:55:34 +0100
Message-ID: <20170303115534.GA13931@salvia>
References: <20170208221429.3555-1-fw@strlen.de>
 <20170221140909.GA3286@salvia>
 <20170221144019.GD9708@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42114 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751050AbdCCL5i (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Mar 2017 06:57:38 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 04A9319D8B7
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Mar 2017 12:55:43 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E8EAFDA811
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Mar 2017 12:55:42 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AD619DA842
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Mar 2017 12:55:39 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170221144019.GD9708@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 21, 2017 at 03:40:19PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
[...]
> > > diff --git a/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c b/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
> > > ick_inndex f8aad03d674b..6f5e8d01b876 100644
> > > --- a/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
> > > +++ b/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
> > > @@ -255,11 +255,6 @@ nf_nat_ipv4_fn(void *priv, struct sk_buff *skb,
> > >  	/* maniptype == SRC for postrouting. */
> > >  	enum nf_nat_manip_type maniptype = HOOK2MANIP(state->hook);
> > >  
> > > -	/* We never see fragments: conntrack defrags on pre-routing
> > > -	 * and local-out, and nf_nat_out protects post-routing.
> > > -	 */
> > > -	NF_CT_ASSERT(!ip_is_fragment(ip_hdr(skb)));
> > > -
> 
> We could make this a explicit test+return but that seems weird too,
> we would track the first fragment but would not nat.

Right, that test+return just for this is weird.

> However, changing test to if (iph->frag_off) return -NF_ACCEPT seems
> wrong too because we have enough info to track. OTOH, this only happens
> with HDRINCL+raw socket so perhaps we shouldn't care about this and
> just change ipv4 l3 tracker to ignore all packets w. iph->frag_off set.

Florian, unless you rise your hand, I'm going to take this patch so we
at least fix splats here. I still have the impression that this
setsockopt() option and its interaction with netfilter is broken at
many levels.
