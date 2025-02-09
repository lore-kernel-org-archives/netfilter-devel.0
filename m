Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFCC8199FC5;
	Sun,  9 Feb 2025 11:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739099451; cv=none; b=NZYQMTZsNTQpbaJaNPHReTNeU1liYjZqVNoqdOeIlIO4llsdQ4In3RcdWM4HW+kNFahDwc9Al1ID4q1eC7VYbA3iYjIGdmGsrEds1Fx98a4yyYtqJ95nZqkzKrHd5PZQx8AhFQe/89I9whkXy+DECFDp0yBZTsrbWKQ4CpZ33ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739099451; c=relaxed/simple;
	bh=Cv52Ysjt2lko9sBWDja1ONZ3DhITuFZz/l5ensZZgPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mBrApA5Lc4rScvlTkilq13BmebXC2kkGAg0/6ggcClacGc/DaeN8W/xx5gnyGxcfCZbU9coo5lNi2YHgLHKCQP13FiVy48JdRyvJ0pJ/5I/8rX4wNTzwN9sHjSV8XWDNPFzzGsAI2EKjzy7jc+cuz0cb83ZpnJgviILlzapLMxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ru+AxV68; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ru+AxV68"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5dc89df7eccso6916723a12.3;
        Sun, 09 Feb 2025 03:10:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739099447; x=1739704247; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+rhlCg4/52AHm6e8tJsmpQptNUxepmsLI5spztxpn6c=;
        b=Ru+AxV68dLHK/GavfUk3WLVjLd+9qjbxWooaD6Vqzl/Gh71FQjdvs/iL0WXCa7Roo0
         MDpQY05uRM+C0TnEFbqgUIIDJxKX7nj4KAv4hjyNQKuu184sw9Iyg12CgBnethXiYJ67
         b31gx9c7S+T/qqu0E/Ro31/KidTMv+TzldzyJRpsd15INZia/8qilXy4w29WBHOSEgKr
         QUieRixhQiuoETQYVoa56fCegn32MxW7h9oEwQge700jRVpe5Rq6vQDq8Qt49xx/1FX+
         GBmYE9kPSikc/JYJT5jFNRj62A/UZfWfhL/+x1IyjJT8x0Q7Vk+nHM07WFZlLYVr7zDk
         I3UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739099447; x=1739704247;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+rhlCg4/52AHm6e8tJsmpQptNUxepmsLI5spztxpn6c=;
        b=gJHFr8CmhO7supRsQW0evup9mktC6nK3MC7Nt8Zyk3X+OHOWjLlSeQ+1Z2R/0+VuF2
         DnzOmZseQuHnHlwh4rDT3Yy6SmtgJqvEUmBMWCwNM8STUtMgrh2SBFXYd16PP7CzCoPP
         R6u01x+xOlPax6IZ3Ma58GVDZt3+ja9DvSpQu/fmliekEAWYzljT9zjzbQzQ1Gsvmjli
         stIlpre74J/SRc+SagZfpvo6z+uygOkcCpvCLTJ7WVku3mgDrumGj4ciPLlHnT1dSfGa
         0fN74UzSnbOBeWOEXG0Ox7V2y7sbYcwLN5WLKhQtW2QelPL+05ejBbw6Dj/1pHOjzh3a
         LikA==
X-Forwarded-Encrypted: i=1; AJvYcCVxw6rwK/7/hBWZunP6ZDLhiE9JJwR+CD844bUxa7LFKN0JFZdZqJ7F1635l9LBl5pYMZTvykOpK2tEVWE=@vger.kernel.org, AJvYcCX5u8lrk+xjfDzfdKqAvFRKchJ0hG/2ImizilaNmzx2Xcybwkjlo/4Pgwcvk4oKn8Iln9GxclcsfZ+Z13l4FEhO@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3PTTKHx98rJA0o/oHeVPcoMZzTn440OiNEl6lhAkag8dTo8gJ
	8W0lU1DoAvbD5XL8rN4JfdFsgjdOB5e70Ws/Hnu4CCHG3M/2d81y
