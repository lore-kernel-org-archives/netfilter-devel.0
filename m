Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792569020;
	b=Lh6EgcyyNWbFIcJOocwTduEXaMENEg53J8h0Xv8guud5bYZdw4orCtFi3DLZLHWEJHG4
	 8xNija74nE3khn4m2p4Mn2wDsTa1vN1MpnK3YomtbhuXNOsUA1wbwvIzRkFNaxo8Tpdt/
	 SDJ7ICM3pHRZFwDyJ89Ff/lfk+5x5TigphW/fvq+JcwqnM4xbShotAeEBIFx5tYkBx74c
	 NIlYaXu2bloOPZ0hVjwE2QOzgsmdxv6McHNljyVSfF2B6oTtgsQcng66JDG2veMhsAJ7+
	 VEIyDDZixRl/BWdoHDc+rLn6Pz7Sfpu73h+mjMl5sjOAVmOcfoXyAdF3P8aTCu5gdXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792569020;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To:X-Mailer:X-Mutt-Fcc;
	bh=3DuwadyU2g5iqGEIG2IzR3pcwhryNWc0jF5HYbT+65k=;
	b=ZTtw4veXNM97DUMV7PvFKI1TrFxqTUbpa8qXTRjeX2vcNhpIxw/La8j5aqZD3jiHF2uC
	 nm7iLlx8KrLFLgaSfqc8R7k6IJ4M9cKIcFj3bs3LOgI+lzd51p9vQmrXi6PsFSLNooZ0H
	 DHXpLSzc3HJkNsMoHcXNXUxAhbU2JpqFbqKemYdwFnGn/Mrz36DP7C6DVCvtCQuFrtiOL
	 GbEdDQH9pZh5DQ/FGWz44ZCIWHZbJqmrKNoW5vJV0QD9QX9yfYt7pkKulp0Ne3xI32z1R
	 PeQ30nuXEz2zdjqRDMDnh+YkLu4MeFSyzBMNitpGiIFHbT8sodF9IBOcY/NQ75k0GtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=DoIG8IHb;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=NP9rkW0A;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C13B606A32E
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2026 07:50:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2C13B606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=DoIG8IHb;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=NP9rkW0A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792569018;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3DuwadyU2g5iqGEIG2IzR3pcwhryNWc0jF5HYbT+65k=;
	b=DoIG8IHbeFDFs46HhJ/cv2qUOnQTxENGDocfZPR7/qpr7S2J263T9GPZCtIlxKdz/R8K0U
	JQOXYqa/kDKQfgoQD1BCQudnVzHIRnNqMEDWaTS8FbRvCGwkq6A5HREcOLsPH4CICWzoNn
	Ty/lebP7eGwAsjkj/f114cuBYwmGrdw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-280-aopUE3j_MJy20CipFgsnWQ-1; Wed, 21 Oct 2026 07:50:17 +0000
X-MC-Unique: aopUE3j_MJy20CipFgsnWQ-1
X-Mimecast-MFC-AGG-ID: aopUE3j_MJy20CipFgsnWQ_1792569016
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-49953abe51fso3053835e9.1
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2026 00:50:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1792569016; x=1793173816; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=3DuwadyU2g5iqGEIG2IzR3pcwhryNWc0jF5HYbT+65k=;
        b=NP9rkW0A7xpelmyGEGiwy3UN094Hqg7edG2BGlCLDjYH4p3FtWXdvkRtregRBCPcU4
         tWi7MSxaS8Yr6mc+hNcb/AJuhpsZHAEK1eR4GEX27KrZNEkHPtdaY0bdWwEm+vLSP7tP
         WCwlzczzQK5U4eXfpJQ7WUCE9PF3LwsKbWTfeD8rxSfDUdPCVlf3aE0HM8xCbS/azug7
         kMQW9p7sAZnAM8AF8hCXF538J2hB4iLxKd8pD50LFnV4G7Q8T5u+FUEL9YdADdO38/HL
         UY5WPDZlO45rcpI/GoL+RiarDzjeg2SfpU70PJxiAoczj568yiBC8dEsjxdbpom1o+WM
         cGJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792569016; x=1793173816;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=3DuwadyU2g5iqGEIG2IzR3pcwhryNWc0jF5HYbT+65k=;
        b=MgbidvDMH9Q5dcFodBpddtZ2U69N9Vyl1diDJYvPpgI1R16iGzTKzXz7mMzfx39bb3
         AlFbLrUlYy7Sko3UpYJXuQakLg0P8kGPcxRbpOv8G6Ol4JcimfJj7UF9vELOeADTy34h
         2dqLV4gk9wf+aL3WLfpBqwfIyyyYAYhaw8o9QJcH3XS/cwV0tP3u9UdFTurFLDaMW5CN
         0P7nI38+4/dMh2GGP0gqtrZnxRN5LHQOQhAgO0ajm/t4B7gBeRUAtZKgrhiuC66NWqQg
         z8gFk54ASZA4tkhs6RZzp2e3g67CIkhJz3N0xvqyGBS31b1WJDYWQu/dSOTluUgwkXeP
         luHQ==
