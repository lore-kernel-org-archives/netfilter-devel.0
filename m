From: Phil Sutter <phil@nwl.cc>
Subject: Re: libnftables extended API proposal
Date: Fri, 22 Dec 2017 14:08:16 +0100
Message-ID: <20171222130816.GV32305@orbyte.nwl.cc>
References: <20171204164327.GA32305@orbyte.nwl.cc>
 <20171204184604.GA1556@salvia>
 <20171205134317.GE32305@orbyte.nwl.cc>
 <20171207000545.GA27739@salvia>
 <20171207113431.GF32305@orbyte.nwl.cc>
 <20171210215540.GA14363@salvia>
 <20171216160651.GP32305@orbyte.nwl.cc>
 <20171218230048.pwtnnezyxyhh4geu@salvia>
 <20171220123225.GS32305@orbyte.nwl.cc>
 <20171220222336.yqnl3g5fgeopsxuf@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:52314 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751465AbdLVNIS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 22 Dec 2017 08:08:18 -0500
Content-Disposition: inline
In-Reply-To: <20171220222336.yqnl3g5fgeopsxuf@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On Wed, Dec 20, 2017 at 11:23:36PM +0100, Pablo Neira Ayuso wrote:
> On Wed, Dec 20, 2017 at 01:32:25PM +0100, Phil Sutter wrote:
> [...]
> > On Tue, Dec 19, 2017 at 12:00:48AM +0100, Pablo Neira Ayuso wrote:
> > > On Sat, Dec 16, 2017 at 05:06:51PM +0100, Phil Sutter wrote:
> > > > On Sun, Dec 10, 2017 at 10:55:40PM +0100, Pablo Neira Ayuso wrote:
> > > > > On Thu, Dec 07, 2017 at 12:34:31PM +0100, Phil Sutter wrote:
> > > > > > On Thu, Dec 07, 2017 at 01:05:45AM +0100, Pablo Neira Ayuso wrote:
> > > > > > > On Tue, Dec 05, 2017 at 02:43:17PM +0100, Phil Sutter wrote:
> > > > > > [...]
> > > > > > > > After tweaking the parser a bit, I can use it now to parse just a
> > > > > > > > set_list_member_expr and use the struct expr it returns. This made it
> > > > > > > > possible to create the desired struct cmd in above function without
> > > > > > > > having to invoke the parser there.
> > > > > > > > 
> > > > > > > > Exercising this refining consequently should allow to reach arbitrary
> > > > > > > > levels of granularity. For instance, one could stop at statement level,
> > > > > > > > i.e. statements are created using a string representation. Or one could
> > > > > > > > go down to expression level, and statements are created using one or two
> > > > > > > > expressions (depending on whether it is relational or not). Of course
> > > > > > > > this means the library will eventually become as complicated as the
> > > > > > > > parser itself, not necessarily a good thing.
> > > > > > > 
> > > > > > > Yes, and we'll expose all internal representation details, that we
> > > > > > > will need to maintain forever if we don't want to break backward.
> > > > > > 
> > > > > > Not necessarily. I had this in mind when declaring 'struct nft_table'
> > > > > > instead of reusing 'struct table'. :)
> > > > > > 
> > > > > > The parser defines the grammar, the library would just follow it. So if
> > > > > > a given internal change complies with the old grammar, it should comply
> > > > > > with the library as well. Though this is quite theoretical, of course.
> > > > > > 
> > > > > > Let's take relational expressions as simple example: In bison, we define
> > > > > > 'expr op rhs_expr'. An equivalent library function could be:
> > > > > > 
> > > > > > | struct nft_expr *nft_relational_new(struct nft_expr *,
> > > > > > | 				      enum rel_ops,
> > > > > > | 				      struct nft_expr *);
> > > > > 
> > > > > Then that means you would like to expose an API that allows you to
> > > > > build the abstract syntax tree.
> > > > 
> > > > That was the idea I had when I thought about how to transition from
> > > > fully text-based simple API to an extended one which allows to work with
> > > > objects instead. We could start simple and refine further if
> > > > required/sensible. At the basic level, adding a new rule could be
> > > > something like:
> > > > 
> > > > | myrule = nft_rule_create("tcp dport 22 accept");
> > > > 
> > > > If required, one could implement rule building based on statements:
> > > > 
> > > > | stmt1 = nft_stmt_create("tcp dport 22");
> > > > | stmt2 = nft_stmt_create("accept");
> > > > | myrule = nft_rule_create();
> > > > | nft_rule_add_stmt(myrule, stmt1);
> > > > | nft_rule_add_stmt(myrule, stmt2);
> > > 
> > > This is mixing parsing and abstract syntax tree creation.
> > > 
> > > If you want to expose the syntax tree, then I would the parsing layer
> > > entirely and expose the syntax tree, which is what the json
> > > representation for the high level library will be doing.
> > 
> > But that means having to provide a creating function for every
> > expression there is, no?
> 
> Yes.
> 
> > > To support new protocol, we will need a new library version too, when
> > > the abstraction to represent a payload is already well-defined, ie.
> > > [ base, offset, length ], which is pretty much everywhere the same,
> > > not only in nftables.
> > 
> > Sorry, I didn't get that. Are you talking about that JSON
> > representation?
> 
> Yes. The one that does not exist.
> 
> > > I wonder if firewalld could generate high level json representation
> > > instead, so it becomes a compiler/translator from its own
> > > representation to nftables abstract syntax tree. As I said, the json
> > > representation is mapping to the abstract syntax tree we have in nft.
> > > I'm refering to the high level json representation that doesn't exist
> > > yet, not the low level one for libnftnl.
> > 
> > Can you point me to some information about that high level JSON
> > representation? Seems I'm missing something here.
> 
> It doesn't exist :-), if we expose a json-based API, third party tool
> only have to generate the json high-level representation, we would
> need very few API calls for this, and anyone could generate rulesets
> for nftables, without relying on the bison parser, given the json
> representation exposes the abstract syntax tree.

So you're idea is to accept a whole command in JSON format from
applications? And output in JSON format as well since that is easier for
parsing than human readable text we have right now?

I'm not sure about the '[ base, offset, length ]' part though:
Applications would have to care about protocol header layout including
any specialties themselves, or should libnftables provide them with
convenience functions to generate the correct JSON markup? For simple
stuff like matching on a TCP port there's probably no need, but
correctly interpreting IPv4 ToS field is rather error-prone I guess.

The approach seems simple at first, but application input in JSON format
has to be validated as well, so I fear we'll end up with a second parser
to avoid the first one.

Cheers, Phil