X-Gm-Gg: ASbGncv2OmmwDQAoHsecEwA/2HJKy1R+BOjD+wjwIkWV31dkUArMIbJBJYUcs4d8QWZ
	72aOHqg6wNw6xc/jgd1TklToXkTpW2MegNXrvggNkm1OT1PAxaP340hGjaxvNeP5xwazgBufxZh
	Ec3vRDYh/PxtC5rM3ERJaJLVtDvA1lVPE9UIVrUoO66Zm21Fxp8Gu4fnKSmpnNcJ8gvJNHfH6YF
	hPwWGXdgjJOotwRJe8cUg6N6qt6XfQm24GmxCLJURf0cMfvaXErLQzWh+mADOwf2srfOtcVKs8V
	PhtdeYBT5AVjRXIxuGpB6nJ4I3Sqf9rtVG5Fx5KHw2enzdMYOd9cvwHTs99jNJu94Jemfm4srPy
	qTefj2m5VIyrI6PMokNdVHN+LOmwbdTL4
X-Google-Smtp-Source: AGHT+IEJGx8wQoo1dMKGJULnbHYNaXYTUKaNfqX5z4+uVPE/Bt8Onuv1jKMr9kAQ8Pgh/X+AOmc+8w==
X-Received: by 2002:a17:907:c04:b0:ab7:e71:adb5 with SMTP id a640c23a62f3a-ab789cbe4f0mr1245719366b.35.1739099447174;
        Sun, 09 Feb 2025 03:10:47 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab79afc7452sm357516366b.163.2025.02.09.03.10.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Feb 2025 03:10:46 -0800 (PST)
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
	Kuniyuki Iwashima <kuniyu@amazon.com>,
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
Subject: [PATCH v6 net-next 03/14] netfilter: bridge: Add conntrack double vlan and pppoe
Date: Sun,  9 Feb 2025 12:10:23 +0100
Message-ID: <20250209111034.241571-4-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250209111034.241571-1-ericwouds@gmail.com>
References: <20250209111034.241571-1-ericwouds@gmail.com>
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
 net/bridge/netfilter/nf_conntrack_bridge.c | 83 ++++++++++++++++++----
 1 file changed, 71 insertions(+), 12 deletions(-)

diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index 816bb0fde718..4b4e3751fb13 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -242,53 +242,112 @@ static unsigned int nf_ct_bridge_pre(void *priv, struct sk_buff *skb,
 {
 	struct nf_hook_state bridge_state = *state;
 	enum ip_conntrack_info ctinfo;
+	int ret, offset = 0;
 	struct nf_conn *ct;
-	u32 len;
-	int ret;
+	__be16 outer_proto;
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
+		} *ph;
+
+		offset = PPPOE_SES_HLEN;
+		if (!pskb_may_pull(skb, offset))
+			return NF_ACCEPT;
+		outer_proto = skb->protocol;
+		ph = (struct ppp_hdr *)(skb->data);
+		switch (ph->proto) {
+		case htons(PPP_IP):
+			skb->protocol = htons(ETH_P_IP);
+			break;
+		case htons(PPP_IPV6):
+			skb->protocol = htons(ETH_P_IPV6);
+			break;
+		default:
+			nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
+			return NF_ACCEPT;
+		}
+		data_len = ntohs(ph->hdr.length) - 2;
+		skb_pull_rcsum(skb, offset);
+		skb_reset_network_header(skb);
+		break;
+	}
+	case htons(ETH_P_8021Q): {
+		struct vlan_hdr *vhdr;
+
+		offset = VLAN_HLEN;
+		if (!pskb_may_pull(skb, offset))
+			return NF_ACCEPT;
+		outer_proto = skb->protocol;
+		vhdr = (struct vlan_hdr *)(skb->data);
+		skb->protocol = vhdr->h_vlan_encapsulated_proto;
+		data_len = U32_MAX;
+		skb_pull_rcsum(skb, offset);
+		skb_reset_network_header(skb);
+		break;
+	}
+	default:
+		data_len = U32_MAX;
+		break;
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
 
 static unsigned int nf_ct_bridge_in(void *priv, struct sk_buff *skb,
-- 
2.47.1

