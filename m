From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next RFC,v2 1/6] netfilter: nf_conntrack: add
 IPS_OFFLOAD status bit
Date: Fri, 8 Dec 2017 22:00:09 +0100
Message-ID: <20171208210009.GA4126@salvia>
References: <20171207124501.24325-1-pablo@netfilter.org>
 <20171207124501.24325-2-pablo@netfilter.org>
 <20171208064702.GA26061@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        f.fainelli@gmail.com, simon.horman@netronome.com,
        ronye@mellanox.com, jiri@mellanox.com, nbd@nbd.name,
        john@phrozen.org, kubakici@wp.pl
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60450 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752208AbdLHVAP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Dec 2017 16:00:15 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CF21C1C438C
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Dec 2017 22:00:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BF04CDA86F
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Dec 2017 22:00:12 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171208064702.GA26061@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 08, 2017 at 07:47:02AM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > diff --git a/include/uapi/linux/netfilter/nf_conntrack_common.h b/include/uapi/linux/netfilter/nf_conntrack_common.h
> > index dc947e59d03a..6b463b88182d 100644
> > --- a/include/uapi/linux/netfilter/nf_conntrack_common.h
> > +++ b/include/uapi/linux/netfilter/nf_conntrack_common.h
> > @@ -100,6 +100,10 @@ enum ip_conntrack_status {
> >  	IPS_HELPER_BIT = 13,
> >  	IPS_HELPER = (1 << IPS_HELPER_BIT),
> >  
> > +	/* Conntrack has been offloaded to flow table. */
> > +	IPS_OFFLOAD_BIT = 14,
> > +	IPS_OFFLOAD = (1 << IPS_OFFLOAD_BIT),
> > +
> >  	/* Be careful here, modifying these bits can make things messy,
> >  	 * so don't let users modify them directly.
> >  	 */
> 
> I think this new bit has to be added to the UNCHANGEABLE mask below.

Right.

> > diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> > index 01130392b7c0..02e195accd47 100644
> > --- a/net/netfilter/nf_conntrack_core.c
> > +++ b/net/netfilter/nf_conntrack_core.c
> > @@ -901,6 +901,9 @@ static unsigned int early_drop_list(struct net *net,
> >  	hlist_nulls_for_each_entry_rcu(h, n, head, hnnode) {
> >  		tmp = nf_ct_tuplehash_to_ctrack(h);
> >  
> > +		if (test_bit(IPS_OFFLOAD_BIT, &tmp->status))
> > +			continue;
> > +
> 
> nit: I would move this below the ASSURED bit check, AFAIU most
> (all?) offloaded conntracks are not in ASSURED state since they never
> see two-way communication but in case we've mixed flows or no offloading
> in place then the ASSURED check takes care of skipping earlydrop
> already.

Offload happens once we enter established state (or later if your rule
postpone it to a later stage), that is before we observe the full
3-way handshake in tcp, hence the assured bit. So I think we still
need this here.

> > +/* Set an arbitrary timeout large enough not to ever expire, this save
> > + * us a check for the IPS_OFFLOAD_BIT from the packet path via
> > + * nf_ct_is_expired().
> > + */
> > +static void nf_ct_offload_timeout(struct nf_conn *ct)
> > +{
> > +       ct->timeout = nfct_time_stamp + DAY;
> > +}
> 
> Not sure if its worth adding a test to avoid unconditional write,
> e.g. something like
> 
> > +static void nf_ct_offload_timeout(struct nf_conn *ct)
> > +{
> 	if (nf_ct_expires(ct) < DAY/2))
> > +       ct->timeout = nfct_time_stamp + DAY;
> 
> but perhaps not worth it, gc_worker is infrequent.

That's fine, I'll do this.
