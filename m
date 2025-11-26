Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 647D2343D9E;
	Wed, 26 Nov 2025 20:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764190589; cv=none; b=JqV9T1ty1sh59rUaPGdHCFlP97e5sIv09IUVBjKLXlj8gQyLZitFFhH+rauIUZ9Pr3oXenAmDMvfpywzfioYPWS9QKTECXb2V9B0oSDf2wUp5fP34V9j1S9Ge5zlnwEK9E+990RgIgBFBl8O4USQ9s9ogcg3ClfkrbuIESnYtzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764190589; c=relaxed/simple;
	bh=d+YMRAlaPGI/N92k1fyvZcFW6F6hM87s0LGwZ3IdaEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sTVqzOg3VjRfx7S9aShOB6+3JB82QXge90hHxcMC85pL0B0LcFNePx6fDGoZrKFscYpaqxDrIz3R5wzDqfWU1zZplLMgZ9N8t1+oS3sUKYruXOSNHsgySJtYwoAi/M66x1zv42buzlXGHNKLILDKGpKp1g2DPmGgi602z3l/fLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=h230qCHG; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="h230qCHG"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 500CE6026F;
	Wed, 26 Nov 2025 21:56:25 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1764190585;
	bh=PAtB0N3hfz4c/ip9IXAT42kKp6virYn4qwwKaVuATCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h230qCHGFwOPmv1nKwUpZTR2pEp9ZOKEYD41pGCPd8RJ5hJzhB8YQLZJZzw5/Z3N/
	 dcs1gtpwTLvBzEERjugLvJwOWQIzHU8cCxSnVDL+DKqU3BMruIuNZWV/NhwGb26VXv
	 dYCQxm0/OfNSxBGVd1mXUaj5o+69bSvOHqJjsi6ivrjSngUXoUnxa4JFIfPi/X2Qnh
	 fQ7DUO76wrN7TsSJC9xNyEmvL71DY5tjF7NOV9RasinJQtCIgGAtfYF8E3+bo9HUvF
	 qyMXgudONmbJD5xyuL3oDvNgoKa9OELycJr68UOB/Xi2ApKv/yXWEIunoKFUB2ylHn
	 6gEEo861IIeOQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 04/16] netfilter: flowtable: inline pppoe encapsulation in xmit path
Date: Wed, 26 Nov 2025 20:55:59 +0000
Message-ID: <20251126205611.1284486-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251126205611.1284486-1-pablo@netfilter.org>
References: <20251126205611.1284486-1-pablo@netfilter.org>
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
index a4229fb65444..61ab3102c8ec 100644
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
index 1cb04c3e6dde..7ba6a0c4e5d8 100644
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
@@ -154,9 +151,7 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
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

