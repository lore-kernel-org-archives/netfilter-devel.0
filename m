Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6686A228CBC
	for <netfilter-devel@vger.kernel.org>; Fri, 10 Oct 2025 11:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760095129; cv=none; b=KEmCMLirfSQLLT+QgfZ+3XugXthj4uuyHUkD55lgLi8RMh6k5jtA7zQnSuE1U6HxMh3lCSdD2DzQCpNkCJYuNmPhJ+9NAwRn+z10rMslg1pvZ3+6TCIQz7CU0K0ax3VWP2E5osnWcmbdCJbloCaR4nLfp8urK7ignCmNAuomi6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760095129; c=relaxed/simple;
	bh=GAStAEE1DPlrINfhqZ4FQXOlGZnhtA9nsgixXjmLvOs=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aaun0DcW2Bo70cfccsyRN2GLZFij8+3/9Pz4RSreBslX0N6Ru+s7mb60e0kX4mYcT4MDf6uxc0TFXyVTz1CkmS2LL5VYIPG/rwEFiwyNqrWF0iDK9JI2Mx/bMHiq2AyvKK2fZPhX2744PbZk+PBowRIvm6TLVYVixS3Wzn+Z83U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=o9OHhnFv; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=o9OHhnFv; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="o9OHhnFv";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="o9OHhnFv"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 8D9ED602AA; Fri, 10 Oct 2025 13:18:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1760095119;
	bh=8X/YnvobS/rU8qw1LBSlMNzPHLPBd6nxaywCfF/beCU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=o9OHhnFvpP0MfGBDNYN7ZxQmJEdGDDWdiYqQV+wRxdMGxl0adCCurnsWn0mR803FA
	 t5fGvSSUE4cB45nn1sbtCAa9we+UYsE+qvMPf0SgRgctmQx84UmVmUKQzl3ieBsJVU
	 Apg7G3HBCqIU2axeuTXM47/kEv+R1WR57pyz7gCk9Q1/j+Ci5AMvLftaMxjGVsSIm2
	 hwrqvV65+/cwsVr9XsWCJ8Mhr6+CtP4GaLBwB25sXXcUBhMCvYMlkLcvXpH0cTiNyF
	 i1boqePpYoSkQmiIqRedxOOjPoONEMOFzVnobr6pvEbAkTZUbjyfXr8l6+9zTvr+t4
	 MdoHoO6hnt9WA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 28937602AC
	for <netfilter-devel@vger.kernel.org>; Fri, 10 Oct 2025 13:18:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1760095119;
	bh=8X/YnvobS/rU8qw1LBSlMNzPHLPBd6nxaywCfF/beCU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=o9OHhnFvpP0MfGBDNYN7ZxQmJEdGDDWdiYqQV+wRxdMGxl0adCCurnsWn0mR803FA
	 t5fGvSSUE4cB45nn1sbtCAa9we+UYsE+qvMPf0SgRgctmQx84UmVmUKQzl3ieBsJVU
	 Apg7G3HBCqIU2axeuTXM47/kEv+R1WR57pyz7gCk9Q1/j+Ci5AMvLftaMxjGVsSIm2
	 hwrqvV65+/cwsVr9XsWCJ8Mhr6+CtP4GaLBwB25sXXcUBhMCvYMlkLcvXpH0cTiNyF
	 i1boqePpYoSkQmiIqRedxOOjPoONEMOFzVnobr6pvEbAkTZUbjyfXr8l6+9zTvr+t4
	 MdoHoO6hnt9WA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 4/5] netfilter: flowtable: inline pppoe encapsulation in xmit path
Date: Fri, 10 Oct 2025 13:18:24 +0200
Message-Id: <20251010111825.6723-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20251010111825.6723-1-pablo@netfilter.org>
References: <20251010111825.6723-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Push the pppoe header from the flowtable xmit path, instead of passing
the packet to the pppoe device which delivers the packet to the
userspace pppd daemon for encapsulation.

This is based on a patch originally written by wenxu.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_ip.c   | 42 ++++++++++++++++++++++++++++++
 net/netfilter/nf_flow_table_path.c |  9 ++-----
 2 files changed, 44 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 2d11c46a925c..be21600cff53 100644
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
 static int nf_flow_encap_push(struct sk_buff *skb, struct flow_offload_tuple *tuple)
 {
 	int i;
@@ -424,6 +462,10 @@ static int nf_flow_encap_push(struct sk_buff *skb, struct flow_offload_tuple *tu
 			if (skb_vlan_push(skb, tuple->encap[i].proto, tuple->encap[i].id) < 0)
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
2.30.2

