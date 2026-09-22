Received: from mail-yx2-f27.google.com (mail-yx2-f27.google.com [74.125.224.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AEEC397E96
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Sep 2026 03:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790046202; cv=none; b=ajbmx3v5pUrgWVc0pnYz4Wv9RXIkaJ1gcBVEMewYW4vxR7lEF38b9vBIcO8Xl2cLZsgHFSseTGJTCslt4Z8hQjZaXowVc0/8/of7y2g680UYpF99jQUxdf61V5QSpkMC7bbHNZudNSud92lr7lmOC7A9z9/+dGDo1GrWUvIrv3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790046202; c=relaxed/simple;
	bh=fFie+O+TzjTwVLdyq2ldFdWdLO4af24IGkMSNUH6SYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q44Mf8M5kMniDwAMy8efyXKBtIzkY3RHT9B56mBGuTrKwXlAkgkhRssSU88hDXa9wHBZIT3znbIQBhh4m2m2ZMAc0ndAoBwiqukEnoSJ2dioMotWsveNRPRpp2TYArhFsFwWDxKfpHDF9LrwOPzJF/CkDedOzmK2p/9pFwBJSqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DCy/qzif; arc=none smtp.client-ip=74.125.224.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DCy/qzif"
Received: by mail-yx2-f27.google.com with SMTP id 00721157ae682-895fd505832so27604997b3.3
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Sep 2026 20:03:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790046198; x=1790650998; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5TgtLun0Gp+97adAPkYnXli1FB7YGXH0JDQsRFi7AIo=;
        b=DCy/qzifnOR5ae9v11eX0QDdsMSzKmOiRe1PxJeG6Oi/KYvTISD2VWCXXILmo93uwb
         rqWVdHbkhgl3FkVtWCnBb86V03VH5HX/VFI3s+cqdIqkO8wVtmR12Hkq44K6C89qsxvy
         UlQC9e8xmaXw+Pdf7sJIITSVBrCKy59C2+sdJYG8SfNYOcNLqUmjRNvRvRuaWO/I5zmb
         GfNcDJaYJyRGGeeg724DHIJnUlt8yCi+/NmTIL2fFlCQE45SCWR1cJjhUuJPdyUPKf+u
         ZOGlEjP2KywDhh3SJ/ZSsyg2VZEG6CKqUOn7KmID80VSi8qSgqlzwDWDNHj8nd/edYzn
         sDYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790046198; x=1790650998;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5TgtLun0Gp+97adAPkYnXli1FB7YGXH0JDQsRFi7AIo=;
        b=NwUSLMBlehTpeUay4uAVp/LmBZqQZ0lxNnXAItSoNDNdmHq7L6bSo67Kdr3I0JiXq0
         d1KtBxdDepQUQN+/MbaC7EfGNdoDRVt2cOqlxwlOBXD5FgNhtV6CLgZf2AzZ6Lt1ESy8
         ZASwYNCK5A7hVTwTVSyWCPY1RQ0aPqIxcwej6f/AFdFVZ/IwdTrLfxZXkIgvc6vUI8xh
         Vm03yvtV649T8iieIKyo/cU6MD/x2hXsLLBzvIedwCzvvG3P6fwNZpkmekM5d2vyMKft
         srTZZCOq7ksrT92OAITippMYV2TgElpIgaukMdBnqO7illTxRWQxF6P8SVdzyDxGiKkX
         RDWA==
X-Forwarded-Encrypted: i=1; AKwUvByq06ZwWqGNuZ2RjOOLK0RDlogFqwusoLOjpL8MRmD1OtVpe+0DqJp6Zn6w7HXWQTxbLv+0vkloUpY0ddwUka8=@vger.kernel.org
X-Gm-Message-State: AFuF++mVnxcyLF7+sErNw0Xuvf9iTlBvhnL0Bc5oTQKnCioyjUlPUnF5
	B9ghrHaKhLVKHCvIRlSIkG6JZa3Y05VUeKO5BlF/Y0tI9rCpZFgYICDD
X-Gm-Gg: AYBFou2ITmkMnbsg1bXnt5ZKWve8DBUiHxT5yek7eWY0WQ70IpR1H5bXL4Slr1AbXv/
	f/eRG3PsoPUUX7KSa96EL47a+5h2DvQzmUxUSjfkOL1gxCzGkn5bWsbJJiDgbihaSAVRfx/BKja
	0UR8jrBudQ6ELZWXyqS4UvnMClgVUfqeybm0xiosHIf2CEKce9suP6AzmMGVI0QWGZti4KX1I2h
	nUOCg8MO++Ax5rcCbW657qu8S2WcQU6otJwnxjrWdyUVHGmqErpqQCGpBXKMNj6ODC0IQiyfuej
	vZ2qZJPkQePVyH/gU6yCps+927VmTaqttFiy4NwamALxtEVKP0MbUCyY3LrFObjv8lEACA1VppB
	OSPUclawHfB/6hrZcobtV7mVV6cT5dJBbh/wc7Ogiar77JrdQo6pz7JE4OQ9lV9MDRJ5XDIUvZ2
	Cxafq3WSbp2th0ygzwwdZ11hydQC/dmBdZIQpd9INdK9GSjekasVXtemwQB7gzkIDChh/gnM5HO
	Gi+LrZqcm65Ul06c/pXxh2sVFlZ8eE1mnq04f3YKkZkPxOYQ3e8sw1NK/2CIFkwKheObTLNmO5R
	nANTP7tZ
X-Received: by 2002:a05:690c:d87:b0:81e:29d9:791f with SMTP id 00721157ae682-89734ac835emr44205777b3.34.1790046198355;
        Mon, 21 Sep 2026 20:03:18 -0700 (PDT)
Received: from localhost.localdomain ([2601:155:4200:2c80:2875:43a3:e345:710c])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8a2c1b02abdsm1471447b3.17.2026.09.21.20.03.16
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 21 Sep 2026 20:03:17 -0700 (PDT)
From: Paulos Yibelo <habte.yibelo@gmail.com>
To: netdev@vger.kernel.org
Cc: richard@nod.at,
	anton.ivanov@cambridgegreys.com,
	johannes@sipsolutions.net,
	willemdebruijn.kernel@gmail.com,
	jasowangio@gmail.com,
	mst@redhat.com,
	eperezma@redhat.com,
	xuanzhuo@linux.alibaba.com,
	andrew+netdev@lunn.ch,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	razor@blackwall.org,
	idosch@nvidia.com,
	dsahern@kernel.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	linux-um@lists.infradead.org,
	virtualization@lists.linux.dev,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	bridge@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH net v6 1/2] net: validate virtio checksum start after network header
Date: Mon, 21 Sep 2026 23:03:09 -0400
Message-ID: <20260922030310.8684-2-habte.yibelo@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20260922030310.8684-1-habte.yibelo@gmail.com>
References: <20260922030310.8684-1-habte.yibelo@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__virtio_net_hdr_to_skb() checks a minimum network-header length for
CHECKSUM_PARTIAL packets. Its checksum start is relative to skb->data,
but some callers have not established skb->network_header when they
convert the virtio header.

Pass the data-relative L3 origin explicitly. Ethernet receive paths
parse the frame and nested VLAN headers without changing skb state.
AF_PACKET uses the frame's actual L3 origin even when the socket
protocol is ETH_P_IP and the raw frame carries VLAN tags. Non-Ethernet
AF_PACKET devices retain their established skb network offset.

Also pass the actual L3 protocol so IPv6 packets use the 40-byte base
header minimum even without TCPv6 GSO. IFF_TUN obtains that protocol
from the packet before skb->protocol is set. Name the Ethernet parser
accordingly, use the same origin for tunnel validation, and propagate
conversion failures in UML.

The bound remains a minimum; fragmentation paths separately validate
the parsed IPv4 or IPv6 header length before completing a checksum.

Fixes: 49d14b54a527 ("net: test for not too small csum_start in virtio_net_hdr_to_skb()")
Fixes: a2fb4bc4e2a6 ("net: implement virtio helpers to handle UDP GSO tunneling.")
Reported-by: Paulos Yibelo <habte.yibelo@gmail.com>
Link: https://lore.kernel.org/netdev/20260920004733.6473-2-habte.yibelo@gmail.com/
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Paulos Yibelo <habte.yibelo@gmail.com>
---
 arch/um/drivers/vector_transports.c | 13 ++++-
 drivers/net/tun_vnet.h              | 52 ++++++++++++++++-
 drivers/net/virtio_net.c            | 10 +++-
 include/linux/virtio_net.h          | 87 ++++++++++++++++++++++++-----
 net/packet/af_packet.c              | 24 +++++++-
 5 files changed, 163 insertions(+), 23 deletions(-)

diff --git a/arch/um/drivers/vector_transports.c b/arch/um/drivers/vector_transports.c
index ddd127ee9..5a9d8f49a 100644
--- a/arch/um/drivers/vector_transports.c
+++ b/arch/um/drivers/vector_transports.c
@@ -197,6 +197,8 @@ static int raw_verify_header(
 	uint8_t *header, struct sk_buff *skb, struct vector_private *vp)
 {
 	struct virtio_net_hdr *vheader = (struct virtio_net_hdr *) header;
+	__be16 network_protocol;
+	int network_offset;
 
 	if ((vheader->gso_type != VIRTIO_NET_HDR_GSO_NONE) &&
 		(vp->req_size != 65536)) {
@@ -209,8 +211,14 @@ static int raw_verify_header(
 	if ((vheader->flags & VIRTIO_NET_HDR_F_DATA_VALID) > 0)
 		return 1;
 
-	virtio_net_hdr_to_skb(skb, vheader, virtio_legacy_is_little_endian());
-	return 0;
+	network_offset = virtio_net_hdr_eth_get_l3_offset(skb, vheader,
+							  &network_protocol);
+	if (network_offset < 0)
+		return network_offset;
+
+	return virtio_net_hdr_to_skb(skb, vheader,
+				     virtio_legacy_is_little_endian(),
+				     network_offset, network_protocol);
 }
 
 static bool get_uint_param(
@@ -491,4 +499,3 @@ int build_transport_data(struct vector_private *vp)
 		return build_bess_transport_data(vp);
 	return 0;
 }
-
diff --git a/drivers/net/tun_vnet.h b/drivers/net/tun_vnet.h
index f4c652b1f..e004213fa 100644
--- a/drivers/net/tun_vnet.h
+++ b/drivers/net/tun_vnet.h
@@ -177,10 +177,49 @@ static inline int tun_vnet_hdr_put(int sz, struct iov_iter *iter,
 	return __tun_vnet_hdr_put(sz, 0, iter, hdr);
 }
 
+static inline int
+tun_vnet_hdr_get_l3_offset(unsigned int flags, const struct sk_buff *skb,
+			   const struct virtio_net_hdr *hdr,
+			   __be16 *network_protocol)
+{
+	if ((flags & TUN_TYPE_MASK) != IFF_TAP) {
+		u8 version, first_byte;
+		const u8 *first;
+
+		*network_protocol = 0;
+		if (!(hdr->flags & VIRTIO_NET_HDR_F_NEEDS_CSUM))
+			return 0;
+
+		first = skb_header_pointer(skb, 0, sizeof(first_byte),
+					   &first_byte);
+		if (!first)
+			return -EINVAL;
+
+		version = *first >> 4;
+		if (version == 4)
+			*network_protocol = htons(ETH_P_IP);
+		else if (version == 6)
+			*network_protocol = htons(ETH_P_IPV6);
+		return 0;
+	}
+
+	return virtio_net_hdr_eth_get_l3_offset(skb, hdr,
+					      network_protocol);
+}
+
 static inline int tun_vnet_hdr_to_skb(unsigned int flags, struct sk_buff *skb,
 				      const struct virtio_net_hdr *hdr)
 {
-	return virtio_net_hdr_to_skb(skb, hdr, tun_vnet_is_little_endian(flags));
+	__be16 network_protocol;
+	int network_offset = tun_vnet_hdr_get_l3_offset(flags, skb, hdr,
+						       &network_protocol);
+
+	if (network_offset < 0)
+		return network_offset;
+
+	return virtio_net_hdr_to_skb(skb, hdr,
+				     tun_vnet_is_little_endian(flags),
+				     network_offset, network_protocol);
 }
 
 /*
@@ -199,10 +238,19 @@ tun_vnet_hdr_tnl_to_skb(unsigned int flags, netdev_features_t features,
 			struct sk_buff *skb,
 			const struct virtio_net_hdr_v1_hash_tunnel *hdr)
 {
+	const struct virtio_net_hdr *vnet_hdr = (const struct virtio_net_hdr *)hdr;
+	__be16 network_protocol;
+	int network_offset = tun_vnet_hdr_get_l3_offset(flags, skb, vnet_hdr,
+						       &network_protocol);
+
+	if (network_offset < 0)
+		return network_offset;
+
 	return virtio_net_hdr_tnl_to_skb(skb, hdr,
 				features & NETIF_F_GSO_UDP_TUNNEL,
 				features & NETIF_F_GSO_UDP_TUNNEL_CSUM,
-				tun_vnet_is_little_endian(flags));
+				tun_vnet_is_little_endian(flags),
+				network_offset, network_protocol);
 }
 
 static inline int tun_vnet_hdr_from_skb(unsigned int flags,
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index e34c52d05..8e93dad28 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2502,6 +2502,8 @@ static void virtnet_receive_done(struct virtnet_info *vi, struct receive_queue *
 {
 	struct virtio_net_common_hdr *hdr;
 	struct net_device *dev = vi->dev;
+	__be16 network_protocol;
+	int network_offset;
 
 	hdr = skb_vnet_common_hdr(skb);
 	if (dev->features & NETIF_F_RXHASH && vi->has_rss_hash_report)
@@ -2515,9 +2517,13 @@ static void virtnet_receive_done(struct virtnet_info *vi, struct receive_queue *
 		goto frame_err;
 	}
 
-	if (virtio_net_hdr_tnl_to_skb(skb, &hdr->tnl_hdr, vi->rx_tnl,
+	network_offset = virtio_net_hdr_eth_get_l3_offset(skb, &hdr->hdr,
+							  &network_protocol);
+	if (network_offset < 0 ||
+	    virtio_net_hdr_tnl_to_skb(skb, &hdr->tnl_hdr, vi->rx_tnl,
 				      vi->rx_tnl_csum,
-				      virtio_is_little_endian(vi->vdev))) {
+				      virtio_is_little_endian(vi->vdev),
+				      network_offset, network_protocol)) {
 		net_warn_ratelimited("%s: bad gso: type: %x, size: %u, flags %x tunnel %d tnl csum %d\n",
 				     dev->name, hdr->hdr.gso_type,
 				     hdr->hdr.gso_size, hdr->hdr.flags,
diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
index c381b916c..b89d821a0 100644
--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -48,16 +48,61 @@ static inline int virtio_net_hdr_set_proto(struct sk_buff *skb,
 	return 0;
 }
 
+/*
+ * Return the L3 offset and protocol of an Ethernet frame starting at skb->data.
+ * The offset is unused without NEEDS_CSUM, so avoid parsing and return zero.
+ */
+static inline int
+virtio_net_hdr_eth_get_l3_offset(const struct sk_buff *skb,
+				 const struct virtio_net_hdr *hdr,
+				 __be16 *network_protocol)
+{
+	unsigned int parse_depth = VLAN_MAX_DEPTH;
+	const struct ethhdr *eth;
+	struct ethhdr ethbuf;
+	__be16 protocol;
+	int depth = ETH_HLEN;
+
+	*network_protocol = 0;
+	if (!(hdr->flags & VIRTIO_NET_HDR_F_NEEDS_CSUM))
+		return 0;
+
+	eth = skb_header_pointer(skb, 0, sizeof(ethbuf), &ethbuf);
+	if (!eth)
+		return -EINVAL;
+
+	protocol = eth->h_proto;
+	while (eth_type_vlan(protocol)) {
+		const struct vlan_hdr *vh;
+		struct vlan_hdr vhdr;
+
+		vh = skb_header_pointer(skb, depth, sizeof(vhdr), &vhdr);
+		if (!vh || !--parse_depth)
+			return -EINVAL;
+
+		protocol = vh->h_vlan_encapsulated_proto;
+		depth += VLAN_HLEN;
+	}
+
+	*network_protocol = protocol;
+	return depth;
+}
+
 static inline int __virtio_net_hdr_to_skb(struct sk_buff *skb,
 					  const struct virtio_net_hdr *hdr,
-					  bool little_endian, u8 hdr_gso_type)
+					  bool little_endian, u8 hdr_gso_type,
+					  int network_offset,
+					  __be16 network_protocol)
 {
-	unsigned int nh_min_len = sizeof(struct iphdr);
+	int nh_min_len = sizeof(struct iphdr);
 	unsigned int gso_type = 0;
 	unsigned int thlen = 0;
 	unsigned int p_off = 0;
 	unsigned int ip_proto;
 
+	if (network_protocol == htons(ETH_P_IPV6))
+		nh_min_len = sizeof(struct ipv6hdr);
+
 	if (hdr_gso_type != VIRTIO_NET_HDR_GSO_NONE) {
 		switch (hdr_gso_type & ~VIRTIO_NET_HDR_GSO_ECN) {
 		case VIRTIO_NET_HDR_GSO_TCPV4:
@@ -98,16 +143,20 @@ static inline int __virtio_net_hdr_to_skb(struct sk_buff *skb,
 		u32 start = __virtio16_to_cpu(little_endian, hdr->csum_start);
 		u32 off = __virtio16_to_cpu(little_endian, hdr->csum_offset);
 		u32 needed = start + max_t(u32, thlen, off + sizeof(__sum16));
+		int transport_offset;
 
 		if (!pskb_may_pull(skb, needed))
 			return -EINVAL;
 
 		if (!skb_partial_csum_set(skb, start, off))
 			return -EINVAL;
-		if (skb_transport_offset(skb) < nh_min_len)
+
+		transport_offset = skb_transport_offset(skb);
+		if (transport_offset < nh_min_len || network_offset < 0 ||
+		    network_offset > transport_offset - nh_min_len)
 			return -EINVAL;
 
-		nh_min_len = skb_transport_offset(skb);
+		nh_min_len = transport_offset;
 		p_off = nh_min_len + thlen;
 		if (!pskb_may_pull(skb, p_off))
 			return -EINVAL;
@@ -206,9 +255,12 @@ static inline int __virtio_net_hdr_to_skb(struct sk_buff *skb,
 
 static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
 					const struct virtio_net_hdr *hdr,
-					bool little_endian)
+					bool little_endian,
+					int network_offset,
+					__be16 network_protocol)
 {
-	return __virtio_net_hdr_to_skb(skb, hdr, little_endian, hdr->gso_type);
+	return __virtio_net_hdr_to_skb(skb, hdr, little_endian, hdr->gso_type,
+				       network_offset, network_protocol);
 }
 
 /* This function must be called after virtio_net_hdr_from_skb(). */
@@ -287,7 +339,7 @@ static inline int virtio_net_hdr_from_skb(const struct sk_buff *skb,
 	return 0;
 }
 
-static inline unsigned int virtio_l3min(bool is_ipv6)
+static inline int virtio_l3min(bool is_ipv6)
 {
 	return is_ipv6 ? sizeof(struct ipv6hdr) : sizeof(struct iphdr);
 }
@@ -297,18 +349,20 @@ virtio_net_hdr_tnl_to_skb(struct sk_buff *skb,
 			  const struct virtio_net_hdr_v1_hash_tunnel *vhdr,
 			  bool tnl_hdr_negotiated,
 			  bool tnl_csum_negotiated,
-			  bool little_endian)
+			  bool little_endian, int network_offset,
+			  __be16 network_protocol)
 {
 	const struct virtio_net_hdr *hdr = (const struct virtio_net_hdr *)vhdr;
-	unsigned int inner_nh, outer_th, inner_th;
-	unsigned int inner_l3min, outer_l3min;
 	u8 gso_inner_type, gso_tunnel_type;
 	bool outer_isv6, inner_isv6;
+	int inner_nh, outer_th, inner_th;
+	int inner_l3min, outer_l3min;
 	int ret;
 
 	gso_tunnel_type = hdr->gso_type & VIRTIO_NET_HDR_GSO_UDP_TUNNEL;
 	if (!gso_tunnel_type)
-		return virtio_net_hdr_to_skb(skb, hdr, little_endian);
+		return virtio_net_hdr_to_skb(skb, hdr, little_endian,
+					     network_offset, network_protocol);
 
 	/* Tunnel not supported/negotiated, but the hdr asks for it. */
 	if (!tnl_hdr_negotiated)
@@ -332,19 +386,24 @@ virtio_net_hdr_tnl_to_skb(struct sk_buff *skb,
 	outer_isv6 = gso_tunnel_type & VIRTIO_NET_HDR_GSO_UDP_TUNNEL_IPV6;
 	inner_isv6 = gso_inner_type == VIRTIO_NET_HDR_GSO_TCPV6;
 	inner_l3min = virtio_l3min(inner_isv6);
-	outer_l3min = ETH_HLEN + virtio_l3min(outer_isv6);
+	outer_l3min = virtio_l3min(outer_isv6);
+	if (network_protocol == htons(ETH_P_IPV6))
+		outer_l3min = sizeof(struct ipv6hdr);
 
 	inner_th = __virtio16_to_cpu(little_endian, hdr->csum_start);
 	inner_nh = le16_to_cpu(vhdr->inner_nh_offset);
 	outer_th = le16_to_cpu(vhdr->outer_th_offset);
-	if (outer_th < outer_l3min ||
+	if (network_offset < 0 ||
+	    outer_th < outer_l3min ||
+	    network_offset > outer_th - outer_l3min ||
 	    inner_nh < outer_th + sizeof(struct udphdr) ||
 	    inner_th < inner_nh + inner_l3min)
 		return -EINVAL;
 
 	/* Let the basic parsing deal with plain GSO features. */
 	ret = __virtio_net_hdr_to_skb(skb, hdr, true,
-				      hdr->gso_type & ~gso_tunnel_type);
+				      hdr->gso_type & ~gso_tunnel_type,
+				      network_offset, network_protocol);
 	if (ret)
 		return ret;
 
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 50cae32ae..0b37d5474 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2550,6 +2550,26 @@ static void tpacket_destruct_skb(struct sk_buff *skb)
 	sock_wfree(skb);
 }
 
+static int packet_vnet_hdr_to_skb(struct sk_buff *skb,
+				  const struct virtio_net_hdr *vnet_hdr)
+{
+	__be16 network_protocol = 0;
+	int network_offset;
+
+	if (skb->dev->type == ARPHRD_ETHER) {
+		network_offset = virtio_net_hdr_eth_get_l3_offset(skb, vnet_hdr,
+								  &network_protocol);
+	} else {
+		network_offset = skb_network_offset(skb);
+		network_protocol = skb->protocol;
+	}
+	if (network_offset < 0)
+		return network_offset;
+
+	return virtio_net_hdr_to_skb(skb, vnet_hdr, vio_le(),
+				     network_offset, network_protocol);
+}
+
 static int __packet_snd_vnet_parse(struct virtio_net_hdr *vnet_hdr, size_t len)
 {
 	if ((vnet_hdr->flags & VIRTIO_NET_HDR_F_NEEDS_CSUM) &&
@@ -2901,7 +2921,7 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 		}
 
 		if (has_vnet_hdr) {
-			if (virtio_net_hdr_to_skb(skb, &vnet_hdr, vio_le())) {
+			if (packet_vnet_hdr_to_skb(skb, &vnet_hdr)) {
 				tp_len = -EINVAL;
 				goto tpacket_error;
 			}
@@ -3103,7 +3123,7 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
 	packet_parse_headers(skb, sock);
 
 	if (vnet_hdr_sz) {
-		err = virtio_net_hdr_to_skb(skb, &vnet_hdr, vio_le());
+		err = packet_vnet_hdr_to_skb(skb, &vnet_hdr);
 		if (err)
 			goto out_free;
 		len += vnet_hdr_sz;

base-commit: 1e24c4f2ee44be0eee94092b5d13cbdb4bdf0d60
-- 
2.46.0

