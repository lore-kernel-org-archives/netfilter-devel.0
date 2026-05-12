Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFEB23839B6
	for <netfilter-devel@vger.kernel.org>; Tue, 12 May 2026 10:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778582063; cv=none; b=gRgJzWBDFUEAynesl1BPRvBNd0RtfN8SMSpkGVVhDUlcyJiDS98hI2zlXvRndm0zkxrxiRmld1n+j0fNbBz42vMwaz6Bdloo5HUpbx2YFQbnPKx9qne9cht7APmzHzeo12g0wqzeIuVvKBzBJn0y1Evo8rkXiKxsI9qa9TwDYYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778582063; c=relaxed/simple;
	bh=eEK9CSmflTinHxnclisn+SM8hm5DQJJDluFre7uQ/MA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DxJkcS5/UjNtV0AF4zG+1XxXmWjHb8dSCEaGv1uURswbb/nRNAPO7BqAs/65wy4U+lMwlRHQnq6seUfG4qbN1LQ0JPwCnCpAeYFQt7cpVTGKwl2nzhL7SI+Lz3pxGmDtRM17wZPrlr1TeQ2k1gBhWP4jcBZ+PyA9TU23U+YP5QY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gecWsWuQ; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gecWsWuQ"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-67e9b3037dcso7536187a12.0
        for <netfilter-devel@vger.kernel.org>; Tue, 12 May 2026 03:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778582055; x=1779186855; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VufqCM4273TfrwjnOjJJxWiUfnlQlQVqbX6N4j1aTUk=;
        b=gecWsWuQZUpoD8WlnHHj59AfSkTmRsPLfE/Hq0BEU5Wz4gDinE0Ydjoh8lidMdYojt
         6H1EDyFDC9/prdB+TUOTZiTHNLrNITRX3wfr22gRIUyX1o/XyOs2rX29fJvi+mO+BAMN
         dwFjDp/7mkjeIKr7v+iIPiwMt0joM1KpEECucVc5kG4O4e7amqNjYrJCipuZ1MwCkeib
         /Q4WDgUNlbJfoJZbWlp8cZXbWM57vvvwxOUoE2R3jaSVGxTlvPum37dl+tt+YvwRUep+
         U1XSlta/2PZDQWK74G5KKgUmSVDZmVdn4hnz4ougJ1laCzj4gmb8MueNBhwhfnOxXvV4
         gX8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778582055; x=1779186855;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VufqCM4273TfrwjnOjJJxWiUfnlQlQVqbX6N4j1aTUk=;
        b=CmbA9b1NsSbLAZDZX8pPX5X/P/Pyx8zO/P/dhbXmSzOgeoC8gLIJkxAp/sHss9nJcl
         3AGVFsfhN4oTSfw6NuEqpTlgaM6DRGa6kHcp1O09bQpMWD+3QvsnZjXU0QY74xI3FCnC
         9xcC2eWo6UlrX7wXvk+/Y6uAxrtZCAyG2bLqED9UtHxp5F4p2lTJuzs1in7IMZ8wuzrD
         kIVFcuRqPabMk08IArQVne5k4sxK5iOX1oMxqTUWWvpiSioi2CR72euFnAwh7BgpESc2
         d79zmOPQayGH2olxcz5FIscqpiuWXrNSwDZxkvIaHyX5Lh1VQkvGUlceX2CJ+rrzG/BZ
         uRQw==
X-Gm-Message-State: AOJu0YzhXb1jtL/k3arsVxwLPdTPSOOVdB8ThQ34q0Fro5UE5jKgl5Ws
	m15QAPxrolDcVOfdmzGKrrK4mAttC/OdjmBxi9Q4gpSwOFVAQdlyD6rP16GZrw==
