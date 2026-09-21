Received: from mail-qk2-f13.google.com (mail-qk2-f13.google.com [74.125.230.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A901A683D
	for <netfilter-devel@vger.kernel.org>; Mon, 21 Sep 2026 02:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789959234; cv=none; b=lOHLMajD72WCLQRGYfdjZ+LrOq6AoTdCHknYV8/8oN8AqtM0vXgVqJtnFW5zExo266UO1YWk8O6Za4GLE2Bu2VyVgY7lykPG4E2lYxfsxuWBfsmQCL66GhYI6U/CTA9z4Pse89f51yN6j7xQuvHDtuu7OFbwntS/0XMOJNgYqQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789959234; c=relaxed/simple;
	bh=rF+0orxhGM2+72iiMlOGhSqGFV1AnZmnKlaVomftXAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y7l08Vo0PO3/57ZpM+eaBeqB2574tbeCtwjxVv6tD0MaiAp2BKZ98JzKrVt9yfgEw0WMK1see6cgTVRUaymxbeKGTIg+OBHmSnNdoYCucTxPmzEokl5RDkSUYqpK04fJgZ9c1l6mhxG0u8g8YTyLcQf0F9+/IDHK4RghegLCMjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nRL8AotU; arc=none smtp.client-ip=74.125.230.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nRL8AotU"
Received: by mail-qk2-f13.google.com with SMTP id af79cd13be357-93910ad20d4so298300385a.3
        for <netfilter-devel@vger.kernel.org>; Sun, 20 Sep 2026 19:53:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789959230; x=1790564030; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fkhGS8LwLr9AchoqrwEQvfmCs6eRJO1/8RM9quRrKBU=;
        b=nRL8AotUrjiNPJmv49FVw9DDtBCIsLkeMWH7tkVVD2dC5APnMIBDNqPA48qqZm/8bx
         QosEUNDxdYj0dlSYTNQrUAywGuJ+7lU/38klEqbIzjKeW0wt/+67sTmaArIdCZTU4+Zu
         Mom4+/pLhKg4KGVTxxuqDtgQR08YW9CXTSb0bo5umw5FkTXKb17aMrFv4Ajyglo1mDl6
         YC0PZGomLisVKhi5jpiY60cnkW+sKK4oRvCaRwr9foIbgI4rdVynTDUhC2IrdjL9uslm
         9UEe4exPaaWV87bop1VQURtEGRn5cUrK39sQyNALoBpErvLIPqp173Km97iCtJDPyBoY
         gXAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789959230; x=1790564030;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fkhGS8LwLr9AchoqrwEQvfmCs6eRJO1/8RM9quRrKBU=;
        b=gdsmI1iGmfbRuPCmtMPF8sope19R5pbxaAGNwPWzwKvdC4cugClhgDn8gq9Iz8xGwC
         m8Wqj0dU+ceJS6MctH5HbTBh9n2m0v+36q5l7Bn2DfTQQbE8O8aB+jcTFjxNDZ+6rJ8+
         1c93/GhKqo+jbbXWHUJP6Md+imFLB4YWkgjURbOUkVZWMHC3bIqBfdN3cnrh4QQy4tJI
         jEIXb1mTJilV8EsZbNgMDjo/Qx9Wh7WpHVXcDv4WYocUVWcTn6WBtgg5AO5Tp1wMqIDF
         zFY+dFHE2Gcd1atMom2SMJ86X6v6Eullxu9ohosGlnnuUXv6rRdzpvcE/dynA97Mo6AY
         XUoA==
X-Forwarded-Encrypted: i=1; AKwUvBxYahfFmKDbwhmIONY7HqErrOUHVlU/TsLWpLROqGPsKDpgw8j22WpgfGmZYsIlWUmNZszFqJl56GJlsyHQ05w=@vger.kernel.org
X-Gm-Message-State: AFuF++mRG5BTGb105nfS3spoavtLQ7NiwOiBOSysRxpRItK1HKBWbzsM
	2k/ehuOCdhAY9FH6+BXgEvPyJM0JowYOSdpD2CNFF7An6i6g/Gz1+cU2
X-Gm-Gg: AYBFou2bsNHEio5MMtNbzzi5GCLkjp+mtotj99XFLMGEhwCjDkRWJSjRaD1OmH0kBlG
	Ag+PG+atU8HBTcxLTV+HUe+LPaxsjZuOTLkBXhCWdnAzHxfGR9RxJKH4tkQNnq7gU+3SyMR9Ftm
	8q5NDqqerZ2scOfyGixW57tiE+xwrw1U/jSN2EW0GxVZNG+B+Uh65p4yPS1Cdm9AvcLUdXPqMCV
	ZHT2VWPEzhn2XRXnOMk5y2IXXZdFFaIQ85XEA8v1BIzruVNlvlXce2QXyMNedA8hh4/3m7rPrS7
	4EhUPjpvkIy4GTJkUoazo+11JaD80/+tZPzXPkhCxLyWR5E7Jwenc3l5z6bdy8xfJzZPU6668Fd
	ThnLxp+PwadCy/AgInfAoR6w65dT06WK5lQu1TEx9RT4HA2unAMIDsl6ibHog7kNSNCr++eRNAE
	uZccHdIsBZYbgZHqfqJdKKk4dxRdwYwIk9NFWJnVXjYdWcTWZA6YYwkY6va6HXw6xaPOEAQElMU
	/KbSNzddBzKrQKJe6XNX5wimLFloj4H67vlQ2L3ulJK11aYEWE4pu3/6IrvbM5jzHlU16ua
X-Received: by 2002:a05:620a:298c:b0:93b:d7a1:ba0b with SMTP id af79cd13be357-93bf5742f73mr878321485a.54.1789959230321;
        Sun, 20 Sep 2026 19:53:50 -0700 (PDT)
Received: from localhost.localdomain ([2601:155:4200:2c80:64b9:5e22:f77c:324e])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93bedb3de58sm528732785a.37.2026.09.20.19.53.48
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 20 Sep 2026 19:53:49 -0700 (PDT)
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
Subject: [PATCH net v5 1/2] net: validate virtio checksum start after network header
Date: Sun, 20 Sep 2026 22:53:40 -0400
Message-ID: <20260921025341.44846-2-habte.yibelo@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20260921025341.44846-1-habte.yibelo@gmail.com>
References: <20260920004733.6473-1-habte.yibelo@gmail.com>
 <20260921025341.44846-1-habte.yibelo@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__virtio_net_hdr_to_skb() rejects a CHECKSUM_PARTIAL start smaller than
an estimated minimum network-header length. Its input offsets are relative
to skb->data.

Using skb_network_offset() here is unsafe. TUN/TAP, virtio-net, and UML
parse a received virtio header before skb->network_header is established.
On an skb with headroom, the resulting negative offset enlarges the
apparent distance to the transport header and can admit a checksum start
inside the network header.

Pass the data-relative L3 offset to the converter explicitly. IFF_TUN uses
zero, AF_PACKET supplies its established network offset, and Ethernet
receive paths parse Ethernet and nested VLAN headers with
skb_header_pointer(), without changing skb state. Use the same origin for
tunnel-offset validation, and make UML propagate conversion failures.

This does not require a virtual-machine guest. A TUN or TAP device with
virtio-net header support is sufficient to reach these paths.

Fixes: 49d14b54a527 ("net: test for not too small csum_start in virtio_net_hdr_to_skb()")
Fixes: a2fb4bc4e2a6 ("net: implement virtio helpers to handle UDP GSO tunneling.")
Reported-by: Paulos Yibelo <habte.yibelo@gmail.com>
Link: https://lore.kernel.org/netdev/20260920004733.6473-2-habte.yibelo@gmail.com/
Cc: stable@vger.kernel.org
Signed-off-by: Paulos Yibelo <habte.yibelo@gmail.com>
---
Changes in v5:
- Replace the not-yet-established skb network-header offset with an
  explicit data-relative L3 origin.
- Cover all in-tree callers, including Ethernet/VLAN receive paths,
  tunnel metadata, and UML error propagation.
- Drop the prior Acked-by and Reviewed-by tags because the code changed.

Changes in v4:
- State that a TUN device is sufficient and no guest is required, as
  noted by Michael S. Tsirkin.

Changes in v3:
- Keep the network-relative comparison on one line for readability, as
  requested by David Ahern.

Changes in v2:
- Make nh_min_len an int and remove the casts, as suggested by Michael S.
  Tsirkin.

 arch/um/drivers/vector_transports.c | 10 +++-
 drivers/net/tun_vnet.h              | 28 ++++++++++-
 drivers/net/virtio_net.c            |  8 ++-
 include/linux/virtio_net.h          | 76 +++++++++++++++++++++++------
 net/packet/af_packet.c              |  6 ++-
 5 files changed, 106 insertions(+), 22 deletions(-)

diff --git a/arch/um/drivers/vector_transports.c b/arch/um/drivers/vector_transports.c
index ddd127ee9..79bc05fc6 100644
--- a/arch/um/drivers/vector_transports.c
+++ b/arch/um/drivers/vector_transports.c
@@ -197,6 +197,7 @@ static int raw_verify_header(
 	uint8_t *header, struct sk_buff *skb, struct vector_private *vp)
 {
 	struct virtio_net_hdr *vheader = (struct virtio_net_hdr *) header;
+	int network_offset;
 
 	if ((vheader->gso_type != VIRTIO_NET_HDR_GSO_NONE) &&
 		(vp->req_size != 65536)) {
@@ -209,8 +210,13 @@ static int raw_verify_header(
 	if ((vheader->flags & VIRTIO_NET_HDR_F_DATA_VALID) > 0)
 		return 1;
 
-	virtio_net_hdr_to_skb(skb, vheader, virtio_legacy_is_little_endian());
-	return 0;
+	network_offset = virtio_net_hdr_get_l3_offset(skb, vheader);
+	if (network_offset < 0)
+		return network_offset;
+
+	return virtio_net_hdr_to_skb(skb, vheader,
+				     virtio_legacy_is_little_endian(),
+				     network_offset);
 }
 
 static bool get_uint_param(
diff --git a/drivers/net/tun_vnet.h b/drivers/net/tun_vnet.h
index f4c652b1f..1c83c359d 100644
--- a/drivers/net/tun_vnet.h
+++ b/drivers/net/tun_vnet.h
@@ -177,10 +177,27 @@ static inline int tun_vnet_hdr_put(int sz, struct iov_iter *iter,
 	return __tun_vnet_hdr_put(sz, 0, iter, hdr);
 }
 
+static inline int
+tun_vnet_hdr_get_l3_offset(unsigned int flags, const struct sk_buff *skb,
+			   const struct virtio_net_hdr *hdr)
+{
+	if ((flags & TUN_TYPE_MASK) != IFF_TAP)
+		return 0;
+
+	return virtio_net_hdr_get_l3_offset(skb, hdr);
+}
+
 static inline int tun_vnet_hdr_to_skb(unsigned int flags, struct sk_buff *skb,
 				      const struct virtio_net_hdr *hdr)
 {
-	return virtio_net_hdr_to_skb(skb, hdr, tun_vnet_is_little_endian(flags));
+	int network_offset = tun_vnet_hdr_get_l3_offset(flags, skb, hdr);
+
+	if (network_offset < 0)
+		return network_offset;
+
+	return virtio_net_hdr_to_skb(skb, hdr,
+				     tun_vnet_is_little_endian(flags),
+				     network_offset);
 }
 
 /*
@@ -199,10 +216,17 @@ tun_vnet_hdr_tnl_to_skb(unsigned int flags, netdev_features_t features,
 			struct sk_buff *skb,
 			const struct virtio_net_hdr_v1_hash_tunnel *hdr)
 {
+	const struct virtio_net_hdr *vnet_hdr = (const struct virtio_net_hdr *)hdr;
+	int network_offset = tun_vnet_hdr_get_l3_offset(flags, skb, vnet_hdr);
+
+	if (network_offset < 0)
+		return network_offset;
+
 	return virtio_net_hdr_tnl_to_skb(skb, hdr,
 				features & NETIF_F_GSO_UDP_TUNNEL,
 				features & NETIF_F_GSO_UDP_TUNNEL_CSUM,
-				tun_vnet_is_little_endian(flags));
+				tun_vnet_is_little_endian(flags),
+				network_offset);
 }
 
 static inline int tun_vnet_hdr_from_skb(unsigned int flags,
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index e34c52d05..059eeb18e 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2502,6 +2502,7 @@ static void virtnet_receive_done(struct virtnet_info *vi, struct receive_queue *
 {
 	struct virtio_net_common_hdr *hdr;
 	struct net_device *dev = vi->dev;
+	int network_offset;
 
 	hdr = skb_vnet_common_hdr(skb);
 	if (dev->features & NETIF_F_RXHASH && vi->has_rss_hash_report)
@@ -2515,9 +2516,12 @@ static void virtnet_receive_done(struct virtnet_info *vi, struct receive_queue *
 		goto frame_err;
 	}
 
-	if (virtio_net_hdr_tnl_to_skb(skb, &hdr->tnl_hdr, vi->rx_tnl,
+	network_offset = virtio_net_hdr_get_l3_offset(skb, &hdr->hdr);
+	if (network_offset < 0 ||
+	    virtio_net_hdr_tnl_to_skb(skb, &hdr->tnl_hdr, vi->rx_tnl,
 				      vi->rx_tnl_csum,
-				      virtio_is_little_endian(vi->vdev))) {
+				      virtio_is_little_endian(vi->vdev),
+				      network_offset)) {
 		net_warn_ratelimited("%s: bad gso: type: %x, size: %u, flags %x tunnel %d tnl csum %d\n",
 				     dev->name, hdr->hdr.gso_type,
 				     hdr->hdr.gso_size, hdr->hdr.flags,
diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
index c381b916c..a4c005796 100644
--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -48,11 +48,49 @@ static inline int virtio_net_hdr_set_proto(struct sk_buff *skb,
 	return 0;
 }
 
+/*
+ * Return the L3 offset of an Ethernet frame starting at skb->data.
+ * The offset is unused without NEEDS_CSUM, so avoid parsing and return zero.
+ */
+static inline int
+virtio_net_hdr_get_l3_offset(const struct sk_buff *skb,
+			     const struct virtio_net_hdr *hdr)
+{
+	unsigned int parse_depth = VLAN_MAX_DEPTH;
+	const struct ethhdr *eth;
+	struct ethhdr ethbuf;
+	__be16 protocol;
+	int depth = ETH_HLEN;
+
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
+	return depth;
+}
+
 static inline int __virtio_net_hdr_to_skb(struct sk_buff *skb,
 					  const struct virtio_net_hdr *hdr,
-					  bool little_endian, u8 hdr_gso_type)
+					  bool little_endian, u8 hdr_gso_type,
+					  int network_offset)
 {
-	unsigned int nh_min_len = sizeof(struct iphdr);
+	int nh_min_len = sizeof(struct iphdr);
 	unsigned int gso_type = 0;
 	unsigned int thlen = 0;
 	unsigned int p_off = 0;
@@ -98,16 +136,20 @@ static inline int __virtio_net_hdr_to_skb(struct sk_buff *skb,
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
@@ -206,9 +248,11 @@ static inline int __virtio_net_hdr_to_skb(struct sk_buff *skb,
 
 static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
 					const struct virtio_net_hdr *hdr,
-					bool little_endian)
+					bool little_endian,
+					int network_offset)
 {
-	return __virtio_net_hdr_to_skb(skb, hdr, little_endian, hdr->gso_type);
+	return __virtio_net_hdr_to_skb(skb, hdr, little_endian, hdr->gso_type,
+				       network_offset);
 }
 
 /* This function must be called after virtio_net_hdr_from_skb(). */
@@ -287,7 +331,7 @@ static inline int virtio_net_hdr_from_skb(const struct sk_buff *skb,
 	return 0;
 }
 
-static inline unsigned int virtio_l3min(bool is_ipv6)
+static inline int virtio_l3min(bool is_ipv6)
 {
 	return is_ipv6 ? sizeof(struct ipv6hdr) : sizeof(struct iphdr);
 }
@@ -297,18 +341,19 @@ virtio_net_hdr_tnl_to_skb(struct sk_buff *skb,
 			  const struct virtio_net_hdr_v1_hash_tunnel *vhdr,
 			  bool tnl_hdr_negotiated,
 			  bool tnl_csum_negotiated,
-			  bool little_endian)
+			  bool little_endian, int network_offset)
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
+					     network_offset);
 
 	/* Tunnel not supported/negotiated, but the hdr asks for it. */
 	if (!tnl_hdr_negotiated)
@@ -332,19 +377,22 @@ virtio_net_hdr_tnl_to_skb(struct sk_buff *skb,
 	outer_isv6 = gso_tunnel_type & VIRTIO_NET_HDR_GSO_UDP_TUNNEL_IPV6;
 	inner_isv6 = gso_inner_type == VIRTIO_NET_HDR_GSO_TCPV6;
 	inner_l3min = virtio_l3min(inner_isv6);
-	outer_l3min = ETH_HLEN + virtio_l3min(outer_isv6);
+	outer_l3min = virtio_l3min(outer_isv6);
 
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
+				      network_offset);
 	if (ret)
 		return ret;
 
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 50cae32ae..04c80e23d 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2901,7 +2901,8 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 		}
 
 		if (has_vnet_hdr) {
-			if (virtio_net_hdr_to_skb(skb, &vnet_hdr, vio_le())) {
+			if (virtio_net_hdr_to_skb(skb, &vnet_hdr, vio_le(),
+						  skb_network_offset(skb))) {
 				tp_len = -EINVAL;
 				goto tpacket_error;
 			}
@@ -3103,7 +3104,8 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
 	packet_parse_headers(skb, sock);
 
 	if (vnet_hdr_sz) {
-		err = virtio_net_hdr_to_skb(skb, &vnet_hdr, vio_le());
+		err = virtio_net_hdr_to_skb(skb, &vnet_hdr, vio_le(),
+					    skb_network_offset(skb));
 		if (err)
 			goto out_free;
 		len += vnet_hdr_sz;
-- 
2.46.0
