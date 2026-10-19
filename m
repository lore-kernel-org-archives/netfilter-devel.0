Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F13564EDCAD
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Oct 2026 12:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792411430; cv=none; b=Gtp9yb6+xhiomSfAencn4Jsb1jq1tqtjRlXAx76ASuqFI0agEKG+nQQyL3i7rW3yOozUJulTLh5+BByE0sAR7RCxbclBdOVX3hRBO6j3TAziMvNT2nWtbS9HUg4hvahYsaTrrIRShrtuSfmVeSjSdGPJUKuAMrwzH3I/W5YLocU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792411430; c=relaxed/simple;
	bh=4xBJ6J3iuSF36G6RpbWT4lVJdCclbuvdUzPPgykXxfc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gk5lKxL/yv61fetnr+Tq77Y1bjvGafceLJPsAbzcjd7sqrhAFrWO9LwbyLgD0YFAn8QtSy4akFWxzxUkDAxuY8/bQOmxaIiiLooO+kLzsc2WDztdBjJuKfXEW96/VsXrFck6MTiLzWjsMiqcCNKVPTXisi3h7P5BVdHM3lHiPq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IcJd8L8O; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=qGXWl9xw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IcJd8L8O";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="qGXWl9xw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792411427;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gCjp2dQNMUJar27ptT1bxSKOhQtdKOeP9BpU3pm389M=;
	b=IcJd8L8Oi+oysP16OXqYqvQUU2qlneUg8unBbJyjYt1/0s8xRfVE3A++DbG7AqX6uEKGG9
	QIK2Ikg3+QPSReaQG/zPgjCW1+uiiMsMsOlD3HpBi15vXyjvVNQneKdSIiiV9B42fJgTkC
	s2XYtySidD4YIE9U0wo7xRNtckGpEdk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-367-DszJQOg2Ouye2cQfbGU3ZQ-1; Mon, 19 Oct 2026 12:03:44 +0000
X-MC-Unique: DszJQOg2Ouye2cQfbGU3ZQ-1
X-Mimecast-MFC-AGG-ID: DszJQOg2Ouye2cQfbGU3ZQ_1792411423
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-48c415561aaso1391874f8f.1
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Oct 2026 05:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1792411423; x=1793016223; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=gCjp2dQNMUJar27ptT1bxSKOhQtdKOeP9BpU3pm389M=;
        b=qGXWl9xwH1lDXahifLlTEFrzryXOe4ezVLursNMNMlzrLnwSR7Ez06rQvdqTml3lTZ
         hfwnkRwhGdiL/1+5gi50cPx7dZeO4QRPicdfY/Z1FXLpCnCu1hT/+WuG2G70wyx//87S
         50w2UB9Ap0M8GY9Hz//f09M6XM4059LxuSSpnGmCgtVFsjcDj0eHiXdTrztD44CL6IwF
         Hx+Epz90UHgX7BrxLCWV7udRlsFS8CVJsjkqOsgeVhA3VvcZWohE0yA69YmO4mbkBAxh
         Z150i9bfB88Rp/eC6DA90fxfRjSqtDkQpXOcbfw0eXjLhkMTdm9CmhkNQKvflczO4b7m
         bQlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792411423; x=1793016223;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=gCjp2dQNMUJar27ptT1bxSKOhQtdKOeP9BpU3pm389M=;
        b=R4lx6TO7RgVGeWTeD1NaXwFkc72l7GGbR9E/w1LYlJg+6nk8U4sF8aQrGiCRVpeZMT
         8krZXDNSunxUHmGhoOCeo1ai4QH0qLUr6hfzMIK55RR1/JCl9ecmCBfegsjk2sKHAUzJ
         h7fA3pRqwnrYMRXToahTKEYXJ1ZC6x1UiDx4EOQBNZc4D6HNz79F/56uQDMDQPGef89h
         0UVR5KCo5zfGFMbKYtrOmOQxuTzwTMHlzP7NcX021E/UDq4CHBuUOdrjVlGnKBAnxUoW
         G65BIUEuoHq7jvB6KcuioV2FV4C7stjremoUQ7+ooIX1pQacNRM8QQbHswO8rEPy8wCL
         85KQ==
