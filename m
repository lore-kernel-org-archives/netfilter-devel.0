Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE4F312832
	for <netfilter-devel@vger.kernel.org>; Fri, 10 Apr 2026 11:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775821315; cv=none; b=qRkteQatIE867scqTgYsUKz+ITTeK8h3cVRQKUfUeqA2EF1xJpMrsuh6wXDQourKOsQoncWYrCUzk4OLn9bqGdA4XipOwgCHvBLu8GuSrPkiRkiCPT86WNWB3qaCU29I5ByjUTwtGxEFiXhIvjtOPv2WnaqKPWLyMpusQGApCs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775821315; c=relaxed/simple;
	bh=FSX0U4E9Ywv9e5U4nRaUtDh5Jpuxs5Ql9zSAIOIN0lI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GFi2Tbc8XR5TRL4ItI7ddl59NUVjmoxSMbhHoEkM+sgqhRQ3hTLm8TT+TBSVyOZXbX5A/2TUifQygfVbFu67tokTZoavO84aUR+yS5I0BrilHHK8pFr82xPpSt9q+NO0KRdrAQwkaexGyhgUTEyn+9v52xGAgGM6VT2+kVGvXzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 8232E60CFA; Fri, 10 Apr 2026 13:41:51 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next] netfilter: nat: switch release of ops to kfree_rcu
Date: Fri, 10 Apr 2026 13:41:38 +0200
Message-ID: <20260410114144.10785-1-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Historically this is't an issue, even for normal base hooks: the data
path doesn't use the original nf_hook_ops that are used to register
the callbacks.

However, in v5.14 I added the ability to dump the active netfilter
hooks from userspace.

This code will peek back into the nf_hook_ops that are available
at the tail of the pointer-array blob used by the datapath.

The nat hooks are special, because they are called indirectly from
the central nat dispatcher hook.  They are currently invisible to
the nfnl hook dump subsystem.

But once that changes the nat ops structures have to be deferred too.

Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 @pablo: route via nf if you prefer, in that case you can
 add:
  Fixes: e2cf17d3774c ("netfilter: add new hook nfnl subsystem")

 But as explained above, I don't think its a problem for current
 nf/net; the nat hooks are currently not dumpable from nfnl_hook.

 net/ipv4/netfilter/iptable_nat.c  | 2 +-
 net/ipv6/netfilter/ip6table_nat.c | 2 +-
 net/netfilter/nf_nat_core.c       | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

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
index 3b5434e4ec9c..e8beefa503e5 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -1294,7 +1294,7 @@ void nf_nat_unregister_fn(struct net *net, u8 pf, const struct nf_hook_ops *ops,
 		}
 
 		nat_proto_net->nat_hook_ops = NULL;
-		kfree(nat_ops);
+		kfree_rcu(nat_ops, rcu);
 	}
 unlock:
 	mutex_unlock(&nf_nat_proto_mutex);
-- 
2.52.0

