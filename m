Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 662C52BD590
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Oct 2025 16:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761236092; cv=none; b=hgiM/yO6JA6om+tD4wFzBKQrtANoBPLPxFoQ6ONqse/wpkMcxeU96nkoNjn/pHrEuORBT31gxHkagCCOJ0M4gumgArMHxPPy1aVslIbuBk+Mw5brxXFa+OJEXBw/LTH3EUBaeJaRziiX2UMwNQ1BG7Euj6z/fUU8yhkBNMktCuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761236092; c=relaxed/simple;
	bh=9G0uI0b/wiPl9fivcR6OlQ+rbY9t0tNQuHcWuT3MCwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iPwC+ahzTa7MMum8hI7ewZROPgHZEE1Tpwz34NArVBhf2nYaAjKmaUA8ELcO2zcND81F+Om2me480L8CgW7Rm06kOCKSBistbHpX2tQMv77fvsR5t29sLd71W28gvUbEzSFNDWbRCv7gvetm8YZiA8ldDvCLxDH9fPjEHX/4i5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Iv2c5/ma; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Iv2c5/ma"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=/v5JpIf26A0Ko39ZHzmFn3XvEm5fq4TFvzjd4iyvnNQ=; b=Iv2c5/mavhFwx5g/yI/zDIty4L
	HG7c4RU+/od/irxe5sK6hDP760LE3o5h4tQHzQkmJRjdbkpsfMKyJfZvyQq0cAb/cX7sV5/rTtkBm
	E1iIw2fwx3Wchz8uCV6xTAqcQ7DWl4mX3KIU2d6zVUR23Euq23vUGrHT0qkyQgHMjSqBoCQA0W/b6
	XYv4KgBzhgQTzrlRvfBDOHWbmdx0rJC6DB1Ffom/dseFxFTTuppLbY4E8VBaZURq9AoYvBb+z8r8Z
	O+8esOs8mBRGZR/eaSP8LICsObb4eGacAVtlvE6I0ppWRoqv9ZvpFWre6jBhI0jhLnGy0TLV8pAKD
	kX2G1iOw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vBxxh-00000000079-1xn2;
	Thu, 23 Oct 2025 18:14:49 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 19/28] netlink: Introduce struct nft_data_linearize::byteorder
Date: Thu, 23 Oct 2025 18:14:08 +0200
Message-ID: <20251023161417.13228-20-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251023161417.13228-1-phil@nwl.cc>
References: <20251023161417.13228-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Bits in this field indicate data is in host byte order and thus may need
conversion when being printed "byte by byte" in libnftnl.

With regular immediate values, this field's value may be treated as
boolean (zero or not). Concatenations may contain components in
different byteorder, so with them each bit (at pos N) indicates whether
a component (at index N) is in host byte order. A follow-up patch
collecting components' lengths will complete this.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/netlink.h |  1 +
 src/netlink.c     | 28 ++++++++++++++++++++++++----
 2 files changed, 25 insertions(+), 4 deletions(-)

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
index 3228747a74af8..2a4315c691059 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -248,6 +248,7 @@ void netlink_gen_raw_data(const mpz_t value, enum byteorder byteorder,
 	assert(len > 0);
 	mpz_export_data(data->value, value, byteorder, len);
 	data->len = len;
+	data->byteorder = byteorder == BYTEORDER_HOST_ENDIAN ? UINT32_MAX : 0;
 }
 
 static int netlink_export_pad(unsigned char *data, const mpz_t v,
@@ -353,14 +354,19 @@ static void netlink_gen_concat_key(const struct expr *expr,
 	unsigned char data[NFT_MAX_EXPR_LEN_BYTES];
 	unsigned int offset = 0;
 	const struct expr *i;
+	int n = 0;
 
 	if (len > sizeof(data))
 		BUG("Value export of %u bytes would overflow", len);
 
 	memset(data, 0, sizeof(data));
 
-	list_for_each_entry(i, &expr_concat(expr)->expressions, list)
+	list_for_each_entry(i, &expr_concat(expr)->expressions, list) {
 		offset += __netlink_gen_concat_key(expr->flags, i, data + offset);
+		if (i->byteorder == BYTEORDER_HOST_ENDIAN)
+			nld->byteorder |= 1 << n;
+		n++;
+	}
 
 	nft_data_memcpy(nld, data, len);
 }
@@ -417,17 +423,26 @@ static void __netlink_gen_concat_expand(const struct expr *expr,
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
+		if (i->byteorder == BYTEORDER_HOST_ENDIAN)
+			nld->byteorder |= 1 << n;
+		n++;
+	}
 
-	list_for_each_entry(i, &expr_concat(expr)->expressions, list)
+	list_for_each_entry(i, &expr_concat(expr)->expressions, list) {
 		offset += __netlink_gen_concat_data(true, i, data + offset);
+		if (i->byteorder == BYTEORDER_HOST_ENDIAN)
+			nld->byteorder |= 1 << n;
+		n++;
+	}
 
 	nft_data_memcpy(nld, data, len);
 }
@@ -439,14 +454,19 @@ static void __netlink_gen_concat(const struct expr *expr,
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
+		if (i->byteorder == BYTEORDER_HOST_ENDIAN)
+			nld->byteorder |= 1 << n;
+		n++;
+	}
 
 	nft_data_memcpy(nld, data, len);
 }
-- 
2.51.0

