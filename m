Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFE4A35C1B1
	for <netfilter-devel@vger.kernel.org>; Sun, 22 Feb 2026 19:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771790347; cv=none; b=ZQYBs5n5d80+iFmUJEP63YWwgO7Y/emATUH9Vh3EY0zlnGU7fONPFYvKM9u8ifkegTB/gBhkB4TnDlPH+Fm006dtaIjppV7gx4j+46iF7qCjgmO9JItpY/3YL8v9jKankCwIOj6u1Fp8BL0w86XRVHp8YkTf4ut5J7eji/5JlHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771790347; c=relaxed/simple;
	bh=MgqFP+kEIYkaJNFbJG3TL6RfVtetCetfNmpFyY7dGco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q819vprmj3SKnbZCjz5zWrdzmif9VbOBb5O1bOgH2MzfZ80/IUPclSOehlJz9YQl7ddN4uUcfIOmNZipSy03G6xZnhkKMF4WcfNKo4wRcFYcMwXrT9LCBT2Mu1x+UVNRcw+KlshRczCuBJ7M45BhvwuKAUl+4pgZxcd3W8vreh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ESMJOTpH; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ESMJOTpH"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b8fd976e90cso493590266b.0
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Feb 2026 11:59:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771790344; x=1772395144; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z+3Us/40ma9gw7n/u08hiyPrq5670jVo0kM4Qwre1Os=;
        b=ESMJOTpHZMN/avWIryT1rp+H53Su4+qRs+FwE3WVK+VgvWjp2FlnqxbyG3Dp2J9hEk
         +KPUPWX7DQkd18IgDyPcHMQCxpU2AKw6sfnvuz966IGRUG5RgDkD+K03k+KCHaH7adfR
         29WUl/EQsvSrkxUfLZm/k2U+uaLln4OeJ46uUGS4W8CoHadG+x1khFR6CykZe8ZjpsqT
         lg5Egb3SENYVnqgJLG5sp9ooHa1MKLyexDgfyDGE3InMZyscv8zHdRdjK8PFvJi9eLrG
         bc+FZcNuZ4piC0t65nlSoPVEZgPgFufUNbKss7PaxPl2J0RFFwdFuAtZAYTXvk6Mi4GN
         swsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771790344; x=1772395144;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=z+3Us/40ma9gw7n/u08hiyPrq5670jVo0kM4Qwre1Os=;
        b=gx0z0il9uhj4qQFImWaK7Mcf1wzqEQWCXBkGL5SY056haDNfut6JZGWY1PkrlZ5j7a
         c9Thcc8oJukXCC8zi1OyVy6FwUBo2z5Jr44OcIANC5x/DNl2PsT1PX/MZ7j7KcpzWruw
         nSuaG0nJwnUwW5wXl9uemW5UqttgWmASwA3gCxaLJ2L/SOGhrxp/pth+GmuQ4hPJ/g6r
         tAb39h6hShofJwH9J2rWYt5iTT5pW8KRVVWz/DXx2/oWuFrw1CzP80UswI1I4+yQLBWl
         En13Xi2jH40n+5KTXMMuiqvSm0OJV+VWnAk2sVEYbhr6nfDEw3gou/I2rRqRFBUJF0Eo
         kWzw==
X-Gm-Message-State: AOJu0Yxu5GSwrQ9WhhGHCkClgK7lM2BJj0WhpMmcd5oHKfDNgWDeXuVB
	oawd85umoFGhmWjO4iobBwszbZ3vGFX8NeUpH7fza7SZaaDQaGwsvaiB
X-Gm-Gg: AZuq6aIvQXm5BX2OzWokpA37ZEcoOwYI/c+CxZBkSslmIPJYFNzmFPqBiZNyLk7gRWP
	iX9SyHmli1/lORsv16oG1YofacO6IOcGe1sliCZE/s9SMT5A2VSXWEDVtrCG421S4TPU1GFE8F3
	wolmjxojHpqb8n/cBSpCMBfCzHDz3zS+/QR1UXkKsVJU4PDPRapDRULWMNc9A9Bxv4s/His7goG
	E4XRzfv3iURQUiySnjVuw5YHXRDRIJ4ptivEu3oVWQBNLAgYB9oTqq3qvaD52RQOxmu5UpzjKVp
	wIjVriYuFoSVGcEStiItuAfYkU9SZCuyW7FvnZhRcOiYMrc77YLFc0mop6lXHNuR1EyJDwPewR1
	JXiWHxCLzfG43dtMAO0wUVQxD2+G5XDDxzppPQpzfzscgoL0AY2YrWJzGeUvAqgyC2zuaVxvlFj
	4SuJQzSyW2+pXxjgreP/2O2XLMVMCBFAg+iN7lRDuUBQSp3AiY5o3Re5g03ZhgKSPyn9vwJap1J
	TBFWe9edHdKTYNfm3w7rx9EYvJ6R+uUHOzcDm6iN2PuzA4g5JD7PiU=
X-Received: by 2002:a17:906:2699:b0:b88:4b1f:5aff with SMTP id a640c23a62f3a-b9081b89670mr286298566b.44.1771790344085;
        Sun, 22 Feb 2026 11:59:04 -0800 (PST)
Received: from eric (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b9084c5c514sm246125466b.5.2026.02.22.11.59.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Feb 2026 11:59:02 -0800 (PST)
From: Eric Woudstra <ericwouds@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>
Cc: netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	bridge@lists.linux.dev,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v18 nf-next 2/4] netfilter: bridge: Add conntrack double vlan and pppoe
Date: Sun, 22 Feb 2026 20:58:41 +0100
Message-ID: <20260222195845.77880-3-ericwouds@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260222195845.77880-1-ericwouds@gmail.com>
References: <20260222195845.77880-1-ericwouds@gmail.com>
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

