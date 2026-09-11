Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B613344F54B
	for <netfilter-devel@vger.kernel.org>; Fri, 11 Sep 2026 11:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789125723; cv=none; b=HxsE0AJbLTgbfKfT8VV04mSBrc2os6HVE3LY/a50yFHHNCTpNLc+pr2rACH1+nr1niE0PwM7SngSrciwfDkK4So/KG0NSLqHrqaJICqrhEJuOIISar8/mjaTv7GFVLuh5xY7Jl/fxzqqIQJ8FljLAfDgc6Kk6YkJNBm18vcMQ4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789125723; c=relaxed/simple;
	bh=QhjDyHn2pGCF+34V5jBipN5cbD11FdPQE/XPc3uLWWw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KHfam1GVp7rCQbUe1h+hkb9HGGAOD/g6myoG1oOS6ihBVZ1mrXfl4JOrRO2cavv1kceXs+asoP2zHX8lDiCTEJ3HdxV/xbHtkqqP2XVHIKnCcuYELGNAEZV9/LChEhiqyvlT93WINz+ddFgYa/ywRHW6hrhjrWmXls+qen0Aj9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=IaSQO91I; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="IaSQO91I"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789125711;
	bh=xFKn8L9lspfrZDh17Sk1g4QmXa8rZyF1HPa88db7nVg=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=IaSQO91I6nXcLrSi20ndKA49P4zWJimzCjojdSqt0vECNf03X8DwsfX2rXRXXhHHB
	 Hi2/lwn/J3N5jbJxrCN1O+F2BdFzQkbT9IRqjU+KzM4CTTdR5nguGZa1GeZCZ/eu3J
	 6c7XWN921zDYBI37AgoUz7l45g+oN58bAzyGHmyN62ngF+tt7pTAdX2pc27EGB+YYX
	 XOOr8OXSTE7FRw8M7O6KUusM8KUcVUgzgpGp2PuGqG93WoGcFcISc+jszWVGjH6vFq
	 SzOzW3+Vc3PyEIEYdPXHNIZfEZTURf+KD6/gKXZqFIzZq1FXYQIWOUtTEPcG6Mf+QP
	 MO64O2hmj6xuA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 658CE603DE
	for <netfilter-devel@vger.kernel.org>; Fri, 11 Sep 2026 13:21:51 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH net 3/4] netfilter: nf_nat: unregister and release hooks on error
Date: Fri, 11 Sep 2026 13:21:43 +0200
Message-ID: <20260911112144.1860514-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260911112144.1860514-1-pablo@netfilter.org>
References: <20260911112144.1860514-1-pablo@netfilter.org>
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