X-Forwarded-Encrypted: i=1; AKwUvByLIW/W8TTwfVgSSAN6OWo5xr37mcsOA5GRWHzMPGvp+19XsoyZlzhwPPmagbRoSCpylUpS8f/sar4xhwwU3h8=@vger.kernel.org
X-Gm-Message-State: AFq9FYKikg470ZL00sAKfKLcRv/S5ajrOlnALN5Wy3ZlSnOgQNiuSrxM
	Lk9bZTuIROmwK0aGDFhBrdZBNVmeUXoqYWfUYETUBReOXnmbGsLuSo8q0oMYuCF8HrfZQoY7k8b
	AaOTCc7om+5BE68ftXMJ/pephI1LMb3sXCw3RWd/o0B/Aus8aRZky8+4le2NrOvHT0fOgYg==
X-Gm-Gg: AYBFou16sQiq9MI/+suCN8EOGgDYe4Bx6vWZu/JUlU/Y5jeaHWWhG0L6cMfYGQt4AFN
	2Gh8j0i34tiedUWbl0e7hdGfDuX7dYA2Qel3ni0Jfz8zq8IGYr1HwMmXx2x7MXC2uZhvMETNtRX
	XetzKzdOJWeA6aLzFuy9Cly22hwaVQ/BhIqOzSzlG+BrJjfMm951gGef/9puK5gQPMs3+pop3az
	ssjSNSwZpgXGKPG5F+J34tjdqXBs0TwfqsCYL/y6iSTf9PlyDXZCXX+Jtkd3Y0HIMjfoBBzGdTe
	gG+7Gh77iZOTM0KsauzfXikhNoQ6D2uLDML9pEg6Nc3zhFYr+xZKfijh+AfNFQaS0XUcHg==
X-Received: by 2002:a05:600c:64c9:b0:4a1:f0ca:2de6 with SMTP id 5b1f17b1804b1-4a1f0ca3812mr1628035e9.14.1792411422871;
        Mon, 19 Oct 2026 05:03:42 -0700 (PDT)
X-Received: by 2002:a05:600c:64c9:b0:4a1:f0ca:2de6 with SMTP id 5b1f17b1804b1-4a1f0ca3812mr1626725e9.14.1792411422109;
        Mon, 19 Oct 2026 05:03:42 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:3fd7:5300:3d6b:52a4:a23f:9d0b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1bd9c001dsm356079805e9.12.2026.10.19.05.03.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 05:03:41 -0700 (PDT)
Date: Mon, 19 Oct 2026 08:03:37 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Chris Arges <carges@cloudflare.com>,
	=?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
	Phil Sutter <phil@nwl.cc>, Jason Wang <jasowangio@gmail.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, virtualization@lists.linux.dev,
	Max Krasnyansky <maxk@qualcomm.com>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>, Simon Horman <horms@kernel.org>,
	David Ahern <dsahern@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, bridge@lists.linux.dev
Subject: [PATCH net v3 7/8] net: add ip4_parse()
Message-ID: <8a90cdf35017ad3e2baf04c209718dd4e8d93b0b.1792411304.git.mst@redhat.com>
References: <cover.1792411304.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cover.1792411304.git.mst@redhat.com>
X-Mailer: git-send-email 2.51.2.2891.g4157995a80.dirty
X-Mutt-Fcc: =sent

Multiple places in the net stack open-code the same minimal IPv4 header
validation: pull the fixed header, check version 4 and IHL >= 5 (where 5
is the fixed header size in 32-bit units) - and locate the transport
header at IHL * 4 past the network header.

Add a helper for doing that: it returns the validated header and
the transport header offset, or NULL if truncated or malformed.

As noted by Phil Sutter, there are more places that could use this
helper, e.g. ip_mc_check_iphdr(). They will be converted in a follow-up
patch.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: LLM
Reviewed-by: Björn Töpel <bjorn@kernel.org>
Reviewed-by: Phil Sutter <phil@nwl.cc>
---
 include/linux/ip.h                  | 27 +++++++++++++++++++++++++++
 include/linux/virtio_net.h          | 28 +---------------------------
 net/bridge/br_netfilter_hooks.c     | 15 +++++----------
 net/ipv4/ip_input.c                 | 13 +++++--------
 net/ipv4/netfilter/nf_reject_ipv4.c | 13 +++++--------
 5 files changed, 43 insertions(+), 53 deletions(-)

