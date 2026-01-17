Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A372A279355
	for <netfilter-devel@vger.kernel.org>; Sat, 17 Jan 2026 17:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768671159; cv=none; b=rHS1Eunrs1B3QxNPAt77v733ZCKvvRnxE+9QHBRmooCjT9ZLlRvoo3AE1ZGcaSFeAZH9pKnSmq+xQJfHeJ2mQIDqxF4pEQo8cUwDI+c/Aopnh05yjTmaEd4UGQw4+b7q+aDdNRfy0rd+9M8v9WGTw1mKQri1AcSPQ10XZ6rtglo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768671159; c=relaxed/simple;
	bh=SHquis//YSnRdw9BlDXK2mSGReJsCwA7Pjd51i4SzVU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=is+oDUKYSa8vbzUBlWBpyGN479g6pyhSbUwf4QSl7Yi+n0cC2w2D6W6nAG2PIbgLJ3jGsvcX4yQUP/afCv42WWC2m1lF592wM8rKeE9jjxgwVuGe/50Mvcc9hfriCCSxzF8pxeW7/lbffSId+veYKo6M7hpPCCi5ZN4f4w28gQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N2y8g9QT; arc=none smtp.client-ip=74.125.82.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N2y8g9QT"
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-2b6b65c79aeso3279405eec.1
        for <netfilter-devel@vger.kernel.org>; Sat, 17 Jan 2026 09:32:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768671156; x=1769275956; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rQyYPajs63jOfQrX/n1UkXXCDBCQo3EBXBTdVg7TOwI=;
        b=N2y8g9QTK4fMbMkDaMhHzIh6KG4v3TeuP+tu5pRhGKmxPTeK+KgdcJtZw0p/f8++J5
         GaxOzkWMMjaf2D8lzhOv81zpWjy0To8kV3LQNU4gpncEzqZl3YqMzCZkjG9LNNSkTL53
         GuRMV57zLQgUMilGEVVA2Y7PfJ4Ius4pY1eko9gkq7PT/dwCNZ5s9LeYBh9NktIpfheN
         Ogg63+C7g0Q2lVtqJYMce6PFjmJ2zJPbscPuQbRlvA/DXYXFckDQM7mvZiBLbvWP1A0d
         OamgTksnsaDwgW2/F51gV71wcjvK2l1K8nvL6QzwSCUNgUg1mYMhkAeUGDRiZ9B0INft
         V6pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768671156; x=1769275956;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rQyYPajs63jOfQrX/n1UkXXCDBCQo3EBXBTdVg7TOwI=;
        b=xAila5YtNnRL0reLACFBgIyaxSUaFLeN24JWJ3p/b6H6QcwGhEYBV3Ehv687U/qL7y
         pnPbzjrFw88JqdJ7EfK6ao6OchysU1tuMt6j8hEE51uGHbpoLARbLEQWRa8Z3MQk4rRs
         8MFIFRsFfiuQ3NqqwSuYhu6z0JhAQZ5crABIUGPql+QrSA2+/3B04r0JmguKQPcOaoW9
         e8Yfvo3tB4UBfcDErNijDy3mmuq5ac9aRqV5kdHiXOKZiWbPTG+gyhPU8enBdj3hk8QF
         YDvhyBChhcPi3CiJf/te2dtrsNq4JSSaE1WqOY4wEe5R3BFT5sgMno/RcZAeuzWKs3zP
         wdGA==
X-Gm-Message-State: AOJu0YxkU4eOMdqYPM+lzTjWhUi3uUh8WnIL1oi8IFk5XLVsxApCbKtG
	QZqIJcD3pXNWweEkpNMmLLpHcc2f/C7DGjdQPMcEkIbJmMpPqv8JEAj+mfq3ig==
