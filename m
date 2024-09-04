Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6984D1CCB2F;
	Wed,  4 Sep 2024 09:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725441859; cv=none; b=A6NnQibp+VSiw0pVzMu9eiXcsJgQxZ7lfTCFm9JMTuuEdYOz8Ns7tKFAmT7+3cErNas+FM+nUKj3JfcN8DLtk+x2boFZhN7ncJRa8F/YseMsdLc89F8r5deQkD87ks/IuN3B42ZVAb6Tdz8adlJydUnjilzZS5JQi/OpcpEQyYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725441859; c=relaxed/simple;
	bh=Ay6Z+RGdHF92DKyohFHukGTkwKLrLjTxAfqdEIxo520=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mM/fDGq7d2oqD2+99z0lBfqTZomrwOJI2TAEE1zd9I59XLHHET/s+JbWDikaVBJE5yLXI8Neqonmw1DbExAjlZZWTppd7bnqHSF3JlUvqDlDkQlxWD4Xo03ng4Ps4IxjqQ+YE95kVi76gI/ekpRWNs6Iw5fN7/Mnd/b5UBfUxBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4WzH911G6yz1BNQK;
	Wed,  4 Sep 2024 17:23:17 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 7C6EB1400CA;
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
Subject: [PATCH net-next v2 2/5] net/tipc: make use of the helper macro LIST_HEAD()
Date: Wed, 4 Sep 2024 17:32:40 +0800
Message-ID: <20240904093243.3345012-3-lihongbo22@huawei.com>
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
  - Keep the reverse xmas tree order as Simon's suggested.

v1: https://lore.kernel.org/netdev/36922bd7-5174-4cf0-b7a2-5ddc77c4868d@huawei.com/T/#m3c3c6376534474346018f583eb3637ff9ecf8a1c
---
 net/tipc/socket.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 1a0cd06f0eae..65dcbb54f55d 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -1009,12 +1009,11 @@ static int tipc_send_group_anycast(struct socket *sock, struct msghdr *m,
 	struct tipc_member *mbr = NULL;
 	struct net *net = sock_net(sk);
 	u32 node, port, exclude;
-	struct list_head dsts;
+	LIST_HEAD(dsts);
 	int lookups = 0;
 	int dstcnt, rc;
 	bool cong;
 
-	INIT_LIST_HEAD(&dsts);
 	ua->sa.type = msg_nametype(hdr);
 	ua->scope = msg_lookup_scope(hdr);
 
@@ -1161,10 +1160,9 @@ static int tipc_send_group_mcast(struct socket *sock, struct msghdr *m,
 	struct tipc_group *grp = tsk->group;
 	struct tipc_msg *hdr = &tsk->phdr;
 	struct net *net = sock_net(sk);
-	struct list_head dsts;
 	u32 dstcnt, exclude;
+	LIST_HEAD(dsts);
 
-	INIT_LIST_HEAD(&dsts);
 	ua->sa.type = msg_nametype(hdr);
 	ua->scope = msg_lookup_scope(hdr);
 	exclude = tipc_group_exclude(grp);
-- 
2.34.1

