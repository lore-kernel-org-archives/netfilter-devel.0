From: Patrick McHardy <kaber@trash.net>
Subject: Re: datatype: fix crash if wrong integer type is passed
Date: Fri, 10 Jan 2014 10:02:46 +0000
Message-ID: <20140110100245.GA26080@macbook.localnet>
References: <20140110080425.GA3799@macbook.localnet>
 <20140110095247.GA4159@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: eric@regit.org, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57879 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbaAJKCv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Jan 2014 05:02:51 -0500
Content-Disposition: inline
In-Reply-To: <20140110095247.GA4159@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 10, 2014 at 10:52:47AM +0100, Pablo Neira Ayuso wrote:
> On Fri, Jan 10, 2014 at 08:04:25AM +0000, Patrick McHardy wrote:
> >
> > Looking at the bugzilla entry, the bug report states:
> >
> > BUG: invalid input descriptor type 538976288
> > nft: src/erec.c:100: erec_print: Assertion `0' failed.
> > Abandon
> >
> > So the problem wasn't related to data types at all but simply due to
> > some bug in error reporting. I'll queue up a revert in my tree.
> 
> static int expr_evaluate_symbol(struct eval_ctx *ctx, struct expr **expr)
> {
>         struct error_record *erec;
>         struct symbol *sym;
>         struct set *set;
>         struct expr *new; <------- note this is not initialized
> 
>         switch ((*expr)->symtype) {
>         case SYMBOL_VALUE:
>                 (*expr)->dtype = ctx->ectx.dtype;
>                 erec = symbol_parse(*expr, &new); <---- passed here
>                 if (erec != NULL) {
>                         erec_queue(erec, ctx->msgs);
>                         return -1;
>                 }
>                 break;
>         ...
>         }
>         expr_free(*expr);
>         *expr = new; <--------- if symbol_parse() returns NULL.
>                                 this is set to an invalid memory position.
> 
>         return expr_evaluate(ctx, expr);
> }
> 
> Let's see symbol_parse():
> 
> struct error_record *symbol_parse(const struct expr *sym,
>                                   struct expr **res)
> {
>         const struct datatype *dtype = sym->dtype;
> 
>         assert(sym->ops->type == EXPR_SYMBOL);
> 
>         if (dtype == NULL)
>                 return error(&sym->location, "No symbol type information");
>         do {
>                 if (dtype->parse != NULL)
>                         return dtype->parse(sym, res); <-----
> 
> 
> ....
> }
> 
> And now integer_type_parse(), which is the datatype that is called
> (note that code below assumes that this patch is reverted):
> 
> static struct error_record *integer_type_parse(const struct expr *sym,
>                                                struct expr **res)
> {
>         mpz_t v;
>         int len;
> 
>         mpz_init(v);
>         if (gmp_sscanf(sym->identifier, "%Zu%n", v, &len) != 1 ||
>             (int)strlen(sym->identifier) != len) {
>                 mpz_clear(v);
>                 if (sym->dtype != &integer_type)
>                         return NULL; <-----
> 
> 
> So integer_type_parse() returns NULL, note that **res is left
> uninitialized.

Right, but only if invoked from an upper layer datatype. This needs to
make sure we don't return NULL without an erec. This was actually a bug
in the meta expression that I just posted a fix for.

> Going back to expr_evaluate_symbol(), since NULL is returned, it
> assumes that an expression has been allocated.
> 
> I guess this doesn't crash all the time as we're relying on an
> uninitialized memory area and we can argue that the fix may not be
> optimal, but I really think this is fixing something.

Well, the proper fix seems to be to initialize *res to NULL in meta
before invoking the integer type parsing function. 
