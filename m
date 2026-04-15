Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7375D2F6577
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Apr 2026 11:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776252190; cv=none; b=C4h05L+hrtUqAQ8GIz01ywbU8zSKMPLUmU87ndcPPB3mY1rTUY5GefArO9UtjFo9Ezwh6lsoNVlCX2tNZqiob76mN7lsN3sZ0CI0ONPEJU8MhSqxY2BqiBrai2rjrfpivz7eK69/1tQVeF8igEajUlkORYqPwbP0MHnP/TXPq20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776252190; c=relaxed/simple;
	bh=ese4KL1cZ/fYrN2DLPWDiKmaNzglK/zawukkVBaWvS4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=brQV5pmsJLuD4lCzHGmB+JzjmStYMHTr/ZezmCM2r/UUqF1jf4lGsRL3mUJ9ayztxQ79ZZj3WFlaGgvDAeAu7O8xNZ6sRwY9CQ8ctyBGZQyTKmuHuRx4OP7A3XQdDLvAJjheAt9xCw1JI5awLqYpkYu1IGEBBdDMk1TAdlS0bhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=XwjKNfZK; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="XwjKNfZK"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 8EE3260251;
	Wed, 15 Apr 2026 13:23:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776252187;
	bh=wmCVkHPlvIY4JYSmG/tLFbeO88ORvF4+DU/pnnD3HYE=;
	h=From:To:Cc:Subject:Date:From;
	b=XwjKNfZKJSNxGpsIuf8sX2x4aIDD6QHMYOpjaxVk2BiqjC5XXCwNPzCG8FROz1zWl
	 Elsj/woZ+OkT1DhlIL1D3sdaJC4fFuss2jFIyquNz2MRdYm25FNb7XmTZCROyQVgZT
	 T06EfPx/PbTW644gPNbZyODyqGGALSdAP7pyhK4IYY4Pa+UXJJhN4stOCSfhbPClA0
	 +XVNFWcGxkS79Wx9Dg4mBtREbKLYgTUPyynbqb2f5wXC3W92oehcjQc/s9No0yVZwf
	 020yuFm+T/NmKZnFYQjDQPwyUQk062iNMxbT6hs0XydL1zkRAntB2mA/g9JTusUMur
	 AjcBr4rP3M0Iw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf] nnetfilter: nat: use kfree_rcu to release ops
Date: Wed, 15 Apr 2026 13:23:03 +0200
Message-ID: <20260415112304.59615-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Florian Westphal says:

"Historically this is't an issue, even for normal base hooks: the data
path doesn't use the original nf_hook_ops that are used to register
the callbacks.

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
 net/ipv4/netfilter/iptable_nat.c  |  2 +-
 net/ipv6/netfilter/ip6table_nat.c |  2 +-
 net/netfilter/nf_nat_core.c       | 10 ++++++----
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/netfilter/iptable_nat.c b/net/ipv4/netfilter/iptable_nat.c
index a5db7c67d61b..3b1de7f82bf8 100644
--- a/net/ipv4/netfilter/iptable_nat.c
+++ b/net/ipv4/netfilter/iptable_nat.c
@@ -100,7 +100,7 @@ static void ipt_nat_unregister_lookups(struct net *net)
 	for (i = 0; i < ARRAY_SIZE(nf_nat_ipv4_ops); i++)
 		nf_nat_ipv4_unregister_fn(net, &ops[i]);
 
-	kfree(ops);
+	kfree_rcu(ops, rcu);
 }
 
 static int iptable_nat_table_init(struct net *net)
diff --git a/net/ipv6/netfilter/ip6table_nat.c b/net/ipv6/netfilter/ip6table_nat.c
index e119d4f090cc..9adfbfeaab0c 100644
--- a/net/ipv6/netfilter/ip6table_nat.c
+++ b/net/ipv6/netfilter/ip6table_nat.c
@@ -102,7 +102,7 @@ static void ip6t_nat_unregister_lookups(struct net *net)
 	for (i = 0; i < ARRAY_SIZE(nf_nat_ipv6_ops); i++)
 		nf_nat_ipv6_unregister_fn(net, &ops[i]);
 
-	kfree(ops);
+	kfree_rcu(ops, rcu);
 }
 
 static int ip6table_nat_table_init(struct net *net)
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 3b5434e4ec9c..b30ca94c2bb7 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -1228,9 +1228,11 @@ int nf_nat_register_fn(struct net *net, u8 pf, const struct nf_hook_ops *ops,
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
 
@@ -1294,7 +1296,7 @@ void nf_nat_unregister_fn(struct net *net, u8 pf, const struct nf_hook_ops *ops,
 		}
 
 		nat_proto_net->nat_hook_ops = NULL;
-		kfree(nat_ops);
+		kfree_rcu(nat_ops, rcu);
 	}
 unlock:
 	mutex_unlock(&nf_nat_proto_mutex);
-- 
2.47.3

