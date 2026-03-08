Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7913221FB1
	for <netfilter-devel@vger.kernel.org>; Sun,  8 Mar 2026 11:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772969027; cv=none; b=VdexYalyujlzUJMGihUeEXDA593tsxS7Z1DAN6FGW+oW4uF5M7CY0pHZz2dV7ayfgjRbpvNG+3Zj66afJxC/6VRoKtUcbzvkTNMDoRsqpCsbyW82w9l0Qr+PXdm3taCCUnZpthC9A5fZE5xSeCZkqAcXA3M7MboxK+J1ZTBX8yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772969027; c=relaxed/simple;
	bh=IRZJHQNUtg3dTYHRDxM9KcGkLAfDsGjZjBlcvVrkRrE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Z6LYUPS5e/u4IIcnYDxVrwAgCgPIkIFQTmk2Pv23sKL3sQlgbPU0NiHJX+MCbg0Q1nFOOUSdyC+FM1R9t+xpkQVBKaEVutqFZlVeuKxucrb2uhepg0utJgFL5yj5PIqJjPk8o46HRjQE1HrUfbIHLSUHOoAKT2p63sD9Wv9O7D0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=T8DSWQmp; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="T8DSWQmp"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C8F93603A9;
	Sun,  8 Mar 2026 12:23:44 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1772969025;
	bh=DnbPxitneLw6XIf1D609DIXxYN591GRpjV7Wbym8FC0=;
	h=From:To:Cc:Subject:Date:From;
	b=T8DSWQmpIzRFgV9IxQHpn6zmsc6c6ii71UV1JQTexqfTgFbf69Fl7//JM5Pz6AU46
	 H0iO8CR+0YbXimIMgPvwDSvBga6Sgm1HosAXDSBvBXgMn5Z0dJMwlFc2L9lK97jUf8
	 zIrRwdM/T+hkz0VAJ/mCmstRboczFKBMTjy2gSGQiRaajXviG51R5LyXeDHcBFHyrV
	 +UYoPOWxC/y4pdvREv8+Ph20cul2YJ4VXAfDDCgXOw7x2RteFFB88qOPrazl4VjBLg
	 Al43+9DROrOh7CVtcw/9vh+c39WrCKo0tWJanwVecXMqQrHHxC+6XcgQfsKnV3WfGJ
	 RoZJS/S8+O6FQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de,
	moderador@gmail.com
Subject: [PATCH nf,v2] netfilter: nft_set_rbtree: allocate same array size on updates
Date: Sun,  8 Mar 2026 12:23:41 +0100
Message-ID: <20260308112341.2945020-1-pablo@netfilter.org>
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

