From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: datatype: fix crash if wrong integer type is passed
Date: Fri, 10 Jan 2014 10:52:47 +0100
Message-ID: <20140110095247.GA4159@localhost>
References: <20140110080425.GA3799@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: eric@regit.org, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43491 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781AbaAJJw4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Jan 2014 04:52:56 -0500
Content-Disposition: inline
In-Reply-To: <20140110080425.GA3799@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 10, 2014 at 08:04:25AM +0000, Patrick McHardy wrote:
> I'm going through older commits in nftables that I didn't review at the
> time and I'm wondering about this one:
>
> commit a320531e78f1bcb12b24da048f34592771392a9a
> Author: Pablo Neira Ayuso <pablo@netfilter.org>
> Date:   Wed Jul 24 15:14:22 2013 +0200
>
>     datatype: fix crash if wrong integer type is passed
>
>     Eric Leblond reported that this command:
>
>     nft add rule ip6 filter input position 4 meta protocol icmpv6 accept
>
>     crashes nft. The problem is that 'icmpv6' is wrong there, as
>     meta protocol is expecting an ethernet protocol, that can be
>     expressed as an hexadecimal.
>
>     Now this command displays the following error:
>
>     <cmdline>:1:52-57: Error: This is not a valid Ethernet protocol
>     add rule ip6 filter input position 4 meta protocol icmpv6 accept
>                                                        ^^^^^^
> We have generic type checks so I don't want to add special ones (with
> different error messages) for special cases.
>
> Additionally I don't see the error, reverting that patch and executing
> the mentioned rule produces:
>
> <cmdline>:1:52-57: Error: datatype mismatch, expected Ethernet protocol, expression has type Internet protocol
> add rule ip6 filter input position 4 meta protocol icmpv6 accept
>                                      ~~~~~~~~~~~~~ ^^^^^^
>
> Looking at the bugzilla entry, the bug report states:
>
> BUG: invalid input descriptor type 538976288
> nft: src/erec.c:100: erec_print: Assertion `0' failed.
> Abandon
>
> So the problem wasn't related to data types at all but simply due to
> some bug in error reporting. I'll queue up a revert in my tree.

static int expr_evaluate_symbol(struct eval_ctx *ctx, struct expr **expr)
{
        struct error_record *erec;
        struct symbol *sym;
        struct set *set;
        struct expr *new; <------- note this is not initialized

        switch ((*expr)->symtype) {
        case SYMBOL_VALUE:
                (*expr)->dtype = ctx->ectx.dtype;
                erec = symbol_parse(*expr, &new); <---- passed here
                if (erec != NULL) {
                        erec_queue(erec, ctx->msgs);
                        return -1;
                }
                break;
        ...
        }
        expr_free(*expr);
        *expr = new; <--------- if symbol_parse() returns NULL.
                                this is set to an invalid memory position.

        return expr_evaluate(ctx, expr);
}

Let's see symbol_parse():

struct error_record *symbol_parse(const struct expr *sym,
                                  struct expr **res)
{
        const struct datatype *dtype = sym->dtype;

        assert(sym->ops->type == EXPR_SYMBOL);

        if (dtype == NULL)
                return error(&sym->location, "No symbol type information");
        do {
                if (dtype->parse != NULL)
                        return dtype->parse(sym, res); <-----


....
}

And now integer_type_parse(), which is the datatype that is called
(note that code below assumes that this patch is reverted):

static struct error_record *integer_type_parse(const struct expr *sym,
                                               struct expr **res)
{
        mpz_t v;
        int len;

        mpz_init(v);
        if (gmp_sscanf(sym->identifier, "%Zu%n", v, &len) != 1 ||
            (int)strlen(sym->identifier) != len) {
                mpz_clear(v);
                if (sym->dtype != &integer_type)
                        return NULL; <-----


So integer_type_parse() returns NULL, note that **res is left
uninitialized.

Going back to expr_evaluate_symbol(), since NULL is returned, it
assumes that an expression has been allocated.

I guess this doesn't crash all the time as we're relying on an
uninitialized memory area and we can argue that the fix may not be
optimal, but I really think this is fixing something.
