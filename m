Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1327314265
	for <netfilter-devel@vger.kernel.org>; Fri, 31 May 2024 03:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717127359; cv=none; b=ZRjCLZF8qztMUF2bolmdr5EhvsCCcNhcQRCx1zMBd5o7wn95omwwDFpq75Ce3l4fWyZ60jp/rdJdg1yM/4HUoBaWEdZAs29VoGbneZDI/z0W0jR+MnIAYyM+4p0rYXuzVMstyTUeIpzJTSX+2mr2i00MjdjNk3HOCWqQ14KG3pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717127359; c=relaxed/simple;
	bh=x/FQDpINNyZebwwgX6nhRcdMV+aUWb9STDHxefqllNs=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=BA9eHm1ALSrXyu/Yv7tn0sug5YVlnWNDOL0HsYwJN9n3gI9drkEVH2b3yKtAJwcZGYojVOihanzH+/wo1SklWljfo0jeVG3R7q2wgfUq6wyJOIC4+n5YXoUrVdB66Ow6W0+Ejm6NzFBe5iJKtn0VL3do9KCLps6NW+N97B/3/L0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Vr8CK6nMZzxQw3;
	Fri, 31 May 2024 11:45:17 +0800 (CST)
Received: from dggpemm500008.china.huawei.com (unknown [7.185.36.136])
	by mail.maildlp.com (Postfix) with ESMTPS id E915B1800CD;
	Fri, 31 May 2024 11:48:53 +0800 (CST)
Received: from localhost (10.174.242.157) by dggpemm500008.china.huawei.com
 (7.185.36.136) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.35; Fri, 31 May
 2024 11:48:47 +0800
From: Yunjian Wang <wangyunjian@huawei.com>
To: <netfilter-devel@vger.kernel.org>
CC: <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>,
	<kuba@kernel.org>, <davem@davemloft.net>, <coreteam@netfilter.org>,
	<xudingke@huawei.com>, Yunjian Wang <wangyunjian@huawei.com>
Subject: [PATCH nf-next v2] netfilter: nf_conncount: fix wrong variable type
Date: Fri, 31 May 2024 11:48:47 +0800
Message-ID: <1717127327-22064-1-git-send-email-wangyunjian@huawei.com>
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

Now there is a issue is that code checks reports a warning: implicit
narrowing conversion from type 'unsigned int' to small type 'u8' (the
'keylen' variable). Fix it by removing the 'keylen' variable.

Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
---
v2: update commit log and remove the 'keylen' variable
---
 net/netfilter/nf_conncount.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 8715617b02fe..34ba14e59e95 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -321,7 +321,6 @@ insert_tree(struct net *net,
 	struct nf_conncount_rb *rbconn;
 	struct nf_conncount_tuple *conn;
 	unsigned int count = 0, gc_count = 0;
-	u8 keylen = data->keylen;
 	bool do_gc = true;
 
 	spin_lock_bh(&nf_conncount_locks[hash]);
@@ -333,7 +332,7 @@ insert_tree(struct net *net,
 		rbconn = rb_entry(*rbnode, struct nf_conncount_rb, node);
 
 		parent = *rbnode;
-		diff = key_diff(key, rbconn->key, keylen);
+		diff = key_diff(key, rbconn->key, data->keylen);
 		if (diff < 0) {
 			rbnode = &((*rbnode)->rb_left);
 		} else if (diff > 0) {
@@ -378,7 +377,7 @@ insert_tree(struct net *net,
 
 	conn->tuple = *tuple;
 	conn->zone = *zone;
-	memcpy(rbconn->key, key, sizeof(u32) * keylen);
+	memcpy(rbconn->key, key, sizeof(u32) * data->keylen);
 
 	nf_conncount_list_init(&rbconn->list);
 	list_add(&conn->node, &rbconn->list.head);
@@ -403,7 +402,6 @@ count_tree(struct net *net,
 	struct rb_node *parent;
 	struct nf_conncount_rb *rbconn;
 	unsigned int hash;
-	u8 keylen = data->keylen;
 
 	hash = jhash2(key, data->keylen, conncount_rnd) % CONNCOUNT_SLOTS;
 	root = &data->root[hash];
@@ -414,7 +412,7 @@ count_tree(struct net *net,
 
 		rbconn = rb_entry(parent, struct nf_conncount_rb, node);
 
-		diff = key_diff(key, rbconn->key, keylen);
+		diff = key_diff(key, rbconn->key, data->keylen);
 		if (diff < 0) {
 			parent = rcu_dereference_raw(parent->rb_left);
 		} else if (diff > 0) {
-- 
2.33.0

