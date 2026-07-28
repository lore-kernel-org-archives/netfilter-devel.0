Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF6F3A7F7A
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Jul 2026 12:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785241592; cv=none; b=s59270EhuEuP1rOduL9BPo/XvvOsNxVgTJeC6lasChDfF3ncHOLLadqNbHvdgopUM/vkU/2IF48EFf1FKJO6A3IvHiv/Q5/2PSpwxux8C7QbjP9FNycq5p6krLvDy3zkRvWlL4McJpFqFtfEqG3ovlCuHBAySl9lJEkbl5L/qKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785241592; c=relaxed/simple;
	bh=yZ+uKGAwgGkzbrxYDyPJOSwjXgU8XCYGcPS3YhcVwd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IM7T03XoMK+Dr0oDIOrrUroXf/2T9E5zDsI8XMnvC6EgfTByNqnZkK/ssb1O0TI5qrgHBgaTCiBfCuGoer3TjUVu2qJF5C1v848sKJA7cE5tBcDr8KJ8qRj6cFDj+EBtu//zMnoYhFSqMOQTqIaAvaBosJ8krV+wRhQyeDIgMNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ZYlDf+B7; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ZYlDf+B7"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 83671601A3;
	Tue, 28 Jul 2026 14:26:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785241582;
	bh=tybHXbbv6LRIVfpdMGZkx8rXw7Yix93POeR9Bf4NxS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZYlDf+B7JCT0J4Cd6gZcqZV4T/BrIJnbYTYqDdvwvnUHPhvL+iSCKGDh25itIxy99
	 I2EYW+NSqfjV+wsw1eMe51GwlaRFkmiTeTvG1iw8RdNGoKfwD5fwwYO/Y7UxWcp0Or
	 qQ5Vav80P+mMqUsKzITS9sjzbquFBUsXHu7NzN43HpyCECfsC6BPLEZhfdnyk+jJoA
	 RL3p+K0F8RzYtm0/3EufVHrTr/+hA70E00SaJr8i+maRDX9d/vaqucW95qHJxwGp3w
	 DluVH/euRQQm5m7GQVHyF1pvR3AQM76Dh6m9cxOWhB+25dwaK2BScvnnFaZbQuAR4E
	 A8g0TatHNPHzw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: lorenzo@kernel.org
Subject: [PATCH nf-next,v4 2/5] netfilter: flowtable: consolidate flowtable device check
Date: Tue, 28 Jul 2026 14:26:12 +0200
Message-ID: <20260728122615.142843-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260728122615.142843-1-pablo@netfilter.org>
References: <20260728122615.142843-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Check that device belongs to the flowtable right after the flowtable
discovery path. This is a preparation patch to obtain the dst entry
from the .fill_forward_path in tunnels.

No functional changes are intended.

Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v4: no changes

 net/netfilter/nf_flow_table_path.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
index 261bb44d08eb..8f04a4487897 100644
--- a/net/netfilter/nf_flow_table_path.c
+++ b/net/netfilter/nf_flow_table_path.c
@@ -90,9 +90,12 @@ struct nft_forward_info {
 	enum flow_offload_xmit_type xmit_type;
 };
 
+static bool nft_flowtable_find_dev(const struct net_device *dev,
+				   struct nft_flowtable *ft);
+
 static int nft_dev_path_info(const struct net_device_path_stack *stack,
 			     struct nft_forward_info *info,
-			     unsigned char *ha, struct nf_flowtable *flowtable)
+			     unsigned char *ha, struct nft_flowtable *ft)
 {
 	const struct net_device_path *path;
 	int i;
@@ -178,10 +181,13 @@ static int nft_dev_path_info(const struct net_device_path_stack *stack,
 		}
 	}
 
-	if (nf_flowtable_hw_offload(flowtable) &&
+	if (nf_flowtable_hw_offload(&ft->data) &&
 	    nft_is_valid_ether_device(info->dev))
 		info->xmit_type = FLOW_OFFLOAD_XMIT_DIRECT;
 
+	if (!nft_flowtable_find_dev(info->dev, ft))
+		return -1;
+
 	return 0;
 }
 
@@ -253,10 +259,7 @@ static int nft_dev_forward_path(const struct nft_pktinfo *pkt,
 	int i;
 
 	if (nft_dev_fill_forward_path(dst, ct, dir, ha, &stack) < 0 ||
-	    nft_dev_path_info(&stack, &info, ha, &ft->data) < 0)
-		return -ENOENT;
-
-	if (!nft_flowtable_find_dev(info.dev, ft))
+	    nft_dev_path_info(&stack, &info, ha, ft) < 0)
 		return -ENOENT;
 
 	route->tuple[!dir].in.ifindex = info.dev->ifindex;
-- 
2.47.3

