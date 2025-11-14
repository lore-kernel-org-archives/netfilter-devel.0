Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AA54163
	for <netfilter-devel@vger.kernel.org>; Fri, 14 Nov 2025 00:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763079953; cv=none; b=qx5tiMnHJg6eVpM6jyT6B5GiKKnhzZPvByQzKUGbnb0B8httS2yMqkIdnRE6jft4qxoSxNwNv/QXmWWsuUiyrLGYprYIW6Vef84v+GhVyheTyiEQ1WRWrb2WgyL/O229aiJwOcbaI4UNjqZ1pGHq0zoCJ/KJjWbI7/JtwdoA0sE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763079953; c=relaxed/simple;
	bh=ZUW+qrYByr29sVG3FqbULB+hldmlyk3lt4fKHOSqOdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CDYPGIhfWbnpe2fn3uskk8D908VJTmxuphADYPJJ7NGEZKAoY/ckzMIEl0wNuH61RRYQAmJRwQMMnYTMzvvX4kqot0ClvwWinjti3qIm5nUM0/CFolJy2Qq/YnEaxMfRsZGt1EoepNhvuRcf3BRNiWDnbybSRrX5fLPzYYfNVTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=jEz8uxqo; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="jEz8uxqo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=2OVJjAnwrRzcrD9Y8WlHY1JYSsMqg0bIqSnOutvBZBg=; b=jEz8uxqo+GUT3HbYJzSnNf0MPh
	3vTBENc4rUUNOnVNHOKmyLhpBXocABbRPAOaz/aY6VnlMjPIdLWwNyrg1stt3KucIzvQPq3ElG//s
	PlErLsEKquNhdIaWloyDOXlwmxMi9s6+twokt+xjPADhN83EBfPkRnY5WODNK6/CZpfrp856XmKmf
	m4TsrYqcKJEqk8qpXeBt3AHrdItOdDh7Ndw6B0cQCgwd9EQSjnPXKh2d9GRYxDaWz+O8incT8LIdP
	r1xTACG8MsY982PUDlK0Lc5Ae+YJ1tjBhSfYbkKKmd4gbQzZ5XjTDPdXsInrv8h1VUKiekf+z3Rjf
	9Wd14qow==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vJhdN-000000005jt-1Oi6;
	Fri, 14 Nov 2025 01:25:49 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH v2 06/11] netlink: Introduce struct nft_data_linearize::byteorder
Date: Fri, 14 Nov 2025 01:25:37 +0100
Message-ID: <20251114002542.22667-7-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251114002542.22667-1-phil@nwl.cc>
References: <20251114002542.22667-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Bits in this field indicate data is in host byte order and thus may need
conversion when being printed "byte-by-byte" in libnftnl.

With regular immediate values, this field's value has boolean properties
(if non-zero, data is in host byte order). Concatenations may contain
components in different byte order, so with them each bit (at index N)
indicates whether a component (at the same index) is in host byte order.

Communicate a possible byte order conversion in
__netlink_gen_concat_key() back to caller since this has to be respected
when setting 'byteorder' field in struct nft_data_linearize.

String-based values are special: While defined as being in host byte
order in nftables, libnftnl shall print them without prior conversion
like Big Endian values.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/netlink.h |  1 +
 src/netlink.c     | 60 +++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 51 insertions(+), 10 deletions(-)

