Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.10.208.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794842925;
	b=ryTpqcewFXLV4hAP/0z9ZCfyAAcCg+i5Rz0B7X32JXmbchKPDTIU6CgcIumvceli0Jri
	 Jm+GQPiCPokivEsGSM3PDbkAIngVijyopZYfPsJ4iVaEG9VSBk9q5Eriz88OuTW8G4KMH
	 D+CHSTLXJvtLOCFaAjjB88TpkhM9Sn98b5Xsyk2SHXP7iVjoAtgN9NdYlAUo2e3ncR+eC
	 7rVx1Pq3SB0U9XAMiGHtvf9q5vfhG4H/ZgokESGTcTkZI96h/th6dCf5Eb2ewZJqDwvbC
	 M9oQ3ikL+pkvroDj0NIpRzcupOOZ4Ho7VvHz7FRnOOZGGUWH5avSsJEqdoJAZc0kzqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794842925;
	h=DMARC-Filter:Received:DKIM-Signature:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-Rspamd-Queue-Id;
	bh=qMz+RAf4b7f2BcmkRLvRo5r6beNIKQGAsILjdn7aN30=;
	b=WMxmR3u7KyF6m4MyQ88cbghnfklUyxrb3tBIULWzlinyU1JWuWQfipnCTS9Xl9CzRkH3
	 Bz0Joyus7rSLfWRRvAUGP2++H69fxMhDREN8d8jSXaptZ6aGLTQoGPeGB2JlzJ3W+SZch
	 5fgf37Gsj+TwBcw+M5Mtl8QLlHY92TN7wxGKjudEdKI2+zU3yY99gOosxISGMmsAJNj5z
	 asxA3laouRnPzQ1cgFrWD9loBzSHFsam6+ynFrteyzQXclBr4aYqgi4f29gnZkLcheboM
	 mZVNPPjgZJMO4nPR7Eo/Nimta+0yW/dfrZLPHBcRUbX7+pYdqFHVJpia06m2PqSmk9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=mandelbit.com;
	spf=pass smtp.mailfrom=mandelbit.com;
	dkim=pass header.d=mandelbit.com header.i=@mandelbit.com header.a=rsa-sha256 header.s=MBO0001 header.b=tGXr9hsn;
	arc=none smtp.remote-ip=195.10.208.50
Received: from mout-b-105.mailbox.org (mout-b-105.mailbox.org [195.10.208.50])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4820F606A334;
	Mon, 16 Nov 2026 15:28:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4820F606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mandelbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mandelbit.com header.i=@mandelbit.com header.a=rsa-sha256 header.s=MBO0001 header.b=tGXr9hsn
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:b231:465::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-b-105.mailbox.org (Postfix) with ESMTPS id 4jSsFy5nwQz9rxT;
	Mon, 16 Nov 2026 16:28:38 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mandelbit.com;
	s=MBO0001; t=1794842918;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=qMz+RAf4b7f2BcmkRLvRo5r6beNIKQGAsILjdn7aN30=;
	b=tGXr9hsngJwMNm43mLYcy6bnDJGzqGWJL1NsrfitHYH8NhgNKJ0okvua/eWDAlI2oe3Jci
	hXzH47GZbKRRpKPFjBEa7sPcOekRuRmS946U+mc2/SMvv6K283Fw5rBmdWDk2LySStKmYE
	V6t+P451BZlHDOOLgMwt072/JA9SSrBoqkzHddx3DJWsw3emXy7GDuf2NRTWAfzngA3IC+
	+fVzTAWN+RHCqEyviYJ6ABELmOtOukp9//8H0xDLBnimgYxDLYGFKXO2xErrZGxyvL6ELf
	7Z9De3CNrTggJEM6NtRcydroSeDp03SAre7QSO3om7jqn13vQC5/mNoZBEEjVg==
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of antonio@mandelbit.com designates 2001:67c:2050:b231:465::2 as permitted sender) smtp.mailfrom=antonio@mandelbit.com
From: Antonio Quartulli <antonio@mandelbit.com>
To: stable@vger.kernel.org
Cc: Antonio Quartulli <antonio@mandelbit.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: [PATCH 6.6.y] netfilter: flowtable: ensure sufficient headroom in xmit path
Date: Mon, 16 Nov 2026 16:28:24 +0100
Message-ID: <20261116152826.2997774-1-antonio@mandelbit.com>
X-Mailer: git-send-email 2.56.1
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
X-Rspamd-Queue-Id: 4jSsFy5nwQz9rxT

