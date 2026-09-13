Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 627AC38236F;
	Sun, 13 Sep 2026 20:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789332919; cv=none; b=PnHX1xBabk3xmCm9CUPthRtqGQoXtX2MZDtHxK/Kz5crZsSh/2tTxKbQnXoBHinr7HtCVhwiztPp4LHS+HRqAwPKFF9vJxGopcyrrC5FoEFAu4TdLMyjZ3bBrpci+kFfZntW5RO8AFPETYxR3cMkxs0fwKv1taFZgMWQRdm1b4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789332919; c=relaxed/simple;
	bh=QhjDyHn2pGCF+34V5jBipN5cbD11FdPQE/XPc3uLWWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uZEIMFcyzuiXsT7nBk72KbwgzI5Rtuzyr7X92GVD3N137dszntaw1OLWV78Dq9kKAb8KiuNWJBwvb1mRL9e0CG7ZafZYadJqjjLvqI0PZOBPUqwLskVZtJGmWxHjoh3C04EBKE+IFBZtfWHj31C9iEi5ri0z1zIYnodOtB8j/88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=HTRikNce; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="HTRikNce"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789332900;
	bh=xFKn8L9lspfrZDh17Sk1g4QmXa8rZyF1HPa88db7nVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HTRikNcesVSEKgbgVYgesv/E98bL/1HOlQnk7sR5gMY5eecUXm3GL0HsJKlfqR3Qj
	 QWWT3JPk3TwO8g0c+X6AhMEwkjn0vzXbHgL8IDs7jStJOo76CEZ3294JRIWKy2GnrU
	 zlwxPX+OVI9dwbuADecPKMrzKJ4UltgXkd+AXntFojRCjx5hR//FTgtW3oSc20ZnM9
	 nh06SCTpmIYf9k1FnoVLuW08NQmfMabSRiOTNpyUix+N63MZLFlYk7jEvMNpD/f0j1
	 04w+i9h5jFAiccXWo1Kv0v/8Xgft8DMoNOgXqbOptgCSG37I5RiEoJrKouGZmNwBbZ
	 K9WRjtsTehEKw==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C17046005B;
	Sun, 13 Sep 2026 22:54:59 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 3/4] netfilter: nf_nat: unregister and release hooks on error
Date: Sun, 13 Sep 2026 22:54:46 +0200
Message-ID: <20260913205447.1889203-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260913205447.1889203-1-pablo@netfilter.org>
References: <20260913205447.1889203-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If nf_hook_entries_insert_raw() fails, the NAT hooks get never released,
resulting in a memleak.

Postpone setting nat_proto_net->nat_hook_ops when the hooks are
registered to simplify the error path to decide whether the nat hooks
need unwinding.

Fixes: 1cd472bf036c ("netfilter: nf_nat: add nat hook register functions to nf_nat")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_nat_core.c | 46 ++++++++++++++++++++++++-------------
 1 file changed, 30 insertions(+), 16 deletions(-)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 8ac326e1eb5b..a4858c2b2d65 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -1224,31 +1224,45 @@ int nf_nat_register_fn(struct net *net, u8 pf, const struct nf_hook_ops *ops,
 		}
 
 		ret = nf_register_net_hooks(net, nat_ops, ops_count);
-		if (ret < 0) {
-			mutex_unlock(&nf_nat_proto_mutex);
-			for (i = 0; i < ops_count; i++) {
-				priv = nat_ops[i].priv;
-				kfree_rcu(priv, rcu_head);
-			}
-			kfree_rcu(nat_ops, rcu);
-			return ret;
-		}
-
-		nat_proto_net->nat_hook_ops = nat_ops;
+		if (ret < 0)
+			goto err_free_hooks;
+	} else {
+		nat_ops = nat_proto_net->nat_hook_ops;
 	}
 
-	nat_ops = nat_proto_net->nat_hook_ops;
 	priv = nat_ops[hooknum].priv;
 	if (WARN_ON_ONCE(!priv)) {
-		mutex_unlock(&nf_nat_proto_mutex);
-		return -EOPNOTSUPP;
+		ret = -EOPNOTSUPP;
+		goto err_unregister_hooks;
 	}
 
 	ret = nf_hook_entries_insert_raw(&priv->entries, ops);
-	if (ret == 0)
-		nat_proto_net->users++;
+	if (ret)
+		goto err_unregister_hooks;
+
+	if (!nat_proto_net->nat_hook_ops)
+		nat_proto_net->nat_hook_ops = nat_ops;
+
+	nat_proto_net->users++;
 
 	mutex_unlock(&nf_nat_proto_mutex);
+
+	return 0;
+
+err_unregister_hooks:
+	if (nat_proto_net->nat_hook_ops) {
+		mutex_unlock(&nf_nat_proto_mutex);
+		return ret;
+	}
+	nf_unregister_net_hooks(net, nat_ops, ops_count);
+err_free_hooks:
+	mutex_unlock(&nf_nat_proto_mutex);
+	for (i = 0; i < ops_count; i++) {
+		priv = nat_ops[i].priv;
+		kfree_rcu(priv, rcu_head);
+	}
+	kfree_rcu(nat_ops, rcu);
+
 	return ret;
 }
 
-- 
2.47.3

