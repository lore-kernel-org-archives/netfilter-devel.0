From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/3] evaluate: allow to use string with binary operations
Date: Tue, 14 Jan 2014 15:49:00 +0000
Message-ID: <20140114154859.GB2204@macbook.localnet>
References: <1389699030-6301-1-git-send-email-pablo@netfilter.org>
 <1389699030-6301-3-git-send-email-pablo@netfilter.org>
 <20140114122251.GB27277@macbook.localnet>
 <20140114152532.GA9059@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35406 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbaANPtG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Jan 2014 10:49:06 -0500
Content-Disposition: inline
In-Reply-To: <20140114152532.GA9059@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 14, 2014 at 04:25:32PM +0100, Pablo Neira Ayuso wrote:
> On Tue, Jan 14, 2014 at 12:22:52PM +0000, Patrick McHardy wrote:
> > On Tue, Jan 14, 2014 at 12:30:29PM +0100, Pablo Neira Ayuso wrote:
> > > This allows us to match ifname masks, eg.
> > > 
> > > nft add rule filter output meta oifname and eth == eth counter
> > > 
> > > I've been investigating other possibility, such as adding
> > > ofiname-mask, which requires several patches and transformations
> > > to make it look binop tree, but I still think this looks like
> > > a natural way (and simple, look at the patch, it's rather small)
> > > to represent this in the nftables.
> > 
> > I was just going to suggest adding a shortcut for this since its exposing
> > a lot of low-level detail. The transformation should be quite easy during
> > evaluation, could you elaborate on the problems?
> 
> Not really a problem but a bit more specific code to handle this case.
> I started writing support for this following several approaches, but
> after looking at my patchset I thought this approach was smaller and
> it's requiring way less specific code.
> 
> The fist of my patches here (the ones that I didn't send) replace all
> NFT_META_* references in the parser by internal META_*, eg. META_MARK,
> just to prepare the addition of META_IIFNAMEMASK and META_OIFNAMEMASK.
> Then, the follow-up patch transforms the following expression that we
> got from that looks like:
> 
>               relational
>                 /     \
>                /       \
>     meta oifnamemask  string
> 
> to a binary op expression. These also needs some specific code in the
> delinearize path to transform the binop tree back to the expression
> above.
> 
> Let me know if you have any better idea. Thanks.

Well, I think the easiest approach would be to add some code to
expr_evaluate_relational() for OP_EQ for convert the LHS of a
relational meta expression to LHS & RHS:

     relational (==)
    /               \
meta oifname       string

=>

        relational (==)
       /               \
    binop (&)        string
  /          \
meta oifname  string

The attached patch uses '*' as a trigger (and obviously won't work
because the '*' is also used in the mask, but you get the idea.
netlink_delinarize adjustments are missing, but it should be pretty
trivial to add the corresponding code to postprocessing of relational
expressions.


<cmdline>:0:0-33: Evaluate
filter output meta oifname "eth*"
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


<cmdline>:1:15-33: Evaluate
filter output meta oifname "eth*"
              ^^^^^^^^^^^^^^^^^^^
meta oifname $eth*

<cmdline>:1:15-33: Evaluate
filter output meta oifname "eth*"
              ^^^^^^^^^^^^^^^^^^^
meta oifname $eth*

<cmdline>:1:15-26: Evaluate
filter output meta oifname "eth*"
              ^^^^^^^^^^^^
meta oifname

<cmdline>:1:28-33: Evaluate
filter output meta oifname "eth*"
                           ^^^^^^
$eth*

<cmdline>:1:28-33: Evaluate
filter output meta oifname "eth*"
                           ^^^^^^
"eth*"

<cmdline>:1:15-26: Evaluate
filter output meta oifname "eth*"
              ^^^^^^^^^^^^
meta oifname & "eth*"

<cmdline>:1:15-26: Evaluate
filter output meta oifname "eth*"
              ^^^^^^^^^^^^
meta oifname

<cmdline>:1:28-33: Evaluate
filter output meta oifname "eth*"
                           ^^^^^^
"eth*"

<cmdline>:0:0-33: Error: Could not process rule: Operation not permitted
filter output meta oifname "eth*"
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


diff --git a/src/evaluate.c b/src/evaluate.c
index 4ca3294..9c659dc 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -547,7 +547,8 @@ static int expr_evaluate_binop(struct eval_ctx *ctx, struct expr **expr)
 		return -1;
 	right = op->right;
 
-	if (expr_basetype(left)->type != TYPE_INTEGER)
+	if (expr_basetype(left)->type != TYPE_INTEGER &&
+	    expr_basetype(left)->type != TYPE_STRING)
 		return expr_binary_error(ctx, left, op,
 					 "Binary operation (%s) is undefined "
 					 "for %s types",
@@ -936,6 +937,22 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 		    left->ops->pctx_update)
 			left->ops->pctx_update(&ctx->pctx, rel);
 
+		if (left->ops->type == EXPR_META &&
+		    (left->meta.key == NFT_META_IIFNAME ||
+		     left->meta.key == NFT_META_OIFNAME)) {
+			unsigned int len = div_round_up(right->len, BITS_PER_BYTE);
+			char data[len + 1];
+
+			mpz_export_data(data, right->value, BYTEORDER_HOST_ENDIAN, len);
+			if (strchr(data, '*')) {
+				left = binop_expr_alloc(&left->location, OP_AND,
+							left, expr_clone(right));
+				if (expr_evaluate(ctx, &left) < 0)
+					return -1;
+				(*expr)->left = left;
+			}
+		}
+
 		if (left->ops->type == EXPR_CONCAT)
 			return 0;
 
