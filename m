Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3B891E378C;
	Tue,  7 Jan 2025 09:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736240771; cv=none; b=g/18M6XZdZWXPTYz7J3PYtlCmuiLmORLE4UWHeaE5tPsVn+sdzvX2EUb51dljGpPA7Qma+xEWMd0vw1C9fGLOht5kL87vWvPUZosUd8bBLb/lpXQdbJ/tSJPWAGmR3Ffcs3ilz2hdC8aMnQgoum+vHZVmVRVDwqoGGyc4rfkRLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736240771; c=relaxed/simple;
	bh=EiUlqjqcyycmVQh/cReUaNfMFD5MK6JvPeuoOO/UWjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BIKC9xoNZ6SrQsI4vyg6WO8QecJbJHvHnP403f65uDQWbyHOGwstrxU3/DURATGVG4iY3a1rxZWKpIVORAsbuOKuW/mZ2olGdrgkqq1IV3Xry6D2xlOdEH3dH9N7QsyeBaw35idTFCFEOAhf9ED9K9H55Ft+FYohKNgOdsrAbO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bciSA5Vf; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bciSA5Vf"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5d647d5df90so11559608a12.2;
        Tue, 07 Jan 2025 01:06:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736240764; x=1736845564; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k+WwlYEDG0HLvBd8VAnV5F5MIiHlMD5bJhzWof6nBUU=;
        b=bciSA5Vf8OmUTv3Slz/gpPSUzrgzGdfrh7SaF1ZXAymjOepaRL/u9R2zTzZcKDcmH5
         MkXm8eSxaU60rj48QJQQNHfbJMTObp9WwKaVlqNUa2ImuuXzNkKsFM+adVZgLHtLWOxn
         UMp6RzKpT57giI/lfY/hoKV2e6ZsG2BxdyEWziePqtCAL78gmIdP2ePve9/rGg7JWkyw
         4iQJLulwf3RLqdi02YAWXDQKqyqche00wg9FHotMlwe0f2JJ5a5pOMG7vFXhWdRZZP/Z
         E1JXnJaSQ2I4lwwYAmIPH0F+yilKKGYZQnB1gHZN9pyhgkqsptnCAuuleVmN+y2H4Z4i
         N1Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736240764; x=1736845564;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k+WwlYEDG0HLvBd8VAnV5F5MIiHlMD5bJhzWof6nBUU=;
        b=fCcujFkdytMtpdcPwzam9588FC4hA2SKO/+aUrrAv6RvSxMq8Rm1KruxkOK+6YcBP2
         m94m2To4/I+rcuHTAcO3FIo7IKww38q6R01FUpj4S7U9EIBrv7dITzYEpFgmFyvU3xQV
         1X/5Cl9ia2g0bK2cZWmrtW+r8SY3EE7lM7/XcfIkGlkaYWU7JSd/cF1Z004u3gXACfgV
         ckSRvfiWsJwZ4ZuMYwHZpVSnATeFqyt5Blt3+wjiCRCIf8ahNTxmrZG/BWsDasAcdOAK
         gk/oBsPQA4G/WppU85NJe+eVBpfPbUG/yixCYJRyNXbG9SyvHNVUOfU0uaqU9HKw+H2j
         JMYQ==
X-Forwarded-Encrypted: i=1; AJvYcCVhExsB70lDHJiozNDS0tO+XR1DDg2XNduGuatEjxHxYvaPtDZsg5hXK3PEevZit31p9uvWkXtu7qh5BL80xyzY@vger.kernel.org, AJvYcCWoRti1W8+IANtmPl7K8WUC8WgXqB67Lbjw7WLiUvB9kF7at3aPTUfzP7Hxz8OEASkInQ4l3KE+B80XeRA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxXkKvCweOtsq8yQhwlPu8hEJONv0OdKVljfHBmPPIb2HbaGV7e
	50j2M38/fm/Yr73S06JK89Xns9IDQPihKRlCix2vBrj42+RpytbR
X-Gm-Gg: ASbGncu2LDA8HH22svaQnWClYRX1Bz5MxQQpfn3q+YZ93yjaFlWIU9ubROYKiIhH8AY
	qYkwsbm3f3eMLDztuuc1eeWgkDjH8buEDoc7IfHWi0MA7+DFd+xqo6+kIL7C0U6M96fdB6g1W9X
	uXY0dyrdVZc+LFm1CihqZDeBDw2V2wOReYiWJvqHajM2izo07piQ393ZpQXqxEd63gJgogi5eMx
	TXx+kFdD5Ksk8HtgMthrBo+cu+9g+3KwCeqouC9ZuokZvpZ8DOQEDoaZmloCkzr5+sATZ3hUAI1
	YJkIMSo0N/YW/qqtwOsH4CHxVwD68wvw3PSSX5fYlDZhgEsAozVvWLF6/XDxBGhZBNgdVkY8HQ=
	=
X-Google-Smtp-Source: AGHT+IE84iozQuTG7YLPXSHPMUD1Jp0Hd82dBIjkAMjnqzFh19j2OWr5/GOeKdXGrKNPV87nRB5Drg==
X-Received: by 2002:a05:6402:524d:b0:5d2:723c:a57e with SMTP id 4fb4d7f45d1cf-5d81ddacfeemr57802207a12.16.1736240763963;
        Tue, 07 Jan 2025 01:06:03 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d80676f3f9sm24005333a12.23.2025.01.07.01.06.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2025 01:06:03 -0800 (PST)
