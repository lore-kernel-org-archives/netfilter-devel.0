Received: from baidu.com (mx24.baidu.com [111.206.215.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05DF818FDAF;
	Wed, 22 Jan 2025 07:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.206.215.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737531925; cv=none; b=aKjbVoBc159VVp5vDAi7zmdmBKx3qF67GoCL6Kero9Y/Ix3Q0h5P5RZgBW/tlo4fBdpGbmekU21O9LjpRteU14EzAs2/bDtYtL0IWPLv5j4mgzvwf/wScgEJ8T1pefjuY4zd5rdkiJQJXlYP7kilHo1cBEIufN7k1Iu3ozRb26Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737531925; c=relaxed/simple;
	bh=VNCnzTdmmw4fXHJMK+k19ytLDpp5wOuP1R974fbLLZs=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=KDwhYpYeu15hpV4Zv62/GCRchBTYn3ia9YoLUaAsmo/6Ibq/HN4ILNb8WUEQfJRjpBebCh6gCLUVIdqbX8KymVuHlpfdXekztlNFGImt/M5wBz8mqe+lUa/BQkfnYiiPZ4gb1DnmCyQjxA4TrWdU69Ho2zeBTBzYSei8xnnXHz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; arc=none smtp.client-ip=111.206.215.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
From: lirongqing <lirongqing@baidu.com>
To: <pablo@netfilter.org>, <kadlec@netfilter.org>, <davem@davemloft.net>,
	<edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<horms@kernel.org>, <netfilter-devel@vger.kernel.org>,
	<coreteam@netfilter.org>, <netdev@vger.kernel.org>
CC: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH] net/netfilter: use kvfree_rcu to simplify the code
Date: Wed, 22 Jan 2025 15:44:50 +0800
Message-ID: <20250122074450.3185-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: BC-Mail-Ex16.internal.baidu.com (172.31.51.56) To
 BJHW-Mail-Ex15.internal.baidu.com (10.127.64.38)
X-Baidu-BdMsfe-DateCheck: 1_BJHW-Mail-Ex15_2025-01-22 15:44:57:892
X-Baidu-BdMsfe-DateCheck: 1_BJHW-Mail-Ex15_2025-01-22 15:44:57:907
X-FEAS-Client-IP: 10.127.64.38
X-FE-Policy-ID: 52:10:53:SYSTEM

From: Li RongQing <lirongqing@baidu.com>

The callback function of call_rcu() just calls kvfree(), so we can
use kvfree_rcu() instead of call_rcu() + callback function.

and move struct rcu_head into struct nf_hook_entries, then struct
nf_hook_entries_rcu_head can be removed

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 include/linux/netfilter.h | 13 +------------
 net/netfilter/core.c      | 21 ++-------------------
 2 files changed, 3 insertions(+), 31 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 2b8aac2..c751b0a 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -111,28 +111,17 @@ struct nf_hook_entry {
 	void				*priv;
 };
 
-struct nf_hook_entries_rcu_head {
-	struct rcu_head head;
-	void	*allocation;
-};
-
 struct nf_hook_entries {
 	u16				num_hook_entries;
+	struct rcu_head rcu;
 	/* padding */
 	struct nf_hook_entry		hooks[];
 
 	/* trailer: pointers to original orig_ops of each hook,
-	 * followed by rcu_head and scratch space used for freeing
-	 * the structure via call_rcu.
 	 *
 	 *   This is not part of struct nf_hook_entry since its only
 	 *   needed in slow path (hook register/unregister):
 	 * const struct nf_hook_ops     *orig_ops[]
-	 *
-	 *   For the same reason, we store this at end -- its
-	 *   only needed when a hook is deleted, not during
-	 *   packet path processing:
-	 * struct nf_hook_entries_rcu_head     head
 	 */
 };
 
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index b9f551f0..8889f09 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -52,8 +52,7 @@ static struct nf_hook_entries *allocate_hook_entries_size(u16 num)
 	struct nf_hook_entries *e;
 	size_t alloc = sizeof(*e) +
 		       sizeof(struct nf_hook_entry) * num +
-		       sizeof(struct nf_hook_ops *) * num +
-		       sizeof(struct nf_hook_entries_rcu_head);
+		       sizeof(struct nf_hook_ops *) * num;
 
 	if (num == 0)
 		return NULL;
@@ -64,28 +63,12 @@ static struct nf_hook_entries *allocate_hook_entries_size(u16 num)
 	return e;
 }
 
-static void __nf_hook_entries_free(struct rcu_head *h)
-{
-	struct nf_hook_entries_rcu_head *head;
-
-	head = container_of(h, struct nf_hook_entries_rcu_head, head);
-	kvfree(head->allocation);
-}
-
 static void nf_hook_entries_free(struct nf_hook_entries *e)
 {
-	struct nf_hook_entries_rcu_head *head;
-	struct nf_hook_ops **ops;
-	unsigned int num;
-
 	if (!e)
 		return;
 
-	num = e->num_hook_entries;
-	ops = nf_hook_entries_get_hook_ops(e);
-	head = (void *)&ops[num];
-	head->allocation = e;
-	call_rcu(&head->head, __nf_hook_entries_free);
+	kvfree_rcu(e, rcu);
 }
 
 static unsigned int accept_all(void *priv,
-- 
2.9.4

