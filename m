Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D666233F58F
	for <netfilter-devel@vger.kernel.org>; Tue, 21 Apr 2026 18:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776795425; cv=none; b=VJwa+w0wL3ziG48EYMl5KMy3i/EOOZKkIwc3fL7dCWHJM4R6WM48eCAeTEtjjmrm/ek1z08jarULk6YnLVUxlRPvyqxTlIcYHE6zRhBc3b5xhTvoZ6L7jP7YZ7YB74nswmegA0I+PUAt2WXUfrjyIN3Cb7tWkw511xAMbUJ58kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776795425; c=relaxed/simple;
	bh=RcAN/eLCTL8guNAWedrr7mJtFw/4Y9jyEnrhSk3LlyA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B0MnSfk5nULUnfSdLzlSUFq5YuqIaVFOQF/xEmIDmbuQSdw9gEdaAeI42nmOgjevjrYL95fkQVcXlYHpSRESu7RA3/L9a3hI0zz4nOUtDer4Ax2ntjsMIIAFGx51aQKEgVMYG5IlAkIKCXaLzwmlqSoMFVD+m7reQzLvj7wI8cY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=lWEu2HYL; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="lWEu2HYL"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 2DB7060180
	for <netfilter-devel@vger.kernel.org>; Tue, 21 Apr 2026 20:16:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776795417;
	bh=20toHvYiNKFFsmdx05iKk2JwGo18/a6uVUp9Z06WT0Y=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=lWEu2HYLtd5Hk3drIJTdcvtjLJ0OUFOlkklTfS4QSvo+UoqpNn7woEtXN9dVnk/zF
	 Hly2SVbl8481o/KINbrZeNSDpX6VSBUOCrYfU0vtqgdXCC8EONoMf8zhwtXezDA6i3
	 1f5l/3ZiunJh+W1jO6cHXlydvKq8PnXjf36sZqtZZK+5CLzG98K7ssXjOVfZkbqRoX
	 PrU/eMEaxV/PvcDVQQbrphQ7bnv29O6OyKPwa1G6Y1GU9y4l6jOXnCFmTxfQH+7jw+
	 Wh0TNzf9dPLu3KeIg0QJnKWDuRWQfpo5+lwhCOKXH+MGam7FmvxiHIsFLzavco5rwM
	 CY/EcX5KHqBoA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf 2/3] netfilter: nft_fwd_netdev: drop packet if no device found when forwarding via neigh
Date: Tue, 21 Apr 2026 20:16:51 +0200
Message-ID: <20260421181652.161719-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260421181652.161719-1-pablo@netfilter.org>
References: <20260421181652.161719-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The ttl field has been decremented already and evaluate of this rule
would proceed, just drop this packet instead if there is no destination
device to forwards this packet. This is exactly what nf_dup already does
in this case.

Fixes: d32de98ea70f ("netfilter: nft_fwd_netdev: allow to forward packets via neighbour layer")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_fwd_netdev.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
index 0bc0cf194849..8b6394660d1b 100644
--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -152,8 +152,10 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
 	}
 
 	dev = dev_get_by_index_rcu(nft_net(pkt), oif);
-	if (dev == NULL)
-		return;
+	if (dev == NULL) {
+		verdict = NF_DROP;
+		goto out;
+	}
 
 	skb->dev = dev;
 	skb_clear_tstamp(skb);
-- 
2.47.3

