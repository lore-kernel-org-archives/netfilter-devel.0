From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: libnftables extended API proposal (Was: Re: [nft PATCH]
 libnftables: Fix for multiple context instances)
Date: Thu, 7 Dec 2017 01:05:45 +0100
Message-ID: <20171207000545.GA27739@salvia>
References: <20171120130732.GA20990@salvia>
 <20171120155822.GV32305@orbyte.nwl.cc>
 <20171120165313.GA5316@salvia>
 <20171122174943.GA32305@orbyte.nwl.cc>
 <20171204100955.GA1822@salvia>
 <20171204105324.GX32305@orbyte.nwl.cc>
 <20171204110142.GA19776@salvia>
 <20171204164327.GA32305@orbyte.nwl.cc>
 <20171204184604.GA1556@salvia>
 <20171205134317.GE32305@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39724 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751610AbdLGAFu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Dec 2017 19:05:50 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 370501BCFC7
        for <netfilter-devel@vger.kernel.org>; Thu,  7 Dec 2017 01:05:48 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 288D2DA863
        for <netfilter-devel@vger.kernel.org>; Thu,  7 Dec 2017 01:05:48 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171205134317.GE32305@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Phil,

On Tue, Dec 05, 2017 at 02:43:17PM +0100, Phil Sutter wrote:
[...]
> My "vision" for an extended API which actually provides an additional
> benefit is something that allows to work with the entities nft language
> defines in an abstract manner, ideally without having to invoke the
> parser all the time.
>
> Naturally, nftables entities are hierarchical: rules are contained in
> chains, chains contained in tables, etc. At the topmost level, there is
> something I call 'ruleset', which is basically just an instance of
> struct nft_cache. Since we have that in nft context already, it was
> optimized out (for now at least). As a leftover, I have a function which
> does a cache update (although this might be done implicitly as well).
> 
> For each entity contained in the ruleset, I wrote two functions, lookup
> and create, to reference them later. Due to the hierarchical layout,
> both functions take the higher-level entity as an argument. For
> instance:
> 
> | struct nft_table *nft_table_lookup(struct nft_ctx *nft,
> | 				     unsigned int family,
> | 				     const char *name);
> | struct nft_chain *nft_chain_new(struct nft_ctx *nft,
> | 				  struct nft_table *table,
> | 				  const char *name);
> 
> Family and name are enough to uniquely identify a table. By passing the
> returned object to the second function and a name, a new chain in that
> table can be created - or more precisely, a command (struct cmd
> instance) is created and stored in a new field of struct nft_ctx for
> later, when calling:
> 
> | int nft_ruleset_commit(struct nft_ctx *nft);
> 
> This constructs a new batch job using the previously created commands
> and calls netlink_batch_send().
> 
> The entities I've defined so far are:
> 
> struct nft_table;
> struct nft_chain;
> struct nft_rule;
> struct nft_set;
> struct nft_expr; /* actually this should be setelem */
> 
> The implementation is very incomplete and merely a playground at this
> point. I started with using the parser for everything, then tried to
> eliminate as much as possible. E.g. the first version to add an element
> to a set looked roughly like this (pseudo-code):
> 
> | int nft_set_add_element(struct nft_ctx *nft, struct nft_set *set,
> | 			  const char *elem)
> | {
> | 	char buf[1024];
> | 
> |	sprintf(buf, "add element ip t %s %s", set->name, elem);
> |	scanner_push_buffer(scanner, &indesc_cmdline, buf);
> |	nft_parse(nft, scanner, &state);
> |	list_splice_tail(&state.cmds, &nft->cmds);
> | }
> 
> After tweaking the parser a bit, I can use it now to parse just a
> set_list_member_expr and use the struct expr it returns. This made it
> possible to create the desired struct cmd in above function without
> having to invoke the parser there.
> 
> Exercising this refining consequently should allow to reach arbitrary
> levels of granularity. For instance, one could stop at statement level,
> i.e. statements are created using a string representation. Or one could
> go down to expression level, and statements are created using one or two
> expressions (depending on whether it is relational or not). Of course
> this means the library will eventually become as complicated as the
> parser itself, not necessarily a good thing.

Yes, and we'll expose all internal representation details, that we
will need to maintain forever if we don't want to break backward.

> On the other hand, having an abstract representation for set elements is
> quite convenient - their string representations might differ (take e.g.
> "22" vs. "ssh") so strcmp() is not sufficient to compare them.
> 
> I hope this allows you to get an idea of how I imagine extended API
> although certainly details are missing here. What do you think about it?
> Are you fine with the general concept so we can discuss details or do
> you see a fundamental problem with it?

OK, my understanding is that you would like to operate with some
native library object representation.

Most objects (table, chain...) are easy to represent, as you
mentioned. Rules are the most complex ones internally, but you can
probably abstract a simplified representation that suits well for your
usecases, e.g expose them in an iptables like representation -
something like adding matches and actions - Obviously, this needs to
allow to take sets as input, eg.

        int meta_match_immediate(struct nft_rule *r, enum nft_meta_type, void *data);
        int meta_match_set(struct nft_rule *r, enum nft_meta_type, struct nft_set *set);

meta_match_immediate() adds a meta + cmp to the rule, to compare for
an immediate value. meta_match_set() adds meta + lookup.

A list of use-cases, for the third party application, would be good to
have to design this API.
