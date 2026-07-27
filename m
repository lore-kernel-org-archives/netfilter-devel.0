Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D8532779D
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Jul 2026 14:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785162084; cv=none; b=jxZbPF+SmU2faw+lvXGaXd1B+lnWOIyPqum+m/Uze06fytqOXC8GM0x5Idw7UC9QDTevjQEGDml6eQua7QkqvqsIJzBCYaYjQ4kFU1mQUsgnEn5gMMNymdzt4MSIB47z5UGVKzdHWMGq8KOeV4o9/qSHv/vNxPGXAAdOzkFeD9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785162084; c=relaxed/simple;
	bh=zb9fmbaa9pT1OOsW1Xpsf8MPqS3F7zH9HDuhyMVaTEY=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=rJt+BPuiiSKVl/WKmOwamKmWISAzvM8iCoqWLmxe2MEYyjLCAxIqQVRxw06xGgNxgurc5TOYvg69pkj0XE/O5stKeRTZauLzQEYScLf7+ylhMVQrrfU5bR9ADfm1+57Ie4NyeKcOjIfciFVrZGBmL4oP74F2PZEVWqhYRbX/WL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=K606U2pg; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="K606U2pg"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 4B95A6018F
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Jul 2026 16:21:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785162079;
	bh=X4wPNf9HkoERP6n2Z8Mfu7Fn67c6wRhIvOfRSv6paJw=;
	h=From:To:Subject:Date:From;
	b=K606U2pgXY5InW6ciWV4VOxCemlvHQuJsULgV1u7bwEQXfnGQoE83/LWjcpNOprWW
	 jY9hUGCTrpmHhplYbM5XGc5/AlJ5o84y7tjkstmALWg5DXTUcoZ7y9nEGqo35UOA95
	 b8VYHFgUt/eiyBbDoMFkwsm0qKACKyNneasFSUaIKohYkCb/k27X2ucouxx/uK3i2f
	 dQkrC5JIv4bOt6mDU96qvPKNRLQHnfx1fLLkXav5NM1AtS6pwzgwD6xy3kOfnOLZkp
	 VB1N6Pwg30uSQttYyuJaEfZqwHnXws52ubcNB/n1w6yev9HL8j5S7A5l15B9Aj5KN5
	 TqfbP3mq7TyAQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] mergesort: use lhs expression when sorting concatenation
Date: Mon, 27 Jul 2026 16:21:15 +0200
Message-ID: <20260727142115.96619-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Otherwise, concatenations using binary operations hit an assertion.

 # cat ruleset.nft
 table inet t {
        chain c {
                tcp flags . tcp dport vmap { syn | ack . 80 : drop, ack . 90 : accept }
        }
 }
 # nft -f ruleset.nft
 # nft list ruleset
 nft: src/mergesort.c:23: concat_expr_msort_value: Assertion `ilen > 0' failed.
 Aborted

Inspect the left-hand size of the expression for the merge sorting.

Fixes: 741a06ac15d2 ("mergesort: find base value expression type via recursion")
Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1841
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/mergesort.c | 38 ++++++++++++++++++++++++++++++++++----
 1 file changed, 34 insertions(+), 4 deletions(-)

diff --git a/src/mergesort.c b/src/mergesort.c
index 2e8ddd22f813..f4b4d56b579c 100644
--- a/src/mergesort.c
+++ b/src/mergesort.c
@@ -12,16 +12,46 @@
 #include <gmputil.h>
 #include <list.h>
 
+static mpz_srcptr concat_expr_msort_value_one(const struct expr *expr,
+					      unsigned int *i_len)
+{
+	mpz_srcptr i_value;
+
+	switch (expr->etype) {
+	case EXPR_BINOP:
+	case EXPR_MAPPING:
+	case EXPR_RANGE:
+		i_value = expr->left->value;
+		*i_len = expr->left->len;
+		break;
+	case EXPR_VALUE:
+		i_value = expr->value;
+		*i_len = expr->len;
+		break;
+	case EXPR_RANGE_VALUE:
+		i_value = expr->range.low;
+		*i_len = expr->len;
+		break;
+	default:
+		BUG("Unknown expression %s", expr_name(expr));
+	}
+
+	*i_len = div_round_up(*i_len, BITS_PER_BYTE);
+
+	return i_value;
+}
+
 static void concat_expr_msort_value(const struct expr *expr, mpz_t value)
 {
-	unsigned int len = 0, ilen;
+	unsigned int len = 0, i_len;
 	const struct expr *i;
+	mpz_srcptr i_value;
 	char data[512];
 
 	list_for_each_entry(i, &expr_concat(expr)->expressions, list) {
-		ilen = div_round_up(i->len, BITS_PER_BYTE);
-		mpz_export_data(data + len, i->value, BYTEORDER_BIG_ENDIAN, ilen);
-		len += ilen;
+		i_value = concat_expr_msort_value_one(i, &i_len);
+		mpz_export_data(data + len, i_value, BYTEORDER_BIG_ENDIAN, i_len);
+		len += i_len;
 	}
 
 	mpz_import_data(value, data, BYTEORDER_BIG_ENDIAN, len);
-- 
2.47.3

