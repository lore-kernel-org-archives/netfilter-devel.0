Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9BCE1272A6
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Sep 2024 10:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726222839; cv=none; b=MpKcFcVkvQwR8gOCNLgD9TBYIMB0uw9rlNpX42/Fy5VGKH05Jv8tJoR+kknDkZDhfP520URl5TijdFQdjqArj1cfnslslGqkeN30OOXEO0qMlluO989K20zlDjNJt0eVS00BVc4bs8z40J+3+asDim3Tic1nxxhXVVE5R5MkOXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726222839; c=relaxed/simple;
	bh=dHnt1p3WXz14t+0xciY+pxeGUIuLcByYpm6QwWgEC1Q=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=F+HxFyFbUhSECBwIgYd/vsR2bTmgOJ4binYq0QRhfH2buhU5XLFEmmJCCCG1TJQDwdijN9WIP24AjjjIzJ26zCPbNnOFPC8HZf5feuPnI1ZQZxCcsvudQHvL2jiPYuHMbfsFMBwJ9bcpAVHhqtyDTLnIPAvbjZ7ZM5eZ/vuAvhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: antonio.ojea.garcia@gmail.com,
	phil@nwl.cc
Subject: [PATCH nf] netfilter: nft_tproxy: make it terminal
Date: Fri, 13 Sep 2024 12:20:23 +0200
Message-Id: <20240913102023.3948-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

tproxy action must be terminal since the intent of the user to steal the
traffic and redirect to the port.

Align this behaviour to iptables to make it easier to migrate by issuing
NF_ACCEPT for packets that are redirect to userspace process socket.
Otherwise, NF_DROP packet if socket transparent flag is not set on.

Fixes: 4ed8eb6570a4 ("netfilter: nf_tables: Add native tproxy support")
Reported-by: Antonio Ojea <antonio.ojea.garcia@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_tproxy.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nft_tproxy.c b/net/netfilter/nft_tproxy.c
index 71412adb73d4..f3b563c379d8 100644
--- a/net/netfilter/nft_tproxy.c
+++ b/net/netfilter/nft_tproxy.c
@@ -74,10 +74,13 @@ static void nft_tproxy_eval_v4(const struct nft_expr *expr,
 					   skb->dev, NF_TPROXY_LOOKUP_LISTENER);
 	}
 
-	if (sk && nf_tproxy_sk_is_transparent(sk))
+	if (sk && nf_tproxy_sk_is_transparent(sk)) {
 		nf_tproxy_assign_sock(skb, sk);
-	else
-		regs->verdict.code = NFT_BREAK;
+		regs->verdict.code = NF_ACCEPT;
+		return;
+	}
+
+	regs->verdict.code = NF_DROP;
 }
 
 #if IS_ENABLED(CONFIG_NF_TABLES_IPV6)
@@ -147,10 +150,13 @@ static void nft_tproxy_eval_v6(const struct nft_expr *expr,
 	}
 
 	/* NOTE: assign_sock consumes our sk reference */
-	if (sk && nf_tproxy_sk_is_transparent(sk))
+	if (sk && nf_tproxy_sk_is_transparent(sk)) {
 		nf_tproxy_assign_sock(skb, sk);
-	else
-		regs->verdict.code = NFT_BREAK;
+		regs->verdict.code = NF_ACCEPT;
+		return;
+	}
+
+	regs->verdict.code = NF_DROP;
 }
 #endif
 
-- 
2.30.2

