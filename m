Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF06919FA8E;
	Tue, 27 Aug 2024 09:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724752575; cv=none; b=OczPssCJiS+nrXLlG9/H2ZHD1h8CKZOhhFyMx6bzW/P+USPUcuwbbeAkyAs9GfVAULbTwy3sGG9ZWF1+0DgsNqvWMy/6mnny14D4Np+Oa6ibuGjXytkpkWtvUDopHXA3XsSptONL7Hm7TODe1ZKKz0+dsrl2A8kcxkBtqv6eaZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724752575; c=relaxed/simple;
	bh=nHQFmVoXyRj75aGkvObjdyiMuGcIUvgfkhFf0AajmDE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VfOiEAQ0Z/5pmwguyJxjcc2CZSTYsK2c/NFi42dZO9rrI1rBjLDUCCXfkIP3DXCAmP01DbToXCQ/opDRJ6LEnmiWXm2/bhRgo39Wj4ZsdSsrn5/IgBpnxO0aFAWL4DMedbGRQJV6IIY9boSElvhG2KvLe69Y87V89m/LP1n87e8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4WtNG62pJ3zyR8x;
	Tue, 27 Aug 2024 17:55:42 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 919C41800FF;
	Tue, 27 Aug 2024 17:56:11 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Tue, 27 Aug
 2024 17:56:11 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <davem@davemloft.net>, <dsahern@kernel.org>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <jmaloy@redhat.com>,
	<ying.xue@windriver.com>, <pablo@netfilter.org>, <kadlec@netfilter.org>
CC: <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
	<lihongbo22@huawei.com>
Subject: [PATCH net-next 2/5] net/tipc: make use of the helper macro LIST_HEAD()
Date: Tue, 27 Aug 2024 18:04:04 +0800
Message-ID: <20240827100407.3914090-3-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240827100407.3914090-1-lihongbo22@huawei.com>
References: <20240827100407.3914090-1-lihongbo22@huawei.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500022.china.huawei.com (7.185.36.66)

list_head can be initialized automatically with LIST_HEAD()
instead of calling INIT_LIST_HEAD(). Here we can simplify
the code.

Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
 net/tipc/socket.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 1a0cd06f0eae..9d30e362392c 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -1009,12 +1009,11 @@ static int tipc_send_group_anycast(struct socket *sock, struct msghdr *m,
 	struct tipc_member *mbr = NULL;
 	struct net *net = sock_net(sk);
 	u32 node, port, exclude;
-	struct list_head dsts;
 	int lookups = 0;
 	int dstcnt, rc;
 	bool cong;
+	LIST_HEAD(dsts);
 
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

