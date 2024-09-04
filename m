Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDBD31CCB24;
	Wed,  4 Sep 2024 09:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725441860; cv=none; b=Tc0cmAe0HWDOliPNXCbqMiumfp63PUWsrc36dLMMBcovovGa/W2Le+V51VsRI97ZpN3HnEYHepoOYt2qkzPjHf4S6ioApLQVhRRe0Cl1Cvdp05+q2XI+vuipeBsv8eIWeqJri5IpSdkGltxq2bB0iqkxWQuFLSAllKMBWntVcPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725441860; c=relaxed/simple;
	bh=k00Rr8PAnLm6hpeAXuIGpk+PR4DwSc6jpd01legIipE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ea5/1yVZ3K2/EtBeT+raDWrE28men8PKOqPYJF0WadbcmL/NCPQzuBTfSe5HvSrVd7NtBQ0MI8ttmx1yZFXQ8/0q227qyGdhFTajES5WuQyTWA1kLb0VimcP0CgQ+VhspwvoyLDQN8k2HLTgmHtOQRBxM7aFXibPkomEePNNYog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4WzH7y3hXxzpVDL;
	Wed,  4 Sep 2024 17:22:22 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 176B8180087;
	Wed,  4 Sep 2024 17:24:15 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 4 Sep
 2024 17:24:14 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <davem@davemloft.net>, <dsahern@kernel.org>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <jmaloy@redhat.com>,
	<ying.xue@windriver.com>, <pablo@netfilter.org>, <kadlec@netfilter.org>,
	<horms@kernel.org>
CC: <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
	<lihongbo22@huawei.com>
Subject: [PATCH net-next v2 5/5] net/core: make use of the helper macro LIST_HEAD()
Date: Wed, 4 Sep 2024 17:32:43 +0800
Message-ID: <20240904093243.3345012-6-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240904093243.3345012-1-lihongbo22@huawei.com>
References: <20240904093243.3345012-1-lihongbo22@huawei.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500022.china.huawei.com (7.185.36.66)

list_head can be initialized automatically with LIST_HEAD()
instead of calling INIT_LIST_HEAD(). Here we can simplify
the code.

Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
 net/core/dev.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 05d9624f360f..b67ad9bb81a0 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5727,10 +5727,9 @@ static void __netif_receive_skb_list_core(struct list_head *head, bool pfmemallo
 	struct packet_type *pt_curr = NULL;
 	/* Current (common) orig_dev of sublist */
 	struct net_device *od_curr = NULL;
-	struct list_head sublist;
 	struct sk_buff *skb, *next;
+	LIST_HEAD(sublist);
 
-	INIT_LIST_HEAD(&sublist);
 	list_for_each_entry_safe(skb, next, head, list) {
 		struct net_device *orig_dev = skb->dev;
 		struct packet_type *pt_prev = NULL;
@@ -5868,9 +5867,8 @@ static int netif_receive_skb_internal(struct sk_buff *skb)
 void netif_receive_skb_list_internal(struct list_head *head)
 {
 	struct sk_buff *skb, *next;
-	struct list_head sublist;
+	LIST_HEAD(sublist);
 
-	INIT_LIST_HEAD(&sublist);
 	list_for_each_entry_safe(skb, next, head, list) {
 		net_timestamp_check(READ_ONCE(net_hotdata.tstamp_prequeue),
 				    skb);
-- 
2.34.1

