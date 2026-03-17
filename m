Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D84283ACEF3;
	Tue, 17 Mar 2026 11:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773746983; cv=none; b=qrza8tFU9VwVBEwAcJmaBAeA+WgQFLme5HIFWdxLz60T/wUO8+E0AY3KADdU7NWlPHXioPafL9WEWn549BPc2F+xEbi8WGaaLkqFx/hBe3fz9QZNi4/othFz07ZClz8vSklfO421+XpyaqMdvBldAfL121Z3N9F/1o28XJ0DXCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773746983; c=relaxed/simple;
	bh=tKMqxvTRH4wqN4JrBzwAD+sc/KwUqV/BZUeep420cCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=al9FGRXJeS+PVjwphs9DdMcIsQg8jajLs2w67+m9EysIu6EjRM3agBM9yMujrtVjAYQyS9Im04ij4QjKGyOfqqRpYRuwCxD3w5DMkswpo/uMMHgQ1jg0I9Yk8CleIRdb5U3OFHDQVdAL/eZx0VyK3FapvC0euZ3gL6EutaYgb7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=qvqWW8lx; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="qvqWW8lx"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 997BF60255;
	Tue, 17 Mar 2026 12:29:33 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1773746974;
	bh=UxkmvgYEomF6uRtx2p2M1yNkphkg9Tt1YYicgeOiejU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qvqWW8lxItKME9W4RSCK+jHJcUu9cxUbV0X5KsPJQQOe5es+gKiYmYCTP6TaM1Ky7
	 Xv4dbEiGGupL3kPEz5t3zM+2OBvEtaNcyWitffFGSUYIpLlz5i/tNcOjTfKaiDv90K
	 vOKAwuDjFv/RqgsQuHXb8SsCsFVuG8WnBIskkOgSwpgnn8hPWyhIzloUo9fjRtMnSm
	 oS/wcoB12m1pZ6PEGYi5frSskRCSCM/NvW4w07bXKGjPI5BuY/39fMLlpnUTi1De0e
	 kKGeoJYIaeOt13rnkvqQjIG7vpD+q19VpPgvgGRA2/h1Q81t8YcXUpUT9q/eHv8j+t
	 f8O0BqO2nJZvw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org,
	steffen.klassert@secunet.com,
	antony.antony@secunet.com
Subject: [PATCH net-next,RFC 3/8] netfilter: nf_tables: add flowtable early_ingress support
Date: Tue, 17 Mar 2026 12:29:12 +0100
Message-ID: <20260317112917.4170466-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260317112917.4170466-1-pablo@netfilter.org>
References: <20260317112917.4170466-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update control plane to allow to create a flowtable in the early_ingress
hook.

Co-developed-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 1ed034a47bd0..66fadf4c6e3e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8969,7 +8969,8 @@ static int nft_flowtable_parse_hook(const struct nft_ctx *ctx,
 		}
 
 		hooknum = ntohl(nla_get_be32(tb[NFTA_FLOWTABLE_HOOK_NUM]));
-		if (hooknum != NF_NETDEV_INGRESS)
+		if (hooknum != NF_NETDEV_INGRESS &&
+		    hooknum != NF_NETDEV_EARLY_INGRESS)
 			return -EOPNOTSUPP;
 
 		priority = ntohl(nla_get_be32(tb[NFTA_FLOWTABLE_HOOK_PRIORITY]));
@@ -9008,7 +9009,14 @@ static int nft_flowtable_parse_hook(const struct nft_ctx *ctx,
 			ops->hooknum		= flowtable_hook->num;
 			ops->priority		= flowtable_hook->priority;
 			ops->priv		= &flowtable->data;
-			ops->hook		= flowtable->data.type->hook;
+			switch (ops->hooknum) {
+			case NF_NETDEV_INGRESS:
+				ops->hook	= flowtable->data.type->hook;
+				break;
+			case NF_NETDEV_EARLY_INGRESS:
+				ops->hook	= flowtable->data.type->hook_list;
+				break;
+			}
 			ops->hook_ops_type	= NF_HOOK_OP_NFT_FT;
 		}
 	}
-- 
2.47.3

