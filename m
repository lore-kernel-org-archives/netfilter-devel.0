Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08CF814A4F0;
	Thu, 16 Apr 2026 13:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776345313; cv=none; b=eY+OioVwKvHbxwqMHnU+wK9Q93xCwKTTp9NimHr9pnAS7jA92FcPsGlIntc98e2uTO8N8+5374Z18lUBJz6JxQXutCaw6G5ExZdO9JHk9aNhC8QHMaCLQBLjeZSmZLAAUDL+L/npo2St/RRxrb9+0BPi0GDz8nDmXr5DSPNGPj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776345313; c=relaxed/simple;
	bh=qeMJhnYimVlICJ5eTnyKmjZw7xRdiqN4RqTkKuKW6j8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U4+KUwh0sJjtkNbUkD4fv89xylpElM32E/ac/9je++B+P9X+WWKGREUHvSOtFX/qCFFm3JF96LwE28VUo/GxCMAVBVbSnthcOel6umBWYuuCayt8P5ZMfzPRVbI/v45mfv2PBlkz5IDdf6MxejXd50tWI5QWBDtiWXyoDjwdyWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Fw03q+8R; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Fw03q+8R"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D2E2960254;
	Thu, 16 Apr 2026 15:15:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776345310;
	bh=1b6i10nqRPpCr482KhE186G03DU2qm9L1tneVbMcDng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fw03q+8RcxtyOSLKZTg+yM7ZA3UMnjHEUwfi199xOB/0vcaOb5DY4EmCz/x1Ci7Cj
	 38JCvi6mHMf2ThyjY8zw8gCdqo3QI2IJ3COO+/nyH27mojW5aRBpU21/AUMowAIzqJ
	 GEDADUtK+qWnMI3G7kqTe6O5PiOjHncX/ls84Q4ExhChVyp/jZtsHXAqg0SQWcqhyU
	 tAm+435xqZjCEK20Id9P1K9w7lU8PPgdp0XDt86x5IfunAEMAk9+IQmdd+lwph5YQL
	 +prnnMrEgWXi6GdL2R3cq/H3HRjflotwKMHJLJmLryO/vdbwyOO0zwRIGxM6TXxlfW
	 GKjBAiQUBNH+A==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 07/11] netfilter: nat: use kfree_rcu to release ops
Date: Thu, 16 Apr 2026 15:14:49 +0200
Message-ID: <20260416131453.308611-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260416131453.308611-1-pablo@netfilter.org>
References: <20260416131453.308611-1-pablo@netfilter.org>
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

