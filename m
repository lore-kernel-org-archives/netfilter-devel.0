Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.145.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794357126;
	b=El0LJ3+lnEKWKdyqdMXUYjLneTdNzpMBIZmicR2Mc+6C5I0aZlSGa9pQrOoTPwRUZZJs
	 +OKZs4sWtacIAsfIVlUU0MU9oM9HXRtUOmZuukA/5NUSIZakdMoxEAckiN2hqdcbc4/YI
	 XS0pEuXkzMT3MDzUQ8NJpUQOXa5d/YFZ9nzh5PB3OBPmy+HCTw581qXNJeS6Z2lDsagEA
	 fQITEMahYfpLHSl8OTi9Z1O+KzvYmqQAu+fB7dN70Tu1g5RACd7MEnqcMOf/OuOWwcnGL
	 n6tMV/QCe8C6yYnqJyO2EhDO6jhr2k3jkDYPnfd24FB0JIqUZR3zyDlv2ZxymngwyLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794357126;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version;
	bh=TRQLg4s/KTaINMYgbUxCx+Nvfh0hdPsstfjbWEj/2Sc=;
	b=QqTWQTmo7d+Ap8Wmyh7QcXWk6pELOug960yMpyOpS6gi1COKtzob+onIhz8nQZ5fkjGr
	 3YQuDc3z5u2m0vo+0jEc9aY+yN0JDxiGq4IkJgkT6lUjLsNky5e/yHPUKtZ85iZNWKqtY
	 QB+Iek50ITzm1MPNuiUqurBf1wddeJd/bcPWUfa8bMh62j79ahBK8lce2S9c8jAz/JToA
	 6+YQ0kXGIuHOkdTLgNf8xxxKd6pgb9INZbKWeD90zhIuHJiyL71Qz1mQPxDJ/0AoJg+yI
	 ydQuEaWv7AdNMQZ1AETK9t+Fk/lDdM1CcfqhP14AEngFljETo4ldgpzJML8wJ/alIbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=UdUUHfhU;
	arc=none smtp.remote-ip=67.231.145.42
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9E0606A321;
	Wed, 11 Nov 2026 00:32:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1D9E0606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=UdUUHfhU
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AAMK27u2810126;
	Tue, 10 Nov 2026 16:31:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=TRQLg4s/KTaINMYgbUxCx+Nvfh0hdPsstfjbW
	Ej/2Sc=; b=UdUUHfhU4C8ho3mKFFo1Et3TeOrhjdI4Q8aevfQms5JX6HFTuTUb1
	Ms7zYuHtumuZBvRh5s7PfYj6jJraOqGuT6nItyJMFIKL/p8fTMnLZsxWRrSOtBsC
	jk7faBKBV0D0UvgDwF01zm87quA39oJkuGnJJdAF7Lf0117NUYODqJjl38o70lyK
	XNeRutO6FHb9X9A1dS1MUGONEFTTpaTIFzv9gEtZ0iUvjuoP0BCI+JrXlJp6Ygia
	HkJ8yKxKzeQyuEWjIBfhRA6fSE/Zs2xMJVzESmybgnPX65xWSE5gi/pFB67N4gqB
	oSaO58ImqkENaBzptss0UQt7npWNmOgpQ==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4hv7vgk9mj-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 10 Nov 2026 16:31:32 -0800 (PST)
