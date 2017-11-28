From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next,RFC 3/3] netfilter: ctnetlink: randomize 32-bit ID
Date: Tue, 28 Nov 2017 16:46:57 +0100
Message-ID: <20171128154657.GC1444@salvia>
References: <20171128021309.11277-1-pablo@netfilter.org>
 <20171128021309.11277-3-pablo@netfilter.org>
 <20171128121837.GI23412@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, richard@nod.at
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33880 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752440AbdK1PrB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Nov 2017 10:47:01 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 230881B5CFE
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Nov 2017 16:47:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0FDD0DA86E
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Nov 2017 16:47:00 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171128121837.GI23412@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 28, 2017 at 01:18:37PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Don't leak the kernel pointer to userspace by adding a random seed. If
> > you want a unique conntrack ID, used the new CTA_ID64 attribute.
> > 
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> >  net/netfilter/nf_conntrack_netlink.c | 15 +++++++++++++--
> >  1 file changed, 13 insertions(+), 2 deletions(-)
> > 
> > diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> > index 7aecb8ae5ecc..9a3357eeecdc 100644
> > --- a/net/netfilter/nf_conntrack_netlink.c
> > +++ b/net/netfilter/nf_conntrack_netlink.c
> > @@ -60,6 +60,7 @@
> >  MODULE_LICENSE("GPL");
> >  
> >  static char __initdata version[] = "0.93";
> > +static u32 nf_ct_seed __read_mostly;
> >  
> >  static int ctnetlink_dump_tuples_proto(struct sk_buff *skb,
> >  				const struct nf_conntrack_tuple *tuple,
> > @@ -444,9 +445,19 @@ static int ctnetlink_dump_ct_seq_adj(struct sk_buff *skb, struct nf_conn *ct)
> >  	return -1;
> >  }
> >  
> > +static u32 nf_ct_id32(const struct nf_conn *ct)
> > +{
> > +	u32 id = (u32)(unsigned long)ct;
> > +
> > +	if (!nf_ct_seed)
> > +		nf_ct_seed = get_random_u32();
> > +
> > +	return id + nf_ct_seed;
> > +}
> 
> If we have the 64bit id, why not use it instead of ct address?

What part of the 64bit would you take? The upper 32-bits are likely to
move not very often with the approach this patchset describes. The
lower 32-bits will bump quickly, but will likely overlap with the same
ID in other CPU.
