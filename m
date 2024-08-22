Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3D5317E01C;
	Thu, 22 Aug 2024 22:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724365190; cv=none; b=EvLA7IVcyowAW582WfNt4SwMKhtEWk6FTGLoLJSS5QVjmCgTs1UkuIm6hWWoA7f4fvcIrq6tmM2yXPzdzhaaR4S665xEfoeWlm/XBn7u6eDG4ZWm8I+aIEaZ8g3DQkFcYPDGg89zOfwTHVW6TSpDu2YO2ggiPA1S96Kbm1q7h5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724365190; c=relaxed/simple;
	bh=dck/cgt+QZthy+CAt7OE40r4PpgvPQYHbbrH6JZiQrg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RXd3l9o/+ydGPKC0pqYLBKP6gbxj0E24/JBwvk16Uhvf+YB0Ua+JCfwzmobaKd0AYYEQ7+3jMzdQNaHzLG80xTyURpKRysu65WKd89SjvhOABKoJheYdXLvBsRMrls28sarlbSOsJeYOl3VrmBEh3KsmqL05b+yXGqj5Evq7fY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net-next 3/9] netfilter: nfnetlink: convert kfree_skb to consume_skb
Date: Fri, 23 Aug 2024 00:19:33 +0200
Message-Id: <20240822221939.157858-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240822221939.157858-1-pablo@netfilter.org>
References: <20240822221939.157858-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Donald Hunter <donald.hunter@gmail.com>

Use consume_skb in the batch code path to avoid generating spurious
NOT_SPECIFIED skb drop reasons.

Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 932b3ddb34f1..7784ec094097 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -402,27 +402,27 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 		{
 			nfnl_unlock(subsys_id);
 			netlink_ack(oskb, nlh, -EOPNOTSUPP, NULL);
-			return kfree_skb(skb);
+			return consume_skb(skb);
 		}
 	}
 
 	if (!ss->valid_genid || !ss->commit || !ss->abort) {
 		nfnl_unlock(subsys_id);
 		netlink_ack(oskb, nlh, -EOPNOTSUPP, NULL);
-		return kfree_skb(skb);
+		return consume_skb(skb);
 	}
 
 	if (!try_module_get(ss->owner)) {
 		nfnl_unlock(subsys_id);
 		netlink_ack(oskb, nlh, -EOPNOTSUPP, NULL);
-		return kfree_skb(skb);
+		return consume_skb(skb);
 	}
 
 	if (!ss->valid_genid(net, genid)) {
 		module_put(ss->owner);
 		nfnl_unlock(subsys_id);
 		netlink_ack(oskb, nlh, -ERESTART, NULL);
-		return kfree_skb(skb);
+		return consume_skb(skb);
 	}
 
 	nfnl_unlock(subsys_id);
@@ -567,7 +567,7 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (status & NFNL_BATCH_REPLAY) {
 		ss->abort(net, oskb, NFNL_ABORT_AUTOLOAD);
 		nfnl_err_reset(&err_list);
-		kfree_skb(skb);
+		consume_skb(skb);
 		module_put(ss->owner);
 		goto replay;
 	} else if (status == NFNL_BATCH_DONE) {
@@ -593,7 +593,7 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 		err = ss->abort(net, oskb, abort_action);
 		if (err == -EAGAIN) {
 			nfnl_err_reset(&err_list);
-			kfree_skb(skb);
+			consume_skb(skb);
 			module_put(ss->owner);
 			status |= NFNL_BATCH_FAILURE;
 			goto replay_abort;
@@ -601,7 +601,7 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 	}
 
 	nfnl_err_deliver(&err_list, oskb);
-	kfree_skb(skb);
+	consume_skb(skb);
 	module_put(ss->owner);
 }
 
-- 
2.30.2

