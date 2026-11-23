Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795403457;
	b=UD1j5dzHtmxR6jXPd6JT5jOrAckkEbL8POjFGX6gposjkErEWN406yqt9VSA24PPT2S4
	 s0s9/7G9MvA3yjEO/Rq2nnYLYUt6bb8BqSE/tmF6/JT4wo9YncTpJX2ew5rNQzWpK6lga
	 av/yLaT5MtrNKN2MIYW7npaZdeZkYopXnPB8U0tBPrRbwmxLuKv0uU40fGVuRJSLhfphA
	 gs5//JpJHaJmb0COEymKWtdS0E6/QJue05BOWThnxDahXRAoLuZSQrI6l0iAvF8OQOvlI
	 i4OWT7F036JNP7IuAs5lqC7ewNbo7mnNz8IOU3s95MzzSDO8CbvvMXiexy2yt2Td3Ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795403457;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=xC8uNV0eir7OkjvnqZSoZuHi/kEMl+1aERjTTAXCD8w=;
	b=lZf+kPqs8+6t2fZDGcklxnvcBEPnhmoOpJ996kBnBsxk3Y4KORhoF9CRlp5f0EXWjgT5
	 kcor/+d4ZybeAQP4Z3tJOZ4VFUL385dX27cCAoH6RcgzRjNFXNs8waEhe8aIxQbka+Eso
	 sSfAvdVcUS1wDHf+3Dk3qvCoiiyUOsjlGziLy6u50uImYLmOzgxPvNZMfszAzPlF8CPn8
	 Q7bJXZT+MLuRc86Vk7AXPTTnl4J1ZK22d0veY+jxmBAw5wcO/A3TI0r2TNqpTfYbXxLaW
	 OVkTPCksCKpuqkwsws34D77fjRHk3YlYcfu45FkcE0x07JSNYUASdQNRq/w0Q+Wx8kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nebusec.ai;
	spf=pass smtp.mailfrom=nebusec.ai;
	dkim=pass header.d=nebusec.ai header.i=@nebusec.ai header.a=rsa-sha256 header.s=google header.b=FOaYYFId;
	arc=none smtp.remote-ip=209.85.210.174
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F12606A31A
	for <netfilter-devel@vger.kernel.org>; Mon, 23 Nov 2026 03:10:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 96F12606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.a=rsa-sha256 header.s=google header.b=FOaYYFId
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-8b271e573adso1147928b3a.2
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Nov 2026 19:10:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1795403456; x=1796008256; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xC8uNV0eir7OkjvnqZSoZuHi/kEMl+1aERjTTAXCD8w=;
        b=FOaYYFIdm0rIy7QOU9irALqif7ZufGDcl6FdnaFq1riUskHWf2JHkisw86i0e+K8o9
         HqvJobboDW5Edg0qupeRNyYTAXHfaO45TgYy4H7fjhwxAoZ1drH+iWtZGCT5bsKS0sJJ
         n/ckpnxR7lCrSEC31dhmr1mQfTgLiySxqFgIV/51q/yFeM1sDh0B7Y5NLY6OaiCF4yoJ
         xo0+znipSn9zqp4s0GT/NlzW6FthNPV6ygSHnylHwlWsUZT9Q9rC+HnhQ1ee43EdVLs8
         VU0R2Sc0ipAUo/CgMYf9wn2B1dAe3H0dwSULDhoZR3rTUECQ2gZNFTboATYffZA47dK5
         kHCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795403456; x=1796008256;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xC8uNV0eir7OkjvnqZSoZuHi/kEMl+1aERjTTAXCD8w=;
        b=FdSSKgc6cZiQyj3KsMzHaQSq66sk17KAJMRQYQNqUo+agyc2CVFS53vi2N++7yu+PI
         ZnkRlODD+g6OJTOJMpnO9/2sJI8IGS611H9FKdGsqDmY/AuyaZjtWKIp+xowUjuRbbp6
         G4UGTUnMWEMybH4m18EaBY19UHXJypQXjK6y9l5SzLY3SvnCeh/L8wGxvnLsSjAYLBEF
         a9f7E2guZRVntij6XX4mMWwYan5NogCaBCRohk8ug6c19wFrlZ01Dw7o08K7IzD9c7bh
         8tXH+G3KvvGkhVZoW4Q/ReEU/t2oZfrk+1j69X18Ad1redtoAY3wGtYCMTXrUMqebrtM
         bdPA==
