Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CD6220F079
	for <netfilter-devel@vger.kernel.org>; Fri, 14 Nov 2025 00:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763079953; cv=none; b=iHDcjMn10BWicxzFA/A44mQ2LaN5ydagQ7TK7F5m/m1wb/HYqDqWAHYMOZOGLcb9jyLBiksmCAK7nQDgcxg7OW/p1FhEQbdEVV1cpmYRRrsFQ7h+k4bvJ/zyK8VCIkYO2ad7gt8juBLNmSSR5/GFKCEMDWuitmFMClQ0y5bKa/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763079953; c=relaxed/simple;
	bh=T/YkZQM4k7vbi5s69PcPnayFXRUJb7s+o07rO6hHxr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FXJR0TEiV3KKbEf8XlAXmMe5Q8S/G77plzEdFT5xmHhyoNIYzt60w+/RRf7CCeuA3T+LACIGajIURiheOJJexMQdB/d0DR1il3v+ALWadrsfI3l5FfZuFvmBIaZQRd/vLr5mhQMfxCgS5mOk+pTqP45RIf3zBLneD8ni9XKUoX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=hPuxxJZs; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="hPuxxJZs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=vxUDUzxYx30rvQ2b/tz0G3HJI6h4fV+jw04vYZNifew=; b=hPuxxJZs7D1Ykz797J+UGoR8cw
	b5TnYNLlyWmVfj7BayZYyPQ0u+3rKJ7M9dSZKiKdOL5qu+tayzXvR062v+CI2lmyfkvJH+3SU69Z5
	k6S3u7AG1R9z6f5xh1tG1AGS+z1XEAuU4DYrrQmswtzFH4RUCI4h4LBZf1fpyDDXNHRqg4Ikq0MvK
	2pvbYyNBj0b062GHe3D0FG3sIhuzNhfse+zJIk+Y6liZvQprbbWK7BBKER/gqL1LI3Vhy2LnIGI2E
	UB2PMb4DUwob8y4erBcTiX0SV8UL+6S3gnhJQ9Nam9jFnwyuesh299OspPJS2xYr4jK/Og2wqjTcP
	xZGnwK2w==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vJhdL-000000005jh-25pb;
	Fri, 14 Nov 2025 01:25:48 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH v2 07/11] netlink: Introduce struct nft_data_linearize::sizes
Date: Fri, 14 Nov 2025 01:25:38 +0100
Message-ID: <20251114002542.22667-8-phil@nwl.cc>
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
index 3a512753c7624..d81cfccb6c6aa 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -382,7 +382,7 @@ static void netlink_gen_concat_key(const struct expr *expr,
 		if (byteorder == BYTEORDER_HOST_ENDIAN &&
 		    expr_basetype(i)->type != TYPE_STRING)
 			nld->byteorder |= 1 << n;
-		n++;
+		nld->sizes[n++] = div_round_up(i->len, BITS_PER_BYTE);
 	}
 
 	nft_data_memcpy(nld, data, len);
@@ -452,7 +452,7 @@ static void __netlink_gen_concat_expand(const struct expr *expr,
 		if (i->byteorder == BYTEORDER_HOST_ENDIAN &&
 		    expr_basetype(i)->type != TYPE_STRING)
 			nld->byteorder |= 1 << n;
-		n++;
+		nld->sizes[n++] = div_round_up(i->len, BITS_PER_BYTE);
 	}
 
 	list_for_each_entry(i, &expr_concat(expr)->expressions, list) {
@@ -460,7 +460,7 @@ static void __netlink_gen_concat_expand(const struct expr *expr,
 		if (i->byteorder == BYTEORDER_HOST_ENDIAN &&
 		    expr_basetype(i)->type != TYPE_STRING)
 			nld->byteorder |= 1 << n;
-		n++;
+		nld->sizes[n++] = div_round_up(i->len, BITS_PER_BYTE);
 	}
 
 	nft_data_memcpy(nld, data, len);
@@ -485,7 +485,7 @@ static void __netlink_gen_concat(const struct expr *expr,
 		if (i->byteorder == BYTEORDER_HOST_ENDIAN &&
 		    expr_basetype(i)->type != TYPE_STRING)
 			nld->byteorder |= 1 << n;
-		n++;
+		nld->sizes[n++] = div_round_up(i->len, BITS_PER_BYTE);
 	}
 
 	nft_data_memcpy(nld, data, len);
@@ -563,6 +563,8 @@ static void netlink_gen_range(const struct expr *expr,
 	offset = netlink_export_pad(data, expr->left->value, expr->left);
 	netlink_export_pad(data + offset, expr->right->value, expr->right);
 	nft_data_memcpy(nld, data, len);
+	nld->sizes[0] = div_round_up(expr->left->len, BITS_PER_BYTE);
+	nld->sizes[1] = div_round_up(expr->right->len, BITS_PER_BYTE);
 }
 
 static void netlink_gen_range_value(const struct expr *expr,
@@ -579,6 +581,8 @@ static void netlink_gen_range_value(const struct expr *expr,
 	offset = netlink_export_pad(data, expr->range.low, expr);
 	netlink_export_pad(data + offset, expr->range.high, expr);
 	nft_data_memcpy(nld, data, len);
+	nld->sizes[0] = div_round_up(expr->len, BITS_PER_BYTE);
+	nld->sizes[1] = nld->sizes[0];
 }
 
 static void netlink_gen_prefix(const struct expr *expr,
@@ -599,6 +603,8 @@ static void netlink_gen_prefix(const struct expr *expr,
 	mpz_clear(v);
 
 	nft_data_memcpy(nld, data, len);
+	nld->sizes[0] = div_round_up(expr->prefix->len, BITS_PER_BYTE);
+	nld->sizes[1] = nld->sizes[0];
 }
 
 static void netlink_gen_key(const struct expr *expr,
-- 
2.51.0

