Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E151A35F607;
	Fri, 17 Apr 2026 10:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776420701; cv=none; b=LKi1PnzwnKgHSIe2QmB9EgYKhaBWHrZ6aUOxZ24id218RjjRjrKuyMLHD7r+9ZOLAyoHudcn0EHkBaC6UuN0F8WdFQNCKu++Ot3ZbEMDc2oy2c36ui3guQGBwvdCSb6EAaVJ8wbB0sT2fJ7/cqPih+0vQexsiMJoJ+O4LedXYxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776420701; c=relaxed/simple;
	bh=VSVBMYgTh7yu/qZ8OnzwxDKi0m+ZaB2uzb2sWCnqc84=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oD81+5eALUNnqJJngqQFOOnrOOpuZmDnLF5hLAHm5hgDMYz4MnJbcJnuUnFAa8HWY5IcN1j83WnBuo2NZED1dCmqk5PcoYvX3v4i+4pDiFoBsBVgvVNyWpVdrMQscI/D1cKa1J1U9Dvz26lOHix7gMJb1BtIONvmQu3chR+CW3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=rOoMEw6r; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="rOoMEw6r"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 68ADB600B9;
	Fri, 17 Apr 2026 12:11:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776420697;
	bh=lx/+8I9WrQ7x3ADcx8lsBTwsCsblZH2vLM2Lr48dTmc=;
	h=From:To:Cc:Subject:Date:From;
	b=rOoMEw6rrqL9GUp17rAxtnf4kLQodlGVMVQNjOva69EGIkMWY592wu/SUIt1RHN/8
	 3Y7lCubsryItA7LqrCGvWW0HjXKvAXv6v/fYoVPUNAdwVz4KADuP/2XNti6gFLIgku
	 hBJ7NJ+Ux7F5GQA2C8X8mO3CxGuSIqqDMhtv4ZWvwx6ZqlgJJtiVRHM0LD/Nj32NJi
	 ugNLgUIBGnmAky+EVM/T4zsCGRonUEvgTtYCaBVqWN0FRSSN/mUC3Y4vcheeESKlZ6
	 28dogWvW5WP+rVAS7Q9TJ2cseW18go2WB9w+PXBS3RcCd4q5IVWcX6hiymbY+yl81Y
	 uI4zmZ6Yr8X3Q==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de,
	netdev@vger.kernel.org
Subject: [PATCH nf,v3] netfilter: nat: use kfree_rcu to release ops
Date: Fri, 17 Apr 2026 12:11:31 +0200
Message-ID: <20260417101132.379848-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Florian Westphal says:

"Historically this is not an issue, even for normal base hooks: the data
path doesn't use the original nf_hook_ops that are used to register the
callbacks.

However, in v5.14 I added the ability to dump the active netfilter
hooks from userspace.

This code will peek back into the nf_hook_ops that are available
at the tail of the pointer-array blob used by the datapath.

The nat hooks are special, because they are called indirectly from
the central nat dispatcher hook. They are currently invisible to
the nfnl hook dump subsystem though.

But once that changes the nat ops structures have to be deferred too."

Update nf_nat_register_fn() to deal with partial exposition of the hooks
from error path which can be also an issue for nfnetlink_hook.

Fixes: e2cf17d3774c ("netfilter: add new hook nfnl subsystem")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: use kfree_rcu as suggested by AI in ip{6}tables_nat.

 net/ipv4/netfilter/iptable_nat.c  |  4 ++--
 net/ipv6/netfilter/ip6table_nat.c |  4 ++--
 net/netfilter/nf_nat_core.c       | 10 ++++++----
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/netfilter/iptable_nat.c b/net/ipv4/netfilter/iptable_nat.c
index a5db7c67d61b..625a1ca13b1b 100644
--- a/net/ipv4/netfilter/iptable_nat.c
+++ b/net/ipv4/netfilter/iptable_nat.c
@@ -79,7 +79,7 @@ static int ipt_nat_register_lookups(struct net *net)
 			while (i)
 				nf_nat_ipv4_unregister_fn(net, &ops[--i]);
 
-			kfree(ops);
+			kfree_rcu(ops, rcu);
 			return ret;
 		}
 	}
@@ -100,7 +100,7 @@ static void ipt_nat_unregister_lookups(struct net *net)
 	for (i = 0; i < ARRAY_SIZE(nf_nat_ipv4_ops); i++)
 		nf_nat_ipv4_unregister_fn(net, &ops[i]);
 
-	kfree(ops);
+	kfree_rcu(ops, rcu);
 }
 
 static int iptable_nat_table_init(struct net *net)
diff --git a/net/ipv6/netfilter/ip6table_nat.c b/net/ipv6/netfilter/ip6table_nat.c
index e119d4f090cc..5be723232df8 100644
--- a/net/ipv6/netfilter/ip6table_nat.c
+++ b/net/ipv6/netfilter/ip6table_nat.c
@@ -81,7 +81,7 @@ static int ip6t_nat_register_lookups(struct net *net)
 			while (i)
 				nf_nat_ipv6_unregister_fn(net, &ops[--i]);
 
-			kfree(ops);
+			kfree_rcu(ops, rcu);
 			return ret;
 		}
 	}
@@ -102,7 +102,7 @@ static void ip6t_nat_unregister_lookups(struct net *net)
 	for (i = 0; i < ARRAY_SIZE(nf_nat_ipv6_ops); i++)
 		nf_nat_ipv6_unregister_fn(net, &ops[i]);
 
-	kfree(ops);
+	kfree_rcu(ops, rcu);
 }
 
 static int ip6table_nat_table_init(struct net *net)
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 83b2b5e9759a..74ec224ce0d6 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -1222,9 +1222,11 @@ int nf_nat_register_fn(struct net *net, u8 pf, const struct nf_hook_ops *ops,
 		ret = nf_register_net_hooks(net, nat_ops, ops_count);
 		if (ret < 0) {
 			mutex_unlock(&nf_nat_proto_mutex);
-			for (i = 0; i < ops_count; i++)
-				kfree(nat_ops[i].priv);
-			kfree(nat_ops);
+			for (i = 0; i < ops_count; i++) {
+				priv = nat_ops[i].priv;
+				kfree_rcu(priv, rcu_head);
+			}
+			kfree_rcu(nat_ops, rcu);
 			return ret;
 		}
 
@@ -1288,7 +1290,7 @@ void nf_nat_unregister_fn(struct net *net, u8 pf, const struct nf_hook_ops *ops,
 		}
 
 		nat_proto_net->nat_hook_ops = NULL;
-		kfree(nat_ops);
+		kfree_rcu(nat_ops, rcu);
 	}
 unlock:
 	mutex_unlock(&nf_nat_proto_mutex);
-- 
2.47.3

