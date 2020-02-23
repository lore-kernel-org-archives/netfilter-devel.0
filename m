Return-Path: <SRS0=J2Vc=4L=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52A54C35673
	for <netfilter-devel@archiver.kernel.org>; Sun, 23 Feb 2020 23:12:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2615020880
	for <netfilter-devel@archiver.kernel.org>; Sun, 23 Feb 2020 23:12:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727177AbgBWXMg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 23 Feb 2020 18:12:36 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:45854 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727170AbgBWXMg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 23 Feb 2020 18:12:36 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1j60QJ-0004Pn-7M; Mon, 24 Feb 2020 00:12:31 +0100
Date:   Mon, 24 Feb 2020 00:12:31 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, Jeremy Sowden <jeremy@azazel.net>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft] evaluate: don't eval unary arguments.
Message-ID: <20200223231231.GC19559@breakpoint.cc>
References: <20200128184918.d663llqkrmaxyusl@salvia>
 <20200223221411.GA121279@azazel.net>
 <20200223222321.kjfsxjl6ftbcrink@salvia>
 <20200223223424.GZ19559@breakpoint.cc>
 <20200223223849.ainqgs32iyd4wtbw@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200223223849.ainqgs32iyd4wtbw@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Sun, Feb 23, 2020 at 11:34:24PM +0100, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > On Sun, Feb 23, 2020 at 10:14:11PM +0000, Jeremy Sowden wrote:
> > > > After giving this some thought, it occurred to me that this could be
> > > > fixed by extending bitwise boolean operations to support a variable
> > > > righthand operand (IIRC, before Christmas Florian suggested something
> > > > along these lines to me in another, related context), so I've gone down
> > > > that route.  Patches to follow shortly.
> > > 
> > > Would this require a new kernel extensions? What's the idea behind
> > > this?
> > 
> > Something like this:
> > nft ... ct mark set ct mark & 0xffff0000 | meta mark & 0xffff
> 
> I see, so this requires two source registers as input for nft_bitwise?

Yes, it requires two source registers as input, probably even two.
I have salvaged this old junk patch from an older branch of mine, it
added both sreg_mask and xor.

(I rebased it just now and it compiles).

I will do some more dumpster diving tomorrow to see if i can locate
the corresponding nftables and kernel branch.

---
 include/libnftnl/expr.h             |  2 ++
 include/linux/netfilter/nf_tables.h |  2 ++
 src/expr/bitwise.c                  | 39 ++++++++++++++++++++++++++---
 3 files changed, 39 insertions(+), 4 deletions(-)

diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index cfe456dbc7a5..30f4ef73e9d6 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -118,6 +118,8 @@ enum {
 	NFTNL_EXPR_BITWISE_XOR,
 	NFTNL_EXPR_BITWISE_OP,
 	NFTNL_EXPR_BITWISE_DATA,
+	NFTNL_EXPR_BITWISE_SREG_MASK,
+	NFTNL_EXPR_BITWISE_SREG_XOR,
 };
 
 enum {
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 065218a20bb7..7c560a50ae19 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -549,6 +549,8 @@ enum nft_bitwise_attributes {
 	NFTA_BITWISE_XOR,
 	NFTA_BITWISE_OP,
 	NFTA_BITWISE_DATA,
+	NFTA_BITWISE_SREG_MASK,
+	NFTA_BITWISE_SREG_XOR,
 	__NFTA_BITWISE_MAX
 };
 #define NFTA_BITWISE_MAX	(__NFTA_BITWISE_MAX - 1)
diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index 9ea2f662b3e6..7eb8d2a79c80 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -23,6 +23,8 @@
 
 struct nftnl_expr_bitwise {
 	enum nft_registers	sreg;
+	enum nft_registers	sreg_xor;
+	enum nft_registers	sreg_mask;
 	enum nft_registers	dreg;
 	enum nft_bitwise_ops	op;
 	unsigned int		len;
@@ -54,6 +56,9 @@ nftnl_expr_bitwise_set(struct nftnl_expr *e, uint16_t type,
 		memcpy(&bitwise->mask.val, data, data_len);
 		bitwise->mask.len = data_len;
 		break;
+	case NFTNL_EXPR_BITWISE_SREG_MASK:
+		memcpy(&bitwise->sreg_mask, data, sizeof(bitwise->sreg_mask));
+		break;
 	case NFTNL_EXPR_BITWISE_XOR:
 		memcpy(&bitwise->xor.val, data, data_len);
 		bitwise->xor.len = data_len;
@@ -62,6 +67,9 @@ nftnl_expr_bitwise_set(struct nftnl_expr *e, uint16_t type,
 		memcpy(&bitwise->data.val, data, data_len);
 		bitwise->data.len = data_len;
 		break;
+	case NFTNL_EXPR_BITWISE_SREG_XOR:
+		memcpy(&bitwise->sreg_xor, data, sizeof(bitwise->sreg_xor));
+		break;
 	default:
 		return -1;
 	}
@@ -90,12 +98,18 @@ nftnl_expr_bitwise_get(const struct nftnl_expr *e, uint16_t type,
 	case NFTNL_EXPR_BITWISE_MASK:
 		*data_len = bitwise->mask.len;
 		return &bitwise->mask.val;
+	case NFTNL_EXPR_BITWISE_SREG_MASK:
+		*data_len = sizeof(bitwise->sreg_mask);
+		return &bitwise->sreg_mask;
 	case NFTNL_EXPR_BITWISE_XOR:
 		*data_len = bitwise->xor.len;
 		return &bitwise->xor.val;
 	case NFTNL_EXPR_BITWISE_DATA:
 		*data_len = bitwise->data.len;
 		return &bitwise->data.val;
+	case NFTNL_EXPR_BITWISE_SREG_XOR:
+		*data_len = sizeof(bitwise->sreg_xor);
+		return &bitwise->sreg_xor;
 	}
 	return NULL;
 }
@@ -110,6 +124,8 @@ static int nftnl_expr_bitwise_cb(const struct nlattr *attr, void *data)
 
 	switch(type) {
 	case NFTA_BITWISE_SREG:
+	case NFTA_BITWISE_SREG_XOR:
+	case NFTA_BITWISE_SREG_MASK:
 	case NFTA_BITWISE_DREG:
 	case NFTA_BITWISE_OP:
 	case NFTA_BITWISE_LEN:
@@ -165,6 +181,8 @@ nftnl_expr_bitwise_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
 				bitwise->data.val);
 		mnl_attr_nest_end(nlh, nest);
 	}
+	if (e->flags & (1 << NFTNL_EXPR_BITWISE_SREG_XOR))
+		mnl_attr_put_u32(nlh, NFTA_BITWISE_SREG_XOR, htonl(bitwise->sreg_xor));
 }
 
 static int
