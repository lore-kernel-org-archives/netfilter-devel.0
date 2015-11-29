From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] proto: fix VLAN header definition
Date: Sun, 29 Nov 2015 23:00:37 +0100
Message-ID: <20151129220037.GA2301@salvia>
References: <1448615614-16510-1-git-send-email-kaber@trash.net>
 <20151127094958.GB15392@breakpoint.cc>
 <20151127095424.GF4263@macbook.localdomain>
 <20151127103428.GC15392@breakpoint.cc>
 <20151127104248.GD15392@breakpoint.cc>
 <20151127104923.GH4263@macbook.localdomain>
 <20151127105417.GE15392@breakpoint.cc>
 <20151128233201.GA3542@salvia>
 <20151129000929.GA15493@breakpoint.cc>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="+QahgC5+KEYLbs62"
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34218 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720AbbK2WAm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 29 Nov 2015 17:00:42 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 95D16B6B9D
	for <netfilter-devel@vger.kernel.org>; Sun, 29 Nov 2015 23:00:40 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8903ADA732
	for <netfilter-devel@vger.kernel.org>; Sun, 29 Nov 2015 23:00:40 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8AA53DA803
	for <netfilter-devel@vger.kernel.org>; Sun, 29 Nov 2015 23:00:38 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151129000929.GA15493@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Nov 29, 2015 at 01:09:29AM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Fri, Nov 27, 2015 at 11:54:17AM +0100, Florian Westphal wrote:
> > > Patrick McHardy <kaber@trash.net> wrote:
> > > > Yes, I also did that and it looks correct. I think we probably have a
> > > > discrepancy with bit numbering:
> > > > 
> > > > Looking at an older patch of you:
> > > > 
> > > > -               [IPHDR_VERSION]         = HDR_BITFIELD("version", &integer_type, 0, 4),
> > > > -               [IPHDR_HDRLENGTH]       = HDR_BITFIELD("hdrlength", &integer_type, 4, 4),
> > > > +               [IPHDR_VERSION]         = HDR_BITFIELD("version", &integer_type, 4, 4),
> > > > +               [IPHDR_HDRLENGTH]       = HDR_BITFIELD("hdrlength", &integer_type, 0, 4),
> > > > 
> > > > So you seem to assume a numbering which corresponds to how you would express
> > > > it in C. My patch assumes numbering as used in the RFCs/IEEE standards, which
> > > > is basically the opposite direction.
> > > 
> > > Right, there is a general problem with all sub-byte fields.
> > > 
> > > I just noticed that decoding of ip version/hdrlen doesn't work either.
> > > (ip hdrlength 4 ip version 5).
> > > 
> > > I am sure that I tested matching on ip version/hdrlen on both
> > > x86-64 and a MSB machine (don't recall architecture, ppc i think).
> > 
> > The existing approach works fine in x86-64 and ppc here.
> > 
> > pahole also reports that version bitfield offset starts at 0, then
> > hdrlength starts at 4, both in x86-64 and ppc.
> > 
> > Probably the problem is the way we calculate the shifts. I managed to
> > set the offset according to RFCs/IEEE by adjusting the existing
> > arithmetics, I think the offset semantics was accidentally changes
> > with this first approach to address sub-byte matching.
> 
> Thanks for looking at this.  I'll take a closer look tomorrow,
> your patch works fine for ip version/hdrlength but seems it messes
> with endianess somewhere.

I forgot to update payload_shift_value() too, to skip the shift when
not needed, sorry, new patch attached.

--+QahgC5+KEYLbs62
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="x.patch"

diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 0790dce..579f038 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -109,21 +109,21 @@ static void netlink_gen_payload_mask(struct netlink_linearize_ctx *ctx,
 {
 	struct nft_data_linearize nld, zero = {};
 	struct nftnl_expr *nle;
-	unsigned int offset, len, masklen;
+	unsigned int shift, len, masklen;
 	mpz_t mask;
 
-	offset = expr->payload.offset % BITS_PER_BYTE;
-	masklen = expr->len + offset;
+	shift = BITS_PER_BYTE - ((expr->payload.offset + expr->len) % BITS_PER_BYTE);
+	masklen = expr->len + shift;
 
 	if (masklen > 128)
-		BUG("expr mask length is %u (len %u, offset %u)\n",
-				masklen, expr->len, offset);
+		BUG("expr mask length is %u (len %u, shift %u)\n",
+				masklen, expr->len, shift);
 
 	mpz_init2(mask, masklen);
 	mpz_bitmask(mask, expr->len);
 
-	if (offset)
-		mpz_lshift_ui(mask, offset);
+	if (shift)
+		mpz_lshift_ui(mask, shift);
 
 	nle = alloc_nft_expr("bitwise");
 
@@ -158,7 +158,8 @@ static void netlink_gen_payload(struct netlink_linearize_ctx *ctx,
 
 	nftnl_rule_add_expr(ctx->nlr, nle);
 
-	if (expr->len % BITS_PER_BYTE)
+	if (expr->payload.offset % BITS_PER_BYTE ||
+	    (expr->payload.offset + expr->len) % BITS_PER_BYTE)
 		netlink_gen_payload_mask(ctx, expr, dreg);
 }
 
@@ -283,11 +284,17 @@ static void netlink_gen_range(struct netlink_linearize_ctx *ctx,
 
 static void payload_shift_value(const struct expr *left, struct expr *right)
 {
+	unsigned int shift;
+
 	if (right->ops->type != EXPR_VALUE ||
 	    left->ops->type != EXPR_PAYLOAD)
 		return;
 
-	mpz_lshift_ui(right->value, left->payload.offset % BITS_PER_BYTE);
+	if (left->payload.offset % BITS_PER_BYTE ||
+	    (left->payload.offset + left->len) % BITS_PER_BYTE) {
+		shift = BITS_PER_BYTE - ((left->payload.offset + left->len) % BITS_PER_BYTE);
+		mpz_lshift_ui(right->value, shift);
+	}
 }
 
 static struct expr *netlink_gen_prefix(struct netlink_linearize_ctx *ctx,
diff --git a/src/proto.c b/src/proto.c
index 0fe0b88..9839124 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -508,8 +508,8 @@ const struct proto_desc proto_ip = {
 		PROTO_LINK(IPPROTO_SCTP,	&proto_sctp),
 	},
 	.templates	= {
-		[IPHDR_VERSION]		= HDR_BITFIELD("version", &integer_type, 4, 4),
-		[IPHDR_HDRLENGTH]	= HDR_BITFIELD("hdrlength", &integer_type, 0, 4),
+		[IPHDR_VERSION]		= HDR_BITFIELD("version", &integer_type, 0, 4),
+		[IPHDR_HDRLENGTH]	= HDR_BITFIELD("hdrlength", &integer_type, 4, 4),
 		[IPHDR_TOS]		= IPHDR_FIELD("tos",		tos),
 		[IPHDR_LENGTH]		= IPHDR_FIELD("length",		tot_len),
 		[IPHDR_ID]		= IPHDR_FIELD("id",		id),

--+QahgC5+KEYLbs62--