diff --git a/include/netlink.h b/include/netlink.h
index 2737d5708b295..a762cb485784f 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -106,6 +106,7 @@ struct nft_data_linearize {
 	char		chain[NFT_CHAIN_MAXNAMELEN];
 	uint32_t	chain_id;
 	int		verdict;
+	uint32_t	byteorder;
 };
 
 struct nft_data_delinearize {
diff --git a/src/netlink.c b/src/netlink.c
index 26cf07c379261..3a512753c7624 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -248,6 +248,7 @@ void netlink_gen_raw_data(const mpz_t value, enum byteorder byteorder,
 	assert(len > 0);
 	mpz_export_data(data->value, value, byteorder, len);
 	data->len = len;
+	data->byteorder = byteorder == BYTEORDER_HOST_ENDIAN ? UINT32_MAX : 0;
 }
 
 static int netlink_export_pad(unsigned char *data, const mpz_t v,
@@ -265,12 +266,15 @@ static void byteorder_switch_expr_value(mpz_t v, const struct expr *e)
 }
 
 static int __netlink_gen_concat_key(uint32_t flags, const struct expr *i,
-				    unsigned char *data)
+				    unsigned char *data,
+				    enum byteorder *byteorder)
 {
 	struct expr *expr;
 	mpz_t value;
 	int ret;
 
+	*byteorder = i->byteorder;
+
 	switch (i->etype) {
 	case EXPR_RANGE:
 		if (flags & EXPR_F_INTERVAL_END)
@@ -281,8 +285,10 @@ static int __netlink_gen_concat_key(uint32_t flags, const struct expr *i,
 		mpz_init_set(value, expr->value);
 
 		if (expr_basetype(expr)->type == TYPE_INTEGER &&
-		    expr->byteorder == BYTEORDER_HOST_ENDIAN)
+		    expr->byteorder == BYTEORDER_HOST_ENDIAN) {
 			byteorder_switch_expr_value(value, expr);
+			*byteorder = BYTEORDER_BIG_ENDIAN;
+		}
 
 		i = expr;
 		break;
@@ -293,8 +299,10 @@ static int __netlink_gen_concat_key(uint32_t flags, const struct expr *i,
 			mpz_init_set(value, i->range.low);
 
 		if (expr_basetype(i)->type == TYPE_INTEGER &&
-		    i->byteorder == BYTEORDER_HOST_ENDIAN)
+		    i->byteorder == BYTEORDER_HOST_ENDIAN) {
 			byteorder_switch_expr_value(value, i);
+			*byteorder = BYTEORDER_BIG_ENDIAN;
+		}
 
 		break;
 	case EXPR_PREFIX:
@@ -304,8 +312,10 @@ static int __netlink_gen_concat_key(uint32_t flags, const struct expr *i,
 
 			mpz_init_bitmask(v, i->len - i->prefix_len);
 
-			if (i->byteorder == BYTEORDER_HOST_ENDIAN)
+			if (i->byteorder == BYTEORDER_HOST_ENDIAN) {
 				byteorder_switch_expr_value(v, i);
+				*byteorder = BYTEORDER_BIG_ENDIAN;
+			}
 
 			mpz_add(v, i->prefix->value, v);
 			count = netlink_export_pad(data, v, i);
@@ -323,9 +333,12 @@ static int __netlink_gen_concat_key(uint32_t flags, const struct expr *i,
 			break;
 
 		expr = (struct expr *)i;
+
 		if (expr_basetype(expr)->type == TYPE_INTEGER &&
-		    expr->byteorder == BYTEORDER_HOST_ENDIAN)
+		    expr->byteorder == BYTEORDER_HOST_ENDIAN) {
 			byteorder_switch_expr_value(value, expr);
+			*byteorder = BYTEORDER_BIG_ENDIAN;
+		}
 		break;
 	default:
 		BUG("invalid expression type '%s' in set", expr_ops(i)->name);
@@ -353,16 +366,24 @@ static void netlink_gen_concat_key(const struct expr *expr,
 {
 	unsigned int len = netlink_padded_len(expr->len) / BITS_PER_BYTE;
 	unsigned char data[NFT_MAX_EXPR_LEN_BYTES];
+	enum byteorder byteorder;
 	unsigned int offset = 0;
 	const struct expr *i;
+	int n = 0;
 
 	if (len > sizeof(data))
 		BUG("Value export of %u bytes would overflow", len);
 
 	memset(data, 0, sizeof(data));
 
-	list_for_each_entry(i, &expr_concat(expr)->expressions, list)
-		offset += __netlink_gen_concat_key(expr->flags, i, data + offset);
+	list_for_each_entry(i, &expr_concat(expr)->expressions, list) {
+		offset += __netlink_gen_concat_key(expr->flags, i,
+						   data + offset, &byteorder);
+		if (byteorder == BYTEORDER_HOST_ENDIAN &&
+		    expr_basetype(i)->type != TYPE_STRING)
+			nld->byteorder |= 1 << n;
+		n++;
+	}
 
 	nft_data_memcpy(nld, data, len);
 }
@@ -419,17 +440,28 @@ static void __netlink_gen_concat_expand(const struct expr *expr,
 	unsigned char data[NFT_MAX_EXPR_LEN_BYTES];
 	unsigned int offset = 0;
 	const struct expr *i;
+	int n = 0;
 
 	if (len > sizeof(data))
 		BUG("Value export of %u bytes would overflow", len);
 
 	memset(data, 0, sizeof(data));
 
-	list_for_each_entry(i, &expr_concat(expr)->expressions, list)
+	list_for_each_entry(i, &expr_concat(expr)->expressions, list) {
 		offset += __netlink_gen_concat_data(false, i, data + offset);
+		if (i->byteorder == BYTEORDER_HOST_ENDIAN &&
+		    expr_basetype(i)->type != TYPE_STRING)
+			nld->byteorder |= 1 << n;
+		n++;
+	}
 
-	list_for_each_entry(i, &expr_concat(expr)->expressions, list)
+	list_for_each_entry(i, &expr_concat(expr)->expressions, list) {
 		offset += __netlink_gen_concat_data(true, i, data + offset);
+		if (i->byteorder == BYTEORDER_HOST_ENDIAN &&
+		    expr_basetype(i)->type != TYPE_STRING)
+			nld->byteorder |= 1 << n;
+		n++;
+	}
 
 	nft_data_memcpy(nld, data, len);
 }
@@ -441,14 +473,20 @@ static void __netlink_gen_concat(const struct expr *expr,
 	unsigned char data[NFT_MAX_EXPR_LEN_BYTES];
 	unsigned int offset = 0;
 	const struct expr *i;
+	int n = 0;
 
 	if (len > sizeof(data))
 		BUG("Value export of %u bytes would overflow", len);
 
 	memset(data, 0, sizeof(data));
 
-	list_for_each_entry(i, &expr_concat(expr)->expressions, list)
+	list_for_each_entry(i, &expr_concat(expr)->expressions, list) {
 		offset += __netlink_gen_concat_data(expr->flags, i, data + offset);
+		if (i->byteorder == BYTEORDER_HOST_ENDIAN &&
+		    expr_basetype(i)->type != TYPE_STRING)
+			nld->byteorder |= 1 << n;
+		n++;
+	}
 
 	nft_data_memcpy(nld, data, len);
 }
@@ -468,6 +506,8 @@ static void netlink_gen_constant_data(const struct expr *expr,
 	assert(expr->etype == EXPR_VALUE);
 	netlink_gen_raw_data(expr->value, expr->byteorder,
 			     div_round_up(expr->len, BITS_PER_BYTE), data);
+	if (expr_basetype(expr)->type == TYPE_STRING)
+		data->byteorder = 0;
 }
 
 static void netlink_gen_chain(const struct expr *expr,
-- 
2.51.0