X-Gm-Gg: AY/fxX5Aq/88Iyry4c3ngyjhSJF8SlTV04JODcSdEwrsaSTs285YB+/4FYxAfNCdVk4
	3n8LUXFoVIwgveAlVedt1pmLhYkB4cWVmzIWwMoab8J1HsRKRiT8V8x2Ajiw9wRjlPzPYTrd/0k
	0iEWvuNsUhjyj8FOWjB/UmpVF1poU0xVNTngcZ764FAh+r7hHvmLwEjOABinDu6GIjTcXw0Tie/
	uqJ/t05XBM+ikzY+ut2LLaMunngUmGBwx0HuIYwtqb7wc+BddkGVM32kPnONXq7KDKyNtOj+ufq
	qsxS/Js/HFqJlrm3U9Ixwic6XeDhgYookGQuy+AhE6eWzzEJPFz8GmfFMgeI2l5zfK0eG+smULQ
	TvYMwOhOw43Tb8i0eGqbNBmizTThQq6wDcQ1yWRpWbS7K4rnSgKf7GE3QV42XO6Hk9omsjq/dAO
	gtabKd4bQC9vaZ+yALVcy6EA==
X-Received: by 2002:a05:7301:6086:b0:2a4:3592:cf60 with SMTP id 5a478bee46e88-2b6b3f2236amr4599063eec.4.1768671156199;
        Sat, 17 Jan 2026 09:32:36 -0800 (PST)
Received: from mac.com ([136.24.82.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b6b361f5c9sm6486614eec.22.2026.01.17.09.32.35
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 17 Jan 2026 09:32:35 -0800 (PST)
From: scott.k.mitch1@gmail.com
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	Scott Mitchell <scott.k.mitch1@gmail.com>
Subject: [PATCH v6 1/2] netfilter: nfnetlink_queue: nfqnl_instance GFP_ATOMIC -> GFP_KERNEL_ACCOUNT allocation
Date: Sat, 17 Jan 2026 09:32:30 -0800
Message-Id: <20260117173231.88610-2-scott.k.mitch1@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260117173231.88610-1-scott.k.mitch1@gmail.com>
References: <20260117173231.88610-1-scott.k.mitch1@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Scott Mitchell <scott.k.mitch1@gmail.com>

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
---
 net/netfilter/nfnetlink_queue.c | 73 +++++++++++++++------------------
 1 file changed, 32 insertions(+), 41 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 8b7b39d8a109..7b2cabf08fdf 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -121,17 +121,9 @@ instance_create(struct nfnl_queue_net *q, u_int16_t queue_num, u32 portid)
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
@@ -141,9 +133,15 @@ instance_create(struct nfnl_queue_net *q, u_int16_t queue_num, u32 portid)
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
@@ -153,10 +151,9 @@ instance_create(struct nfnl_queue_net *q, u_int16_t queue_num, u32 portid)
 
 	return inst;
 
-out_free:
-	kfree(inst);
 out_unlock:
 	spin_unlock(&q->instances_lock);
+	kfree(inst);
 	return ERR_PTR(err);
 }
 
@@ -1498,7 +1495,6 @@ static int nfqnl_recv_config(struct sk_buff *skb, const struct nfnl_info *info,
 	struct nfqnl_msg_config_cmd *cmd = NULL;
 	struct nfqnl_instance *queue;
 	__u32 flags = 0, mask = 0;
-	int ret = 0;
 
 	if (nfqa[NFQA_CFG_CMD]) {
 		cmd = nla_data(nfqa[NFQA_CFG_CMD]);
@@ -1544,47 +1540,44 @@ static int nfqnl_recv_config(struct sk_buff *skb, const struct nfnl_info *info,
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
@@ -1609,9 +1602,7 @@ static int nfqnl_recv_config(struct sk_buff *skb, const struct nfnl_info *info,
 		spin_unlock_bh(&queue->lock);
 	}
 
-err_out_unlock:
-	rcu_read_unlock();
-	return ret;
+	return 0;
 }
 
 static const struct nfnl_callback nfqnl_cb[NFQNL_MSG_MAX] = {
-- 
2.39.5 (Apple Git-154)