diff --git a/include/linux/ip.h b/include/linux/ip.h
index d11c25f5030a..7dc666e55a72 100644
--- a/include/linux/ip.h
+++ b/include/linux/ip.h
@@ -56,4 +56,31 @@ static inline void iph_set_totlen(struct iphdr *iph, unsigned int len)
 {
 	iph->tot_len = len <= IP_MAX_MTU ? htons(len) : 0;
 }
+
+/**
+ * ip4_parse - pull and minimally validate an IPv4 header
+ * @skb: buffer to parse
+ * @nhoff: offset of the IPv4 header within the linear data
+ * @thoff: returns the transport header offset
+ *
+ * Only the fixed header is guaranteed linear on return: callers
+ * that need the options or the transport header must pull
+ * further.
+ */
+static inline struct iphdr *ip4_parse(struct sk_buff *skb,
+				      unsigned int nhoff,
+				      unsigned int *thoff)
+{
+	struct iphdr *iph;
+
+	if (!pskb_may_pull(skb, nhoff + sizeof(struct iphdr)))
+		return NULL;
+
+	iph = (struct iphdr *)(skb->data + nhoff);
+	if (iph->version != 4 || iph->ihl < sizeof(struct iphdr) / sizeof(u32))
+		return NULL;
+
+	*thoff = nhoff + iph->ihl * sizeof(u32);
+	return iph;
+}
 #endif	/* _LINUX_IP_H */
diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
index 25aa95c11e31..beaecd9cd28d 100644
--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -53,32 +53,6 @@ static inline int virtio_net_hdr_set_proto(struct sk_buff *skb,
 	return 0;
 }
 
-/* TODO: nothing virtio specific here, move to ip.h */
-
-/*
- * Pull and minimally validate the IPv4 header at @nhoff.
- * Returns the header and stores the transport header offset in
- * @thoff, or NULL if truncated or malformed.  Only the fixed header
- * is guaranteed linear; callers that need the options or the
- * transport header must pull further.
- */
-static inline struct iphdr *virtio_net_ip4_parse(struct sk_buff *skb,
-						  unsigned int nhoff,
-						  unsigned int *thoff)
-{
-	struct iphdr *iph;
-
-	if (!pskb_may_pull(skb, nhoff + sizeof(struct iphdr)))
-		return NULL;
-
-	iph = (struct iphdr *)(skb->data + nhoff);
-	if (iph->version != 4 ||
-	    iph->ihl < sizeof(struct iphdr) / sizeof(u32))
-		return NULL;
-
-	*thoff = nhoff + iph->ihl * sizeof(u32);
-	return iph;
-}
 /* Defined in net/core/dev.c, enabled while any network namespace
  * has net.core.virtio_net_hdr_csum_check set to 0.
  */
