Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792605931;
	b=t8Ts8RizgRzd6rPOXkKtlFh02UHeV3VnbfQadetPyNzNqVcJk3GfzoarrAck/qbvva56
	 3weJ/ohxINKg7DdqKDp3Rrp9zGdi4ccn6hp7w1ocWDuKm96gWJFh7K6tY9HHmpLHreYKM
	 BWFPXCpNBvZgpoDe9XdVdD+EuvGIqOJEofBrd9/bQXPtVIfVZh5rZNg7TJy3nbhChjZ9I
	 /MIvzZexdLrzVEX8pNBrepUc23kMvzfTYVONnTXo7oFKwghz3e6Czlabn0s75x5Hto7Kb
	 sThYglr2GIo3jxZJzAjdAwHTYtIhN/I9YouWMlV/4k3BAAHniz0WWTeeDcyZFtpJeNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792605931;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cDckOYGKiTcCmnZHJzDUIHI22U4mrVjbAtWOGCBnRDk=;
	b=TIqXgzNSrOPUqgIVdhHskVrZzpQGCI0o+OINzIOJtVhypN5xHGrYvkYr6ANcz7S6QFC/
	 D4nJcylDRsaAXT0zR0gphks7hWIH3ljvlE7RUmpNNfb6SAkrwKYG11UkqV2EFxuxyEt1+
	 j5wEhZ4Yt42QURLe2nmI3slcXIgSEcKWm9zrlg0OhFFQC4L8cdMWSyxWYOxm50iXQLoXU
	 9sRJcD0D0wBeX7DalaPLc+yAhz5B4wk0zucKAGjX2uF1W4K3AhRPvytEjZ+Ykz2XNI63p
	 d0sSkLCQv02gMvYwl4H1JAuFfKUvLbTUaT7TB68pMF8PnEXkBdU4kxiCQifCxfTVbaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=CtrYySqg;
	arc=none smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2677606A31F
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2026 18:05:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E2677606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=CtrYySqg
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a018792ab3so8840745e9.0
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2026 11:05:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792605929; x=1793210729; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cDckOYGKiTcCmnZHJzDUIHI22U4mrVjbAtWOGCBnRDk=;
        b=CtrYySqgn+sGrZhH8qfot2dEftpKaba17dq+YaDQIipAKo0hqZV4XoJkZ3mMN8MXcB
         HgqHNcTBf/2jU2gs7HMZ3b2I09Qpc9mthKhD5JqPQoXPe7ZB/HRtRDy8mm+JP5G3bmoF
         Ql7KC0BrxUE9yot9OtoIn/fUv2+knBjWAwvG3CHgYAcQ7Lpp8MqVgEOPbrUtjpLXuoxX
         JZ6GrT47a/9dQaWeHbCHkDvei3P7TSTnbdPY6Ow/M2OyJd3XB7/ENp4z22zbvwzssJKg
         pTvYQNYM40DBCk/hPKijIJnvHEE9Q8U4zQm14IDskOLcMF/HFrBMhUY+D/Ihc4OjclJf
         27mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792605929; x=1793210729;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cDckOYGKiTcCmnZHJzDUIHI22U4mrVjbAtWOGCBnRDk=;
        b=yOJCcfDsE+h3nv+F/142Zzdey4BvhaFF/Alp8Ht8EJ8eWnKfpfm4lCqZaQbcxLKhGV
         qhT0MbRv66f44R0nOhrZ3vnd2z+RA2eLgLUps6dTpvHV3khjyxgzkCpkyy9pKHUij4K0
         DbDqYyKN23aS0tc6u5/T0ntKzzKReRW8r9VXl/yiXily8fHMkpsQ81I7yDvaSyJ9VUzY
         attE5DmiFHg8WsoFNOJcmg+I6trrBhnTQWr95TXyVDIMM5lILH9yT6OgIa7cIcTp+3F9
         BRAI7All/hFb1uo4XF8xaqGhBZHZcdBnRdt+ZQIYtx8Du0RsPaS4GxP69N2S4ntT7UEe
         jmHQ==
X-Forwarded-Encrypted: i=1; AKwUvBwC6pQjhzKZkQDOXSsEp2KErA6JKUXDEqMCx2+do1h7uKGml3LbbEB3/gVnPGcr/EOZcYAq2z5THR9+mnEsZTs=@vger.kernel.org
X-Gm-Message-State: AFq9FYIzKKgI195ArmCGzYFDdqFVp1Gmb3EZLyLhk9cTUaQMqNzR/hrD
	ORnaRjjXnxZNMOTFgPt7AQm4DPFtNxj/ELWQSJ29cByyHAOP5hzuUv+7