X-Gm-Gg: Acq92OFYOMx6ZP+ehO54rFHjEsJNRKgk1SPRVMQDWBdEj3gloZq9KiDnFrOgQDJWm2a
	VuOGnc5VdRiNQC0aSbiHHnJV0l/r2nsYJCCuZdafaZjtLVA2g1uaFKfRChnddPV5tqdk6td+W1y
	ST1nMyMUBAammAUXXqXa8juBmFD0eyt/qEsIdhQvuYeOFKmp+gNzIavDxJsXA94Nn1XJm0MxkZt
	wRb47OlqnN1FWOVm34qYmjo+HgL05sa37FK38Gw1nFAZC6+H86PpkDEgyJJ0akX7fprun4EBzEV
	eaTDq9Cl7Xh9wX36P2w+oCHNUaZCXVdY4ppPZiu9pG4SXpXeV6J7chDAAjbR6JoANzAqOIqaP/k
	dHOKNzxgzVPUiMV/cSMICRQ6rYaG/FzyBImAZheY3rhRmX1A2tZKz1gNYQ3YjeLSoHF6QU9zGhD
	/Ap4ulNOU5pFm1LEFNgakJphsW1UGCw+xcp637RBnJDS/nVb8dMBzooPKQegTt2nkkD+FO4/OzD
	nOE97XRFVkv6+C8Qg4jprgQkrWwgbfMca+hcRYCGsho5hJQVW7ywGw=
X-Received: by 2002:a05:6402:518a:b0:67b:790e:bf12 with SMTP id 4fb4d7f45d1cf-67ef07ba89cmr9095781a12.12.1778582055128;
        Tue, 12 May 2026 03:34:15 -0700 (PDT)
Received: from eric (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-67ef0e1c044sm4629218a12.27.2026.05.12.03.34.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 03:34:14 -0700 (PDT)
From: Eric Woudstra <ericwouds@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Cc: netfilter-devel@vger.kernel.org,
	bridge@lists.linux.dev,
	netdev@vger.kernel.org,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v20 nf-next 2/2] netfilter: bridge: Add conntrack double vlan and pppoe
Date: Tue, 12 May 2026 12:33:47 +0200
Message-ID: <20260512103347.102746-3-ericwouds@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260512103347.102746-1-ericwouds@gmail.com>
References: <20260512103347.102746-1-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In a bridge, until now, it is possible to track connections of plain
ip(v6) and ip(v6) encapsulated in single 802.1q or 802.1ad.

This patch adds the capability to track connections when the connection
is (also) encapsulated in PPPoE. It also adds the capability to track
connections that are encapsulated in an inner 802.1q, combined with an
outer 802.1ad or 802.1q encapsulation.

To prevent mixing connections that are tagged differently in the L2
encapsulations, one should separate them using conntrack zones.
Using a conntrack zone is a hard requirement for the newly added
encapsulations of the tracking capability inside a bridge.

Also handling of de-/re-fragmenting is patched accordingly.

Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 include/linux/netfilter_bridge.h           |   6 +
 net/bridge/netfilter/nf_conntrack_bridge.c | 203 ++++++++++++++++++---
 2 files changed, 182 insertions(+), 27 deletions(-)

diff --git a/include/linux/netfilter_bridge.h b/include/linux/netfilter_bridge.h
index 743475ca7e9d5..51e80b14fe3f4 100644
--- a/include/linux/netfilter_bridge.h
+++ b/include/linux/netfilter_bridge.h
@@ -10,6 +10,12 @@ struct nf_bridge_frag_data {
 	bool    vlan_present;
 	u16     vlan_tci;
 	__be16  vlan_proto;
+	bool    inner_vlan_present;
+	u16     inner_vlan_tci;
+	__be16  inner_vlan_proto;
+	bool    pppoe_present;
+	__be16  pppoe_sid;
+	__be16  pppoe_proto;
 };
 
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index 58a33d0380b00..7e152d1341107 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -16,6 +16,7 @@
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <net/netfilter/nf_conntrack_bridge.h>
 
+#include <linux/ppp_defs.h>
 #include <linux/netfilter_ipv4.h>
 
 #include "../br_private.h"