X-Gm-Message-State: APuU4Z/hUjpkNUR5Q5AY0jXTtM8+6LMdK9E25e2nMWbYOz3Fd0AKdZku
	5g3E0itRtURuEK97Gl58U9l+A7GwPsK8/txof2J6RTto+JSt9XEO76ESbvGgBWIxi9LUjlO4wni
	T5a+yMTQs
X-Gm-Gg: AZFdTZf+vw9HwDt1fJe6wukbu9w0Tl9R3xDRfRO7aDqgsWhK9Ia+1fxYHYBerJDKnHl
	4Vwo/uGgiN7RHebL8JYNIaDm7tQOQRPoFj7SiwqCS/wQot58d28egFi3/8AjXP0M6umHB/jFzV3
	/sRlOj1FgQAKNZfN5HRGeSHAf92cTEG83fqt8zOUgNEUYsaox80pFHUS105sgwT+7PpRgF/7o4Y
	BGAk+E+fIEZUxFLnRavYyDWiYdBqgylp9ZD5NK7soCFay808w+ENtJfZ24Q7CTEWvnCQxG1kILV
	z/CGFjlNZ5G8IjC8rx0jU7mJGjllkFIt5wPeXRX5QDeBvB8eDxKQVzo4CsVzMubww6y5h4nzIgx
	xxVzmtzfrovv/7Suo5bHQkwEvgfMPRpr1htydB7W9MKVUBXurtSIYou/P5mbpQvdADSRCERDAmB
	iPiWlskCZAObKuSEuVcTUwf2fDjjb1yrKRaNx43VQrwnBXb5/AH2cwnjW1bV5W+lTBaVXYpWlcN
	DEddiTQoo2lX4M8atRw6lUsjh8qAD4IhIUQpXYJYL5r5T/TIg4WczLPOoOG0fKR2ifV1M+IIHDw
	gaO9D0oByY/Nba+wTwER07NTZ6Shxe2takHVaNyX
X-Received: by 2002:a05:6a00:4c19:b0:8b5:f313:9f54 with SMTP id d2e1a72fcca58-8c87d32b35cmr8423896b3a.56.1795403455931;
        Sun, 22 Nov 2026 19:10:55 -0800 (PST)
Received: from enjou-Legion-Y7000P-2019 ([191.223.218.36])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c87343fe6csm4826392b3a.37.2026.11.22.19.10.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2026 19:10:55 -0800 (PST)
From: Ren Wei <weir@nebusec.ai>
To: netfilter-devel@vger.kernel.org,
	bridge@lists.linux.dev
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	razor@blackwall.org,
	idosch@nvidia.com,
	davem@davemloft.net,
	vega@nebusec.ai,
	sashiko-bot@kernel.org,
	rakukuip@gmail.com,
	weir@nebusec.ai
Subject: [PATCH nf 1/1] netfilter: bridge: detach conntrack template on invalid IP frames
Date: Mon, 23 Nov 2026 11:11:01 +0800
Message-ID: <b2d3ea42b2d8d4d9c97452a123dd5f6c3cded1c4.1795348417.git.rakukuip@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1795348417.git.rakukuip@gmail.com>
References: <cover.1795348417.git.rakukuip@gmail.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Luxiao Xu <rakukuip@gmail.com>

A bridge rule such as nftables `ct zone set` can attach a conntrack
template with IP_CT_NEW to an skb before nf_ct_bridge_pre() runs. When
a frame has an ETH_P_IP or ETH_P_IPV6 protocol, nf_ct_bridge_pre()
performs header pull, length trimming, and nf_ct_br_ip_check() /
nf_ct_br_ipv6_check() validation before invoking defragmentation and
nf_conntrack_in().

