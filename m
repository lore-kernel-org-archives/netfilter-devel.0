From: Florian Westphal <fw@strlen.de>
Subject: Re: nftables conntrack set ops for zone, helper assignment, etc.
Date: Thu, 12 Jan 2017 00:01:41 +0100
Message-ID: <20170111230141.GA10141@breakpoint.cc>
References: <20170111091721.GA26703@breakpoint.cc>
 <20170111200749.GA16953@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        christophe.leroy@c-s.fr
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:34248 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1759674AbdAKXB7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Jan 2017 18:01:59 -0500
Content-Disposition: inline
In-Reply-To: <20170111200749.GA16953@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > 1).  nft ct $key set $expr
> > 
> > ... would behave differently depending on the key:
> > 
> > Zone key would not work for real conntracks (can't change zone at later
> > point).
> > Other keys would do conntrack lookups and assign skb->nfct. I think we
> > could change existing label/mark set support to perform a conntrack
> > lookup too if conntrack is not yet assigned to alleviate this, otherwise
> > it might be a bit confusion to users...
> 
> We still need the existing template behaviour around for iptables.

Can you elaborate?
I was only referring to the existing nft_ct.c eval set function
(which deals with setting ctmark and labels).

So instead of being a nop in case skb->nfct is not set (or a template)
I'd propose to do a conntrack lookup and assign skb->nfct.

I would not touch/change the CT target.

> > 2). The templating scheme used now is rather unfriendly when
> > we need to reset the percpu scratch space. Not a big deal if we
> > only have to cope with zones since that no longer uses the extension area,
> > i.e. our template object would really just be a very bloated way to
> > pass the zone information.
> 
> I like the percpu scratch approach. Can we probably have a smaller
> object, so the skb->nfct interpretation depends on skb->nfctinfo so it
> tells us this is a template? I know you're sending a patch to remove
> this field, also asking if we could fit in such info in the new
> approach.

Probably, I also thought about adding
struct nf_conn_template {
	atomic_t ref;
	u16 zone;
	void *helper;
	unsgined long *timeout;
	char pad[PAD];
	unsigned long status;
};

(templates are always allocated via kmalloc anyway so they
 could be smaller than nf_conn provided they provide the
 status flags at same offset (TEMPLATE bit is set).

Alternatively we might squeeze another marker into the 3 bits we have
in the "nfctinfo" area.

However, I don't see a real advantage in doing so (would be a bit ugly
and we'd have to make sure that all skb->nfct places check
nfct_is_template() before e.g. dereferencing extension area...

> > 3). nfqueue.  We can infer its presence with refcount test
> > on the percpu template, if its > 1, template is still assigned to another
> > skb.  If it happens we eat cost of additional kmalloc/free.
> > I think this isn't a big deal though.
> 
> Right, we have to deal with the escape path.

Jup.  Should not be too much work though.

> > 4). Doing helper and template assignment requires lookups in packet path,
> > however I think we can make such lookups faster if needed and it would
> > only happen for unconfirmed/new conntracks.
> >
> > 5) helper autoload won't work from packet path.
> 
> Another problem we mentioned before is that we would need to extend
> nft_ct to include a layer 4 protocol attribute specific to look up for
> helpers, which we agreed is ugly.

We don't need that anymore if we do helper lookups from packet path since
we can just look at the packet payload.

> > A consequence of such a design would be that this works:
> > nf .. ct zone set 42 ct timeout set bla
> > 
> > The first part, ct zone set 42, would set template to zone 42, and set
> > skb->nfct to a template
> > 
> > The second part would do a conntrack lookup with the zone provided by
> > the template call nf_conntrack_in(skb), with the zone provided, and assign
> > skb->nfct to the *real* conntrack, and set timeout policy to the one
> > provided.  Problem is that things won't work when order is switched, i.e.:
> > 
> > nf .. ct timeout set bla ct zone set 42
> > 
> > (first we do a conntrack lookup in default zone, then fail
> >  to set the zone because skb->nfct is already set to a non-templated
> >  conntrack).
> > 
> > In case noone reports obvious showstoppers I'd explore an implementation
> > of the above scheme since I believe the advantages outweight the problems.
> 
> I think it should be possible to reuse the new generic object
> infrastructure to add new stateless objects, eg.
> 
> table ip x {
>         ct helper "ftp-standard" { # [1]
>                 type "ftp"
>                 protocol tcp
>                 #
>                 # Other configuration options:
>                 #
>                 # maximum-expectations 3
>                 # expectation-timeout 300
>                 #
>                 # Other specific ftp helper options:
>                 #
>                 # loose         # instead of enabling this via modparam?

Interesting, did not think about avoiding module params completely,
I like this idea.

>         chain y {
>                 type filter hook prerouting priority -250;
> 
>                 tcp dport 21 ct helper set "ftp-standard"
>         }
> }
> 
> So [1] creates a ftp-standard object of helper type. This object needs
> some specific configuration, such as what layer 4 protocol you want to
> use and the helper type. This would also solve the module autoload
> issue since this is loaded at object creation time, from the control
> plane. From rules, we use the "objref" expression from rules to refer
> to this object, the obj->type->eval() will just fetch the ct from the
> skbuff and attach the helper that we can retrieve via the obj->data
> area.
> 
> This also provides maps, since "objref" already supports this, eg.
> 
>         chain y {
>                 type filter hook prerouting priority 0;
> 
>                 ct helper set tcp dport { 21 : "ftp", 2121 : "ftp" }

Do you mean { 21 : "ftp-standard, 2121 : "ftp-standard" } (ie. it uses
an arbitrary "object name"?

> Note that this doesn't involve any string copy to the register area.
> The objref expression is similar to the lookup expression, but it just
> takes a _SREG to fetch the key, and then looks up for the object and
> run obj->type->eval() in one go. So we don't place pointers in the
> data register area since this is illegal in nf_tables.
> 
> Similarly, we can add new ct timeout objects. Actually, we could
> extend struct nft_object_type so we get select_ops() there too. So we
> have ct object types and different operations, eg.
> 
> table ip x {
>         ct timeout "tcp-short-established" {
>                 established     100
>                 #
>                 # ... actually, any tcp state timeout goes here, if not
>                 # specified this uses default values.
>                 #
>         }
> 
>         chain y {
>                 type filter hook prerouting priority -250;
> 
>                 ct timeout set "tcp-short-established"
>         }
> 
> In this case, we won't reuse nfnetlink_cttimeout, instead we have a
> native interface for nftables. So this fits into the transaction
> infrastructure that we have.
> 
> For ct zones, we can simply rely on the templates to pass it on to
> nf_conntrack_in(), a ct zone object to store a single ID is probably
> too much.

Hmm, but we can't use config path for that (or ability to set zone e.g.
from skb->nfmark is off the table).

Or do you suggest this:

ct zone set meta mark   # as per my proposal -- set template
ct eventmask set new	# as per my proposal -- lookup&change real conntrack
ct helper set "foo"	# as per my proposal, lookup and change real
conntrack if its unconfirmed, EXCEPT helper is not looked up based on skb
payload and name "foo" but instead taken from objref infrastructure.
Same for timeout.

If so, that looks good to me, I will probably start by adding zone get
support, then zone set, and then look at the existing objref facilities.

(eventmask is probably simple but its not high on my "wanted" list)

Thanks,
Florian
