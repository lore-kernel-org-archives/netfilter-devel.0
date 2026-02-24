Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE6F30BBA9
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Feb 2026 06:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771916000; cv=none; b=bMOm6b1Ak3tnON1UE614OsuMS3cNuA3rYU99ohRYv6s5GQUsqzjelXa3iVWL1L5HBaWBrUwEpmBa2HaNljQaqF/KSFye5pBce03mZBpj0vL6vNHcaEMKTifH6/BqRV9zGpDBPYttFVRyo+1rCPVJkwRB/NFghE8/oQnuMybqsvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771916000; c=relaxed/simple;
	bh=MgqFP+kEIYkaJNFbJG3TL6RfVtetCetfNmpFyY7dGco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W3QXmZCHIgx3GE+mbjGGDSry1ceca9fSh70ru27fDfkh1GJPA0293zT3LYzpNxX9/cyWMIEWM+g5zziv9LjxpxOzL0WRydFbwyI+2v+zrEkC2ENcveIahXkD+qFeBe0ev5s7ULdLs2hzHOccG7B6dMXeuCa1bb0gj0DxH9TcHP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CQ+DoYCO; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CQ+DoYCO"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-65bebcbffe8so9694841a12.1
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Feb 2026 22:53:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771915998; x=1772520798; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z+3Us/40ma9gw7n/u08hiyPrq5670jVo0kM4Qwre1Os=;
        b=CQ+DoYCOlzAgyFbGVpRPcmWRPkpG/RypGlbSy1ZnsweMdS0iyyr+wQN+APNNkdmGWL
         q4x0mbMEk7Vr31fJkhPTFnoEXFFayVNjMZb3NY3mjJh8ShoqmXbTMpYGePXeGd75rd7w
         ojHxNNYQgAlfNr+lyngy/Vm9DdHJYcZQugEltn8w973v+2KlUW8l1fRPypndPUPa8WXn
         R5y74s6Jv8uQ1QwbZu8xFPPNGsDToogEocprzBEJHcamaRg4shKGE+WesN/ZUktK55bA
         uwubQ5Mmb4+cZVt2TFzBj3JATGi7farJAgza564AZgtXPlHU5Fjauiv3KNoB2xrdfMmU
         gZuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771915998; x=1772520798;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=z+3Us/40ma9gw7n/u08hiyPrq5670jVo0kM4Qwre1Os=;
        b=oPMIxBjmkbHIm4q6rx+K/dMdwwyDEYtiNaWFDfoIY8vuHvlwi7YEC0MH1djei8DQIw
         1Qq7zMQ4cOZuOoomQkUOVwtelAAJ/UmF5vbn2uuzyABUoRTLDFjuRs3/m7USih6TAaER
         oTVfLMGpwtno9wz0t/jD3uGwHUoUvi2qPP9uZpKKigleTQ1OUwo26zo8C5EA3drk7rfF
         B44jNueG7h+Us8CLco/mKUemsqL5LiUzeIsb/n9ReC5iHQItCMn2MQSlyiZ+PjS3Iba2
         JNDVHQzwh1OgFbFNu55HQlYrdYW35Mp5uC26fZmFcP38tK67CG2rchMRn3ktUeVroVmd
         cO6Q==
X-Forwarded-Encrypted: i=1; AJvYcCVcjSiMidyAJTe6C0RExe5Pm8a0LvDBpbnnuHrd89zVIa69fNSlSK8/YxzC1qhXKLTd5Xo0MN+Ej/4SoBt4x9c=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxrw9esnZns69eXnpYc5eRCnAtSV/inf9ndfSHVPw9tsPCN8bEE
	d1nGbZCS9PaQzMNMrKRS0gaR1GYItTLdmhFqnlclBeGBhwQy4cunlo+W
