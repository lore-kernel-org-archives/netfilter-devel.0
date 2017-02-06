From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nftables 5/9] src: add host byte order integer type
Date: Mon, 6 Feb 2017 19:17:27 +0100
Message-ID: <20170206181727.GA19350@salvia>
References: <20170203123556.17357-1-fw@strlen.de>
 <20170203123556.17357-6-fw@strlen.de>
 <20170206173110.GA18703@salvia>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="YZ5djTAD1cGYuMQK"
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34554 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751121AbdBFSRg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Feb 2017 13:17:36 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AE3CA170D2B
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Feb 2017 19:17:34 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9CBB4DA801
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Feb 2017 19:17:34 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8286DDA725
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Feb 2017 19:17:28 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170206173110.GA18703@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 06, 2017 at 06:31:10PM +0100, Pablo Neira Ayuso wrote:
> On Fri, Feb 03, 2017 at 01:35:52PM +0100, Florian Westphal wrote:
> > diff --git a/include/datatype.h b/include/datatype.h
> > index 9f127f2954e3..8c1c827253be 100644
> > --- a/include/datatype.h
> > +++ b/include/datatype.h
> > @@ -82,6 +82,7 @@ enum datatypes {
> >  	TYPE_DSCP,
> >  	TYPE_ECN,
> >  	TYPE_FIB_ADDR,
> > +	TYPE_U32,
> >  	__TYPE_MAX
> >  };
> >  #define TYPE_MAX		(__TYPE_MAX - 1)
> 
> Right, this is a real problem with host byteorder integer, the
> bytecode that we generate is not correct.
> 
> I have a patch to avoid this, it's still incomplete. I'm attaching it.
> 
> Note this is still incomplete, since this doesn't solve the netlink
> delinearize path. We can use the NFT_SET_USERDATA area and the tlv
> infrastructure that Carlos made in summer to store this
> metainformation that is only useful to
> 
> This shouldn't be a showstopper to get kernel patches in, we have a
> bit of time ahead to solve this userspace issue.

Forgot attachment, here it comes.

--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=0001-evaluate-store-byteorder-for-set-keys-patch

>From 52594fb4130560e2072524193296019d209e3bf8 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Tue, 6 Sep 2016 19:49:05 +0200
Subject: [PATCH] evaluate: store byteorder for set keys

Selectors that rely on the integer type and expect host endian
byteorder don't work properly.

We need to keep the byteorder around based on the left hand size
expression that provides the context, so store the byteorder when
evaluating the map.

Before this patch.

 # nft --debug=netlink add rule x y meta mark set meta cpu map { 0 : 1, 1 : 2 }
 __map%d x b
 __map%d x 0
        element 00000000  : 00000001 0 [end]    element 01000000  : 00000002 0 [end]
                                                        ^^^^^^^^

This is expressed in network byteorder, because the invalid byteorder
defaults on this.

After this patch:

 # nft --debug=netlink add rule x y meta mark set meta cpu map { 0 : 1, 1 : 2 }
 __map%d x b
 __map%d x 0
        element 00000000  : 00000001 0 [end]    element 00000001  : 00000002 0 [end]
                                                        ^^^^^^^^

This is in host byteorder, as the key selector in the map mandates.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/rule.h |  3 +++
 src/evaluate.c | 23 +++++++++++++++--------
 2 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index 99e92ee..ae9e462 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -209,6 +209,8 @@ enum set_flags {
 	SET_F_EVAL		= 0x20,
 };
 
+#include <datatype.h>
+
 /**
  * struct set - nftables set
  *
@@ -237,6 +239,7 @@ struct set {
 	uint64_t		timeout;
 	const struct datatype	*keytype;
 	unsigned int		keylen;
+	enum byteorder		keybyteorder;
 	const struct datatype	*datatype;
 	unsigned int		datalen;
 	struct expr		*init;
diff --git a/src/evaluate.c b/src/evaluate.c
index 45af329..b64dfc1 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -63,6 +63,7 @@ static struct expr *implicit_set_declaration(struct eval_ctx *ctx,
 					     const char *name,
 					     const struct datatype *keytype,
 					     unsigned int keylen,
+					     enum byteorder byteorder,
 					     struct expr *expr)
 {
 	struct cmd *cmd;
@@ -70,11 +71,12 @@ static struct expr *implicit_set_declaration(struct eval_ctx *ctx,
 	struct handle h;
 
 	set = set_alloc(&expr->location);
-	set->flags	= SET_F_ANONYMOUS | expr->set_flags;
-	set->handle.set = xstrdup(name),
-	set->keytype 	= keytype;
-	set->keylen	= keylen;
-	set->init	= expr;
+	set->flags	  = SET_F_ANONYMOUS | expr->set_flags;
+	set->handle.set   = xstrdup(name),
+	set->keytype 	  = keytype;
+	set->keylen	  = keylen;
+	set->keybyteorder = byteorder;
+	set->init	  = expr;
 
 	if (ctx->table != NULL)
 		list_add_tail(&set->list, &ctx->table->sets);
@@ -1104,7 +1106,9 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 	case EXPR_SET:
 		mappings = implicit_set_declaration(ctx, "__map%d",
 						    ctx->ectx.dtype,
-						    ctx->ectx.len, mappings);
+						    ctx->ectx.len,
+						    ctx->ectx.byteorder,
+						    mappings);
 		mappings->set->datatype = ectx.dtype;
 		mappings->set->datalen  = ectx.len;
 
@@ -1159,7 +1163,8 @@ static int expr_evaluate_mapping(struct eval_ctx *ctx, struct expr **expr)
 	if (!(set->flags & SET_F_MAP))
 		return set_error(ctx, set, "set is not a map");
 
-	expr_set_context(&ctx->ectx, set->keytype, set->keylen);
+	__expr_set_context(&ctx->ectx, set->keytype, set->keybyteorder,
+			   set->keylen, 0);
 	if (expr_evaluate(ctx, &mapping->left) < 0)
 		return -1;
 	if (!expr_is_constant(mapping->left))
@@ -1443,6 +1448,7 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 			right = rel->right =
 				implicit_set_declaration(ctx, "__set%d",
 							 left->dtype,
+							 left->byteorder,
 							 left->len, right);
 			break;
 		case EXPR_SET_REF:
@@ -1818,7 +1824,8 @@ static int stmt_evaluate_flow(struct eval_ctx *ctx, struct stmt *stmt)
 		set->set_flags |= SET_F_TIMEOUT;
 
 	setref = implicit_set_declaration(ctx, stmt->flow.table ?: "__ft%d",
-					  key->dtype, key->len, set);
+					  key->dtype, key->dtype->byteorder,
+					  key->len, set);
 
 	stmt->flow.set = setref;
 
-- 
2.1.4


--YZ5djTAD1cGYuMQK--
