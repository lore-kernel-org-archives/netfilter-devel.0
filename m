Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352C82F5A36
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Jan 2026 19:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769716630; cv=none; b=isfETiTBMxQS+T3ptP9pH258r12e24Gjkjw+/G8kU1Vy49yQWZHmvMS8NjUDxUHFggRDjaVBFTxUuT0KvOvqwc7Axi4HNzWzhS7tHERqq44n4PbSAfSyZTNznPY8UalmKgA+zcJL8WAr8H7C+opsRxHhCno327GsvZREE4d3HlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769716630; c=relaxed/simple;
	bh=jsrAaXYLcFrpuYE1zbY9TUR+MxXqy8GQzCTWEadhkIc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jVYZJIJitAoCC3PrleeXgIBvp7UV4RTMYETwPV8x9oHXT88M6ghCxKAXxwMTajOb7gqgIRjsTrgPQQqw9ttHAqCRsAHeuXLrvBFZvectaOrJl7nRIM/vtbOZXh4V6WGOVIXUb1HfakfMiubXh4JQhpE5tJWaY8YN4vEGJ6FCCfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=FXlb3sZT; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="FXlb3sZT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=DpjDQ+wkxyioJ3MsJc5nphL0iukZkzU+qFCHBpslGjo=; b=FXlb3sZT4HPLZkOdrIkQmp2Bhk
	mqgWP0kOzIdAqI1s4BHX4OTuJZx7nbAI3B3+6XTJPbaPfyZwsGmu59NXkDPnPEezZ+Sjk8lfC4LcN
	TXd8lWXoYk0cp+DmraNiIxAwytfAIcA9r57ZgRDkGcvrem4aC+DmKJitMuQMv9QlkLZMW1T/yQUh/
	AKlND3LWx98xi3PcYXAu7rWrxVulGVn73fr6GaxuVR44VIpt+kkFP4xcIyeqsIPHAJFfYc3zMKMrl
	fEyBfDcVpsJtlxLnuvi1tr4+CSorQpRK+PtHhfp5qOO3DH9WFdaAJZGo/h+TrqNZpz3TVy/3REEaA
	3v2uv0YQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1vlY8Y-000000000TZ-0k8o;
	Thu, 29 Jan 2026 20:57:06 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>
Subject: [iptables PATCH v2] ruleparse: arp: Fix for all-zero mask on Big Endian
Date: Thu, 29 Jan 2026 20:56:38 +0100
Message-ID: <20260129195700.13553-1-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With 16bit mask values, the first two bytes of bitwise.mask in struct
nft_xt_ctx_reg are significant. Reading the first 32bit-sized field
works only on Little Endian, on Big Endian the mask appears in the upper
two bytes which are discarded when assigning to a 16bit variable.

Fixes: ab2d5f8c7bbee ("nft-arp: add missing mask support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Use memcpy() to avoid gcc's -Wstrict-aliasing warning
---
 iptables/nft-ruleparse-arp.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/iptables/nft-ruleparse-arp.c b/iptables/nft-ruleparse-arp.c
index b0671cb0dfe8f..632e7ac94727c 100644
--- a/iptables/nft-ruleparse-arp.c
+++ b/iptables/nft-ruleparse-arp.c
@@ -90,7 +90,8 @@ static void nft_arp_parse_payload(struct nft_xt_ctx *ctx,
 		if (inv)
 			fw->arp.invflags |= IPT_INV_ARPHRD;
 		if (reg->bitwise.set)
-			fw->arp.arhrd_mask = reg->bitwise.mask[0];
+			memcpy(&fw->arp.arhrd_mask, reg->bitwise.mask,
+			       sizeof(fw->arp.arhrd_mask));
 		break;
 	case offsetof(struct arphdr, ar_pro):
 		get_cmp_data(e, &ar_pro, sizeof(ar_pro), &inv);
@@ -99,7 +100,8 @@ static void nft_arp_parse_payload(struct nft_xt_ctx *ctx,
 		if (inv)
 			fw->arp.invflags |= IPT_INV_PROTO;
 		if (reg->bitwise.set)
-			fw->arp.arpro_mask = reg->bitwise.mask[0];
+			memcpy(&fw->arp.arpro_mask, reg->bitwise.mask,
+			       sizeof(fw->arp.arpro_mask));
 		break;
 	case offsetof(struct arphdr, ar_op):
 		get_cmp_data(e, &ar_op, sizeof(ar_op), &inv);
@@ -108,7 +110,8 @@ static void nft_arp_parse_payload(struct nft_xt_ctx *ctx,
 		if (inv)
 			fw->arp.invflags |= IPT_INV_ARPOP;
 		if (reg->bitwise.set)
-			fw->arp.arpop_mask = reg->bitwise.mask[0];
+			memcpy(&fw->arp.arpop_mask, reg->bitwise.mask,
+			       sizeof(fw->arp.arpop_mask));
 		break;
 	case offsetof(struct arphdr, ar_hln):
 		get_cmp_data(e, &ar_hln, sizeof(ar_hln), &inv);
@@ -117,7 +120,8 @@ static void nft_arp_parse_payload(struct nft_xt_ctx *ctx,
 		if (inv)
 			fw->arp.invflags |= IPT_INV_ARPHLN;
 		if (reg->bitwise.set)
-			fw->arp.arhln_mask = reg->bitwise.mask[0];
+			memcpy(&fw->arp.arhln_mask, reg->bitwise.mask,
+			       sizeof(fw->arp.arhln_mask));
 		break;
 	case offsetof(struct arphdr, ar_pln):
 		get_cmp_data(e, &ar_pln, sizeof(ar_pln), &inv);
-- 
2.51.0

