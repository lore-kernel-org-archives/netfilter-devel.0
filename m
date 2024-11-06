Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F2B3208981
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Nov 2024 23:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730934719; cv=none; b=PYsrRQNriJF4wv1xcv5ILC2s0zO/yf9txXhqmrog1wDtzJgZC+ppOKOebfsyNMHAhYgJsr176o6g5Zn1TkOzvQNkxOm8uUWjFhNiONziHt+Mp/9XkKkLNV9LNZXqdx6/wM2JvF7HYVxCUzrPeHkbugWWTclgpOp7k2d8XpgxgF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730934719; c=relaxed/simple;
	bh=HlXoYwUQ7+8MYthkh2KQV4lOyFdK3UNWmsIrn8ICmqs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JbHLu3dgV/gDtJscktmUZsDq3k7MzfSnO4Xdv0059RRbyy4XaakTQYZen8uR4yHxJeFGhWqE2SjxPgOO8tvyTT0epX/jSij2zWZHaHnRGlu5AzhZe3GBIzSELv/w+lqkodSvLki86KageCwtJ+qhSy6jFJMsc7rYQWCUUTwYXqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=60094 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t8pBm-00Bhwl-4F; Thu, 07 Nov 2024 00:11:52 +0100
Date: Thu, 7 Nov 2024 00:11:48 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] src: allow to map key to nfqueue number
Message-ID: <Zyv3tBgF9jW5D0v-@calendula>
References: <20241025074729.12412-1-fw@strlen.de>
 <Zytu_YJeGyF-RaxI@calendula>
 <20241106135244.GA11098@breakpoint.cc>
 <20241106143253.GA12653@breakpoint.cc>
 <ZyuTa9lmkXRAvSfn@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="gu4Y/oIARLFVpfrF"
Content-Disposition: inline
In-Reply-To: <ZyuTa9lmkXRAvSfn@calendula>
X-Spam-Score: -1.8 (-)


--gu4Y/oIARLFVpfrF
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Wed, Nov 06, 2024 at 05:03:55PM +0100, Pablo Neira Ayuso wrote:
> I can take a look later today based on your patch, I think I can reuse
> 90% of it, it is just a subtle detail what I am referring to.

See attachment, not better than your proposal, just a different focus.

--gu4Y/oIARLFVpfrF
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0001-src-allow-to-map-key-to-nfqueue-number.patch"

From 26a7503fd5dadf0425515f5647add64a2a9eb404 Mon Sep 17 00:00:00 2001
From: Florian Westphal <fw@strlen.de>
Date: Fri, 25 Oct 2024 09:47:25 +0200
Subject: [PATCH] src: allow to map key to nfqueue number

Allow to specify a numeric queue id as part of a map.
The parser side is easy, but the reverse direction (listing) is not.

'queue' is a statement, it doesn't have an expression.

Add a generic 'queue_type' datatype as a TYPE_TYPEOF shim to the real
basetype with constant expressions, this is used only for udata
build/parse, it stores the "key" (the parser token, here "queue") as
udata in kernel and can then restore the original key.

Add a dumpfile to validate parser & output.

JSON support is missing because JSON allow typeof only since quite
recently.

Joint work with Pablo.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1455
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/datatype.h                            |  3 +
 src/datatype.c                                | 17 ++++
 src/expression.c                              | 80 +++++++++++++++++++
 src/json.                                     |  0
 src/netlink.c                                 |  6 +-
 src/parser_bison.y                            |  4 +
 tests/shell/testcases/nft-f/dumps/nfqueue.nft | 11 +++
 tests/shell/testcases/nft-f/nfqueue           |  6 ++
 8 files changed, 126 insertions(+), 1 deletion(-)
 create mode 100644 src/json.
 create mode 100644 tests/shell/testcases/nft-f/dumps/nfqueue.nft
 create mode 100755 tests/shell/testcases/nft-f/nfqueue

diff --git a/include/datatype.h b/include/datatype.h
index 75d6d6b8c628..61c6bf595e9e 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -102,6 +102,8 @@ enum datatypes {
 };
 #define TYPE_MAX		(__TYPE_MAX - 1)
 
+#define TYPE_TYPEOF		__TYPE_MAX
+
 #define TYPE_BITS		6
 #define TYPE_MASK		((1 << TYPE_BITS) - 1)
 
@@ -271,6 +273,7 @@ extern const struct datatype boolean_type;
 extern const struct datatype priority_type;
 extern const struct datatype policy_type;
 extern const struct datatype cgroupv2_type;
+extern const struct datatype queue_type;
 
 /* private datatypes for reject statement. */
 extern const struct datatype reject_icmp_code_type;
diff --git a/src/datatype.c b/src/datatype.c
index ea73eaf9a691..c9c5a198bd3b 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -505,6 +505,23 @@ const struct datatype xinteger_type = {
 	.parse		= integer_type_parse,
 };
 