commit ef4f741e8627512cb8c82f59a1fc7aacd854aadf upstream.

Check for headroom and call skb_expand_head() like in the IP output
path to ensure there is sufficient headroom for the mac header when
forwarding this packet as suggested by sashiko.

Fixes: b5964aac51e0 ("netfilter: flowtable: consolidate xmit path")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
[ aq: the upstream commit does not apply to 6.6: 6.6 predates
  b5964aac51e0, and FLOW_OFFLOAD_XMIT_NEIGH flows are still sent through
  neigh_xmit() from nf_flow_offload_ip_hook() and
  nf_flow_offload_ipv6_hook(). Do the same headroom check there, before
  skb->dev is switched to the output device, and in nf_flow_queue_xmit().

  Without it, a forwarded skb reaches the output device's
  header_ops->create() with only the headroom it was received with. A
  UDP socket behind a veth (e.g. a container) leaves 16 bytes; virtio_net
  leaves 26 for frames larger than GOOD_COPY_LEN. GRE, ip6gre and VLAN
  have since been hardened individually, 6LoWPAN has not:
  lowpan_header_create() stores struct lowpan_addr_info (32 bytes) in
  front of skb->data after a mere WARN_ON_ONCE(), i.e. an out-of-bounds
  write before the skb head. Seen on v6.6.162 with IPv6 forwarded by a
  flowtable from a veth to a 6LoWPAN interface:

    WARNING: CPU: 1 PID: 3974 at net/ieee802154/6lowpan/tx.c:21 lowpan_header_create+0x165/0x1b0 [ieee802154_6lowpan]
    Call Trace:
     neigh_connected_output+0xa6/0xf0
     neigh_xmit+0xb4/0x1e0
     nf_flow_offload_ipv6_hook+0x544/0x7c0
     nf_hook_slow+0x39/0xe0
     __netif_receive_skb_core.constprop.0+0xd8a/0xf40
     __netif_receive_skb_one_core+0x37/0xa0
     process_backlog+0x75/0x130

  Before e67c577d8989 ("ipv4: ip_gre: make ipgre_header() robust") the
  same path panicked with multipoint GRE (DMVPN) output devices:
  skb_under_panic in ipgre_header() via nf_flow_offload_ip_hook(). ]
