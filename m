Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A972821CC5C;
	Fri, 28 Nov 2025 00:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764289443; cv=none; b=J74++LZkBHkLjK1OahyD95jH01t6KTtKN0y4VDIq2zdn81jUgQWBqEk53ObRd9+CJknHxO7l+5+DGRUDdZmAku6G4WX41nd/5BW5tOEKlHLWHqKOEqg99SO15HBr4Yv3K5Hg4UvJTGVaBrPMUOeJNBS3kJaAwJTX8NIjwVCOaxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764289443; c=relaxed/simple;
	bh=eIxUXbFZYi7HFJ46Etisg+wN4Uc3ukRtWwaUORL83SQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qec6fJII0TCSzEjKmitsAh7pXB3PspSyiJnqtijDZxASYbWboTVCtg5xiBef2vclpQLiGbI22Yqh/BLLGTaQfyCgCvXAHaMtVG3eblRnPKvdcL0GJjaSZhzZl69f1ncapLIPGLnVMStkGTYaIqtyc3NwlmeRlxP1htN0wT+e4wU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=O/AJwj/m; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="O/AJwj/m"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id CB33860278;
	Fri, 28 Nov 2025 01:23:55 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1764289436;
	bh=z7U48L2uJMWSnsyaie5RXe20Lx+GEK650qKDmerFMtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O/AJwj/mP8rHTombapG4c1GYLaEYXFwub5UmyRg5xyx1VcyPwgcaUebVeI0DNCnCM
	 cYVDBG//EHIvfMI9oZUyIVH2Uv35ORsTsnr+OkcESmG6/Ce3/uC9/yUHWIdUW6d9no
	 KfBDhYk4dL2yBhgBawIJrcwG20xSceCw1NKliWcQCcHQe0OySkqBKSafovo7fe6b71
	 MMAlkRKQjOYV/4S+LBgLqee07HBwKmhK/YYaDPzGO4wrtdG2ELRxNb82pDsBjNLu+Y
	 mEp9Lmkl+8hq3j0E7WIN9FQlMaPamrRK2TzcgdP9XZW07RZ6rMmUW3NFk0CkqFI1yY
	 Ge+dy7eoDtLxw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 05/17] netfilter: flowtable: inline pppoe encapsulation in xmit path
Date: Fri, 28 Nov 2025 00:23:32 +0000
Message-ID: <20251128002345.29378-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251128002345.29378-1-pablo@netfilter.org>
References: <20251128002345.29378-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Push the pppoe header from the flowtable xmit path, inlining is faster
than the original xmit path because it can avoid some locking.

This is based on a patch originally written by wenxu.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_ip.c   | 42 ++++++++++++++++++++++++++++++
 net/netfilter/nf_flow_table_path.c |  9 ++-----
 2 files changed, 44 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index aef799edca9f..ee6ec63257d1 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -413,6 +413,44 @@ static int nf_flow_offload_forward(struct nf_flowtable_ctx *ctx,
 	return 1;
 }
 
+static int nf_flow_pppoe_push(struct sk_buff *skb, u16 id)
+{
+	int data_len = skb->len + sizeof(__be16);
+	struct ppp_hdr {
+		struct pppoe_hdr hdr;
+		__be16 proto;
+	} *ph;
+	__be16 proto;
+
+	if (skb_cow_head(skb, PPPOE_SES_HLEN))
+		return -1;
+
+	switch (skb->protocol) {
+	case htons(ETH_P_IP):
+		proto = htons(PPP_IP);
+		break;
+	case htons(ETH_P_IPV6):
+		proto = htons(PPP_IPV6);
+		break;
+	default:
+		return -1;
+	}
+
+	__skb_push(skb, PPPOE_SES_HLEN);
+	skb_reset_network_header(skb);
+
+	ph = (struct ppp_hdr *)(skb->data);
+	ph->hdr.ver	= 1;
+	ph->hdr.type	= 1;
+	ph->hdr.code	= 0;
+	ph->hdr.sid	= htons(id);
+	ph->hdr.length	= htons(data_len);
+	ph->proto	= proto;
+	skb->protocol	= htons(ETH_P_PPP_SES);
+
+	return 0;
+}
+
 static int nf_flow_encap_push(struct sk_buff *skb,
 			      struct flow_offload_tuple *tuple)
 {
@@ -426,6 +464,10 @@ static int nf_flow_encap_push(struct sk_buff *skb,
 					  tuple->encap[i].id) < 0)
 				return -1;
 			break;
+		case htons(ETH_P_PPP_SES):
+			if (nf_flow_pppoe_push(skb, tuple->encap[i].id) < 0)
+				return -1;
+			break;
 		}
 	}
 
diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
index 38ebda1afdce..c51e310bb2ab 100644
--- a/net/netfilter/nf_flow_table_path.c
+++ b/net/netfilter/nf_flow_table_path.c
@@ -122,11 +122,8 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 			info->encap[info->num_encaps].id = path->encap.id;
 			info->encap[info->num_encaps].proto = path->encap.proto;
 			info->num_encaps++;
-			if (path->type == DEV_PATH_PPPOE) {
-				if (!info->outdev)
-					info->outdev = path->dev;
+			if (path->type == DEV_PATH_PPPOE)
 				memcpy(info->h_dest, path->encap.h_dest, ETH_ALEN);
-			}
 			break;
 		case DEV_PATH_BRIDGE:
 			if (is_zero_ether_addr(info->h_source))
@@ -161,9 +158,7 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 			break;
 		}
 	}
-	if (!info->outdev)
-		info->outdev = info->indev;
-
+	info->outdev = info->indev;
 	info->hw_outdev = info->indev;
 
 	if (nf_flowtable_hw_offload(flowtable) &&
-- 
2.47.3

