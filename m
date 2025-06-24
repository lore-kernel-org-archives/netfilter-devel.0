Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E91EC5;
	Tue, 24 Jun 2025 01:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750728656; cv=none; b=K0wqw3nULcrBIXpuUxpebXVxrizyTtLB5N+UVOIFCnnIsxBxVWeT24QZpl01J/Zxoc0r6BHorBQdkMYTEHsG7RCgXjWr74XFRH370xyX/70EwJZuh01PZaJ4VRxWMsaUZzkgkUUlpVscIYfHjAPibE7IATeipFBlusbSllkUWn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750728656; c=relaxed/simple;
	bh=tl/e/9ymTLqHLQqs+J9fy9WBksOUWfKXz2K9IpuEdA8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=TTU+CLlZOnajxhfJm/D0J8kOclymRztPnkDKvNfLemClyOxStS7Qu8KN9CWG8d5sB5GYqmwHdWWTY8JdON02wc2PegUYFfJSfZOGYsmLgDJRdbxwjjOTeJfaG1vajyGwSDp34uHzBRkVOZT09TK4gH6hP5JibwJa9xCccM4myNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4bR6ms30VDz2TSmK;
	Tue, 24 Jun 2025 09:29:17 +0800 (CST)
Received: from dggpemf500002.china.huawei.com (unknown [7.185.36.57])
	by mail.maildlp.com (Postfix) with ESMTPS id 07149140294;
	Tue, 24 Jun 2025 09:30:53 +0800 (CST)
Received: from huawei.com (10.175.124.27) by dggpemf500002.china.huawei.com
 (7.185.36.57) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 24 Jun
 2025 09:30:51 +0800
From: Yue Haibing <yuehaibing@huawei.com>
To: <pablo@netfilter.org>, <kadlec@netfilter.org>, <davem@davemloft.net>,
	<edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<horms@kernel.org>, <fw@strlen.de>
CC: <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<yuehaibing@huawei.com>
Subject: [PATCH net-next] netfilter: nf_tables: Remove unused nft_reduce_is_readonly()
Date: Tue, 24 Jun 2025 09:48:18 +0800
Message-ID: <20250624014818.3708922-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf500002.china.huawei.com (7.185.36.57)

Since commit 9e539c5b6d9c ("netfilter: nf_tables: disable expression
reduction infra") this is unused.

Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
---
 include/net/netfilter/nf_tables.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index e4d8e451e935..8e487cd1ef7b 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1944,11 +1944,6 @@ static inline u64 nft_net_tstamp(const struct net *net)
 #define __NFT_REDUCE_READONLY	1UL
 #define NFT_REDUCE_READONLY	(void *)__NFT_REDUCE_READONLY
 
-static inline bool nft_reduce_is_readonly(const struct nft_expr *expr)
-{
-	return expr->ops->reduce == NFT_REDUCE_READONLY;
-}
-
 void nft_reg_track_update(struct nft_regs_track *track,
 			  const struct nft_expr *expr, u8 dreg, u8 len);
 void nft_reg_track_cancel(struct nft_regs_track *track, u8 dreg, u8 len);
-- 
2.34.1

