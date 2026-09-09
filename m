Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE623D3CE5;
	Wed,  9 Sep 2026 22:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788992344; cv=none; b=P9Pwp40k0iD/i0kMqpv8PM+r9aRgaGCFGxzh1W5N4nYRrt9l9Dlg8lh2AQizGDL03BxHcb+4VPv/oOFgx6bwreM4dbZvguk+Dubp3EvIwwl4Aq0lTzClPjiwNGGXY1y30dsUKo1MgHCK1pVoDparh+sQK6x8+mn+2u9RtMrivfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788992344; c=relaxed/simple;
	bh=ooFq9rIwJFOV0op5nxpPPFFPJCP+084vNRS6kFe81GQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eyYQjk2GM09iNJwDxW947km0NllnSvS0lmv+hJVs84C+4wOiS9DAEjw34rA16ovXgmcjHUCwOXyWn8L0FEX0TpKjJuaNF6bt28dKovTCvkhksZD3gFG9rgkwrwGMfgxAJ5yj8DSkDWB8/ngDqT+bhd1WVH6xo4mDwdWe5gm8gpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=kS2GOblT; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="kS2GOblT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788992335;
	bh=QbaCMtgtPngOGGJuOKsmCCf9eZ0pgVq3D3g9SKr0nr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kS2GOblT/md5a/wnEWVUte5mkMiRV9sTu6LfMScVPlCSbx1Oenetxs+9TfNx2xmaA
	 7ZT5GU55Og53YwMQA8uvTGGmhk74wtoYZ1FX8OOwVmGIx2ske40X05RzvBf5ztT8BY
	 0liS0fqsCCFrKEeLHoVEpXWMley+xQs8wizMk88S+ewVe7c0z/GNZJaZ/MuLrIZ7Sd
	 R1PKcIbOCuYwSiBDAcNtCfmOVkyuYIEdoCmOPxxdOd5klE9/1GKT87oIyF4tRzPqpz
	 LdY/q9dxdZcxjkjEFlQc8WAystM3cNrATCUCpfs4ezoUM16peln/aS5KUsCLQEYDgE
	 bxbxNbLAwiHbg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id F3660607C1;
	Thu, 10 Sep 2026 00:18:54 +0200 (CEST)
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
Subject: [PATCH net 3/7] netfilter: nf_nat: unregister and release hooks on error
Date: Thu, 10 Sep 2026 00:18:40 +0200
Message-ID: <20260909221844.1650275-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260909221844.1650275-1-pablo@netfilter.org>
References: <20260909221844.1650275-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After the base nat hooks are registered, the first nested nat hook is
added through nf_hook_entries_insert_raw() and ->users is bumped.

However, sashiko reports that nf_hook_entries_insert_raw() fails, then
->users count remains at zero and nf_nat_unregister_fn() could hit
WARN_ON() since base nat hooks with no users is unexpected in the
unregistration path.

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