If any of those six checks fails, nf_ct_bridge_pre() returns NF_ACCEPT
immediately without passing the skb to nf_conntrack_in(), which would
normally clear skb->_nfct and drop the template reference on parse
failure. Because nft_ct_get_eval() evaluates NFT_CT_STATE from ct and
ctinfo before rejecting template objects, the retained template causes
malformed, truncated, or wrong-version IP frames to match `ct state new`
instead of `ct state invalid`.

Jump to a shared error path that calls nf_reset_ct(skb) before returning
NF_ACCEPT on all IPv4 and IPv6 header/length rejection paths so the
template reference is released and the frame is treated as invalid,
even on kernels without downstream template filtering in ct readers.

Fixes: 3c171f496ef5 ("netfilter: bridge: add connection tracking system")
Cc: stable@vger.kernel.org
Reported-by: VEGA <vega@nebusec.ai>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/3cf187b612fd78f8835fa9dad870326ce380f82f.1785479514.git.zhilinz@nebusec.ai
Signed-off-by: Luxiao Xu <rakukuip@gmail.com>
Signed-off-by: Ren Wei <weir@nebusec.ai>
---
Note on related upstream work:
Florian Westphal's series "[v2,nf-next] netfilter: conntrack: add and
use nf_ct_get_real()" (linked below) mitigates the downstream symptom
by making ct state readers such as nft_ct_get_eval() treat retained
templates as NULL (INVALID rather than NEW). However, nf_ct_get_real()
targets nf-next and is not present in nf or -stable kernels, and
nf_ct_bridge_pre() still leaves an unconsumed template attached to
skb->_nfct on malformed IP frames until freed. Resetting ct state at
the rejection site in nf_ct_bridge_pre() aligns it with
nf_conntrack_in() and the existing non-IP default branch.
Link: https://lore.kernel.org/netfilter-devel/20260923122741.30468-1-fw@strlen.de/

 net/bridge/netfilter/nf_conntrack_bridge.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index b5444335b86f..0da0f899edb8 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -257,28 +257,28 @@ static unsigned int nf_ct_bridge_pre(void *priv, struct sk_buff *skb,
 	switch (skb->protocol) {
 	case htons(ETH_P_IP):
 		if (!pskb_may_pull(skb, sizeof(struct iphdr)))
-			return NF_ACCEPT;
+			goto invalid;
 
 		len = skb_ip_totlen(skb);
 		if (pskb_trim_rcsum(skb, len))
-			return NF_ACCEPT;
+			goto invalid;
 
 		if (nf_ct_br_ip_check(skb))
-			return NF_ACCEPT;
+			goto invalid;
 
 		bridge_state.pf = NFPROTO_IPV4;
 		ret = nf_ct_br_defrag4(skb, &bridge_state);
 		break;
 	case htons(ETH_P_IPV6):
 		if (!pskb_may_pull(skb, sizeof(struct ipv6hdr)))
-			return NF_ACCEPT;
+			goto invalid;
 
 		len = sizeof(struct ipv6hdr) + skb_ipv6_payload_len(skb);
 		if (pskb_trim_rcsum(skb, len))
-			return NF_ACCEPT;
+			goto invalid;
 
 		if (nf_ct_br_ipv6_check(skb))
-			return NF_ACCEPT;
+			goto invalid;
 
 		bridge_state.pf = NFPROTO_IPV6;
 		ret = nf_ct_br_defrag6(skb, &bridge_state);
@@ -293,6 +293,10 @@ static unsigned int nf_ct_bridge_pre(void *priv, struct sk_buff *skb,
 		return ret;
 
 	return nf_conntrack_in(skb, &bridge_state);
+
+invalid:
+	nf_reset_ct(skb);
+	return NF_ACCEPT;
 }
 
 static unsigned int nf_ct_bridge_in(void *priv, struct sk_buff *skb,
-- 
2.43.0

