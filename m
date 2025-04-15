Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C7A2DFA29
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Apr 2025 15:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744731900; cv=none; b=LzyGPchs6hKwdS84FBcLGolvZvE0WoVg/jsKOPRsThaQEYC8ieqvz8w8Iq8o3r8R9ugBKMLq2OmwH69FBev/tc1M1bcLLAUlcI0NbUApiwT4WUW9n+R/YAkn4IRUDzLr5Tk7EXABO74sP+rd4jMhD3rNmi3ZFdatLyPHMvrAGsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744731900; c=relaxed/simple;
	bh=FxNOYM4+zJLxwRtEckiu8f73/IrWVxw/IGf9ppDagxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H00ro/Bsmpha0KvyAcTSAvbiKChHAQyaM36lAUcogQlKSr9iJ851dWkQ0EIOpoRxBvbiM3T3xUpu/TclcQABaJKxnPJk1D52y5qtCucavehBd80R9HEKWdWFyP1alBdvb4sFv0Q1ysBybkaY9kwQADEan5+SG/P943mV8KbTsls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=InNl5ENN; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="InNl5ENN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=3TVtC3/1YDY4PuCYfPH6bgyh4iKDsDrxSzpSMiNVSxo=; b=InNl5ENNn+qegdwqiQb4+W4+p9
	+CDvpmHCUzgSyHEAA9jaLN1HoaTGCzOphquwpHNvGcaA/GrS1RamLneBdL8juGk1uyz9vZdefZ6qp
	ia6Emn76EW+MYv8a4icNgmxcBeeHugX5MhcybWtmG2BhbxE2liL3a1KEG+Z9Jt+YZWOvZMRD4+ohh
	P/YQ9qDcUi7XChzvTJlGsVguG9SwWYtpMhKhFz09QYe1f9NkkUCI5aQ+qsKfkAEt85IfmyBCNPw6K
	sHRAdhnxcRNbUoQPTz4BmWTliMMGeSrQz3wGSvSuBmDSFfNyORHVjjaL/lOhkNAjae3mV/zau8y84
	/zbPeZSA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1u4iSx-000000004yM-26Mx;
	Tue, 15 Apr 2025 17:44:51 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v6 03/12] netfilter: nf_tables: Introduce nft_register_flowtable_ops()
Date: Tue, 15 Apr 2025 17:44:31 +0200
Message-ID: <20250415154440.22371-4-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250415154440.22371-1-phil@nwl.cc>
References: <20250415154440.22371-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Facilitate binding and registering of a flowtable hook via a single
function call.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_tables_api.c | 32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 3e7a6b65177f..bc205114527a 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8903,6 +8903,26 @@ static void nft_unregister_flowtable_net_hooks(struct net *net,
 	__nft_unregister_flowtable_net_hooks(net, flowtable, hook_list, false);
 }
 
+static int nft_register_flowtable_ops(struct net *net,
+				      struct nft_flowtable *flowtable,
+				      struct nf_hook_ops *ops)
+{
+	int err;
+
+	err = flowtable->data.type->setup(&flowtable->data,
+					  ops->dev, FLOW_BLOCK_BIND);
+	if (err < 0)
+		return err;
+
+	err = nf_register_net_hook(net, ops);
+	if (!err)
+		return 0;
+
+	flowtable->data.type->setup(&flowtable->data,
+				    ops->dev, FLOW_BLOCK_UNBIND);
+	return err;
+}
+
 static int nft_register_flowtable_net_hooks(struct net *net,
 					    struct nft_table *table,
 					    struct list_head *hook_list,
@@ -8923,20 +8943,10 @@ static int nft_register_flowtable_net_hooks(struct net *net,
 			}
 		}
 
-		err = flowtable->data.type->setup(&flowtable->data,
-						  hook->ops.dev,
-						  FLOW_BLOCK_BIND);
+		err = nft_register_flowtable_ops(net, flowtable, &hook->ops);
 		if (err < 0)
 			goto err_unregister_net_hooks;
 
-		err = nf_register_net_hook(net, &hook->ops);
-		if (err < 0) {
-			flowtable->data.type->setup(&flowtable->data,
-						    hook->ops.dev,
-						    FLOW_BLOCK_UNBIND);
-			goto err_unregister_net_hooks;
-		}
-
 		i++;
 	}
 
-- 
2.49.0

