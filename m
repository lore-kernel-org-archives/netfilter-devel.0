Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76E9F244692;
	Thu, 16 Apr 2026 01:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776303078; cv=none; b=LwPxPM8sFhZA6VyDnxqlOhAvrjknwH5dFuKgaL5puoa5cV3bi/QaWG9nqWX+N7w0Um4r+ABmQSW0/lB/TPOoqgVzLGbR/eeiqccfLyQzJWRkMBIz1NAagg5XiXnWucHo1feqRNvgqLez9IgGGziwTpfsFElefnDntoJHsplbNBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776303078; c=relaxed/simple;
	bh=Z6YUIMRuOVp321+8lw9LYyehu6/N0DR1dpuAURrKhrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NzpgGnNEqIikLjr0AGIw/hhYT+xYrjCFOLhQJrL3SLkbyos05v5BetBp1tiRyy3ONX3sxpRTKXiK03mLfiJisQb04Lp9Xa5MlwcNkGqHYcqa26EKBp8v2tq8P7cIlvbjVcXcEhEbuAz0Vny2yBjusK+t6kG+lK9gMjBMerGkAFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=EJItkzQm; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="EJItkzQm"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 466A06024E;
	Thu, 16 Apr 2026 03:31:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776303075;
	bh=Ahs+WJN8L1pfM+4/Cbsu/C8n7IwarIzR7hF4whbKjDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EJItkzQmlWyBzco2la2moj/HCmhgxrvHu3hHbxIPWenaI/cjXqbSMgrQq2lWCAaop
	 HyxYtVRzv+5O1CHSJSUPPhGbXIruPa1JA9B7nQ09KMFA6JmkEzxbJNb1cwhbpCitnx
	 gEqg+wZCsRr6QMtxoPA/jbMUHok80ulr5kWL6S7aMfL56T6Bk9H9oYLrpdIqw359I9
	 2dRLkFEHz36wP59m7ncH6W43QJeJf6odsd716Plnc9SqpSu5q+OrEqMoLdHW7zuQYG
	 7kQK73a7MjRD7sYCK7lubDSfiTeUvagRoet4ZbtOguKax0ry7ePZnAuUs3t3rYiTdF
	 qIbuFrpiMKfQw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 06/14] netfilter: nf_flow_table_ip: Introduce nf_flow_vlan_push()
Date: Thu, 16 Apr 2026 03:30:53 +0200
Message-ID: <20260416013101.221555-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260416013101.221555-1-pablo@netfilter.org>
References: <20260416013101.221555-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Woudstra <ericwouds@gmail.com>

Calling skb_reset_mac_header() before calling skb_vlan_push() does
remove the error:

"skb_vlan_push got skb with skb->data not at mac header (offset 18)"

But the inner vlan tag is still not inserted correctly.

skb_vlan_push() uses __vlan_insert_inner_tag() to insert the tag
at offset ETH_HLEN. But the inner tag should only be pushed, without
offset, similar to nf_flow_pppoe_push().

Fixes: c653d5a78f34 ("netfilter: flowtable: inline vlan encapsulation in xmit path")
Fixes: a3aca98aec9a ("netfilter: nf_flow_table_ip: reset mac header before vlan push")
Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_ip.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index fd56d663cb5b..0086f8a1a0d6 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -544,6 +544,26 @@ static int nf_flow_offload_forward(struct nf_flowtable_ctx *ctx,
 	return 1;
 }
 
+static int nf_flow_vlan_push(struct sk_buff *skb, __be16 proto, u16 id)
+{
+	if (skb_vlan_tag_present(skb)) {
+		struct vlan_hdr *vhdr;
+
+		if (skb_cow_head(skb, VLAN_HLEN))
+			return -1;
+
+		__skb_push(skb, VLAN_HLEN);
+		skb_reset_network_header(skb);
+		vhdr = (struct vlan_hdr *)(skb->data);
+		vhdr->h_vlan_TCI = htons(id);
+		vhdr->h_vlan_encapsulated_proto = skb->protocol;
+		skb->protocol = proto;
+	} else {
+		__vlan_hwaccel_put_tag(skb, proto, id);
+	}
+	return 0;
+}
+
 static int nf_flow_pppoe_push(struct sk_buff *skb, u16 id)
 {
 	int data_len = skb->len + sizeof(__be16);
@@ -738,9 +758,8 @@ static int nf_flow_encap_push(struct sk_buff *skb,
 		switch (tuple->encap[i].proto) {
 		case htons(ETH_P_8021Q):
 		case htons(ETH_P_8021AD):
-			skb_reset_mac_header(skb);
-			if (skb_vlan_push(skb, tuple->encap[i].proto,
-					  tuple->encap[i].id) < 0)
+			if (nf_flow_vlan_push(skb, tuple->encap[i].proto,
+					      tuple->encap[i].id) < 0)
 				return -1;
 			break;
 		case htons(ETH_P_PPP_SES):
-- 
2.47.3

