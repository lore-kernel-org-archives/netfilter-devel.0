From: Phil Sutter <phil@nwl.cc>
Subject: libnftables extended API proposal (Was: Re: [nft PATCH] libnftables:
 Fix for multiple context instances)
Date: Tue, 5 Dec 2017 14:43:17 +0100
Message-ID: <20171205134317.GE32305@orbyte.nwl.cc>
References: <20171120125418.GU32305@orbyte.nwl.cc>
 <20171120130732.GA20990@salvia>
 <20171120155822.GV32305@orbyte.nwl.cc>
 <20171120165313.GA5316@salvia>
 <20171122174943.GA32305@orbyte.nwl.cc>
 <20171204100955.GA1822@salvia>
 <20171204105324.GX32305@orbyte.nwl.cc>
 <20171204110142.GA19776@salvia>
 <20171204164327.GA32305@orbyte.nwl.cc>
 <20171204184604.GA1556@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:37906 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752126AbdLENnT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 Dec 2017 08:43:19 -0500
Content-Disposition: inline
In-Reply-To: <20171204184604.GA1556@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

Since I was about to start explaining my extended API idea as part of my
reply, let's take this on-list and I'll give a full overview.

On Mon, Dec 04, 2017 at 07:46:04PM +0100, Pablo Neira Ayuso wrote:
[...]
> Kernel code to check if an element is exists is already upstream, it's
> in current -rc2. And I have a patch here that I'm finishing to add a
> command to do something like:
> 
> # nft get element x y { 1.1.1.1 }
> 
> to see if element 1.1.1.1 is there. You can check for several elements
> in one go. For intervals, you can check both if an element exists in an
> interval and if an interval exists itself.

Looks good!

> Is that what you need? It would be a matter of offering an API for
> this.

It was just an example. The problem with simple API is that for any
task, a command string has to be created and the output parsed again.
Actually, there are good reasons to just call 'nft' instead:

- Debugging is a bit easier since behaviour is fully defined by the
  command string. In simple API, one has to look at settings of nft
  context object as well to determine behaviour.
- For reading output, popen() is a bit simpler to use than fmemopen().
  Also, simple API might lose messages due to bugs in code (missing
  nft_print() conversion) - whatever nft binary prints is caught by
  popen().
- Success/fail state of command is clearly defined by nft exit code, no
  need to check for presence of erec messages or similar "hacks" to find
  out.

> > I have a draft for this extended API and have been working on a PoC to
> > sched a light on the biggest shortcomings. Expect me to start upstream
> > discussion soon. :)
> 
> Great.

My "vision" for an extended API which actually provides an additional
benefit is something that allows to work with the entities nft language
defines in an abstract manner, ideally without having to invoke the
parser all the time.

Naturally, nftables entities are hierarchical: rules are contained in
chains, chains contained in tables, etc. At the topmost level, there is
something I call 'ruleset', which is basically just an instance of
struct nft_cache. Since we have that in nft context already, it was
optimized out (for now at least). As a leftover, I have a function which
does a cache update (although this might be done implicitly as well).

For each entity contained in the ruleset, I wrote two functions, lookup
and create, to reference them later. Due to the hierarchical layout,
both functions take the higher-level entity as an argument. For
instance:

| struct nft_table *nft_table_lookup(struct nft_ctx *nft,
| 				     unsigned int family,
| 				     const char *name);
| struct nft_chain *nft_chain_new(struct nft_ctx *nft,
| 				  struct nft_table *table,
| 				  const char *name);

Family and name are enough to uniquely identify a table. By passing the
returned object to the second function and a name, a new chain in that
table can be created - or more precisely, a command (struct cmd
instance) is created and stored in a new field of struct nft_ctx for
later, when calling:

| int nft_ruleset_commit(struct nft_ctx *nft);

This constructs a new batch job using the previously created commands
and calls netlink_batch_send().

The entities I've defined so far are:

struct nft_table;
struct nft_chain;
struct nft_rule;
struct nft_set;
struct nft_expr; /* actually this should be setelem */

The implementation is very incomplete and merely a playground at this
point. I started with using the parser for everything, then tried to
eliminate as much as possible. E.g. the first version to add an element
to a set looked roughly like this (pseudo-code):

| int nft_set_add_element(struct nft_ctx *nft, struct nft_set *set,
| 			  const char *elem)
| {
| 	char buf[1024];
| 
|	sprintf(buf, "add element ip t %s %s", set->name, elem);
|	scanner_push_buffer(scanner, &indesc_cmdline, buf);
|	nft_parse(nft, scanner, &state);
|	list_splice_tail(&state.cmds, &nft->cmds);
| }

After tweaking the parser a bit, I can use it now to parse just a
set_list_member_expr and use the struct expr it returns. This made it
possible to create the desired struct cmd in above function without
having to invoke the parser there.

Exercising this refining consequently should allow to reach arbitrary
levels of granularity. For instance, one could stop at statement level,
i.e. statements are created using a string representation. Or one could
go down to expression level, and statements are created using one or two
expressions (depending on whether it is relational or not). Of course
this means the library will eventually become as complicated as the
parser itself, not necessarily a good thing.

On the other hand, having an abstract representation for set elements is
quite convenient - their string representations might differ (take e.g.
"22" vs. "ssh") so strcmp() is not sufficient to compare them.

I hope this allows you to get an idea of how I imagine extended API
although certainly details are missing here. What do you think about it?
Are you fine with the general concept so we can discuss details or do
you see a fundamental problem with it?

Cheers, Phil
