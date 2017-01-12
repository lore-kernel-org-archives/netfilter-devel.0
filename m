From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nftables conntrack set ops for zone, helper assignment, etc.
Date: Thu, 12 Jan 2017 14:00:35 +0100
Message-ID: <20170112130035.GA1816@salvia>
References: <20170111091721.GA26703@breakpoint.cc>
 <20170111200749.GA16953@salvia>
 <20170111230141.GA10141@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, christophe.leroy@c-s.fr
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38464 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750960AbdALNAm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 Jan 2017 08:00:42 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 599F0E9774
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Jan 2017 14:00:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3F7D2A7BEB
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Jan 2017 14:00:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D0CF6A7E98
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Jan 2017 14:00:36 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170111230141.GA10141@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 12, 2017 at 12:01:41AM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > 1).  nft ct $key set $expr
> > > 
> > > ... would behave differently depending on the key:
> > > 
> > > Zone key would not work for real conntracks (can't change zone at later
> > > point).
> > > Other keys would do conntrack lookups and assign skb->nfct. I think we
> > > could change existing label/mark set support to perform a conntrack
> > > lookup too if conntrack is not yet assigned to alleviate this, otherwise
> > > it might be a bit confusion to users...
> > 
> > We still need the existing template behaviour around for iptables.
> 
> Can you elaborate?
> I was only referring to the existing nft_ct.c eval set function
> (which deals with setting ctmark and labels).
> 
> So instead of being a nop in case skb->nfct is not set (or a template)
> I'd propose to do a conntrack lookup and assign skb->nfct.
> 
> I would not touch/change the CT target.

OK, now I see. I was wondering how this would interfer with the
existing CT target.

> > > 2). The templating scheme used now is rather unfriendly when
> > > we need to reset the percpu scratch space. Not a big deal if we
> > > only have to cope with zones since that no longer uses the extension area,
> > > i.e. our template object would really just be a very bloated way to
> > > pass the zone information.
> > 
> > I like the percpu scratch approach. Can we probably have a smaller
> > object, so the skb->nfct interpretation depends on skb->nfctinfo so it
> > tells us this is a template? I know you're sending a patch to remove
> > this field, also asking if we could fit in such info in the new
> > approach.
> 
> Probably, I also thought about adding
> struct nf_conn_template {
> 	atomic_t ref;
> 	u16 zone;
> 	void *helper;
> 	unsgined long *timeout;
> 	char pad[PAD];
> 	unsigned long status;
> };
> 
> (templates are always allocated via kmalloc anyway so they
>  could be smaller than nf_conn provided they provide the
>  status flags at same offset (TEMPLATE bit is set).
> 
> Alternatively we might squeeze another marker into the 3 bits we have
> in the "nfctinfo" area.
> 
> However, I don't see a real advantage in doing so (would be a bit ugly
> and we'd have to make sure that all skb->nfct places check
> nfct_is_template() before e.g. dereferencing extension area...

Right.

> > So [1] creates a ftp-standard object of helper type. This object needs
> > some specific configuration, such as what layer 4 protocol you want to
> > use and the helper type. This would also solve the module autoload
> > issue since this is loaded at object creation time, from the control
> > plane. From rules, we use the "objref" expression from rules to refer
> > to this object, the obj->type->eval() will just fetch the ct from the
> > skbuff and attach the helper that we can retrieve via the obj->data
> > area.
> > 
> > This also provides maps, since "objref" already supports this, eg.
> > 
> >         chain y {
> >                 type filter hook prerouting priority 0;
> > 
> >                 ct helper set tcp dport { 21 : "ftp", 2121 : "ftp" }
> 
> Do you mean { 21 : "ftp-standard, 2121 : "ftp-standard" } (ie. it uses
> an arbitrary "object name"?

Yes. That should be "ftp-standard", any arbitrary name actually.

[...]
> > Note that this doesn't involve any string copy to the register area.
> > The objref expression is similar to the lookup expression, but it just
> > takes a _SREG to fetch the key, and then looks up for the object and
> > run obj->type->eval() in one go. So we don't place pointers in the
> > data register area since this is illegal in nf_tables.
> > 
> > Similarly, we can add new ct timeout objects. Actually, we could
> > extend struct nft_object_type so we get select_ops() there too. So we
> > have ct object types and different operations, eg.
> > 
> > table ip x {
> >         ct timeout "tcp-short-established" {
> >                 established     100
> >                 #
> >                 # ... actually, any tcp state timeout goes here, if not
> >                 # specified this uses default values.
> >                 #
> >         }
> > 
> >         chain y {
> >                 type filter hook prerouting priority -250;
> > 
> >                 ct timeout set "tcp-short-established"
> >         }
> > 
> > In this case, we won't reuse nfnetlink_cttimeout, instead we have a
> > native interface for nftables. So this fits into the transaction
> > infrastructure that we have.
> > 
> > For ct zones, we can simply rely on the templates to pass it on to
> > nf_conntrack_in(), a ct zone object to store a single ID is probably
> > too much.
> 
> Hmm, but we can't use config path for that (or ability to set zone e.g.
> from skb->nfmark is off the table).
> 
> Or do you suggest this:
> 
> ct zone set meta mark   # as per my proposal -- set template
> ct eventmask set new	# as per my proposal -- lookup&change real conntrack
> ct helper set "foo"	# as per my proposal, lookup and change real
> conntrack if its unconfirmed, EXCEPT helper is not looked up based on skb
> payload and name "foo" but instead taken from objref infrastructure.
> Same for timeout.

Yes, something like the one above. By look&change, you refer to this?

ct = nf_ct_get(...);
if (!ct || !nf_ct_unconfirmed(ct))
        return;

/*
 * ... update ct with helper here.
 */

This is fine for helpers, since the helper invocations comes late in
the pipeline.

For timeouts, after a second look I think this is more complicated: we
set them from nf_conntrack_in() via l4proto->packet(). Thus, if we add
the conntrack extension to store timeouts later on, the first
conntrack state will not get refreshed with the right timeout.
Assuming this is the first packet of a flow, that should be easy to
amend later. But if we pickup a flow from the middle, timeout
amendment gets a bit more tricky.  Calling l4proto->packet() is not
possible either since this sets packets as invalid, so we can drop it
from the ruleset.

Back to helpers, users are familiar with the current way to attach
helpers, ie. from the raw chain.

Am I missing anything? I'm starting to think we can't escape the
conntrack template. If we make it percpu, this would actually fix
another limitation in iptables since we need to set all ct extensions
(helper, timeout and zones) in one go, ie. with one single rule.

> If so, that looks good to me, I will probably start by adding zone get
> support, then zone set, and then look at the existing objref facilities.

OK.

> (eventmask is probably simple but its not high on my "wanted" list)

This is basically there for state synchronization and anyone
performing intensive ct logging via ulogd2, to filter out events. So
this can wait, yes.
