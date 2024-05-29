Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A353D6B
	for <netfilter-devel@vger.kernel.org>; Wed, 29 May 2024 01:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716947241; cv=none; b=NuAaFIYHFjaj9fYbELfwE/BTAcloHD+7Q9CHfd99byPNABhYeiGCm3BmZ5jNhJ5WgUNNi7aefwLS/eAIDb+8B78qH3smNLbI6+YsemKcqwcI9/pNO/EBMfMQPINVSSsT1Rtga6Di6L/wAIIaoG3mLauEEuypG7Lkvle28Z7W5MQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716947241; c=relaxed/simple;
	bh=5NCgNOTmb3qMG58Wn5/ND2LJ9CqJmR6OaqD3YuPYP7o=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=EkFHuNZoj1RbuvlIHPz4N86/GWNU596M4LMMB4B3FxXnSYJEI8BVMdUJZmTpHcDU+VKF9iEckg/XPrwjCP79tQpEcgkpwZ4Ak5TSexUwRmgJ0S6C72uQhs1VhuBquJSlq4loySEtrIVqt0GomIXS4+Wv8+mVQ8Umiw7dnha4GiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4VpsfZ6V0Cz1xs32;
	Wed, 29 May 2024 09:45:58 +0800 (CST)
Received: from dggpemm500008.china.huawei.com (unknown [7.185.36.136])
	by mail.maildlp.com (Postfix) with ESMTPS id CE6881400F4;
	Wed, 29 May 2024 09:47:15 +0800 (CST)
Received: from localhost (10.174.242.157) by dggpemm500008.china.huawei.com
 (7.185.36.136) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.35; Wed, 29 May
 2024 09:47:15 +0800
From: Yunjian Wang <wangyunjian@huawei.com>
To: <netfilter-devel@vger.kernel.org>
CC: <pablo@netfilter.org>, <kadlec@netfilter.org>, <kuba@kernel.org>,
	<davem@davemloft.net>, <coreteam@netfilter.org>, <xudingke@huawei.com>,
	Yunjian Wang <wangyunjian@huawei.com>
Subject: [PATCH net] netfilter: nf_conncount: fix wrong variable type
Date: Wed, 29 May 2024 09:40:29 +0800
Message-ID: <1716946829-77508-1-git-send-email-wangyunjian@huawei.com>
X-Mailer: git-send-email 1.9.5.msysgit.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500008.china.huawei.com (7.185.36.136)

'keylen' is supposed to be unsigned int, not u8, so fix it.

Fixes: 2ba39118c10a ("netfilter: nf_conncount: Move locking into count_tree()")
Fixes: c80f10bc973a ("netfilter: nf_conncount: speculative garbage collection on empty lists")
Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
---
 net/netfilter/nf_conncount.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 8715617b02fe..4554f4b093fa 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -321,7 +321,7 @@ insert_tree(struct net *net,
 	struct nf_conncount_rb *rbconn;
 	struct nf_conncount_tuple *conn;
 	unsigned int count = 0, gc_count = 0;
-	u8 keylen = data->keylen;
+	unsigned int keylen = data->keylen;
 	bool do_gc = true;
 
 	spin_lock_bh(&nf_conncount_locks[hash]);
@@ -403,7 +403,7 @@ count_tree(struct net *net,
 	struct rb_node *parent;
 	struct nf_conncount_rb *rbconn;
 	unsigned int hash;
-	u8 keylen = data->keylen;
+	unsigned int keylen = data->keylen;
 
 	hash = jhash2(key, data->keylen, conncount_rnd) % CONNCOUNT_SLOTS;
 	root = &data->root[hash];
-- 
2.33.0

