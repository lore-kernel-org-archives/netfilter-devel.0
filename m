Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B4E3DD50B;
	Mon, 20 Apr 2026 13:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691455; cv=none; b=UIXBiExV7X+D5FcIbOEw2ujXjQHnwKrGGESB8+1bE24SfRjfMF8sknKTEc4QT8+hKUFvKOghRK654/U6Ke93IDnZOAQCYgD0Y6g3OjlUyarUOeOsJ8zMGjTL1crGRc5DwqfdILrtNxAHvpu2y3kRARtpD/CMElhWhMtNT6CeK6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691455; c=relaxed/simple;
	bh=msI9t+qAYKpSyX5QpmNr5nY9GdLPOvWI+oK3ar2YSWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kc1cSFCicXz/LzsZrhPcuoPGVXYZ7L9h/OOEVLohwNcZ1RdUpFYnU8rWL3/ZqknPPuWuaA3XSVzfoJ+CSX2iGyXSxtti+u/pSVffH5h/zn8BGG+7QBO2buYIq/XxJZuiGQhjuRtn41+EnYRZMyRXBjWKfJncqT0UuqPIpxkkdag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tMW/XZC9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tMW/XZC9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D583C2BCB8;
	Mon, 20 Apr 2026 13:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691454;
	bh=msI9t+qAYKpSyX5QpmNr5nY9GdLPOvWI+oK3ar2YSWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tMW/XZC9AzF7jGuTANSYEIfG2AcnBFLAsxL8wroMw65wKpllE+CkyqivFPdx4oodE
	 KK8v1LkckeQGs3GSTCmJpu2M5/0XUwlWBsscuLcMXcQwU11pOI+Tax9FMfdQvRg0zj
	 BAN8xC7RnFwfiem9MFyyOoZmQ921cADGxVloxKlyNt/StyRef+KiZZi+7JJoBSXVRD
	 1TnOfTVBKN1AVh/XkXAT+On+4VGqhjGyMCycvibsSdA1CxPbXXjMk4tg1nblJh4nsR
	 ZDIHoJ7eIsQwQRqx6HCHXhYoIEhzcdJwEAomo+70tmT1KoIRwjho4rPZw/HtiSJOVB
	 2rbHxqavejwkw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Scott Mitchell <scott.k.mitch1@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>,
	pablo@netfilter.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] netfilter: nfnetlink_queue: nfqnl_instance GFP_ATOMIC -> GFP_KERNEL_ACCOUNT allocation
Date: Mon, 20 Apr 2026 09:17:12 -0400
Message-ID: <20260420132314.1023554-38-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: Scott Mitchell <scott.k.mitch1@gmail.com>

[ Upstream commit a4400a5b343d1bc4aa8f685608515413238e7ee2 ]

Currently, instance_create() uses GFP_ATOMIC because it's called while
holding instances_lock spinlock. This makes allocation more likely to
fail under memory pressure.

Refactor nfqnl_recv_config() to drop RCU lock after instance_lookup()
and peer_portid verification. A socket cannot simultaneously send a
message and close, so the queue owned by the sending socket cannot be
destroyed while processing its CONFIG message. This allows
instance_create() to allocate with GFP_KERNEL_ACCOUNT before taking
the spinlock.

Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Scott Mitchell <scott.k.mitch1@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Stable-dep-of: 936206e3f6ff ("netfilter: nfnetlink_queue: make hash table per queue")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 net/netfilter/nfnetlink_queue.c | 75 +++++++++++++++------------------
 1 file changed, 34 insertions(+), 41 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 0b96d20bacb73..a39d3b989063c 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -178,17 +178,9 @@ instance_create(struct nfnl_queue_net *q, u_int16_t queue_num, u32 portid)
 	unsigned int h;
 	int err;
 
-	spin_lock(&q->instances_lock);
-	if (instance_lookup(q, queue_num)) {
-		err = -EEXIST;
-		goto out_unlock;
-	}
-
-	inst = kzalloc(sizeof(*inst), GFP_ATOMIC);
-	if (!inst) {
-		err = -ENOMEM;
-		goto out_unlock;
-	}
+	inst = kzalloc(sizeof(*inst), GFP_KERNEL_ACCOUNT);
+	if (!inst)
+		return ERR_PTR(-ENOMEM);
 
 	inst->queue_num = queue_num;
 	inst->peer_portid = portid;