Received: from localhost (2620:10d:c0a8:1b::8e35) by mail.thefacebook.com
 (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Wed, 11 Nov
 2026 00:31:31 +0000
From: Todd Freed <toddfreed@meta.com>
To: <netfilter-devel@vger.kernel.org>, <toddfreed@meta.com>
CC: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
        Phil Sutter <phil@nwl.cc>, Nikolay Aleksandrov <razor@blackwall.org>,
        "Ido
 Schimmel" <idosch@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric
 Dumazet" <edumazet@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>,
        Simon Horman <horms@kernel.org>, Boris Pismenny
	<borisp@nvidia.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        John Fastabend
	<john.fastabend@gmail.com>,
        Daniel Zahka <daniel.zahka@gmail.com>,
        "Willem de
 Bruijn" <willemdebruijn.kernel@gmail.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        <coreteam@netfilter.org>, <bridge@lists.linux.dev>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH nf-next v1 2/2] netfilter: reject: don't reply to decrypted skbs
Date: Tue, 10 Nov 2026 16:31:11 -0800
Message-ID: <20261111003111.3826942-3-toddfreed@meta.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261111003111.3826942-1-toddfreed@meta.com>
References: <20261111003111.3826942-1-toddfreed@meta.com>
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
Content-Type: text/plain
X-Proofpoint-GUID: UB0mLJ6udQT7WS8KuCJY3dHbtU9d3mhA
X-Proofpoint-ORIG-GUID: UB0mLJ6udQT7WS8KuCJY3dHbtU9d3mhA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDAwMSBTYWx0ZWRfX5lpbTxpq4yrd
 WYnW4ixUv+za8DllhL+N3UMchlMxL/t6NtM9f3uUdOKq6FQIn2QsItAdTQP8xXTXxlrCe3oPd6D
 z7Ycw4FJo3ozUFx++XGe+wU0B/UxAwAkYudxCCkv/RA6KMEAb9ubSJ5ObqdeuxKcho3MnE7jVZj
 MgKWQPQ3IuaeIzCyKKJ/drq4dZ7VvQ6kR6cxZnWNSel/c9oPxvj+yX7ZNoehUhFbWCoNGPCbG8R
 ZfrwAPcQFHDBpBBz+9QbxmPDn3CaYrPLbeTqudo+feOIZpBkHS8HpU/n53+4qxXvHAyVsqxhvUv
 RWeC/DV5vo7rEp6DG8SVYQoj1lRQEkicOQai8407mUUYFXLGJCBqkuAC/nMf6XaipLuS5CH/kLB
 Lc1GU5pB5NT8X7rP70KhByPF5ekx5/blun2GVnw3xFpkFDpV6ExtGn5MELHM5WXbxybktl4mcSL
 K4u5j43U2C3V7eT1QeQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDAwMSBTYWx0ZWRfX7vEn71Xy8ODx
 9Ru7UCdIjRh56D8a55fO73Za8HYzH5A3lqn0WNPuUr7vk4sd8JNwN/2RjOBtbaU48Ck6sQ6wkM7
 DhfRgmZWsJ98jLJKjLRVJyf1PRDE2rI=
X-Authority-Analysis: v=2.4 cv=feA4WEQF c=1 sm=1 tr=0 ts=6af3b764 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=03ozwUkBphtHgyqjj1sw:22 a=VabnemYjAAAA:8 a=U4wNhkmuLUUvqrDBkvsA:9
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-10_07,2026-11-06_01,2025-10-01_01

on receive, skb->decrypted means that the device decrypted the skb (tls
device offload, psp). for a decrypted skb, any part of the packet which
had been encrypted should not be sent back onto the network in
cleartext.

"ipv4: icmp: don't quote decrypted payload in icmp errors" and
"ipv6: icmpv6: don't quote decrypted payload in icmpv6 errors" (net)
make the ip stack send no icmp error about a received decrypted skb.
tls and psp skbs can't be told apart reliably, since
skb_scrub_packet() drops SKB_EXT_PSP and keeps skb->decrypted, so the
rule covers both.

the reject code builds its own replies, without icmp_send() and
icmpv6_send():

 - nf_reject_skb_v4_unreach() and nf_reject_skb_v6_unreach(), used by
   the reject expression in netdev and bridge chains, quote up to 536
   and 1220 bytes of the packet.
 - the tcp resets of nf_reject_skb_v4_tcp_reset(),
   nf_reject_skb_v6_tcp_reset(), nf_send_reset() and nf_send_reset6()
   carry the ports and sequence numbers of the packet's tcp header,
   which are encrypted with psp.

apply the same rule here:

 - nf_reject_skb_v4_tcp_reset(), nf_reject_skb_v4_unreach() and their
   ipv6 versions only get received skbs: the bridge and netdev reject
   expressions are limited to the prerouting, input and ingress hooks.
   don't send a reply for a decrypted skb.
 - nf_send_reset() and nf_send_reset6() also get locally originated
   skbs, from a reject rule in the output chain. don't send a reset
   about a received decrypted skb. for a locally originated, decrypted
   skb, only send the reset if it is routed to a local address
   (RTCF_LOCAL, RTF_LOCAL), as icmp_send() and icmpv6_send() do.

a reject rule then drops a received decrypted packet without a reply, as
it does a packet it can't reply to, and conntrack isn't moved to closing
either, as with a drop rule. nf_send_unreach() and nf_send_unreach6()
use icmp_send() and icmpv6_send(), and get the rule from the patches in
net.

Signed-off-by: Todd Freed <toddfreed@meta.com>
---
 net/ipv4/netfilter/nf_reject_ipv4.c | 26 ++++++++++++++++++++++++++
 net/ipv6/netfilter/nf_reject_ipv6.c | 28 ++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+)

diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
index 7cb33af671e2..1ad5ada45536 100644
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -59,6 +59,12 @@ struct sk_buff *nf_reject_skb_v4_tcp_reset(struct net *net,
 	if (!nf_reject_iphdr_validate(oldskb))
 		return NULL;
 
+	/* Only received skbs get here (bridge, netdev ingress): see
+	 * nf_send_reset()
+	 */
+	if (unlikely(skb_is_decrypted(oldskb)))
+		return NULL;
+
 	oth = nf_reject_ip_tcphdr_get(oldskb, &_oth, hook);
 	if (!oth)
 		return NULL;
@@ -118,6 +124,12 @@ struct sk_buff *nf_reject_skb_v4_unreach(struct net *net,
 	if (!nf_reject_iphdr_validate(oldskb))
 		return NULL;
 
+	/* Only received skbs get here (bridge, netdev ingress): see
+	 * nf_send_reset()
+	 */
+	if (unlikely(skb_is_decrypted(oldskb)))
+		return NULL;
+
 	/* IP header checks: fragment. */
 	if (ip_hdr(oldskb)->frag_off & htons(IP_OFFSET))
 		return NULL;
@@ -287,6 +299,16 @@ void nf_send_reset(struct net *net, struct sock *sk, struct sk_buff *oldskb,
 	if (skb_rtable(oldskb)->rt_flags & (RTCF_BROADCAST | RTCF_MULTICAST))
 		return;
 
+	/* Don't send the decrypted part of an skb onto the network. A
+	 * received skb was decrypted by the device with crypto offload, which
+	 * in some cases encrypts the transport header. The different offloads
+	 * can't be reliably distinguished, so don't reply at all. A locally
+	 * originated skb to be encrypted gets a reply if the reply is routed to
+	 * a local address.
+	 */
+	if (unlikely(skb_is_decrypted(oldskb) && oldskb->skb_iif))
+		return;
+
 	nskb = alloc_skb(sizeof(struct iphdr) + sizeof(struct tcphdr) +
 			 LL_MAX_HEADER, GFP_ATOMIC);
 	if (!nskb)
@@ -304,6 +326,10 @@ void nf_send_reset(struct net *net, struct sock *sk, struct sk_buff *oldskb,
 	if (ip_route_me_harder(net, sk, nskb, RTN_UNSPEC))
 		goto free_nskb;
 
+	if (unlikely(skb_is_decrypted(oldskb)) &&
+	    !(skb_rtable(nskb)->rt_flags & RTCF_LOCAL))
+		goto free_nskb;
+
 	/* "Never happens" */
 	if (nskb->len > dst4_mtu(skb_dst(nskb)))
 		goto free_nskb;
diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
index 5e08d8529cc8..de815538ebf1 100644
--- a/net/ipv6/netfilter/nf_reject_ipv6.c
+++ b/net/ipv6/netfilter/nf_reject_ipv6.c
@@ -84,6 +84,12 @@ struct sk_buff *nf_reject_skb_v6_tcp_reset(struct net *net,
 	if (!nf_reject_ip6hdr_validate(oldskb))
 		return NULL;
 
+	/* Only received skbs get here (bridge, netdev ingress): see
+	 * nf_send_reset6()
+	 */
+	if (unlikely(skb_is_decrypted(oldskb)))
+		return NULL;
+
 	oth = nf_reject_ip6_tcphdr_get(oldskb, &_oth, &otcplen, hook);
 	if (!oth)
 		return NULL;
@@ -144,6 +150,12 @@ struct sk_buff *nf_reject_skb_v6_unreach(struct net *net,
 	if (!nf_reject_ip6hdr_validate(oldskb))
 		return NULL;
 
+	/* Only received skbs get here (bridge, netdev ingress): see
+	 * nf_send_reset6()
+	 */
+	if (unlikely(skb_is_decrypted(oldskb)))
+		return NULL;
+
 	/* Don't reply to ICMPV6_DEST_UNREACH with ICMPV6_DEST_UNREACH */
 	if (nf_skb_is_icmp6_unreach(oldskb))
 		return NULL;
@@ -331,6 +343,16 @@ void nf_send_reset6(struct net *net, struct sock *sk, struct sk_buff *oldskb,
 	if (!otcph)
 		return;
 
+	/* Don't send the decrypted part of an skb onto the network. A
+	 * received skb was decrypted by the device with crypto offload, which
+	 * in some cases encrypts the transport header. The different offloads
+	 * can't be reliably distinguished, so don't reply at all. A locally
+	 * originated skb to be encrypted gets a reply if the reply is routed to
+	 * a local address.
+	 */
+	if (unlikely(skb_is_decrypted(oldskb) && oldskb->skb_iif))
+		return;
+
 	memset(&fl6, 0, sizeof(fl6));
 	fl6.flowi6_proto = IPPROTO_TCP;
 	fl6.saddr = oip6h->daddr;
@@ -359,6 +381,12 @@ void nf_send_reset6(struct net *net, struct sock *sk, struct sk_buff *oldskb,
 	if (IS_ERR(dst))
 		return;
 
+	if (unlikely(skb_is_decrypted(oldskb)) &&
+	    !(dst_rt6_info(dst)->rt6i_flags & RTF_LOCAL)) {
+		dst_release(dst);
+		return;
+	}
+
 	nskb = alloc_skb(LL_MAX_HEADER + sizeof(struct ipv6hdr) +
 			 sizeof(struct tcphdr) + dst->trailer_len,
 			 GFP_ATOMIC);
-- 
2.53.0-Meta