+static void queue_type_print(const struct expr *expr, struct output_ctx *octx)
+{
+	nft_gmp_print(octx, "queue");
+}
+
+/* Dummy queue_type for set declaration with typeof, see
+ * constant_expr_build_udata and constant_expr_parse_udata,
+ * basetype is used for elements.
+*/
+const struct datatype queue_type = {
+	.type		= TYPE_TYPEOF,
+	.name		= "queue",
+	.desc		= "queue",
+	.basetype	= &integer_type,
+	.print		= queue_type_print,
+};
+
 static void string_type_print(const struct expr *expr, struct output_ctx *octx)
 {
 	unsigned int len = div_round_up(expr->len, BITS_PER_BYTE);
diff --git a/src/expression.c b/src/expression.c
index c0cb7f22eb73..62786f483eed 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -371,6 +371,84 @@ struct expr *variable_expr_alloc(const struct location *loc,
 	return expr;
 }
 
+#define NFTNL_UDATA_CONSTANT_TYPE 0
+#define NFTNL_UDATA_CONSTANT_MAX NFTNL_UDATA_CONSTANT_TYPE
+
+#define CONSTANT_EXPR_NFQUEUE_ID 0
+
+static int constant_expr_build_udata(struct nftnl_udata_buf *udbuf,
+				     const struct expr *expr)
+{
+	uint32_t type;
+
+	if (expr->dtype == &queue_type)
+		type = CONSTANT_EXPR_NFQUEUE_ID;
+	else
+		return -1;
+
+	if (!nftnl_udata_put_u32(udbuf, NFTNL_UDATA_CONSTANT_TYPE, type))
+		return -1;
+
+	return 0;
+}
+
+static int constant_parse_udata(const struct nftnl_udata *attr, void *data)
+{
+	const struct nftnl_udata **ud = data;
+	uint8_t type = nftnl_udata_type(attr);
+	uint8_t len = nftnl_udata_len(attr);
+	uint32_t value;
+
+	switch (type) {
+	case NFTNL_UDATA_CONSTANT_TYPE:
+		if (len != sizeof(uint32_t))
+			return -1;
+
+		value = nftnl_udata_get_u32(attr);
+		switch (value) {
+		case CONSTANT_EXPR_NFQUEUE_ID:
+			break;
+		default:
+			return -1;
+		}
+		break;
+	default:
+		return 0;
+	}
+
+	ud[type] = attr;
+
+	return 0;
+}
+
+static struct expr *constant_expr_parse_udata(const struct nftnl_udata *attr)
+{
+	const struct nftnl_udata *ud[NFTNL_UDATA_CONSTANT_MAX + 1] = {};
+	const struct datatype *dtype = NULL;
+	uint32_t type;
+	int err;
+
+	err = nftnl_udata_parse(nftnl_udata_get(attr), nftnl_udata_len(attr),
+				constant_parse_udata, ud);
+	if (err < 0)
+		return NULL;
+
+	if (!ud[NFTNL_UDATA_CONSTANT_TYPE])
+		return NULL;
+
+	type = nftnl_udata_get_u32(ud[NFTNL_UDATA_CONSTANT_TYPE]);
+	switch (type) {
+	case CONSTANT_EXPR_NFQUEUE_ID:
+		dtype = &queue_type;
+		break;
+	default:
+		break;
+	}
+
+	return constant_expr_alloc(&internal_location, dtype, BYTEORDER_HOST_ENDIAN,
+				   16, NULL);
+}
+
 static void constant_expr_print(const struct expr *expr,
 				 struct output_ctx *octx)
 {
@@ -401,6 +479,8 @@ static const struct expr_ops constant_expr_ops = {
 	.cmp		= constant_expr_cmp,
 	.clone		= constant_expr_clone,
 	.destroy	= constant_expr_destroy,
+	.build_udata	= constant_expr_build_udata,
+	.parse_udata	= constant_expr_parse_udata,
 };
 
 struct expr *constant_expr_alloc(const struct location *loc,
diff --git a/src/json. b/src/json.
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/src/netlink.c b/src/netlink.c
index 25ee3419772b..68e7da68ed68 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1466,7 +1466,11 @@ key_end:
 		data = netlink_alloc_data(&netlink_location, &nld,
 					  set->data->dtype->type == TYPE_VERDICT ?
 					  NFT_REG_VERDICT : NFT_REG_1);
-		datatype_set(data, set->data->dtype);
+
+		if (set->data->dtype->type == TYPE_TYPEOF)
+			datatype_set(data, set->data->dtype->basetype);
+		else
+			datatype_set(data, set->data->dtype);
 		data->byteorder = set->data->byteorder;
 
 		if (set->data->dtype->subtypes) {
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 602fc60e6de3..6e6f3cf8335d 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -2173,6 +2173,10 @@ typeof_data_expr	:	INTERVAL	typeof_expr
 			{
 				$$ = $1;
 			}
+			|	QUEUE
+			{
+				$$ = constant_expr_alloc(&@$, &queue_type, BYTEORDER_HOST_ENDIAN, 16, NULL);
+			}
 			;
 
 typeof_expr		:	primary_expr
diff --git a/tests/shell/testcases/nft-f/dumps/nfqueue.nft b/tests/shell/testcases/nft-f/dumps/nfqueue.nft
new file mode 100644
index 000000000000..7fe3ca669544
--- /dev/null
+++ b/tests/shell/testcases/nft-f/dumps/nfqueue.nft
@@ -0,0 +1,11 @@
+table inet t {
+	map get_queue_id {
+		typeof ip saddr . ip daddr . tcp dport : queue
+		elements = { 127.0.0.1 . 127.0.0.1 . 22 : 1,
+			     127.0.0.1 . 127.0.0.2 . 22 : 2 }
+	}
+
+	chain test {
+		queue flags bypass to ip saddr . ip daddr . tcp dport map @get_queue_id
+	}
+}
diff --git a/tests/shell/testcases/nft-f/nfqueue b/tests/shell/testcases/nft-f/nfqueue
new file mode 100755
index 000000000000..07820b7c4fdd
--- /dev/null
+++ b/tests/shell/testcases/nft-f/nfqueue
@@ -0,0 +1,6 @@
+#!/bin/bash
+
+set -e
+dumpfile=$(dirname $0)/dumps/$(basename $0).nft
+
+$NFT -f "$dumpfile"
-- 
2.30.2


--gu4Y/oIARLFVpfrF--