@@ -197,6 +215,10 @@ nftnl_expr_bitwise_parse(struct nftnl_expr *e, struct nlattr *attr)
 		ret = nftnl_parse_data(&bitwise->mask, tb[NFTA_BITWISE_MASK], NULL);
 		e->flags |= (1 << NFTA_BITWISE_MASK);
 	}
+	if (tb[NFTA_BITWISE_SREG_MASK]) {
+		bitwise->sreg_mask = ntohl(mnl_attr_get_u32(tb[NFTA_BITWISE_SREG_MASK]));
+		e->flags |= (1 << NFTA_BITWISE_SREG_MASK);
+	}
 	if (tb[NFTA_BITWISE_XOR]) {
 		ret = nftnl_parse_data(&bitwise->xor, tb[NFTA_BITWISE_XOR], NULL);
 		e->flags |= (1 << NFTA_BITWISE_XOR);
@@ -205,13 +227,18 @@ nftnl_expr_bitwise_parse(struct nftnl_expr *e, struct nlattr *attr)
 		ret = nftnl_parse_data(&bitwise->data, tb[NFTA_BITWISE_DATA], NULL);
 		e->flags |= (1 << NFTNL_EXPR_BITWISE_DATA);
 	}
+	if (tb[NFTA_BITWISE_SREG_XOR]) {
+		bitwise->sreg_xor = ntohl(mnl_attr_get_u32(tb[NFTA_BITWISE_SREG_XOR]));
+		e->flags |= (1 << NFTA_BITWISE_SREG_XOR);
+	}
 
 	return ret;
 }
 
 static int
 nftnl_expr_bitwise_snprintf_bool(char *buf, size_t size,
-				 const struct nftnl_expr_bitwise *bitwise)
+				 const struct nftnl_expr_bitwise *bitwise,
+				 uint32_t flags)
 {
 	int remain = size, offset = 0, ret;
 
@@ -226,8 +253,12 @@ nftnl_expr_bitwise_snprintf_bool(char *buf, size_t size,
 	ret = snprintf(buf + offset, remain, ") ^ ");
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
-	ret = nftnl_data_reg_snprintf(buf + offset, remain, &bitwise->xor,
-				      NFTNL_OUTPUT_DEFAULT, 0, DATA_VALUE);
+	if (flags & (1 << NFTNL_EXPR_BITWISE_SREG_XOR))
+		ret = snprintf(buf + offset, remain, "reg %u",
+			       bitwise->sreg_xor);
+	else
+		ret = nftnl_data_reg_snprintf(buf + offset, remain, &bitwise->xor,
+					    NFTNL_OUTPUT_DEFAULT, 0, DATA_VALUE);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	return offset;
@@ -260,7 +291,7 @@ static int nftnl_expr_bitwise_snprintf_default(char *buf, size_t size,
 
 	switch (bitwise->op) {
 	case NFT_BITWISE_BOOL:
-		err = nftnl_expr_bitwise_snprintf_bool(buf, size, bitwise);
+		err = nftnl_expr_bitwise_snprintf_bool(buf, size, bitwise, e->flags);
 		break;
 	case NFT_BITWISE_LSHIFT:
 		err = nftnl_expr_bitwise_snprintf_shift(buf, size, "<<", bitwise);
-- 
2.24.1