@@ -153,7 +127,7 @@ virtio_net_l4_start(struct sk_buff *skb, unsigned int nhoff, __be16 proto,
 		    unsigned int *thoff, int *ip_proto)
 {
 	if (proto == htons(ETH_P_IP)) {
-		const struct iphdr *iph = virtio_net_ip4_parse(skb, nhoff, thoff);
+		const struct iphdr *iph = ip4_parse(skb, nhoff, thoff);
 
 		if (!iph || ip_is_fragment(iph))
 			return false;
diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index 0a394e5f4391..e89da0e41542 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -206,18 +206,13 @@ static inline void nf_bridge_pull_encap_header_rcsum(struct sk_buff *skb)
 static int br_validate_ipv4(struct net *net, struct sk_buff *skb)
 {
 	const struct iphdr *iph;
-	u32 len;
+	u32 len, thoff;
 
-	if (!pskb_may_pull(skb, sizeof(struct iphdr)))
+	iph = ip4_parse(skb, 0, &thoff);
+	if (!iph)
 		goto inhdr_error;
 
-	iph = ip_hdr(skb);
-
-	/* Basic sanity checks */
-	if (iph->ihl < 5 || iph->version != 4)
-		goto inhdr_error;
-
-	if (!pskb_may_pull(skb, iph->ihl*4))
+	if (!pskb_may_pull(skb, thoff))
 		goto inhdr_error;
 
 	iph = ip_hdr(skb);
@@ -228,7 +223,7 @@ static int br_validate_ipv4(struct net *net, struct sk_buff *skb)
 	if (skb->len < len) {
 		__IP_INC_STATS(net, IPSTATS_MIB_INTRUNCATEDPKTS);
 		goto drop;
-	} else if (len < (iph->ihl*4))
+	} else if (len < thoff)
 		goto inhdr_error;
 
 	if (pskb_trim_rcsum(skb, len)) {
diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
index 9860178752b8..5adf01763e85 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -500,7 +500,7 @@ static struct sk_buff *ip_rcv_core(struct sk_buff *skb, struct net *net)
 {
 	const struct iphdr *iph;
 	int drop_reason;
-	u32 len;
+	u32 len, thoff;
 
 	/* When the interface is in promisc. mode, drop all the crap
 	 * that it receives, do not try to analyse it.
@@ -520,10 +520,6 @@ static struct sk_buff *ip_rcv_core(struct sk_buff *skb, struct net *net)
 	}
 
 	drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
-	if (!pskb_may_pull(skb, sizeof(struct iphdr)))
-		goto inhdr_error;
-
-	iph = ip_hdr(skb);
 
 	/*
 	 *	RFC1122: 3.2.1.2 MUST silently discard any IP frame that fails the checksum.
@@ -536,7 +532,8 @@ static struct sk_buff *ip_rcv_core(struct sk_buff *skb, struct net *net)
 	 *	4.	Doesn't have a bogus length
 	 */
 
-	if (iph->ihl < 5 || iph->version != 4)
+	iph = ip4_parse(skb, 0, &thoff);
+	if (!iph)
 		goto inhdr_error;
 
 	BUILD_BUG_ON(IPSTATS_MIB_ECT1PKTS != IPSTATS_MIB_NOECTPKTS + INET_ECN_ECT_1);
@@ -546,7 +543,7 @@ static struct sk_buff *ip_rcv_core(struct sk_buff *skb, struct net *net)
 		       IPSTATS_MIB_NOECTPKTS + (iph->tos & INET_ECN_MASK),
 		       max_t(unsigned short, 1, skb_shinfo(skb)->gso_segs));
 
-	if (!pskb_may_pull(skb, iph->ihl*4))
+	if (!pskb_may_pull(skb, thoff))
 		goto inhdr_error;
 
 	iph = ip_hdr(skb);
@@ -559,7 +556,7 @@ static struct sk_buff *ip_rcv_core(struct sk_buff *skb, struct net *net)
 		drop_reason = SKB_DROP_REASON_PKT_TOO_SMALL;
 		__IP_INC_STATS(net, IPSTATS_MIB_INTRUNCATEDPKTS);
 		goto drop;
-	} else if (len < (iph->ihl*4))
+	} else if (len < thoff)
 		goto inhdr_error;
 
 	/* Our transport medium may have padded the buffer out. Now we know it
diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
index 59ec465a9df9..42d639854ddf 100644
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -25,22 +25,19 @@ nf_reject_ip_tcphdr_get(struct sk_buff *oldskb,
 static int nf_reject_iphdr_validate(struct sk_buff *skb)
 {
 	struct iphdr *iph;
-	u32 len;
+	u32 len, thoff;
 
-	if (!pskb_may_pull(skb, sizeof(struct iphdr)))
-		return 0;
-
-	iph = ip_hdr(skb);
-	if (iph->ihl < 5 || iph->version != 4)
+	iph = ip4_parse(skb, 0, &thoff);
+	if (!iph)
 		return 0;
 
 	len = ntohs(iph->tot_len);
 	if (skb->len < len)
 		return 0;
-	else if (len < (iph->ihl*4))
+	else if (len < thoff)
 		return 0;
 
-	if (!pskb_may_pull(skb, iph->ihl*4))
+	if (!pskb_may_pull(skb, thoff))
 		return 0;
 
 	return 1;
-- 
MST