@@ -198,9 +190,15 @@ instance_create(struct nfnl_queue_net *q, u_int16_t queue_num, u32 portid)
 	spin_lock_init(&inst->lock);
 	INIT_LIST_HEAD(&inst->queue_list);
 
+	spin_lock(&q->instances_lock);
+	if (instance_lookup(q, queue_num)) {
+		err = -EEXIST;
+		goto out_unlock;
+	}
+
 	if (!try_module_get(THIS_MODULE)) {
 		err = -EAGAIN;
-		goto out_free;
+		goto out_unlock;
 	}
 
 	h = instance_hashfn(queue_num);
@@ -210,10 +208,9 @@ instance_create(struct nfnl_queue_net *q, u_int16_t queue_num, u32 portid)
 
 	return inst;
 
-out_free:
-	kfree(inst);
 out_unlock:
 	spin_unlock(&q->instances_lock);
+	kfree(inst);
 	return ERR_PTR(err);
 }
 
@@ -1604,7 +1601,8 @@ static int nfqnl_recv_config(struct sk_buff *skb, const struct nfnl_info *info,
 	struct nfqnl_msg_config_cmd *cmd = NULL;
 	struct nfqnl_instance *queue;
 	__u32 flags = 0, mask = 0;
-	int ret = 0;
+
+	WARN_ON_ONCE(!lockdep_nfnl_is_held(NFNL_SUBSYS_QUEUE));
 
 	if (nfqa[NFQA_CFG_CMD]) {
 		cmd = nla_data(nfqa[NFQA_CFG_CMD]);
@@ -1650,47 +1648,44 @@ static int nfqnl_recv_config(struct sk_buff *skb, const struct nfnl_info *info,
 		}
 	}
 
+	/* Lookup queue under RCU. After peer_portid check (or for new queue
+	 * in BIND case), the queue is owned by the socket sending this message.
+	 * A socket cannot simultaneously send a message and close, so while
+	 * processing this CONFIG message, nfqnl_rcv_nl_event() (triggered by
+	 * socket close) cannot destroy this queue. Safe to use without RCU.
+	 */
 	rcu_read_lock();
 	queue = instance_lookup(q, queue_num);
 	if (queue && queue->peer_portid != NETLINK_CB(skb).portid) {
-		ret = -EPERM;
-		goto err_out_unlock;
+		rcu_read_unlock();
+		return -EPERM;
 	}
+	rcu_read_unlock();
 
 	if (cmd != NULL) {
 		switch (cmd->command) {
 		case NFQNL_CFG_CMD_BIND:
-			if (queue) {
-				ret = -EBUSY;
-				goto err_out_unlock;
-			}
-			queue = instance_create(q, queue_num,
-						NETLINK_CB(skb).portid);
-			if (IS_ERR(queue)) {
-				ret = PTR_ERR(queue);
-				goto err_out_unlock;
-			}
+			if (queue)
+				return -EBUSY;
+			queue = instance_create(q, queue_num, NETLINK_CB(skb).portid);
+			if (IS_ERR(queue))
+				return PTR_ERR(queue);
 			break;
 		case NFQNL_CFG_CMD_UNBIND:
-			if (!queue) {
-				ret = -ENODEV;
-				goto err_out_unlock;
-			}
+			if (!queue)
+				return -ENODEV;
 			instance_destroy(q, queue);
-			goto err_out_unlock;
+			return 0;
 		case NFQNL_CFG_CMD_PF_BIND:
 		case NFQNL_CFG_CMD_PF_UNBIND:
 			break;
 		default:
-			ret = -ENOTSUPP;
-			goto err_out_unlock;
+			return -EOPNOTSUPP;
 		}
 	}
 
-	if (!queue) {
-		ret = -ENODEV;
-		goto err_out_unlock;
-	}
+	if (!queue)
+		return -ENODEV;
 
 	if (nfqa[NFQA_CFG_PARAMS]) {
 		struct nfqnl_msg_config_params *params =
@@ -1715,9 +1710,7 @@ static int nfqnl_recv_config(struct sk_buff *skb, const struct nfnl_info *info,
 		spin_unlock_bh(&queue->lock);
 	}
 
-err_out_unlock:
-	rcu_read_unlock();
-	return ret;
+	return 0;
 }
 
 static const struct nfnl_callback nfqnl_cb[NFQNL_MSG_MAX] = {
-- 
2.53.0

