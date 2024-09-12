Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F08F91A4E82
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Sep 2024 12:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726145107; cv=none; b=TWaeuGhuGJ6w4Oz9PZPsmsALheHUH2K9LF7um8YTWyGaWKKe1CjPX0EjOaa7zpzJoO2rbZVGumvzV606xLA4pPpYGZshgJKLNLFB+lp2VnoYAdZ7i89OYg3S9662Mnz6eNJVV43hRWnfKADdn+ETP3HQgLvZ4RBjfFfKlF9ClEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726145107; c=relaxed/simple;
	bh=hhs3AB7xr8GEOvvGtNfVShR54TM8BhU06E72WFmePXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uCO3z7l/XoXV98fXmXA8rK7ksP3xx7L/IsUHslD8WLqhyW4ru5PCWEAVjTITPdTWsu+VhwV6eOJXRAIRtzFPlPAyziKp7mfeBZjh8v0S+xCr8Z9wWnHlydUoMaL6C2L9QnCaVC0Fwm32wW4HOiDdFa6Yz4/wzBDKHcJqdjHuXOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=R3Vq1yIz; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="R3Vq1yIz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=GpldQ7V92cEGbZprVddzneLP7c70VnhTrE/ruGY3pKM=; b=R3Vq1yIzgsLaq0uB2Oy1srMekl
	PnGDOUaS9sw1d1L9CPQx+xPaWtJKMG2stF3hYpxUmiaNWB6dcE9O8Lz4vKqjvxRzda3WIMMdL6wqw
	CY46hOw/0yJvUBuZ0MAb85TP6H343HMTzIPw3xAD+OJffOgaqeXvySdNXn5XUIwxhz7KjV7srO7A2
	YV+Bmu6g9C0T69U8uCk7s5puSUV403LiteGByOAdHLAg8yuWRLfGn+8UctjbdTtiEaOOdAWvLrwNu
	xH1q0m7QYj4pNKLnHvIcl1cqrfpvFrGBYILXVPzk1iyFi/QNkUWY2KQs4aLgjl0Ou7FWtIQVXy0mc
	RHtvGnDg==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1soipc-000000004D7-3Z3A;
	Thu, 12 Sep 2024 14:21:52 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: [nf-next PATCH v3 09/16] netfilter: nf_tables: Introduce nft_register_flowtable_ops()
Date: Thu, 12 Sep 2024 14:21:41 +0200
Message-ID: <20240912122148.12159-10-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240912122148.12159-1-phil@nwl.cc>
References: <20240912122148.12159-1-phil@nwl.cc>
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
index 65db4c54cfae..dc30d2be09fb 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8550,6 +8550,26 @@ static void nft_unregister_flowtable_net_hooks(struct net *net,
 	__nft_unregister_flowtable_net_hooks(net, hook_list, false);
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
@@ -8570,20 +8590,10 @@ static int nft_register_flowtable_net_hooks(struct net *net,
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
2.43.0

