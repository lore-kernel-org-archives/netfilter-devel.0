Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D39B23FFADA
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Jun 2026 12:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782736417; cv=none; b=tESpEc28LFg17m9MTsWxPsTsLJi20+o2xcguHYNyOmykgJqMCH9Wg9h+FQn1lmMzO56i1vR0BXXOAFnB0lvjjp5gz0mzo8A6GWd9IDJCkEWCfXEj34VgkS+EYB1QP6XtmDQ+qILP8T6nGu0Sd6YX4j2tX9upPtRbsX5trxXWRdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782736417; c=relaxed/simple;
	bh=FLmf68CizDgbkWkilfIYmqlhpJjGjSd3CzUEP2obw5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IOmtdv6Qf9gHr8YBqDXD9e+NI6cMDRd4JN0s4K0Eq9oZ1NCMnNEpieDmcfFI4bTrz2q4LEMQQixDEO1P/1T8Pd/Lj6DqFo6P5Xdct7dwuIMmsFeqXqTVghjAQD9TBf9bYh1a9sB5XPVdG0sOlGh8R/Kq+b9bkPRTYQXtZEN5JPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RgE5djvf; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RgE5djvf"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c12614b81c9so198033566b.3
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Jun 2026 05:33:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782736414; x=1783341214; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B0BtFT/DLMwlAC+IMAnaYdEaIQ9JUWZrSmMLsMhq+s0=;
        b=RgE5djvfa2/29IlLg79qmpnBPkFA1sgr2pggoc1WxASGsGcamn6Yq5KrjVBPbnZQQD
         FCDwa2El+OupzMMb4fvC43ACKNsvkblu0MUN/CTxW2PWZOJVtupJW6u4WCmGWLwZdNpF
         25bS80YFWSVTnKCPsc45p9Zj12L/tv9k7WxqwESaIvT08Vs1KPF43PPqp6gyKVt1ExHK
         O8Fv9xE+MTBfIdURRwSMnNsIwNuNI0JO/mDm5KMRPa0W2xmFTOko1vz5HepgTgqACF7A
         r/HEFGtkDnIHMmTdxc9lteZDq5F9ZuHsOTktVajrCHBi4epFhpWV/p4Zm+qLLgUdqIR3
         c7nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782736414; x=1783341214;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=B0BtFT/DLMwlAC+IMAnaYdEaIQ9JUWZrSmMLsMhq+s0=;
        b=pad0ES0R4KGQVWG5YmSKH981vPDG2g9ZZte/c6UcV1Jp8k/dAyPsmAPT5ryi+2coQs
         twFiy4mHGbY2yF5JGWeKHMIC5Wrv2UeLVgl/OjNJRHIQ+8k3qFEvfnGw8fpvMUCDcIsB
         T4FZuUAxrVb2cdOS7uyImofC4DqYO4j3h2mhPgqRsS5iK8RFRUoa+XVZJegQqu83PGL/
         sI5JdIcsfXWdHbyNdCQeZwRfwNnDyAKu5X5bEom/vcH6o8Nj1z1SP/HiI6PP+7A82UYs
         Ex9WygrAwLkY00bOjo1pPD1XDBGhxjdXEyfKy8GVn8Q/Cx3OljIc9ytw71/Py0ZfVxWF
         PUgw==
X-Gm-Message-State: AOJu0Yz4r3jblvarW8OMIdrJZIapuVWPWl2FX75i9RUeWr4wcT19Zcs6
	acLJd04C9ONnCS5keO8QknFnJMIMSDkNuVTkqJah8JdoG89efwPwA+U/jor+P3/v
X-Gm-Gg: AfdE7cmSZWXNh0Z+GUUBYcHrUmoUBypG/7VNggo7cz1OJ/TCLqs/pzqN+0RuoPN1fV5
	1rRchFebc0rETiPPWXUVcy80QN2XS7zQZ2tupD2eYYEie84HxWUG/dFJWOQKSVbweX8n/HWJYZ4
	UpNstfRDcRiJIgpVrShzEJNroAa72vh7opmIksOM/3zKJlLgBrMlmifU5WYY7ODJAmh3ZSA1sNo
	XAooWgGXmoR+H/OMW3x99VI97OHGTMsj4DM7KZ50UDUiQwAVILrhCRzS9PS2AOT85JqdibnGgEd
	TskmJ4VfnGK0CrIdrv5pENeYJ3OBp6kEukerP+1mXB5UjR9b3fz6wTeFTIFyc/JZumMv2uWCsHj
	mvuoxt4M3ynz5u0YcfB1v+pzPufj7p4QNmAG+ZkU0d9iTnhIubmNkL9FAd0q+raPIoExv6y4Cpg
	SHXYj3Ml4=
