Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE3DDC433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Dec 2021 11:22:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235313AbhLQLWV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Dec 2021 06:22:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235311AbhLQLWT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Dec 2021 06:22:19 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24425C061574
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Dec 2021 03:22:19 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1myBJZ-00067T-Mj; Fri, 17 Dec 2021 12:22:17 +0100
Date:   Fri, 17 Dec 2021 12:22:17 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 2/2] src: propagate key datatype for anonymous sets
Message-ID: <20211217112217.GA23359@breakpoint.cc>
References: <20211209151131.22618-1-fw@strlen.de>
 <20211209151131.22618-3-fw@strlen.de>
 <Ybp40gmoXMtPpDDm@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ybp40gmoXMtPpDDm@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Dec 09, 2021 at 04:11:31PM +0100, Florian Westphal wrote:
> > set s10 {
> >   typeof tcp option mptcp subtype
> >   elements = { mp-join, dss }
> > }
> > 
> > is listed correctly: typeof provides the 'mptcpopt_subtype'
> > datatype, so listing will print the elements with their sybolic types.
> > 
> > In anon case this doesn't work:
> > tcp option mptcp subtype { mp-join, dss }
> > 
> > gets shown as 'tcp option mptcp subtype { 1,  2}' because the anon
> > set has integer type.
> > 
> > This change propagates the datatype to the individual members
> > of the anon set.
> > 
> > After this change, multiple existing data types such as
> > TYPE_ICMP_TYPE could be replaced by integer-type aliases, but those
> > data types are already exposed to userspace via the 'set type'
> > directive so doing this may break existing set definitions.
> > 
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> > ---
> >  src/expression.c              | 34 ++++++++++++++++++++++++++++++++++
> >  tests/py/any/tcpopt.t         |  2 +-
> >  tests/py/any/tcpopt.t.payload | 10 +++++-----
> >  3 files changed, 40 insertions(+), 6 deletions(-)
> > 
> > diff --git a/src/expression.c b/src/expression.c
> > index f1cca8845376..9de70c6cc1a4 100644
> > --- a/src/expression.c
> > +++ b/src/expression.c
> > @@ -1249,6 +1249,31 @@ static void set_ref_expr_destroy(struct expr *expr)
> >  	set_free(expr->set);
> >  }
> >  
> > +static void set_ref_expr_set_type(const struct expr *expr,
> > +				  const struct datatype *dtype,
> > +				  enum byteorder byteorder)
> > +{
> > +	const struct set *s = expr->set;
> > +
> > +	/* normal sets already have a precise datatype that is given in
> > +	 * the set definition via type foo.
> > +	 *
> > +	 * Anon sets do not have this, and need to rely on type info
> > +	 * generated at rule creation time.
> > +	 *
> > +	 * For most cases, the type info is correct.
> > +	 * In some cases however, the kernel only stores TYPE_INTEGER.
> > +	 *
> > +	 * This happens with expressions that only use an integer alias
> > +	 * type, such as mptcp_suboption.
> > +	 *
> > +	 * In this case nft would print '1', '2', etc. instead of symbolic
> > +	 * names because the base type lacks ->sym_tbl information.
> > +	 */
> > +	if (s->init && set_is_anonymous(s->flags))
> > +		expr_set_type(s->init, dtype, byteorder);
> 
> Will this work with concatenations?

No.  But concatenations won't work for any of these, e.g.

ip version . ip daddr
tcp option mptcp subtype . tcp dport

... and so on because integer type (unspecific length) can't be
used with concat types so far.

So I think the problem is related but not added in this patch.

However, I think I need to withdraw this propsed patch for a different
reason.

If we'd try to expose mptcp option matching for specific sub fields,
the symbol expression path might not be ideal, for example consider:

   mptcp option subtype mp-join address-id gt 4 drop

(illustrative example with made-up syntax).

From parser perspective it might be better to make this

MPTCP OPTION SUBTYPE mptcp_option_fields : { ...


mptcp_option_fields : MP_JOIN mptcp_option_mpjoin_fields ...
		    | MP_CAPABLE mptcp_option_capable_fields ...


rather than

mptcp option subtype STRING STRING
... where parser calls helpers to 'translate' $4 and $5 to
the desired needed offset-length values (plus dependencies
to avoid bogus match on different suboption).

What do you think?
