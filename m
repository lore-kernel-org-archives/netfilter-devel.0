Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF5F157469;
	Wed, 28 Aug 2024 07:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724828537; cv=none; b=OWvK9aqajlgumArSNiyO5XpR1ySJHhzkYr/e0NlJhjIKh125POaNnHWRKze4NGYLJ7flG4+CfzVOxxH5Iyu2f2rwBEG9b30d8tLHKSzpAWXwjx8zPnDx0tDMG3qLl6RLTQ/Q2GY0lFyWX2gRxp5aybtnxJvKAOuVasx3ZfLCYz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724828537; c=relaxed/simple;
	bh=K6r6lzcghPAsZtTUPZXavYqG1W7fOtNQiqHEKMLSYgA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pavLn/3JNfiTIEjy4FqNQ3cyOOE5Z8JwoCDcNMEU2/X1upp4QBRb8UuHF8bm+yzwZQ5gKRt7GrCBE2fIwPjKt7X0e/+L1R0ibqU3+S5J0d7SXsmqh+n7THLQnfXiiZVpchqwlLb6x4ObPZRQD0Gef3xuDLO4N6UFP4QYSIfIz8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4WtwLw1m0KzyR4b;
	Wed, 28 Aug 2024 15:01:44 +0800 (CST)
Received: from kwepemh500013.china.huawei.com (unknown [7.202.181.146])
	by mail.maildlp.com (Postfix) with ESMTPS id 6459F180106;
	Wed, 28 Aug 2024 15:02:14 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemh500013.china.huawei.com
 (7.202.181.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 28 Aug
 2024 15:02:13 +0800
From: Jinjie Ruan <ruanjinjie@huawei.com>
To: <pablo@netfilter.org>, <kadlec@netfilter.org>, <roopa@nvidia.com>,
	<razor@blackwall.org>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <dsahern@kernel.org>,
	<krzk@kernel.org>, <netfilter-devel@vger.kernel.org>,
	<coreteam@netfilter.org>, <bridge@lists.linux.dev>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <ruanjinjie@huawei.com>
Subject: [PATCH -next 5/5] netfilter: nf_nat: Use kmemdup_array() instead of kmemdup() for multiple allocation
Date: Wed, 28 Aug 2024 15:10:04 +0800
Message-ID: <20240828071004.1245213-6-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240828071004.1245213-1-ruanjinjie@huawei.com>
References: <20240828071004.1245213-1-ruanjinjie@huawei.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemh500013.china.huawei.com (7.202.181.146)

Let the kmemdup_array() take care about multiplication and possible
overflows.

Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 net/netfilter/nf_nat_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 016c816d91cb..6d8da6dddf99 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -1104,7 +1104,7 @@ int nf_nat_register_fn(struct net *net, u8 pf, const struct nf_hook_ops *ops,
 	if (!nat_proto_net->nat_hook_ops) {
 		WARN_ON(nat_proto_net->users != 0);
 
-		nat_ops = kmemdup(orig_nat_ops, sizeof(*orig_nat_ops) * ops_count, GFP_KERNEL);
+		nat_ops = kmemdup_array(orig_nat_ops, ops_count, sizeof(*orig_nat_ops), GFP_KERNEL);
 		if (!nat_ops) {
 			mutex_unlock(&nf_nat_proto_mutex);
 			return -ENOMEM;
-- 
2.34.1

