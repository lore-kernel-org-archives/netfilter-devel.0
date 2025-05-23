Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7272920BE;
	Fri, 23 May 2025 13:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748006881; cv=none; b=JmaW5zZJreZIxnCh1+6F9iBbSMTfc381NpAPHmC+A/JeH2xBgR470nM+jI+6QSBdRPXrmTYbO/whn/+GUUH0/mN/Nh9sQSAuSr3boSKLl8WD3kjsRMinNxArL7RVAO4fHxpVMU+E2K/qU5mVQOyv+r3MjoBVLtQcaNgf/BioKhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748006881; c=relaxed/simple;
	bh=CW6EoAO2gf8HRSWmIs9RYh0vZn4bXOh33+j+W0/2nug=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MDnbPWOSCmPPmCdVQoXKS2BRJ/slfQC2HZ2S1NgPITHD30o1MDGIJfBu0C0vNlRWhZAJHAGpyk4+fuXm4w/YGHESyUB83euhDOdoXf5nWgXR35PIszLhMA8tZQeS5J5DLvvPGy9BxQ/pO7nIL8aa5QSb5CBWx/mUX8xZu1ff1Ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=h4ogb0k7; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ZD8UurAI; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="h4ogb0k7";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ZD8UurAI"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 5DEC1602B6; Fri, 23 May 2025 15:27:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1748006878;
	bh=3hJ1ICFvaiIoo7clLaQ8Yz0R7kbbGHQ1T5gQo5PH7Mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h4ogb0k7mA6YzrZS6hd2nwxcA+pt65cUJDhYVizPwCmhT0VS5YJ7ylax3PK1Ba5sd
	 REIcPu3wTHogATTQVjlFv7nJio6Ep5/SUmq/QOhmbopOOIznnaWgHyrKGeEWBPR/ui
	 bF7Mj8adalipAXr26ozmDhzSGZXmr7JSiBl+rmWoZTRttqHa/JF/15rmztlkU3S3Vd
	 Tvv3acOwy72aD3JsOeZdMcIOGj7UwhFcOLWTDvS7lFlaflqP+Vvl6VGtLh0l+nchIH
	 pJIkTwupcsVYs+Rvg6uEFjqKEBEaMUHMv2XAwpvH2CmDMMl9RMoPlzRcoeYIXgzxfM
	 n030YrEj58QTg==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 89DF660767;
	Fri, 23 May 2025 15:27:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1748006850;
	bh=3hJ1ICFvaiIoo7clLaQ8Yz0R7kbbGHQ1T5gQo5PH7Mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZD8UurAIEPN6jtJh8vSujPRV7s078BuTEiu0pTYuMn14v14K48VwGr9PIrF3cUshR
	 XRR/HIrYyn1oV80b1ssxI0vI0mWsflPNMtE9fEn/A2hYAOIXLFt5Qmr9xj+GmYrJNl
	 ChC/gaFiskx3UMytksnt6p2qfdpZc3uqWnbVX8/BXrDyyaWO1NQT6qn6t61KqQZwAM
	 trRwF0mBijbxOjO3/dxsCD4S4XYp1mjWVb70nhMNDWfja14JtSBisjWIkqD4Xs3YMA
	 CrfD0XhX1VxdSakjc+J9ayeyJx6Hsa0+xoKUbsP7nR0IXeYXcBc7YtVy5cx8ORebO/
	 b0CQggkd4mqXA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 16/26] netfilter: nf_tables: Introduce nft_register_flowtable_ops()
Date: Fri, 23 May 2025 15:27:02 +0200
Message-Id: <20250523132712.458507-17-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250523132712.458507-1-pablo@netfilter.org>
References: <20250523132712.458507-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Phil Sutter <phil@nwl.cc>

Facilitate binding and registering of a flowtable hook via a single
function call.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c5b7922ca5bf..a1d705796282 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8929,6 +8929,26 @@ static void nft_unregister_flowtable_net_hooks(struct net *net,
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
@@ -8949,20 +8969,10 @@ static int nft_register_flowtable_net_hooks(struct net *net,
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
2.30.2