X-Received: by 2002:a17:906:f58a:b0:c12:34ec:ad25 with SMTP id a640c23a62f3a-c1234ecbf2bmr445790166b.65.1782736414123;
        Mon, 29 Jun 2026 05:33:34 -0700 (PDT)
Received: from fedora ([46.205.218.111])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c11fbe05c22sm773866566b.39.2026.06.29.05.33.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 05:33:32 -0700 (PDT)
From: Daniel Pawlik <pawlik.dan@gmail.com>
To: netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	andrew+netdev@lunn.ch,
	razor@blackwall.org,
	idosch@nvidia.com,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	bridge@lists.linux.dev,
	coreteam@netfilter.org,
	linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	rchen14b@gmail.com,
	lorenzo@kernel.org,
	Daniel Pawlik <pawlik.dan@gmail.com>
Subject: [PATCH 5/5] netfilter: nf_flow_table_path: add VLAN passthrough support
Date: Mon, 29 Jun 2026 14:32:53 +0200
Message-ID: <20260629123253.1912621-6-pawlik.dan@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260629123253.1912621-1-pawlik.dan@gmail.com>
References: <20260629123253.1912621-1-pawlik.dan@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ryan Chen <rchen14b@gmail.com>

VLAN passthrough packets can be offloaded when bridge-nf-filter-vlan-tagged
is enabled. When a packet has a VLAN tag and the bridge does not have VLAN
filtering enabled (passthrough mode), record the VLAN encap info so the
hardware flow offload entry includes the correct VLAN tag.

Without this change, VLAN-tagged bridged traffic cannot be offloaded by PPE
because the VLAN encap information is missing from the flow entry.

Enable with: echo 1 > /proc/sys/net/bridge/bridge-nf-filter-vlan-tagged

Based on a MediaTek SDK patch by Chak-Kei Lam <chak-kei.lam@mediatek.com>.
Signed-off-by: Ryan Chen <rchen14b@gmail.com>
Signed-off-by: Daniel Pawlik <pawlik.dan@gmail.com>
---
 net/netfilter/nf_flow_table_path.c | 32 ++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
index 580aa1db3cb4..d15c425c88c4 100644
--- a/net/netfilter/nf_flow_table_path.c
+++ b/net/netfilter/nf_flow_table_path.c
@@ -17,6 +17,7 @@
 #include <net/netfilter/nf_flow_table.h>
 #include <linux/if_bridge.h>
 #include <linux/if_ether.h>
+#include <linux/if_vlan.h>
 #include <net/route.h>
 #include <net/ip6_route.h>
 
@@ -136,6 +137,29 @@ struct nft_forward_info {
 	enum flow_offload_xmit_type xmit_type;
 };
 
+static void nft_fill_vlan_passthrough_info(const struct nft_pktinfo *pkt,
+					   struct nft_forward_info *info)
+{
+	if (!skb_vlan_tag_present(pkt->skb))
+		return;
+
+	rcu_read_lock();
+	/* when bridge VLAN filtering is enabled, the bridge handles the tag */
+	if (netif_is_bridge_port(pkt->skb->dev) &&
+	    !br_vlan_is_enabled_rcu(pkt->skb->dev)) {
+		if (info->num_encaps >= NF_FLOW_TABLE_ENCAP_MAX) {
+			info->indev = NULL;
+		} else {
+			info->encap[info->num_encaps].id =
+				skb_vlan_tag_get_id(pkt->skb);
+			info->encap[info->num_encaps].proto =
+				pkt->skb->vlan_proto;
+			info->num_encaps++;
+		}
+	}
+	rcu_read_unlock();
+}
+
 static int nft_dev_path_info(const struct net_device_path_stack *stack,
 			     struct nft_forward_info *info,
 			     unsigned char *ha, struct nf_flowtable *flowtable)
@@ -326,8 +350,12 @@ static int nft_dev_forward_path(const struct nft_pktinfo *pkt,
 		nft_br_vlan_dev_fill_forward_path(pkt, &ctx);
 	}
 
-	if (nft_dev_fill_forward_path(&ctx, route, dst, ct, dir, ha, &stack) < 0 ||
-	    nft_dev_path_info(&stack, &info, ha, &ft->data) < 0)
+	if (nft_dev_fill_forward_path(&ctx, route, dst, ct, dir, ha, &stack) < 0)
+		return -ENOENT;
+
+	nft_fill_vlan_passthrough_info(pkt, &info);
+
+	if (nft_dev_path_info(&stack, &info, ha, &ft->data) < 0)
 		return -ENOENT;
 
 	if (!nft_flowtable_find_dev(info.indev, ft))
-- 
2.54.0