X-Forwarded-Encrypted: i=1; AKwUvBx7tdMZDqVsDTmEG1LuCqYSMmv8lLRsAV4bLIeEdryDB9RgxF8WP51pvFc6bt3w9PauoTLg7bs1ClGzIaslAv0=@vger.kernel.org
X-Gm-Message-State: AFq9FYIxHnWAuXrvUgTu5B0YqIT60ahS5N7GiRiUgwj9fMNWMZY6o3bo
	ooPE2oGrw9/pVnmFFl8LLorausP5NcQhisB5ToWA1x4B0XJNn4DOH6l5lKBM1F3WTFmsb3+801U
	Bu4bXXAvrWWzo6uXULUAppz2iclCzdJZtGJ1dLFe5ChyBW7cMEeqLHKI1X/lwjbs3SJ7IHg==
X-Gm-Gg: AYBFou20F7plc638xk8Y0ojzFNNpdL+ow2boyFy42nOXwmv/872MTKfx8JK9mUBJ9Ef
	V2PN5eTB0WJ9omEJMiGafnuI1+RT97N5QSbGuR/Ea8fToRCdRFWZNBuO7k3+563hezpDfF3keDh
	XPXGp+COUavbr7iPFeBBz+RECMTU2qIQQPf3hJi0lqsCytVDwSOxb6W7+7eaAlQ8WJZAf0+vk8r
	JrEfVSDgFLjgLvO+d99dqbGRfx9y/Y1AwA/UKVQQJk23gLV8clIQUXFimvId+kcfNPgozYpyEo0
	K/75YhfFG321uF1olB9oMLxcZeO+AocLJ3KtJeORqCJnxULmetGPGQ0BO5FhHUEjgmxF9A==
X-Received: by 2002:a05:600c:1f88:b0:4a1:a45a:88f with SMTP id 5b1f17b1804b1-4a1fdd2463dmr21819605e9.20.1792569015535;
        Wed, 21 Oct 2026 00:50:15 -0700 (PDT)
X-Received: by 2002:a05:600c:1f88:b0:4a1:a45a:88f with SMTP id 5b1f17b1804b1-4a1fdd2463dmr21818905e9.20.1792569014920;
        Wed, 21 Oct 2026 00:50:14 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:3fd7:5300:3d6b:52a4:a23f:9d0b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1fc0b42bdsm38255635e9.0.2026.10.21.00.50.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 00:50:13 -0700 (PDT)
Date: Wed, 21 Oct 2026 03:50:10 -0400
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
Subject: [PATCH net v4 6/7] net: add ip4_parse()
Message-ID: <aa1551c0357a149a84d01761872cb4d3b489d1af.1792565282.git.mst@redhat.com>
References: <be251d104f881a309cfef150455efa128ebb101d.1792565282.git.mst@redhat.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <be251d104f881a309cfef150455efa128ebb101d.1792565282.git.mst@redhat.com>
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
Reviewed-by: Björn Töpel <bjorn@kernel.org>
Reviewed-by: Phil Sutter <phil@nwl.cc>
---
 include/linux/ip.h                  | 30 +++++++++++++++++++++++++++++
 include/linux/virtio_net.h          | 28 +--------------------------
 net/bridge/br_netfilter_hooks.c     | 15 +++++----------
 net/ipv4/ip_input.c                 | 13 +++++--------
 net/ipv4/netfilter/nf_reject_ipv4.c | 13 +++++--------
 5 files changed, 46 insertions(+), 53 deletions(-)

diff --git a/include/linux/ip.h b/include/linux/ip.h
index d11c25f5030a..aba37cd60212 100644
--- a/include/linux/ip.h
+++ b/include/linux/ip.h
@@ -56,4 +56,34 @@ static inline void iph_set_totlen(struct iphdr *iph, unsigned int len)
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
+ *
+ * Return: the validated IPv4 header, or NULL if truncated or
+ * malformed.
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
index b3bbecbd023c..724ab8659501 100644
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
  * has net.core.virtio_net_hdr_validate set to 0.
  */
@@ -157,7 +131,7 @@ virtio_net_l4_start(struct sk_buff *skb, unsigned int nhoff, __be16 proto,
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

