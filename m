Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F3B396591
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jul 2026 17:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784829003; cv=none; b=ti4R/YdfHvUBzMEh+lUm59yo0/oVXKtV+sE+hOZzsRhSxEWIFFWZm4d0njpHu3AnO2vCRLqazAZ9TtioQ7WAGgh/mSl9Lt+RRBFqQkjYw5Oz4xlxXn4Pw430swZO7IXn19gQh35uXk/qE8RhnIfnxTmX4hfOcqotjhZygAu9Ock=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784829003; c=relaxed/simple;
	bh=O1AspusXeTBhRNHbXZUqSp03kFicQWIHEQWL1PZBli4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OnnoTth4lyFqQb1UzF3XOhdNTnwufhIiD3ecQcRT7X4coOcES3+ay4mZpsnfJDqRLUMJkCFG516l+hWtnqG3gKBTUbDNe6ioMkUZwAViLYTo5D2O/FUTR4F7GKFvmhX/d4hAW3aqoA6LkVDng8r51RS6v6y2ebb8lUTX7wz8p+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=WpQSz4Mg; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="WpQSz4Mg"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 2CA486019D;
	Thu, 23 Jul 2026 19:49:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1784828999;
	bh=/u+QEIAEHl5F7iK579VojfSAk0QlU14PsuvS7CiAQGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WpQSz4MgF7vuESbs+v6ox4WDFP+zb6CvhY6FwXhPqXIdic7G+HBNB8aS++EDjtSUp
	 w3lTaa+p1lsCYsxt602MFTr11IDSVhUf1jvLlvC6WAha+9mQ03C67zPy8JyAmdKwgd
	 aQ3FrocIx5n985bQWTPbQjj3YGgk/lsHjdVlaZ0nnP3W7JFBYoZy02igHYh8ddXV/q
	 LK8L7LYFN0iRLs2kwLaT2vxl+UP9gnT19pyKOjR9rrJ79BVts31p3FA0IrB6CQQRWC
	 cLJvp75sMzyhAARPBjOsZ0JWklTGrLfc7/i5Av6hF1SqvG/ar+qBHsynlyLzDXCxqo
	 XGViyUCTyTYbA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: lorenzo@kernel.org
Subject: [PATCH nf-next 2/4] netfilter: flowtable: consolidate flowtable device check
Date: Thu, 23 Jul 2026 19:49:50 +0200
Message-ID: <20260723174952.329650-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260723174952.329650-1-pablo@netfilter.org>
References: <20260723174952.329650-1-pablo@netfilter.org>
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

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
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

