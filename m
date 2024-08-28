Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F46615B560;
	Wed, 28 Aug 2024 07:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724828544; cv=none; b=bns2v17Pz3W48SnFsp2VakvbCyRhWkNu4G1yDK8qtuSpC1462shHgFhhp7t+h7TFXnJ30qbxhiyA+Tuqrc2VpfmNyS4z8bg4MfCxAWhrRRp5gtKPhnN78CRCLHJQLxeSr6GmKf8TH/ZKqWL1pZLJ4CMUVfjSnG2/lRX9X/bd1ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724828544; c=relaxed/simple;
	bh=KRea+Vl+gVbOaLY/HDCRVQFg8GITaziBqGbQ2FPwNY0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nxC4ZQJ/kOO4sQAQfZrNl15y9Fv9pog6l2VlgrFn6B002U12Bieb3q1E1bMNyKJEvEsa+ZuI1UlzXBB5CP3TND9T1X7PZJX2ZNipMM/Z/VGeEy1PRHmaQ05czZFhr7DBWwGlTQCFYdLpInCjFIbEn1y0cDwDFBY1zqNM47LiWBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4WtwFw4Jhkz20n0H;
	Wed, 28 Aug 2024 14:57:24 +0800 (CST)
Received: from kwepemh500013.china.huawei.com (unknown [7.202.181.146])
	by mail.maildlp.com (Postfix) with ESMTPS id C163A14013B;
	Wed, 28 Aug 2024 15:02:13 +0800 (CST)
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
Subject: [PATCH -next 4/5] netfilter: iptables: Use kmemdup_array() instead of kmemdup() for multiple allocation
Date: Wed, 28 Aug 2024 15:10:03 +0800
Message-ID: <20240828071004.1245213-5-ruanjinjie@huawei.com>
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
 net/ipv4/netfilter/ip_tables.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index fe89a056eb06..096bfef472b1 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1767,7 +1767,7 @@ int ipt_register_table(struct net *net, const struct xt_table *table,
 		goto out_free;
 	}
 
-	ops = kmemdup(template_ops, sizeof(*ops) * num_ops, GFP_KERNEL);
+	ops = kmemdup_array(template_ops, num_ops, sizeof(*ops), GFP_KERNEL);
 	if (!ops) {
 		ret = -ENOMEM;
 		goto out_free;
-- 
2.34.1

