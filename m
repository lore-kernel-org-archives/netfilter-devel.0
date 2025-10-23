Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD71026ED5A
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Oct 2025 16:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761236067; cv=none; b=ccjitI9zmhprrNRuz6iULbolIjGN8loSR9sZApML6LRoyzZ9RYKSO1yJnG2fcpGri8EzTMhKxg+I680YFTkpLUplrVQHHyEKzVPzdEN6BcZA7aXUPAQB0wDWkyz6bzAj9xHHYWIFdG9ckB4+UfaDIuQuXNUrhAjL1w/knEXtt5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761236067; c=relaxed/simple;
	bh=EHatGNXkiutgmDt6yC4bBFQMSecVo+pmQP1s8Dvj2H8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eAKfvx8E7A3w/IEEsQXM67blhMOqUjO8vURvY2jxbQaKJ42TxPlPfSkVKQWshTDOHF7VZoShIZnemqxOf7azq5XzGGRdz/LjwtpKK/laYpi1Qk9VEKjnyDniG7gY+J+IouASvLKlrcA2SAtxmzwGEkUGDM9mGolHwsHKazYofMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=STZrcFF1; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="STZrcFF1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=kfxmGVYpwoHAUU2FiitIYsjKOg1A6fGOTiyzitnGgiI=; b=STZrcFF124DwwbWiOTsTV5QwJe
	BaNWE14zLg4PjI+ZXybXTcyS7Qwjg0cIbW98tb/EWaslgYNvAdqUmsysRAExUU6FIqLUXUAnaewSI
	d2D0rIXvPPsnDYxZkOPaMNmb416evtnsO5aiPerh/vp223taplZlIfn2faExCunzgWGpGz3s/9oZu
	l6TQ3RrNL43CUzpHVSxLTJZn3rKbEqjMIPDz4KGCUnBMNpGi4eZGYn9qKY7zp/jqs1KTF3Q8BxlAq
	CPU3Z5co4CBDwU7OLTreJHyXnnfHTlB/2YSHlz4R5Px/+VQ/h1ibb46QOIFipTxig4Lg0dI7rUpaf
	MRYrYDLw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vBxxH-000000008WV-2cIB;
	Thu, 23 Oct 2025 18:14:23 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 20/28] netlink: Introduce struct nft_data_linearize::sizes
Date: Thu, 23 Oct 2025 18:14:09 +0200
Message-ID: <20251023161417.13228-21-phil@nwl.cc>
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

This array holds each concat component's actual length in bytes. It is
crucial because component data is padded to match register lengths and
if libnftnl has to print data "in reverse" (to print Little Endian
values byte-by-byte), it will print extra leading zeroes with odd data
lengths and thus indicate number of printed bytes does no longer
correctly reflect actual data length.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/netlink.h |  1 +
 src/netlink.c     | 14 ++++++++++----
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/include/netlink.h b/include/netlink.h
index a762cb485784f..aa25094dc7c1d 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -107,6 +107,7 @@ struct nft_data_linearize {
 	uint32_t	chain_id;
 	int		verdict;
 	uint32_t	byteorder;
+	uint8_t		sizes[NFT_REG32_COUNT];
 };
 
 struct nft_data_delinearize {
diff --git a/src/netlink.c b/src/netlink.c
index 2a4315c691059..9d6cc31e40fb5 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -365,7 +365,7 @@ static void netlink_gen_concat_key(const struct expr *expr,
 		offset += __netlink_gen_concat_key(expr->flags, i, data + offset);
 		if (i->byteorder == BYTEORDER_HOST_ENDIAN)
 			nld->byteorder |= 1 << n;
-		n++;
+		nld->sizes[n++] = div_round_up(i->len, BITS_PER_BYTE);
 	}
 
 	nft_data_memcpy(nld, data, len);
@@ -434,14 +434,14 @@ static void __netlink_gen_concat_expand(const struct expr *expr,
 		offset += __netlink_gen_concat_data(false, i, data + offset);
 		if (i->byteorder == BYTEORDER_HOST_ENDIAN)
 			nld->byteorder |= 1 << n;
-		n++;
+		nld->sizes[n++] = div_round_up(i->len, BITS_PER_BYTE);
 	}
 
 	list_for_each_entry(i, &expr_concat(expr)->expressions, list) {
 		offset += __netlink_gen_concat_data(true, i, data + offset);
 		if (i->byteorder == BYTEORDER_HOST_ENDIAN)
 			nld->byteorder |= 1 << n;
-		n++;
+		nld->sizes[n++] = div_round_up(i->len, BITS_PER_BYTE);
 	}
 
 	nft_data_memcpy(nld, data, len);
@@ -465,7 +465,7 @@ static void __netlink_gen_concat(const struct expr *expr,
 		offset += __netlink_gen_concat_data(expr->flags, i, data + offset);
 		if (i->byteorder == BYTEORDER_HOST_ENDIAN)
 			nld->byteorder |= 1 << n;
-		n++;
+		nld->sizes[n++] = div_round_up(i->len, BITS_PER_BYTE);
 	}
 
 	nft_data_memcpy(nld, data, len);
@@ -541,6 +541,8 @@ static void netlink_gen_range(const struct expr *expr,
 	offset = netlink_export_pad(data, expr->left->value, expr->left);
 	netlink_export_pad(data + offset, expr->right->value, expr->right);
 	nft_data_memcpy(nld, data, len);
+	nld->sizes[0] = div_round_up(expr->left->len, BITS_PER_BYTE);
+	nld->sizes[1] = div_round_up(expr->right->len, BITS_PER_BYTE);
 }
 
 static void netlink_gen_range_value(const struct expr *expr,
@@ -557,6 +559,8 @@ static void netlink_gen_range_value(const struct expr *expr,
 	offset = netlink_export_pad(data, expr->range.low, expr);
 	netlink_export_pad(data + offset, expr->range.high, expr);
 	nft_data_memcpy(nld, data, len);
+	nld->sizes[0] = div_round_up(expr->len, BITS_PER_BYTE);
+	nld->sizes[1] = nld->sizes[0];
 }
 
 static void netlink_gen_prefix(const struct expr *expr,
@@ -577,6 +581,8 @@ static void netlink_gen_prefix(const struct expr *expr,
 	mpz_clear(v);
 
 	nft_data_memcpy(nld, data, len);
+	nld->sizes[0] = div_round_up(expr->prefix->len, BITS_PER_BYTE);
+	nld->sizes[1] = nld->sizes[0];
 }
 
 static void netlink_gen_key(const struct expr *expr,
-- 
2.51.0

