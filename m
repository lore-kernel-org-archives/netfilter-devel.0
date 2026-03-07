Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE99A13DDAA
	for <netfilter-devel@vger.kernel.org>; Sat,  7 Mar 2026 00:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772842292; cv=none; b=hE/7F2MUSVJ0IPJ4u4+fF4d7TPjy05n+Iop4Gvrkx6RoECAa+i5w7qEIKEQEXLblETtNVfiBxkWjVTP59Bb9T0G8P0f2QHnrbhHD2KMhX0HyibpiUWcKKJbYWUc1smfmKXRENnupfJU3su8/9R2i1/tgeC+pQP7Iat7FaKheyJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772842292; c=relaxed/simple;
	bh=IRZJHQNUtg3dTYHRDxM9KcGkLAfDsGjZjBlcvVrkRrE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cfp2ER6NPXz9e7Fn096si6Lhv745GR+svWHnWpdyqoE7nxPa+P5wlbDpXXMF0RooG+8W53gudDbEvTMTb2YSqavWMW2hq4Tf612qnV8zOnH81f9RyHnPLe6GdPoqBbIVKRk6J66kqgW/m21Wi6BHziXu7eHfquE8G8DKRwd/kik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=FU/GNJ13; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="FU/GNJ13"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B591860287;
	Sat,  7 Mar 2026 01:11:28 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1772842288;
	bh=DnbPxitneLw6XIf1D609DIXxYN591GRpjV7Wbym8FC0=;
	h=From:To:Cc:Subject:Date:From;
	b=FU/GNJ134pNnyvL8HMpTLao4xgSXVDx3Lsh+0q/d4vet6iCZ6V3kebSoH9lBSxDrs
	 O9ga3if2wkfPuqmi8AOwoy61eYEBcMF7Xg0lFZt0vxkxpYsCmR9DGkWka5DBSnLyFR
	 sWw+eW1WwL+VKO3FIbMLzm5oM3MV7TThcDPBkk9y2W6hRqWv/eSNykbxaPYfWTGZQs
	 5OjArkZWjKib43djkhTDPdhMldpsYHXz8rJlp58Lwgj2HKg5ud0os+evD1dQYLFcj6
	 qaDUj/ASp9WSxkQbJTffZS+B4b5MTLNbB19gqOcjcxRA97EP2F/qaUaN04r+Q9iLf4
	 NoZ28iMplv3Ug==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de,
	carges@cloudflare.com
Subject: [PATCH nf,v2] netfilter: nft_set_rbtree: allocate same array size on updates
Date: Sat,  7 Mar 2026 01:11:24 +0100
Message-ID: <20260307001124.2897063-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The array resize function increments the size of the array in
NFT_ARRAY_EXTRA_SIZE slots for each update, this is unnecesarily
increasing the array size.

To determine the number of array slots:

- Use NFT_ARRAY_EXTRA_SIZE for new sets.
- Use the current maximum number of intervals in the live array.

Reported-by: Chris Arges <carges@cloudflare.com>
Fixes: 7e43e0a1141d ("netfilter: nft_set_rbtree: translate rbtree to array for binary search")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: fix crash with new sets, reported by Florian.

 net/netfilter/nft_set_rbtree.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 853ff30a208c..bdcea649467f 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -646,7 +646,12 @@ static int nft_array_may_resize(const struct nft_set *set)
 	struct nft_array *array;
 
 	if (!priv->array_next) {
-		array = nft_array_alloc(nelems + NFT_ARRAY_EXTRA_SIZE);
+		if (priv->array)
+			new_max_intervals = priv->array->max_intervals;
+		else
+			new_max_intervals = NFT_ARRAY_EXTRA_SIZE;
+
+		array = nft_array_alloc(new_max_intervals);
 		if (!array)
 			return -ENOMEM;
 
-- 
2.47.3

