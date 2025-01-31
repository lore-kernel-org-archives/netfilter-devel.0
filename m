Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE314C7C
	for <netfilter-devel@vger.kernel.org>; Fri, 31 Jan 2025 12:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738326627; cv=none; b=Xu337KHaNgcsQibXSbijsy+o4DaYo5F3rhdEhfNW2sd1S+Mp665U10jQ7QzniYvN8bu1vQKvwFJEvY/tY6B/L8b7D5bFw8GHI59aLp1kOtGpezr11VzTSIHUYXUs9D17L2tlRWJrG8KWNb4K4t+vV9MT1WRyKuKOQ4KJlMXSu20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738326627; c=relaxed/simple;
	bh=Zvw8sGAH7huWi5STDvBRuDW8hiqGCZdA20DG9GzEL9w=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=V6fTlDxvtwwcpbLJ5hlVWnyaRKw7FRF0yP71HpEk8yOYSXs81ddW+PsYeg0gDbjdfqdbRZX3wCBvxLXYtFxhFE97o9KQxFm/Y+S33RnA2Y3LHvBDaABpWkuKmbVyEtwPFSsqEmc0ZzZAk3zjxnmGlUCcJPmjelWIDsK90qSwb8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=DSHOK7K6; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=BpooGs6U; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="DSHOK7K6";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="BpooGs6U"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 0B0626029C; Fri, 31 Jan 2025 13:30:16 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1738326616;
	bh=D54z72p8UBTXwql73QivYbu0RS/ZaL3zxQRvZFFZ55M=;
	h=From:To:Subject:Date:From;
	b=DSHOK7K68Gkc//4rVshxL5jq1mGZ7bz7a1IoeQoQ/ILa0xgBjIpehNwEnJaIngXtV
	 j2sHRgVO+Zil6JFnXRNpysJKNEAs7qYSMX4WgP64O36+SwZ9jvfKXdaLmUT604HClI
	 gGOOg4W95N9Xw88rpsQu7BG5zOnFwv+Hq/ngU/26ENCzyZXmr1nARIlvysQaglfVAv
	 fvybByQRZlrMPsjNk5F1/7cuLThFiTsFqgdo9aXTWiZebWy7bHU9bLzidDjIKSVhEV
	 xkg+uDp08Zv8PcOUSWumiIu909AoUMe0nGt5J5OeZjaQhdYRhUzQJyUl4FuqjNomZF
	 VTwacoZ7OqEMw==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A006360297
	for <netfilter-devel@vger.kernel.org>; Fri, 31 Jan 2025 13:30:15 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1738326615;
	bh=D54z72p8UBTXwql73QivYbu0RS/ZaL3zxQRvZFFZ55M=;
	h=From:To:Subject:Date:From;
	b=BpooGs6UzZ28pBg15ATnvSVNyj/q747doNBSo7jGj1RDIpPD/RwOujye9C9/RREW0
	 yvjjfFDD4KqaOjEal1FFU/FWKfD/pQYp8FgrhNiWnSRcqx/J4Bgo272Abu+JknVkOJ
	 YaELvbvKZVrgGSuoCWDq0mXP3tqlRgTrwgtQDsYpgXSRfHyHCoSLPuYrhONf8e3yE3
	 qcc0o18KH318xO7jssYVexZA5owFDaRKZzA7llCeYAe3/5SuNQLE3OnjmXeKEFfKQn
	 YhXSIZ5OiXVZnNW9UtjURBf0E2A9RtyYqfGRt23bhk6/KMaRUWlepw6NMMrm+0wmuT
	 eai0os4lFcmQQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] datatype: clamp boolean value to 0 and 1
Date: Fri, 31 Jan 2025 13:30:11 +0100
Message-Id: <20250131123011.831035-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If user provides a numeric value larger than 0 or 1, match never
happens:

 # nft --debug=netlink add rule x y tcp option sack-perm 4
 ip x y
  [ exthdr load tcpopt 1b @ 4 + 0 present => reg 1 ]
  [ cmp eq reg 1 0x00000004 ]

After this update:

 # nft --debug=netlink add rule x y tcp option sack-perm 4
 ip x y
  [ exthdr load tcpopt 1b @ 4 + 0 present => reg 1 ]
  [ cmp eq reg 1 0x00000001 ]

This is to address a rare corner case, in case user specifies the
boolean value through the integer base type.

Fixes: 9fd9baba43c8 ("Introduce boolean datatype and boolean expression")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/datatype.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/src/datatype.c b/src/datatype.c
index 0c13bbd4270e..f347010f4a1a 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -1554,11 +1554,35 @@ static const struct symbol_table boolean_tbl = {
 	},
 };
 
+static struct error_record *boolean_type_parse(struct parse_ctx *ctx,
+					       const struct expr *sym,
+					       struct expr **res)
+{
+	struct error_record *erec;
+	int num;
+
+	erec = integer_type_parse(ctx, sym, res);
+	if (erec)
+		return erec;
+
+	if (mpz_cmp_ui((*res)->value, 0))
+		num = 1;
+	else
+		num = 0;
+
+	expr_free(*res);
+
+	*res = constant_expr_alloc(&sym->location, &boolean_type,
+				   BYTEORDER_HOST_ENDIAN, 1, &num);
+	return NULL;
+}
+
 const struct datatype boolean_type = {
 	.type		= TYPE_BOOLEAN,
 	.name		= "boolean",
 	.desc		= "boolean type",
 	.size		= 1,
+	.parse		= boolean_type_parse,
 	.basetype	= &integer_type,
 	.sym_tbl	= &boolean_tbl,
 	.json		= boolean_type_json,
-- 
2.30.2

