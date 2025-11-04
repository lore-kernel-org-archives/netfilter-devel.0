Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B656732F75C
	for <netfilter-devel@vger.kernel.org>; Tue,  4 Nov 2025 14:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762268300; cv=none; b=UCNRUscD3nrxBduja+JeeUtpJn8o2FiXguHSqf/46NpqzOpMyX5h1ZyfRm0Ak3xzZSYxbbYljl/1W1V7wWSc+QSsdyWGrnUEkn0MHGZdgPwzYmx3TvfRIgMhV/2+3LzZ2NQVXj3obTJoOB4Oly6gNLTQJfu8TnO+ke+IAb0f8w8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762268300; c=relaxed/simple;
	bh=NfMwE8dlBybLdyHrMU5tp+2O3dmiRVolCqKrdaLCBmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RdB19BDe78tqaYRRdBnCh4kJFX3/YwnUgZSxNrIxwC322y+6hhijbPu0IRQzRMKMa8+wpTXZn8cBhQ79We+9/7U/7dO5Y0qyhtyHnp5x6ljfqa/U7bcH7HNNJvPdfSJhqwWE7jObgK1FfQmQJj3LsfMSM48vR2EyNrglp5FcPqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=enDtNJyo; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="enDtNJyo"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b710601e659so327106966b.1
        for <netfilter-devel@vger.kernel.org>; Tue, 04 Nov 2025 06:58:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762268296; x=1762873096; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hS4vmMYkkCMh57/80KWcAsjRY0+LD1ZQh8tlkeNEwTE=;
        b=enDtNJyo6gd2xWxdoMQynXypH05rX5ToadiKZJuvDN/2NOI/l/LFmIy2K8x08X+qlD
         V1CX3kPT5IrYmI1dqQgidtC21BI19SaT1Z1UjUDNWY8tIovDYU+L2Z1M0+GykTVwbQMh
         l2f/axRUdbbOWEkh9okqtKng42gegmxPwYzQZemTQtI0kHrxfLgXozntLDMRVmA0oNQ7
         M1ogIzPxYe39Kkaj0DVFV2OJUbVwYpfZuQnre4eFwm17rVdu5EebJ5QGqWdBD+pW9A3g
         ADWTvNDU9MQ0dnp+14RxvE5sHS2Qrmh9gSmlPg0U2ht97GjIGuJywIjrz9F3R5iPwmyp
         LuWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762268296; x=1762873096;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hS4vmMYkkCMh57/80KWcAsjRY0+LD1ZQh8tlkeNEwTE=;
        b=ue87SI+nr6D3gUlCjZUk+E96bv9JLE2qUEQxnESwkrzSs4iRrwQH7ikF06uhYvnbHF
         D1b6i9iTT5ZpJExOMlPC3GzfZ+Y+rYHjPhzX38Wiv9FfAWPjuexh75Eou/5IMFLU6D5A
         uUBYryVDIny3/bjGMsN8lYb31o/jgIGK3xxYRnxli5LEcDG7KL3dvxp0R3xOHSvruoCU
         qoK1CEW0JKgK8lnwns4DL7QIipW6cmK/PWgfsZ+PhfoxTPUnMYF2HfSpRwxnHs91aTju
         Wh0qPc9L11//FbAiQlqOqIM2H9rJO31jqXjyQ1rhOUY5pU8tvRD7aDXFDPSIl5zpos8D
         t1zg==
X-Gm-Message-State: AOJu0YzSXcf+cMqU3ve7Ngg7NS9NgnWcZLxc2knFFfjKGjmhxKAWW9yO
	i9gBHLfG9groIgPET64qGSFnT7d7dY2tc4TzS2prZi0cAz03seUAj3G8
X-Gm-Gg: ASbGncu2y9zX8Bv3m3bbV8LqQuP0reXnV6Rm0DjUnJ0CxgBEA8dSNHp13I/ab+QRByC
	uCjxospgTTkvQY29Ip3bLGityXeSEWmlMVr4k9PZ9dxilxvZCPxo8ORz38I8vIE7VWBeEz3/NXh
	M1bssKRApc0y8lE5RIbUgUyj2QT0aWTCFmHExKJ6cZi0AJLd04RbaGyp60IdTWCUz0X12OIsdAx
	IRdoBIXMR1CHNeI7FawtQ+o82OQTy2t+HBVSkdl4mIxDLdQw0ZqJcJ4Gvx4CBQEof0tI/93Qz+p
	fuffnteRbxFdQdcGZ4fbS7VKrb8DL6g7QCosl4eUTCjiBKUO7EldooscdpFuUyz8En4D7LCcdFv
	mE9LDm7jU/tRjz+I/mIOOXjw2Cou6YV5Jpxmm1aLJsGhurfhXz1N6OF7+NouLDEW2eWwqHbDhgB
	UnJ3tlh8S2UIwvWEK65DtQ59Gmo4sC6c0NeYdQUldDS8fylFi2WkYF/024b75gH2aH8b6FpvY=
X-Google-Smtp-Source: AGHT+IEzyqLNCwkiIEcsmd4yqk6UOJ2lkQsHu2qKvUmx/if9TQ0V8rUE84bH+QRg7d80a1B6xxzGPg==
X-Received: by 2002:a17:906:6051:b0:b70:8519:44a3 with SMTP id a640c23a62f3a-b7085195e4amr1116437366b.21.1762268295938;
        Tue, 04 Nov 2025 06:58:15 -0800 (PST)
Received: from eric (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b723f6e2560sm232681666b.46.2025.11.04.06.58.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Nov 2025 06:58:15 -0800 (PST)
From: Eric Woudstra <ericwouds@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
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
Subject: [PATCH v16 nf-next 2/3] netfilter: bridge: Add conntrack double vlan and pppoe
Date: Tue,  4 Nov 2025 15:57:27 +0100
Message-ID: <20251104145728.517197-3-ericwouds@gmail.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20251104145728.517197-1-ericwouds@gmail.com>
References: <20251104145728.517197-1-ericwouds@gmail.com>
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
 net/bridge/netfilter/nf_conntrack_bridge.c | 92 ++++++++++++++++++----
 1 file changed, 75 insertions(+), 17 deletions(-)

diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index 6482de4d8750..39e844b3d3c4 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -237,58 +237,116 @@ static int nf_ct_br_ipv6_check(const struct sk_buff *skb)
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
 
 		len = sizeof(struct ipv6hdr) + ntohs(ipv6_hdr(skb)->payload_len);
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
2.50.0