From: Eric Woudstra <ericwouds@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Jiri Pirko <jiri@resnulli.us>,
	Ivan Vecera <ivecera@redhat.com>,
	Roopa Prabhu <roopa@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	David Ahern <dsahern@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Joe Damato <jdamato@fastly.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"Frank Wunderlich" <frank-w@public-files.de>,
	Daniel Golle <daniel@makrotopia.org>
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	bridge@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v4 net-next 02/13] netfilter: bridge: Add conntrack double vlan and pppoe
Date: Tue,  7 Jan 2025 10:05:19 +0100
Message-ID: <20250107090530.5035-3-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250107090530.5035-1-ericwouds@gmail.com>
References: <20250107090530.5035-1-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This adds the capability to conntrack 802.1ad, QinQ, PPPoE and PPPoE-in-Q
packets that are passing a bridge.

Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 net/bridge/netfilter/nf_conntrack_bridge.c | 88 ++++++++++++++++++----
 1 file changed, 75 insertions(+), 13 deletions(-)

diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index 816bb0fde718..31e2bcd71735 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -241,56 +241,118 @@ static unsigned int nf_ct_bridge_pre(void *priv, struct sk_buff *skb,
 				     const struct nf_hook_state *state)
 {
 	struct nf_hook_state bridge_state = *state;
+	__be16 outer_proto, inner_proto;
 	enum ip_conntrack_info ctinfo;
+	int ret, offset = 0;
 	struct nf_conn *ct;
-	u32 len;
-	int ret;
+	u32 len, data_len;
 
 	ct = nf_ct_get(skb, &ctinfo);
 	if ((ct && !nf_ct_is_template(ct)) ||
 	    ctinfo == IP_CT_UNTRACKED)
 		return NF_ACCEPT;
 
+	switch (skb->protocol) {
+	case htons(ETH_P_PPP_SES): {
+		struct ppp_hdr {
+			struct pppoe_hdr hdr;
+			__be16 proto;
+		} *ph = (struct ppp_hdr *)(skb->data);
+
+		data_len = ntohs(ph->hdr.length) - 2;
+		offset = PPPOE_SES_HLEN;
+		outer_proto = skb->protocol;
+		switch (ph->proto) {
+		case htons(PPP_IP):
+			inner_proto = htons(ETH_P_IP);
+			break;
+		case htons(PPP_IPV6):
+			inner_proto = htons(ETH_P_IPV6);
+			break;
+		default:
+			return NF_ACCEPT;
+		}
+		break;
+	}
+	case htons(ETH_P_8021Q): {
+		struct vlan_hdr *vhdr = (struct vlan_hdr *)(skb->data);
+
+		data_len = 0xffffffff;
+		offset = VLAN_HLEN;
+		outer_proto = skb->protocol;
+		inner_proto = vhdr->h_vlan_encapsulated_proto;
+		break;
+	}
+	default:
+		data_len = 0xffffffff;
+		break;
+	}
+
+	if (offset) {
+		switch (inner_proto) {
+		case htons(ETH_P_IP):
+		case htons(ETH_P_IPV6):
+			if (!pskb_may_pull(skb, offset))
+				return NF_ACCEPT;
+			skb_pull_rcsum(skb, offset);
+			skb_reset_network_header(skb);
+			skb->protocol = inner_proto;
+			break;
+		default:
+			return NF_ACCEPT;
+		}
+	}
+
+	ret = NF_ACCEPT;
 	switch (skb->protocol) {
 	case htons(ETH_P_IP):
 		if (!pskb_may_pull(skb, sizeof(struct iphdr)))
-			return NF_ACCEPT;
+			goto do_not_track;
 
 		len = skb_ip_totlen(skb);
+		if (data_len < len)
+			len = data_len;
 		if (pskb_trim_rcsum(skb, len))
-			return NF_ACCEPT;
+			goto do_not_track;
 
 		if (nf_ct_br_ip_check(skb))
-			return NF_ACCEPT;
+			goto do_not_track;
 
 		bridge_state.pf = NFPROTO_IPV4;
 		ret = nf_ct_br_defrag4(skb, &bridge_state);
 		break;
 	case htons(ETH_P_IPV6):
 		if (!pskb_may_pull(skb, sizeof(struct ipv6hdr)))
-			return NF_ACCEPT;
+			goto do_not_track;
 
 		len = sizeof(struct ipv6hdr) + ntohs(ipv6_hdr(skb)->payload_len);
+		if (data_len < len)
+			len = data_len;
 		if (pskb_trim_rcsum(skb, len))
-			return NF_ACCEPT;
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
 
-	return nf_conntrack_in(skb, &bridge_state);
+do_not_track:
+	if (offset) {
+		skb_push_rcsum(skb, offset);
+		skb_reset_network_header(skb);
+		skb->protocol = outer_proto;
+	}
+	return ret;
 }
-
 static unsigned int nf_ct_bridge_in(void *priv, struct sk_buff *skb,
 				    const struct nf_hook_state *state)
 {
-- 
2.47.1

