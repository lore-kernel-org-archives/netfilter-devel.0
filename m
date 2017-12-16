From: Phil Sutter <phil@nwl.cc>
Subject: Re: libnftables extended API proposal
Date: Sat, 16 Dec 2017 17:06:51 +0100
Message-ID: <20171216160651.GP32305@orbyte.nwl.cc>
References: <20171122174943.GA32305@orbyte.nwl.cc>
 <20171204100955.GA1822@salvia>
 <20171204105324.GX32305@orbyte.nwl.cc>
 <20171204110142.GA19776@salvia>
 <20171204164327.GA32305@orbyte.nwl.cc>
 <20171204184604.GA1556@salvia>
 <20171205134317.GE32305@orbyte.nwl.cc>
 <20171207000545.GA27739@salvia>
 <20171207113431.GF32305@orbyte.nwl.cc>
 <20171210215540.GA14363@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:36160 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752746AbdLPQGx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 16 Dec 2017 11:06:53 -0500
Content-Disposition: inline
In-Reply-To: <20171210215540.GA14363@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On Sun, Dec 10, 2017 at 10:55:40PM +0100, Pablo Neira Ayuso wrote:
> On Thu, Dec 07, 2017 at 12:34:31PM +0100, Phil Sutter wrote:
> > On Thu, Dec 07, 2017 at 01:05:45AM +0100, Pablo Neira Ayuso wrote:
> > > On Tue, Dec 05, 2017 at 02:43:17PM +0100, Phil Sutter wrote:
> > [...]
> > > > After tweaking the parser a bit, I can use it now to parse just a
> > > > set_list_member_expr and use the struct expr it returns. This made it
> > > > possible to create the desired struct cmd in above function without
> > > > having to invoke the parser there.
> > > > 
> > > > Exercising this refining consequently should allow to reach arbitrary
> > > > levels of granularity. For instance, one could stop at statement level,
> > > > i.e. statements are created using a string representation. Or one could
> > > > go down to expression level, and statements are created using one or two
> > > > expressions (depending on whether it is relational or not). Of course
> > > > this means the library will eventually become as complicated as the
> > > > parser itself, not necessarily a good thing.
> > > 
> > > Yes, and we'll expose all internal representation details, that we
> > > will need to maintain forever if we don't want to break backward.
> > 
> > Not necessarily. I had this in mind when declaring 'struct nft_table'
> > instead of reusing 'struct table'. :)
> > 
> > The parser defines the grammar, the library would just follow it. So if
> > a given internal change complies with the old grammar, it should comply
> > with the library as well. Though this is quite theoretical, of course.
> > 
> > Let's take relational expressions as simple example: In bison, we define
> > 'expr op rhs_expr'. An equivalent library function could be:
> > 
> > | struct nft_expr *nft_relational_new(struct nft_expr *,
> > | 				      enum rel_ops,
> > | 				      struct nft_expr *);
> 
> Then that means you would like to expose an API that allows you to
> build the abstract syntax tree.

That was the idea I had when I thought about how to transition from
fully text-based simple API to an extended one which allows to work with
objects instead. We could start simple and refine further if
required/sensible. At the basic level, adding a new rule could be
something like:

| myrule = nft_rule_create("tcp dport 22 accept");

If required, one could implement rule building based on statements:

| stmt1 = nft_stmt_create("tcp dport 22");
| stmt2 = nft_stmt_create("accept");
| myrule = nft_rule_create();
| nft_rule_add_stmt(myrule, stmt1);
| nft_rule_add_stmt(myrule, stmt2);

[...]
> > Yes, that sounds good. I had something like this in mind:
> > 
> > | struct nft_stmt *nft_meta_match_immediate(enum nft_meta_type, void *data);
> > | int nft_rule_append_stmt(struct nft_rule *r, struct nft_stmt *stmt);
> > 
> > The obvious problem is that at the time that meta match is created,
> > there is no context information. So the second function would have to
> > do that.
> > 
> > I am not sure if this kind of context evaluation works in any case. E.g.
> > set elements are interpreted depending on the set they are added to. To
> > my surprise, that wasn't really an issue - the parser interprets it as
> > constant symbol, when evaluating the expression as part of adding it to
> > the set it is resolved properly. This might not work in any case,
> > though.
> 
> Not sure I follow, what's the problem with the "missing context"?

The parser always has the full context available. E.g. if you pass it a
string such as this:

| add rule ip t c tcp dport 22 accept

By the time it parses the individual statements, it already knows e.g.
the table family and that might make a difference. As far as I can tell
from my hacking, it is possible to tweak the parser so that one could
use it to parse just a statement ('tcp dport 22').

> > > A list of use-cases, for the third party application, would be good to
> > > have to design this API.
> > 
> > OK, I'll take firewalld as an example and come up with a number of
> > use-cases which would help there.
> 
> Thanks, those use-cases would be very useful to design this.

OK, we've collected a bit:

Ability to verify ruleset state
-------------------------------
I want to find out whether a given element (table, chain, rule, set, set
element) previously added to the ruleset still exists.

Possibility to remove previously added ruleset components
---------------------------------------------------------
After making an addition to the ruleset, it should be possible to remove
the added items again. For tables, chains, sets, set elements and
stateful objects, the data used when adding the item is sufficient for
later removal (as removal happens by value). For rules though, the
corresponding handle is required.
XXX: This is inconsistent regarding items removed and added back
again by another instance: As the rule's handle changes, it is not
found anymore afterwards.

Create/delete user chains
-------------------------
Firewalld makes heavy use of custom named chains to organize rules. It
needs to be able to create/delete them easily.

Sets
----
I want to be able to freely read/modify sets of IPv4/IPv6/MAC addresses
and have them apply to existing rules.

Transactions
------------
I want to be able to add many custom chains and rules in
batch/transaction mode to reduce round trips. Ideally failure of a
transaction would return something that can indicate the invalid piece
of the transaction.

Cheers, Phil
