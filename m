From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: libnftables extended API proposal (Was: Re: [nft PATCH]
 libnftables: Fix for multiple context instances)
Date: Sun, 10 Dec 2017 22:55:40 +0100
Message-ID: <20171210215540.GA14363@salvia>
References: <20171120165313.GA5316@salvia>
 <20171122174943.GA32305@orbyte.nwl.cc>
 <20171204100955.GA1822@salvia>
 <20171204105324.GX32305@orbyte.nwl.cc>
 <20171204110142.GA19776@salvia>
 <20171204164327.GA32305@orbyte.nwl.cc>
 <20171204184604.GA1556@salvia>
 <20171205134317.GE32305@orbyte.nwl.cc>
 <20171207000545.GA27739@salvia>
 <20171207113431.GF32305@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55556 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751945AbdLJVzo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 10 Dec 2017 16:55:44 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E1B31DA73F
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Dec 2017 22:55:42 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CB61ADA7B9
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Dec 2017 22:55:42 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171207113431.GF32305@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Dec 07, 2017 at 12:34:31PM +0100, Phil Sutter wrote:
> Hi Pablo,
> 
> On Thu, Dec 07, 2017 at 01:05:45AM +0100, Pablo Neira Ayuso wrote:
> > On Tue, Dec 05, 2017 at 02:43:17PM +0100, Phil Sutter wrote:
> [...]
> > > After tweaking the parser a bit, I can use it now to parse just a
> > > set_list_member_expr and use the struct expr it returns. This made it
> > > possible to create the desired struct cmd in above function without
> > > having to invoke the parser there.
> > > 
> > > Exercising this refining consequently should allow to reach arbitrary
> > > levels of granularity. For instance, one could stop at statement level,
> > > i.e. statements are created using a string representation. Or one could
> > > go down to expression level, and statements are created using one or two
> > > expressions (depending on whether it is relational or not). Of course
> > > this means the library will eventually become as complicated as the
> > > parser itself, not necessarily a good thing.
> > 
> > Yes, and we'll expose all internal representation details, that we
> > will need to maintain forever if we don't want to break backward.
> 
> Not necessarily. I had this in mind when declaring 'struct nft_table'
> instead of reusing 'struct table'. :)
> 
> The parser defines the grammar, the library would just follow it. So if
> a given internal change complies with the old grammar, it should comply
> with the library as well. Though this is quite theoretical, of course.
> 
> Let's take relational expressions as simple example: In bison, we define
> 'expr op rhs_expr'. An equivalent library function could be:
> 
> | struct nft_expr *nft_relational_new(struct nft_expr *,
> | 				      enum rel_ops,
> | 				      struct nft_expr *);

Then that means you would like to expose an API that allows you to
build the abstract syntax tree.

> What is allowed in rhs_expr may change internally without breaking ABI
> or the parser-defined language.
> 
> Can you think of a problematic situation? My view is probably a bit
> rose-coloured. ;)
>
> > > On the other hand, having an abstract representation for set elements is
> > > quite convenient - their string representations might differ (take e.g.
> > > "22" vs. "ssh") so strcmp() is not sufficient to compare them.
> > > 
> > > I hope this allows you to get an idea of how I imagine extended API
> > > although certainly details are missing here. What do you think about it?
> > > Are you fine with the general concept so we can discuss details or do
> > > you see a fundamental problem with it?
> > 
> > OK, my understanding is that you would like to operate with some
> > native library object representation.
> > 
> > Most objects (table, chain...) are easy to represent, as you
> > mentioned. Rules are the most complex ones internally, but you can
> > probably abstract a simplified representation that suits well for your
> > usecases, e.g expose them in an iptables like representation -
> > something like adding matches and actions - Obviously, this needs to
> > allow to take sets as input, eg.
> > 
> >         int meta_match_immediate(struct nft_rule *r, enum nft_meta_type, void *data);
> >         int meta_match_set(struct nft_rule *r, enum nft_meta_type, struct nft_set *set);
> > 
> > meta_match_immediate() adds a meta + cmp to the rule, to compare for
> > an immediate value. meta_match_set() adds meta + lookup.
> 
> Yes, that sounds good. I had something like this in mind:
> 
> | struct nft_stmt *nft_meta_match_immediate(enum nft_meta_type, void *data);
> | int nft_rule_append_stmt(struct nft_rule *r, struct nft_stmt *stmt);
> 
> The obvious problem is that at the time that meta match is created,
> there is no context information. So the second function would have to
> do that.
> 
> I am not sure if this kind of context evaluation works in any case. E.g.
> set elements are interpreted depending on the set they are added to. To
> my surprise, that wasn't really an issue - the parser interprets it as
> constant symbol, when evaluating the expression as part of adding it to
> the set it is resolved properly. This might not work in any case,
> though.

Not sure I follow, what's the problem with the "missing context"?

> > A list of use-cases, for the third party application, would be good to
> > have to design this API.
> 
> OK, I'll take firewalld as an example and come up with a number of
> use-cases which would help there.

Thanks, those use-cases would be very useful to design this.