X-Gm-Gg: ATEYQzxdDL41a/EdaoUBfahEHX+/xUxGv/1LJN61BxUPVUQntIYLfNFMOQZ9KLEVeHW
	lm+7rYqTz4hrF+hQvV1yV3bcJwaBJxVghBnyKqLc2VahCx1Jp2nFS5tRm9GUIO41tbx+MK3B34Y
	bjY/5jWXr1knGRDNLYMvFaUm6ebC9RWFXvcwOhTXXn182XhlPDQHfhpSiC5OckCh9HIdy5s9MSU
	GWh4jso3g3JnHjz78Ks8ihnDFTkopWLqdc1eTpga/RC9A5kC/s0aP8wZ8GqBrVdIzgUEesiIeFh
	Oxso4aMlCXWEu0dyGRV90py1t4FHRqK1lOk48w4n7guLyni8Z9Mma4Yfo0Wip7ovBBI6OVUR0ll
	nMiR9ktMO+Zvlgm0xx6bZzZRa4eghknSmYXaBmTSYw1TQSBtoxxdki6tYkTWZ43FdiUxUtqHnMN
	QLajjnfoAJt85YfcF79ELQ5GHLsZiv2VyekJ2dzwBubTXRvLDBxKkxbR2eRZj49BEncxw02dXuF
	CF3jvvPKum8422i9rpNSdwXatH9pPvO3EVDQqesWfNzyjIyb1zXRcI=
X-Received: by 2002:a05:6402:440a:b0:65a:4202:640b with SMTP id 4fb4d7f45d1cf-65ea4ef5ff8mr6889632a12.19.1771915997684;
        Mon, 23 Feb 2026 22:53:17 -0800 (PST)
Received: from eric (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-65eaba13866sm3096698a12.18.2026.02.23.22.53.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 22:53:16 -0800 (PST)
From: Eric Woudstra <ericwouds@gmail.com>
To: Michal Ostrowski <mostrows@earthlink.net>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	Simon Horman <horms@kernel.org>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>
Cc: netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	bridge@lists.linux.dev,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v19 nf-next 3/5] netfilter: bridge: Add conntrack double vlan and pppoe
Date: Tue, 24 Feb 2026 07:53:04 +0100
Message-ID: <20260224065307.120768-4-ericwouds@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260224065307.120768-1-ericwouds@gmail.com>
References: <20260224065307.120768-1-ericwouds@gmail.com>
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

Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 net/bridge/netfilter/nf_conntrack_bridge.c | 93 ++++++++++++++++++----
 1 file changed, 76 insertions(+), 17 deletions(-)

diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index 58a33d0380b0..49e01083278c 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -16,6 +16,7 @@
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <net/netfilter/nf_conntrack_bridge.h>
 
+#include <linux/ppp_defs.h>
 #include <linux/netfilter_ipv4.h>
 
 #include "../br_private.h"
@@ -236,58 +237,116 @@ static int nf_ct_br_ipv6_check(const struct sk_buff *skb)
 	return 0;
 }
 
+static int nf_ct_bridge_pre_inner(struct sk_buff *skb, __be16 *proto, u32 *len)
+{
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
+			*len = ntohs(ph->hdr.length) - 2;
+			skb_set_network_header(skb, PPPOE_SES_HLEN);
+			return PPPOE_SES_HLEN;
+		case htons(PPP_IPV6):
+			*proto = htons(ETH_P_IPV6);
+			*len = ntohs(ph->hdr.length) - 2;
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
+		offset = nf_ct_bridge_pre_inner(skb, &proto, &pppoe_len);
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
 		ret = nf_ct_br_defrag4(skb, &bridge_state);
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
 		ret = nf_ct_br_defrag6(skb, &bridge_state);
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
+
+do_not_track:
+	if (offset && ret == NF_ACCEPT)
+		skb_reset_network_header(skb);
 
-	return nf_conntrack_in(skb, &bridge_state);
+	return ret;
 }
 
 static unsigned int nf_ct_bridge_in(void *priv, struct sk_buff *skb,
-- 
2.53.0

