Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB7B1922FF;
	Wed,  4 Sep 2024 09:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725441859; cv=none; b=gT34r7hjLMR5VLm1hgiyGmzJwQJ8WP+tf6xsl9dT+C06pqCMYMdk9OGnlYmefCgmBn/WT8mln434/9IleWCJtC4usrROigeQI6paGfui4vmr5kkfW0RwwtdJaVQciYPjWH38DGc+TBItpxvNdB1zZKhgL9hgXrD6yjOLOFhXS6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725441859; c=relaxed/simple;
	bh=z7BnA7y/SFlHnNaY0c0eZ4Genmmv6eyqmc0k7ibxFKA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X7N7yGG26bBlAzIH//hN4QDjM57MJKcAzoq17WKvh1Ud45ggPuq1l67A8aZK3Sb6YbVj/M7SE4cgI7AtTkIGaKF6HjPnIPrCkDOfdP4bXp9m1WYnCsfv2PyTYHl5oXA9Yf/L9oERO5j1V99BUWVZlwPRhv6rJIapTXJHT5fTqBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4WzH7g3N8GzgYry;
	Wed,  4 Sep 2024 17:22:07 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id A8FC1180087;
	Wed,  4 Sep 2024 17:24:14 +0800 (CST)
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
Subject: [PATCH net-next v2 3/5] net/netfilter: make use of the helper macro LIST_HEAD()
Date: Wed, 4 Sep 2024 17:32:41 +0800
Message-ID: <20240904093243.3345012-4-lihongbo22@huawei.com>
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
v2:
  - Keep the reverse xmas tree order as Pablo's suggested.

v1: https://lore.kernel.org/netdev/20240827165723.GQ1368797@kernel.org/T/#ma8c13d915dce14e01b66c03fd7c2588344596ac8
---
 net/netfilter/core.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index b00fc285b334..b9f551f02c81 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -655,11 +655,9 @@ void nf_hook_slow_list(struct list_head *head, struct nf_hook_state *state,
 		       const struct nf_hook_entries *e)
 {
 	struct sk_buff *skb, *next;
-	struct list_head sublist;
+	LIST_HEAD(sublist);
 	int ret;
 
-	INIT_LIST_HEAD(&sublist);
-
 	list_for_each_entry_safe(skb, next, head, list) {
 		skb_list_del_init(skb);
 		ret = nf_hook_slow(skb, state, e, 0);
-- 
2.34.1