@@ -142,7 +143,8 @@ static void br_skb_cb_restore(struct sk_buff *skb,
 }
 
 static unsigned int nf_ct_br_defrag4(struct sk_buff *skb,
-				     const struct nf_hook_state *state)
+				     const struct nf_hook_state *state,
+				     int offset)
 {
 	u16 zone_id = NF_CT_DEFAULT_ZONE_ID;
 	enum ip_conntrack_info ctinfo;
@@ -153,6 +155,9 @@ static unsigned int nf_ct_br_defrag4(struct sk_buff *skb,
 	if (!ip_is_fragment(ip_hdr(skb)))
 		return NF_ACCEPT;
 
+	if (offset)
+		__skb_pull(skb, offset);
+
 	ct = nf_ct_get(skb, &ctinfo);
 	if (ct)
 		zone_id = nf_ct_zone_id(nf_ct_zone(ct), CTINFO2DIR(ctinfo));
@@ -165,6 +170,8 @@ static unsigned int nf_ct_br_defrag4(struct sk_buff *skb,
 	if (!err) {
 		br_skb_cb_restore(skb, &cb, IPCB(skb)->frag_max_size);
 		skb->ignore_df = 1;
+		if (offset)
+			__skb_push(skb, offset);
 		return NF_ACCEPT;
 	}
 
@@ -172,7 +179,8 @@ static unsigned int nf_ct_br_defrag4(struct sk_buff *skb,
 }
 
 static unsigned int nf_ct_br_defrag6(struct sk_buff *skb,
-				     const struct nf_hook_state *state)
+				     const struct nf_hook_state *state,
+				     int offset)
 {
 #if IS_ENABLED(CONFIG_NF_DEFRAG_IPV6)
 	u16 zone_id = NF_CT_DEFAULT_ZONE_ID;
@@ -181,6 +189,9 @@ static unsigned int nf_ct_br_defrag6(struct sk_buff *skb,
 	const struct nf_conn *ct;
 	int err;
 
+	if (offset)
+		__skb_pull(skb, offset);
+
 	ct = nf_ct_get(skb, &ctinfo);
 	if (ct)
 		zone_id = nf_ct_zone_id(nf_ct_zone(ct), CTINFO2DIR(ctinfo));
@@ -194,7 +205,12 @@ static unsigned int nf_ct_br_defrag6(struct sk_buff *skb,
 		return NF_STOLEN;
 
 	br_skb_cb_restore(skb, &cb, IP6CB(skb)->frag_max_size);
-	return err == 0 ? NF_ACCEPT : NF_DROP;
+	if (err)
+		return NF_DROP;
+
+	if (offset)
+		__skb_push(skb, offset);
+	return NF_ACCEPT;
 #else
 	return NF_ACCEPT;
 #endif
@@ -236,58 +252,139 @@ static int nf_ct_br_ipv6_check(const struct sk_buff *skb)
 	return 0;
 }
 
+static int nf_ct_bridge_inner(struct sk_buff *skb, __be16 *proto, u32 *len,
+			      struct nf_bridge_frag_data *data)
+{
+	if (data) {
+		data->inner_vlan_present = false;
+		data->pppoe_present = false;
+	}
+
+	switch (*proto) {
+	case htons(ETH_P_PPP_SES): {
+		struct ppp_hdr {
+			struct pppoe_hdr hdr;
+			__be16 proto;
+		} *ph;
+
+		if (!pskb_may_pull(skb, PPPOE_SES_HLEN))
+			return -1;
+		ph = (struct ppp_hdr *)(skb->data);
+		switch (ph->proto) {
+		case htons(PPP_IP):
+			*proto = htons(ETH_P_IP);
+			if (len)
+				*len = ntohs(ph->hdr.length) - 2;
+			if (data) {
+				data->pppoe_present = true;
+				data->pppoe_sid = ph->hdr.sid;
+				data->pppoe_proto = ph->proto;
+			}
+			skb_set_network_header(skb, PPPOE_SES_HLEN);
+			return PPPOE_SES_HLEN;
+		case htons(PPP_IPV6):
+			*proto = htons(ETH_P_IPV6);
+			if (len)
+				*len = ntohs(ph->hdr.length) - 2;
+			if (data) {
+				data->pppoe_present = true;
+				data->pppoe_sid = ph->hdr.sid;
+				data->pppoe_proto = ph->proto;
+			}
+			skb_set_network_header(skb, PPPOE_SES_HLEN);
+			return PPPOE_SES_HLEN;
+		}
+		break;
+	}
+	case htons(ETH_P_8021Q): {
+		struct vlan_hdr *vhdr;
+
+		if (!pskb_may_pull(skb, VLAN_HLEN))
+			return -1;
+		vhdr = (struct vlan_hdr *)(skb->data);
+		*proto = vhdr->h_vlan_encapsulated_proto;
+		if (data) {
+			data->inner_vlan_present = true;
+			data->inner_vlan_tci = vhdr->h_vlan_TCI;
+			data->inner_vlan_proto = vhdr->h_vlan_encapsulated_proto;
+		}
+		skb_set_network_header(skb, VLAN_HLEN);
+		return VLAN_HLEN;
+	}
+	}
+	return 0;
+}
+
 static unsigned int nf_ct_bridge_pre(void *priv, struct sk_buff *skb,
 				     const struct nf_hook_state *state)
 {
 	struct nf_hook_state bridge_state = *state;
+	int ret = NF_ACCEPT, offset = 0;
 	enum ip_conntrack_info ctinfo;
+	u32 len, pppoe_len = 0;
 	struct nf_conn *ct;
-	u32 len;
-	int ret;
+	__be16 proto;
 
 	ct = nf_ct_get(skb, &ctinfo);
 	if ((ct && !nf_ct_is_template(ct)) ||
 	    ctinfo == IP_CT_UNTRACKED)
 		return NF_ACCEPT;
 
-	switch (skb->protocol) {
-	case htons(ETH_P_IP):
-		if (!pskb_may_pull(skb, sizeof(struct iphdr)))
+	proto = skb->protocol;
+
+	if (ct && nf_ct_zone_id(nf_ct_zone(ct), CTINFO2DIR(ctinfo)) !=
+			NF_CT_DEFAULT_ZONE_ID) {
+		offset = nf_ct_bridge_inner(skb, &proto, &pppoe_len, NULL);
+		if (offset < 0)
 			return NF_ACCEPT;
+	}
+
+	switch (proto) {
+	case htons(ETH_P_IP):
+		if (!pskb_may_pull(skb, offset + sizeof(struct iphdr)))
+			goto do_not_track;
 
 		len = skb_ip_totlen(skb);
-		if (pskb_trim_rcsum(skb, len))
-			return NF_ACCEPT;
+		if (pppoe_len && pppoe_len != len)
+			goto do_not_track;
+		if (pskb_trim_rcsum(skb, offset + len))
+			goto do_not_track;
 
 		if (nf_ct_br_ip_check(skb))
-			return NF_ACCEPT;
+			goto do_not_track;
 
 		bridge_state.pf = NFPROTO_IPV4;
-		ret = nf_ct_br_defrag4(skb, &bridge_state);
+		ret = nf_ct_br_defrag4(skb, &bridge_state, offset);
 		break;
 	case htons(ETH_P_IPV6):
-		if (!pskb_may_pull(skb, sizeof(struct ipv6hdr)))
-			return NF_ACCEPT;
+		if (!pskb_may_pull(skb, offset + sizeof(struct ipv6hdr)))
+			goto do_not_track;
 
 		len = sizeof(struct ipv6hdr) + skb_ipv6_payload_len(skb);
-		if (pskb_trim_rcsum(skb, len))
-			return NF_ACCEPT;
+		if (pppoe_len && pppoe_len != len)
+			goto do_not_track;
+		if (pskb_trim_rcsum(skb, offset + len))
+			goto do_not_track;
 
 		if (nf_ct_br_ipv6_check(skb))
-			return NF_ACCEPT;
+			goto do_not_track;
 
 		bridge_state.pf = NFPROTO_IPV6;
-		ret = nf_ct_br_defrag6(skb, &bridge_state);
+		ret = nf_ct_br_defrag6(skb, &bridge_state, offset);
 		break;
 	default:
 		nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
-		return NF_ACCEPT;
+		goto do_not_track;
 	}
 
-	if (ret != NF_ACCEPT)
-		return ret;
+	if (ret == NF_ACCEPT)
+		ret = nf_conntrack_in(skb, &bridge_state);
 
-	return nf_conntrack_in(skb, &bridge_state);
+do_not_track:
+	if (offset && ret == NF_ACCEPT)
+		skb_reset_network_header(skb);
+
+	return ret;
 }
 
 static unsigned int nf_ct_bridge_in(void *priv, struct sk_buff *skb,
@@ -340,12 +437,22 @@ nf_ct_bridge_refrag(struct sk_buff *skb, const struct nf_hook_state *state,
 				  struct sk_buff *))
 {
 	struct nf_bridge_frag_data data;
+	__be16 proto;
+	int offset;
 
 	if (!BR_INPUT_SKB_CB(skb)->frag_max_size)
 		return NF_ACCEPT;
 
 	nf_ct_bridge_frag_save(skb, &data);
-	switch (skb->protocol) {
+
+	proto = skb->protocol;
+
+	offset = nf_ct_bridge_inner(skb, &proto, NULL, &data);
+	if (offset < 0)
+		return NF_ACCEPT;
+	__skb_pull(skb, offset);
+
+	switch (proto) {
 	case htons(ETH_P_IP):
 		nf_br_ip_fragment(state->net, state->sk, skb, &data, output);
 		break;
@@ -366,11 +473,49 @@ static int nf_ct_bridge_frag_restore(struct sk_buff *skb,
 {
 	int err;
 
-	err = skb_cow_head(skb, ETH_HLEN);
-	if (err) {
-		kfree_skb(skb);
-		return -ENOMEM;
+	if (data->pppoe_present) {
+		struct ppp_hdr {
+			struct pppoe_hdr hdr;
+			__be16 proto;
+		} *ph;
+
+		err = skb_cow_head(skb, PPPOE_SES_HLEN);
+		if (err)
+			goto error;
+
+		__skb_push(skb, PPPOE_SES_HLEN);
+		skb_reset_network_header(skb);
+		skb->protocol = htons(ETH_P_PPP_SES);
+
+		ph = (struct ppp_hdr *)(skb->data);
+		ph->hdr.ver  = 1;
+		ph->hdr.type = 1;
+		ph->hdr.code = 0;
+		ph->hdr.sid  = data->pppoe_sid;
+		ph->hdr.length = htons(skb->len + 2 - PPPOE_SES_HLEN);
+		ph->proto = data->pppoe_proto;
 	}
+
+	if (data->inner_vlan_present) {
+		struct vlan_hdr *vhdr;
+
+		err = skb_cow_head(skb, VLAN_HLEN);
+		if (err)
+			goto error;
+
+		__skb_push(skb, VLAN_HLEN);
+		skb_reset_network_header(skb);
+		skb->protocol = htons(ETH_P_8021Q);
+
+		vhdr = (struct vlan_hdr *)(skb->data);
+		vhdr->h_vlan_TCI = data->inner_vlan_tci;
+		vhdr->h_vlan_encapsulated_proto = data->inner_vlan_proto;
+	}
+
+	err = skb_cow_head(skb, ETH_HLEN);
+	if (err)
+		goto error;
+
 	if (data->vlan_present)
 		__vlan_hwaccel_put_tag(skb, data->vlan_proto, data->vlan_tci);
 	else if (skb_vlan_tag_present(skb))
@@ -380,6 +525,10 @@ static int nf_ct_bridge_frag_restore(struct sk_buff *skb,
 	skb_reset_mac_header(skb);
 
 	return 0;
+
+error:
+	kfree_skb(skb);
+	return -ENOMEM;
 }
 
 static int nf_ct_bridge_refrag_post(struct net *net, struct sock *sk,
-- 
2.53.0