X-Gm-Gg: AYBFou2hqOm9lUMfITn/mEeQw7K5EfA7C0Td9nDw3VR0kLWASEhJORaCvBsSGzZYyNW
	qcsUps+AD2ThtjPbLzvY2h4/tUHhMwTFVhaRlXHX2i2zI+FlYyAcNknObGkgagbaUeI9WW2dyfc
	c2yV1fdal8gVAcyPxpzRdXWGqrt4qiWmjtToUKonvktRHPDGznBxLj8gRfk5k8BbW4tOvgx34i4
	qHzyOpPKPOLpbusQSncL+GO+rsiDVT9qBMxgsqaXOXViJ8zNeh9Y+mOxNhHv4uk4+MMkLEC+o5H
	T/uTs3Lz7yh5piOk264BtC27Y2E+TrVGehmGqTzBfjJNrvLu3g1e9QSyWEkgQq4O9tSR4shfgaO
	nWoV1EJUq1G5FecP7j1nKkyPrAdDssYv+LYrxcj5D/JH+G6zKJ2zWKKo7ruIPKpMBMa8l3r1cPC
	anNrnBJyJVq9r0mdsAnT76axR3ooUY7+aOHTt0/7AaNfGc0S4YSX3vqOoJYJRSxFMVswrp42CWb
	tH7hA/FptUOFfgRKBjY42jDsqmRMTDzcLwegl72ahc21ayhf9rjDPNN3VInhTOw1XHS+qrhuV6l
	2McS9UgRc6YH5SdCsFDUrBKsEjSz8E4pwWOfvcn/wgCFjsNojDGO8P9vmy2x7ytp2i5Ys2xN35o
	zz0Uq6NQujI3LfEIKAQIylcyDXn5ZLieT
X-Received: by 2002:a05:600c:4fd4:b0:4a1:dda8:eb73 with SMTP id 5b1f17b1804b1-4a1fdd53c8cmr60392565e9.27.1792605928777;
        Wed, 21 Oct 2026 11:05:28 -0700 (PDT)
Received: from localhost.localdomain ([2a00:23c6:e6ea:6401:f04a:ac6f:988e:f33d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1fcd13891sm47007775e9.2.2026.10.21.11.05.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 21 Oct 2026 11:05:28 -0700 (PDT)
From: Nick Simpson <nick.simo@gmail.com>
To: Magnus Karlsson <magnus.karlsson@intel.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	David Ahern <dsahern@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>
Cc: Stanislav Fomichev <sdf@fomichev.me>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Song Yoong Siang <yoong.siang.song@intel.com>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Max Krasnyansky <maxk@qualcomm.com>,
	Sridhar Samudrala <sri@us.ibm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	netdev@vger.kernel.org,
	linux-doc@vger.kernel.org,
	bpf@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net 1/3] xsk: validate checksum offload requests in copy mode
Date: Wed, 21 Oct 2026 19:03:27 +0100
Message-ID: <20261021180329.26358-2-nick.simo@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261021180329.26358-1-nick.simo@gmail.com>
References: <20261021180329.26358-1-nick.simo@gmail.com>
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

In copy mode, XDP_TXMD_FLAGS_CHECKSUM turns the csum_start and
csum_offset from the TX metadata into a CHECKSUM_PARTIAL skb.
xsk_skb_metadata() only checks that the checksum fits in the frame, so
csum_start can point into the Ethernet or IP header.

On a veth, the skb reaches the peer namespace still CHECKSUM_PARTIAL.
When that namespace forwards IPv6 with nf_defrag_ipv6 loaded,
nf_ct_frag6_reasm() moves the IPv6 header forward by the 8 bytes of the
fragment header without adjusting csum_start, the forward hook accepts
the reassembled packet, and ip6_fragment() then completes the checksum
with skb_checksum_help(), writing two bytes into the accepted header.
With csum_start = 22 and csum_offset = 22 on a fragmented IPv6/UDP
datagram from fd00:1::100, the write lands on source address bytes
14-15: an nftables forward rule matching "ip6 saddr fd00:1::100"
accepted the packet and the fragments sent out carried saddr
fd00:1::e87. For an unfragmented packet the same write happens at
egress when the output device does not offload the checksum; with
csum_start = 14 and csum_offset = 22 the packet left as fd00:1::ebf. A
csum_start that ends up before the network header (14 to 21 on the
fragmented path) makes skb_checksum_help() warn instead:

  offset (-2) >= skb_headlen() (640)
  WARNING: net/core/dev.c:3647 at skb_checksum_help+0x4c8/0x850
  Call trace:
   skb_checksum_help
   ip6_fragment
   ip6_finish_output
   ip6_output
   ip6_forward
   ipv6_rcv
   ...
   __dev_direct_xmit
   __xsk_generic_xmit
   xsk_sendmsg

socket(AF_XDP) only requires CAP_NET_RAW in the user namespace that owns
the network namespace, so the sender can be a container that owns one
end of the veth. With panic_on_warn, the warning panics the forwarding
host.

The interface is documented for L4 checksums. Leave CHECKSUM_PARTIAL in
place only when the request designates the TCP or UDP checksum field of
an unfragmented IPv4 or IPv6 packet, not IP-in-IP or GRE encapsulated,
on an Ethernet device, and complete any other request in software, as
XDP_UMEM_TX_SW_CSUM would, before the frame is handed to the device.
The frame is dissected from its Ethernet type, as skb->protocol is not
set for xsk skbs. The pending "net: resolve uncommon partial checksums
at ingress" applies the same rule to virtio_net_hdr sources.

A request on a frame that is itself an IP fragment is therefore
completed over that fragment alone, which is also all a device could
compute, so the reassembled datagram does not carry a valid transport
checksum. Before, if every fragment carried such a request, the
reassembled datagram stayed CHECKSUM_PARTIAL and was completed on
refragmentation; now conntrack marks it invalid.

Skbs without a linear part (IFF_TX_SKB_NO_LINEAR, i.e. virtio_net) are
left unchanged: their data stays in the umem, where user space can
still modify it after any check, and they go to the device rather than
to the local stack.

The problem was found with LLM-assisted code review.

Fixes: 48eb03dd2630 ("xsk: Add TX timestamp and TX checksum offload support")
Link: https://lore.kernel.org/r/9c08d12b3a7819ae03ded6a154e4f908276e93d4.1792411304.git.mst@redhat.com
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Nick Simpson <nick.simo@gmail.com>
---
 net/xdp/xsk.c | 58 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 781ba46eb152..a1cf701d42fc 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -11,6 +11,8 @@
 
 #define pr_fmt(fmt) "AF_XDP: %s: " fmt, __func__
 
+#include <linux/if_arp.h>
+#include <linux/if_ether.h>
 #include <linux/if_xdp.h>
 #include <linux/init.h>
 #include <linux/sched/mm.h>
@@ -21,6 +23,8 @@
 #include <linux/uaccess.h>
 #include <linux/net.h>
 #include <linux/netdevice.h>
+#include <linux/tcp.h>
+#include <linux/udp.h>
 #include <linux/rculist.h>
 #include <linux/uio.h>
 #include <linux/vmalloc.h>
@@ -28,6 +32,7 @@
 #include <net/netdev_queues.h>
 #include <net/xdp_sock_drv.h>
 #include <net/busy_poll.h>
+#include <net/flow_dissector.h>
 #include <net/netdev_lock.h>
 #include <net/netdev_rx_queue.h>
 #include <net/xdp.h>
@@ -985,6 +990,54 @@ static void xsk_drop_skb(struct sk_buff *skb)
 	xs->skb = NULL;
 }
 
