Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81ECB3FF1;
	Sat, 28 Jun 2025 10:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751105742; cv=none; b=ZGtEe8dQ2wYNKCWP0N+e3liexwaZln7Ypob6uViyGIKLZFdv5H+cW5iYwq7sUQGdXb1SYU4wnzNPnfe/Yh4jJLJCyrpMwp8UMQ6okAfmO0N47mFzYvu+8Pj4V/OVJes7aUoFcfuJ96Jw3qUMRd7WxqwT/nmOIFxj4ExSKEwExW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751105742; c=relaxed/simple;
	bh=J8w/juXGG9OioioHoAEYgFk5ki+vMhrSRZM2leBodM0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=WDzN1qX3PUPkKv5J9FAu3GhBR4aNjK1Tsw3IDc2ZkjCml02zDWoTcwmAq52NaYlMNJAiO9mmIqP94J0dBR9kOx5/CMbcOicc/Hi1oU58aSeqlFXBUCok28uOoQy7PwbKU4JSDBcoth2H/+5qMXzczUw+F5PJ2vIwAFRsILSi2eE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4bTpDL4JWqz2TRxF;
	Sat, 28 Jun 2025 18:13:54 +0800 (CST)
Received: from dggpemf500002.china.huawei.com (unknown [7.185.36.57])
	by mail.maildlp.com (Postfix) with ESMTPS id C76001401F0;
	Sat, 28 Jun 2025 18:15:35 +0800 (CST)
Received: from huawei.com (10.175.124.27) by dggpemf500002.china.huawei.com
 (7.185.36.57) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Sat, 28 Jun
 2025 18:15:34 +0800
From: Yue Haibing <yuehaibing@huawei.com>
To: <pablo@netfilter.org>, <kadlec@netfilter.org>, <davem@davemloft.net>,
	<edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<horms@kernel.org>, <fw@strlen.de>
CC: <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<yuehaibing@huawei.com>
Subject: [PATCH net-next] netfilter: conntrack: Remove unused net in nf_conntrack_double_lock()
Date: Sat, 28 Jun 2025 18:32:40 +0800
Message-ID: <20250628103240.211386-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf500002.china.huawei.com (7.185.36.57)

Since commit a3efd81205b1 ("netfilter: conntrack: move generation
seqcnt out of netns_ct") this param is unused.

Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
---
 net/netfilter/nf_conntrack_core.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 201d3c4ec623..d80f68e06177 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -136,8 +136,8 @@ static void nf_conntrack_double_unlock(unsigned int h1, unsigned int h2)
 }
 
 /* return true if we need to recompute hashes (in case hash table was resized) */
-static bool nf_conntrack_double_lock(struct net *net, unsigned int h1,
-				     unsigned int h2, unsigned int sequence)
+static bool nf_conntrack_double_lock(unsigned int h1, unsigned int h2,
+				     unsigned int sequence)
 {
 	h1 %= CONNTRACK_LOCKS;
 	h2 %= CONNTRACK_LOCKS;
@@ -616,7 +616,7 @@ static void __nf_ct_delete_from_lists(struct nf_conn *ct)
 		reply_hash = hash_conntrack(net,
 					   &ct->tuplehash[IP_CT_DIR_REPLY].tuple,
 					   nf_ct_zone_id(nf_ct_zone(ct), IP_CT_DIR_REPLY));
-	} while (nf_conntrack_double_lock(net, hash, reply_hash, sequence));
+	} while (nf_conntrack_double_lock(hash, reply_hash, sequence));
 
 	clean_from_lists(ct);
 	nf_conntrack_double_unlock(hash, reply_hash);
@@ -893,7 +893,7 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
 		reply_hash = hash_conntrack(net,
 					   &ct->tuplehash[IP_CT_DIR_REPLY].tuple,
 					   nf_ct_zone_id(nf_ct_zone(ct), IP_CT_DIR_REPLY));
-	} while (nf_conntrack_double_lock(net, hash, reply_hash, sequence));
+	} while (nf_conntrack_double_lock(hash, reply_hash, sequence));
 
 	max_chainlen = MIN_CHAINLEN + get_random_u32_below(MAX_CHAINLEN);
 
@@ -1231,7 +1231,7 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 		reply_hash = hash_conntrack(net,
 					   &ct->tuplehash[IP_CT_DIR_REPLY].tuple,
 					   nf_ct_zone_id(nf_ct_zone(ct), IP_CT_DIR_REPLY));
-	} while (nf_conntrack_double_lock(net, hash, reply_hash, sequence));
+	} while (nf_conntrack_double_lock(hash, reply_hash, sequence));
 
 	/* We're not in hash table, and we refuse to set up related
 	 * connections for unconfirmed conns.  But packet copies and
-- 
2.34.1