Fixes: 97add9f0d66d ("netfilter: flow table support for IPv4")
Fixes: 0995210753a2 ("netfilter: flow table support for IPv6")
Fixes: 7a27f6ab4135 ("netfilter: flowtable: use dev_fill_forward_path() to obtain egress device")
Link: https://vyos.dev/T7549
Signed-off-by: Antonio Quartulli <antonio@mandelbit.com>
---
Reproducer (run on v6.6.162: WARNING without this patch, clean with it).
Needs CONFIG_MAC802154_HWSIM and CONFIG_IEEE802154_6LOWPAN, plus nft,
conntrack and python3. The 6LoWPAN neighbour is static and the conntrack
entry is inserted with SEEN_REPLY, so the very first packet matches "ct
state established" and the flow is offloaded; no 802.15.4 peer is
needed. If udev renames wpan0, use the name of the first
ARPHRD_IEEE802154 (type 804) interface. Run it in a throwaway VM.

  modprobe mac802154_hwsim; modprobe ieee802154_6lowpan
  sysctl -w net.ipv6.conf.all.forwarding=1
  ip link set wpan0 up
  ip link add link wpan0 name lowpan0 type lowpan
  ip link set lowpan0 up
  ip -6 addr add fd00:b::1/64 dev lowpan0 nodad
  ip -6 neigh replace fd00:b::2 lladdr 02:11:22:33:44:55:66:77 dev lowpan0 nud permanent

  ip netns add lan
  ip link add lan0 type veth peer name lan1 netns lan
  ip link set lan0 up
  ip -6 addr add fd00:a::1/64 dev lan0 nodad
  ip -n lan link set lan1 up
  ip -n lan -6 addr add fd00:a::2/64 dev lan1 nodad
  ip -n lan -6 route add default via fd00:a::1

  nft add table inet t
  nft 'add flowtable inet t ft { hook ingress priority filter; devices = { lan0, lowpan0 }; }'
  nft 'add chain inet t forward { type filter hook forward priority filter; policy accept; }'
  nft add rule inet t forward ct state established flow add @ft
  conntrack -I -p udp -s fd00:a::2 -d fd00:b::2 --sport 40000 --dport 5000 \
      -r fd00:b::2 -q fd00:a::2 --reply-port-src 5000 --reply-port-dst 40000 \
      -t 120 -u SEEN_REPLY,ASSURED

  ip netns exec lan python3 -c 'import socket; s = socket.socket(socket.AF_INET6, socket.SOCK_DGRAM); s.bind(("fd00:a::2", 40000)); [s.sendto(b"x" * 64, ("fd00:b::2", 5000)) for _ in range(100)]'
  dmesg | grep -A12 lowpan_header_create

Without this patch: the WARNING above. With it: none, while the flow is
still offloaded ("conntrack -L" shows [OFFLOAD]). Replacing
"flow add @ft" with "accept" also avoids it, because
ip6_finish_output2() expands the headroom.

 net/netfilter/nf_flow_table_ip.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -330,6 +330,22 @@
 	}
 }
 
+/* Make room for the link layer header of @dev, like ip_finish_output2() does.
+ * The flowtable fast path skips the IP output path, and a device with
+ * header_ops (e.g. an NBMA GRE tunnel) may need more headroom than the skb
+ * was received with. On failure the skb has been freed.
+ */
+static struct sk_buff *nf_flow_xmit_headroom(struct sk_buff *skb,
+					     struct net_device *dev)
+{
+	unsigned int hh_len = LL_RESERVED_SPACE(dev);
+
+	if (unlikely(skb_headroom(skb) < hh_len && dev->header_ops))
+		skb = skb_expand_head(skb, hh_len);
+
+	return skb;
+}
+
 static unsigned int nf_flow_queue_xmit(struct net *net, struct sk_buff *skb,
 				       const struct flow_offload_tuple_rhash *tuplehash,
 				       unsigned short type)
@@ -340,6 +356,10 @@
 	if (!outdev)
 		return NF_DROP;
 
+	skb = nf_flow_xmit_headroom(skb, outdev);
+	if (!skb)
+		return NF_STOLEN;
+
 	skb->dev = outdev;
 	dev_hard_header(skb, skb->dev, type, tuplehash->tuple.out.h_dest,
 			tuplehash->tuple.out.h_source, skb->len);
@@ -452,6 +472,9 @@
 	case FLOW_OFFLOAD_XMIT_NEIGH:
 		rt = (struct rtable *)tuplehash->tuple.dst_cache;
 		outdev = rt->dst.dev;
+		skb = nf_flow_xmit_headroom(skb, outdev);
+		if (!skb)
+			return NF_STOLEN;
 		skb->dev = outdev;
 		nexthop = rt_nexthop(rt, flow->tuplehash[!dir].tuple.src_v4.s_addr);
 		skb_dst_drop(skb);
@@ -748,6 +771,9 @@
 	case FLOW_OFFLOAD_XMIT_NEIGH:
 		rt = dst_rt6_info(tuplehash->tuple.dst_cache);
 		outdev = rt->dst.dev;
+		skb = nf_flow_xmit_headroom(skb, outdev);
+		if (!skb)
+			return NF_STOLEN;
 		skb->dev = outdev;
 		nexthop = rt6_nexthop(rt, &flow->tuplehash[!dir].tuple.src_v6);
 		skb_dst_drop(skb);