+/* Only TCP and UDP checksums of unfragmented IP packets that are not
+ * IP-in-IP or GRE encapsulated are left to the device. A CHECKSUM_PARTIAL
+ * skb can reach the local stack (e.g. through veth), and completing an
+ * arbitrary csum_start there may write into headers that were already
+ * inspected, e.g. after IPv6 reassembly. skb->protocol is not set for
+ * xsk skbs, so the frame is dissected from its Ethernet type instead.
+ */
+static bool xsk_csum_partial_ok(const struct sk_buff *skb)
+{
+	const struct ethhdr *eth = (const struct ethhdr *)skb->data;
+	struct flow_keys_basic keys;
+
+	if (skb->dev->type != ARPHRD_ETHER || skb_headlen(skb) < ETH_HLEN)
+		return false;
+
+	if (!skb_flow_dissect_flow_keys_basic(dev_net(skb->dev), NULL, &keys,
+					      skb->data, eth->h_proto, ETH_HLEN,
+					      skb_headlen(skb),
+					      FLOW_DISSECTOR_F_STOP_AT_ENCAP))
+		return false;
+
+	if ((keys.control.flags & FLOW_DIS_IS_FRAGMENT) ||
+	    skb_checksum_start_offset(skb) != keys.control.thoff)
+		return false;
+
+	switch (keys.basic.ip_proto) {
+	case IPPROTO_TCP:
+		return skb->csum_offset == offsetof(struct tcphdr, check);
+	case IPPROTO_UDP:
+		return skb->csum_offset == offsetof(struct udphdr, check);
+	default:
+		return false;
+	}
+}
+
+static int xsk_skb_resolve_csum(struct sk_buff *skb)
+{
+	/* Without a linear part (IFF_TX_SKB_NO_LINEAR), the frame stays in
+	 * the umem, where user space can still change it, and goes to the
+	 * device rather than the local stack: leave it as it is.
+	 */
+	if (skb->ip_summed != CHECKSUM_PARTIAL || !skb_headlen(skb) ||
+	    xsk_csum_partial_ok(skb))
+		return 0;
+
+	return skb_checksum_help(skb);
+}
+
 static int xsk_skb_metadata(struct sk_buff *skb, void *buffer,
 			    struct xdp_desc *desc, struct xsk_buff_pool *pool,
 			    u32 hr)
@@ -1277,6 +1330,11 @@ static int __xsk_generic_xmit(struct sock *sk)
 			continue;
 		}
 
+		if (unlikely(xsk_skb_resolve_csum(skb))) {
+			xsk_drop_skb(skb);
+			continue;
+		}
+
 		err = __dev_direct_xmit(skb, xs->queue_id);
 		if  (err == NETDEV_TX_BUSY) {
 			/* Tell user-space to retry the send */
-- 
2.53.0

