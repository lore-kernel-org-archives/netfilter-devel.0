From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nf-next] netfilter: acct: add support to accounters in nftables
Date: Tue, 13 Jan 2015 18:01:37 +0000
Message-ID: <20150113180137.GF11414@acer.localdomain>
References: <cover.1421059771.git.ana@soleta.eu>
 <99c6e9b457ccc93fb761f6fa7f87fb9e6affc4ee.1421059771.git.ana@soleta.eu>
 <20150112113135.GA3279@salvia>
 <20150112114539.GD3491@acer.localdomain>
 <20150112122754.GA4326@salvia>
 <20150112123337.GK3491@acer.localdomain>
 <20150112125919.GM3491@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ana@soleta.eu, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46954 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbbAMSBm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Jan 2015 13:01:42 -0500
Content-Disposition: inline
In-Reply-To: <20150112125919.GM3491@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 12.01, Patrick McHardy wrote:
> On 12.01, Patrick McHardy wrote:
> > On 12.01, Pablo Neira Ayuso wrote:
> > > I just noticed Ana have to replace NFTA_ACCT_EXPR_NAME by
> > > NFTA_ACCT_EXPR_SREG to support mappings.
> > > 
> > > What's your idea behind the references? Use some unique id to identify
> > > the object instead of the name?
> > 
> > Similar to verdicts we'd include another data type which refers to
> > accounting objects. Those are resolved when the data is created and
> > we'd return them from the map lookup. Resolving can use the name,
> > just as we do for chains.
> > 
> > At runtime the map would either load the reference to a register and
> > pass it to the counter expression (might need a special register
> > similar to NFT_REG_VERDICT) or we just add a special type of the
> > counter expression that invokes the lookup itself.
> 
> Thinking a bit more about this, I think this is very much similar
> to what we've discussed about having some generic state provider
> for limit, quota etc.
> 
> In all these cases we need to provide some persistent storage to
> the expressions to be used instead of their private data. For
> hashlimit or hashquota it would probably be based on some generic
> state provider that dynamically instantiates this, but its still
> very similar to looking up an accounting object in a set and
> passing that on.
> 
> So strike that "special type of counter expression", I think what
> we need is either a special register to pass state between modules
> or just some better validation for the existing registers so passing
> pointers is safe.

For getting a better feeling of this I did some initial hacking on
the state module for limit/quota etc. What the module does is
basically maintaining a hash with opaque state objects, looking
them up based on a provided key and handing them to another module
to use instead of its private data. If the state doesn't exist
it is instantiated and added to the hash.

The use would be something like this:

nft filter input ... limit flow ip saddr . tcp dport rate 10/s
nft filter forward ... quota flow ether saddr 1gb

The expressions inside the kernel for the first example would look
like this:

ip saddr  => reg0
tcp dport => reg1
state reg0 len 8 => reg_state
limit priv = reg_state

For the state module, there are two different problems in the
interaction with the limit module:

- initializing a new state based on the parameters of the limit
  expression

- passing the state to the limit expression to be used instead of the
  private space

Initialization obviously requires the parameters used in the limit
expression, which are unknown to the generic state expression. So
we need to call into the limit module to perform this initialization
and pass it its configuration data, which is also unknown to the
state expression.

A simple solution to this is to limit the use of the state expression
to the expression following it directly. In that case we can simply
do something like

expr_next->ops->init_state(expr_next, obj)

The second question is how to pass the state to the limit expression.
The possibilities are:

- use registers
- invoke the limit expression directly and make the core skip it
- change the ->eval() functions to not take a pointer to the expression
  but to expr_priv(expr) and replace that pointer

Using registers is probably the worst solution since it requires
complicated validation and also special cased ->eval() functions.
Both other ways should be completely transparent.

Now why I'm describing this is because its very similar to what
the accounting could do using the named counters. Instead of the
state expression we'd have a different expression which passes
the data of the global accounting objects to the counter expression.

So what is missing for both cases is to get the state from sets.
This unfortunately mostly rules out not using registers since
direct ->eval invocation or replacement of argument pointers inside
the lookup expression would be quite an ugly hack.

We might be able to hide this behind some function so we don't
need different ->eval() functions. Not very important for the
counter case, but still desirable.

Any ideas/comments?
