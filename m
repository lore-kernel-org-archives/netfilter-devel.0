Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.145.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795475972;
	b=c7rpdXtI4Z+mLTQnyq7onrTzjS8eeVjp+ZBXfLzknheSyEQDK6YgyAPxRIotiG88feKQ
	 WPnz6QhD7tA3kFGHYzbDi7HujBTpv3PsSPKMR5OjzEGyd4qvnFEZXRXcPjq620I59sRlZ
	 tOR2a6MzlZEIfnDLSK3iTQ5j+O+zaBZDBCqCHA529JabgHESLMKtE5T71E4e6W65ubztX
	 K/uP2XuLS1+KLLJqEUulMOXjCGDtl6iip7+AvuEDYEdouFwLKO1QFsnzy761XlD62flqD
	 OVw7kAhYZ52uYwU7sNGlhoQvPxLvnuY1QIgT11ZcU2K1Ec4S0Z1FG9wDLrTPAuX0cJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795475972;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-Authority-Analysis:X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version;
	bh=YnITptjLDMHlKMuNDcyL11AHr7ri5HqywhVbFsv/2zs=;
	b=Q4zAYFeWUfLmHFFzd/L1L87gTt4T+AXqQXRncM+6+g2R4enkm+uwArOQdq6qyumDI0G0
	 5lwzQPcWGnPl3eP/0wu3z4itMZEn4gTp6QMo/XrQgmMYhq7riOguIWXZW6l58k+O8goN1
	 Hv/YmMq15LT6A8t0/b5BI2scwuFHtjwgbmOH8zubxxRBZ0pSNCPSrYE67TQbaDAQaO5S0
	 sykfOj2Ze9Qvr0s1wW2VwFyVQq2BL1Jf21quqmOeEV1njjbKBqD3LwWMh7m0iS+W0blmn
	 DuUMmmU/YkzjKpP/47j4mVGUXZROLeHiDVo+p1TFOQwzHejexTqMbNZ9dRBYyqrWlCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=TYuBCMHj;
	arc=none smtp.remote-ip=67.231.145.42
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A0EE606A31E;
	Mon, 23 Nov 2026 23:19:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9A0EE606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=TYuBCMHj
Received: from pps.filterd (m0528009.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ANJw1RT2657760;
	Mon, 23 Nov 2026 15:18:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps82601-s2048-2026-q3; bh=YnITptjLD
	MHlKMuNDcyL11AHr7ri5HqywhVbFsv/2zs=; b=TYuBCMHjvl5dEnOSa8vwRYtxR
	za4E3wkq1CWwgiGgSCwpDvhmRHYme3l05zeZ3DxJkZm0d4bF6JSLPuNU/3M8lBxU
	6MC6uPrknt9SD97qPG7XFRZv5gaiQ3AiARnDuvnZvwfGhpyH/iHr8oKL/NoK+d5z
	AFxdTutVyXRRIVHVELsJdShPf7+QUnGH9UK0Bo0FRw8wSSdqF1Ubkxhlt5pY8cyM
	7o8przmZy9Rp5Ibgn/seWZMBF/hUguH5smAh1NKscbq4EwlFi29w2KNoT7sbhYjJ
	LW54qWZu6HFKEs9CSK8eIJh3erByWMjix91dACQc8l70SuVV/RbGfz7UfmAEw==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4j3wx9hxa9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 23 Nov 2026 15:18:45 -0800 (PST)
Received: from localhost (2620:10d:c0a8:1c::11) by mail.thefacebook.com
 (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Mon, 23 Nov
 2026 23:18:43 +0000
From: Todd Freed <toddfreed@meta.com>
To: <netfilter-devel@vger.kernel.org>
CC: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
        Phil Sutter <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>,
        Eric
 Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni
	<pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        Boris Pismenny
	<borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Sabrina
 Dubroca <sd@queasysnail.net>,
        Daniel Zahka <daniel.zahka@gmail.com>,
        Willem
 de Bruijn <willemdebruijn.kernel@gmail.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        <coreteam@netfilter.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: [PATCH nf] netfilter: reject: don't quote decrypted payload in icmp errors
Date: Mon, 23 Nov 2026 15:18:35 -0800
Message-ID: <20261123231835.2356740-1-toddfreed@meta.com>
X-Mailer: git-send-email 2.53.1
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
X-Authority-Analysis: v=2.4 cv=aY/0Dhot c=1 sm=1 tr=0 ts=6b04c9d5 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=U_y8lYiYyhHBU5rMqhb2:22 a=VwQbUJbxAAAA:8 a=VabnemYjAAAA:8
 a=DTGP0nILiB9DUAOxyKkA:9 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-ORIG-GUID: rA4bA3gNgBn3RbXgZyhV9bTnbfaRvJEq
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIzMDA5MiBTYWx0ZWRfX7igi5WtQnCLe
 6lfZXqhH72GRRf+LINkq+BhD9z+BDIzR+m4s1PpzKDFRvHKLsMxcpxvc089T0djoHiYpYIZT25T
 fPCv5Vvb64y5VjkAuRPWMD52QUHWV+k=
X-Proofpoint-GUID: rA4bA3gNgBn3RbXgZyhV9bTnbfaRvJEq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIzMDA5MiBTYWx0ZWRfX1pC1+PSo5A0q
 QpHrAGErgWWIKxCSHO5TMU/O4/bLRq8le9N0PuO6bsbonew+5pnocIpjAAMOoQWj+2HrEFN/IMx
 H9JvHbAa340IT8tVpEmM+De9AVPLUZS4K04PooGZF/xiwlOnhAHzhRs6NDxY1Kdoujq2V9xrOcf
 NiZJZLEWiF5vBs47TnIWERkHD1O+qrnDXVsMQnHQYB8dvhfgf+mQ1J7g3HuRZ/I3MyK9cxO/TJe
 NJ4Ya/RLAmbx8gMWOwHs32yKJFN04ndi8MaayayGI4LqC7S1S+Cedwmz3YjkQ986NrHAJdmy8C4
 fnd7UEv0OW/4jEoXxJyP/igsUkXTKket37B3QJEROJLBrvcmx0b2AlUHMjkaNzRl8JfHNwIJbxf
 D+QRctd3Tj+wCpRWjIyCfvUqYVbUak71VQSV3XNuAXdp1OyuxV4/OryIIfHqBVUKFTYbAFqvSvt
 KhEdpcgaVgY5WT7WA+Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-23_05,2026-11-23_01,2025-10-01_01

On receive, skb->decrypted means that the device decrypted the skb
(kTLS device offload, PSP). For a decrypted skb, any part of the packet
which had been encrypted should not be sent back onto the network in
cleartext.

These patches in the net series,

https://lore.kernel.org/netdev/20261117203137.804424-1-toddfreed@meta.com

 ipv4: icmp: don't quote decrypted payload in icmp errors
 ipv6: icmpv6: don't quote decrypted payload in icmpv6 errors

make the IP stack not send any ICMP error about a received decrypted
skb.

The reject expression in netdev and bridge chains builds its own ICMP
errors, without icmp_send() and icmpv6_send().
nf_reject_skb_v4_unreach() and nf_reject_skb_v6_unreach() quote up to
536 and 1220 bytes of the packet. Apply the rule to these paths too.
These only get received skbs, as the netdev and bridge reject
expressions are limited to the ingress, prerouting and input hooks, so
unlike icmp_send() no locally originated case needs to be kept.

The reject rule still drops the packet, but without a reply, as it
already does in other cases (non-first fragments, ICMP errors, bad
checksums).

nf_send_unreach() and nf_send_unreach6() use icmp_send() and
icmpv6_send(), which are covered by the net series.

Testing:

Reproduced with mlx5 (ConnectX-7) on net/main, with a reject rule in a
netdev ingress chain on the receiving host matching an established
connection. With kTLS RX device offload, the ICMP and ICMPv6
unreachables quoted the decrypted TLS payload in cleartext. With PSP
sockets, the ICMPv6 unreachables quoted the decrypted TCP header and
payload. With this patch, no ICMP error is sent for the decrypted
packets.

Fixes: 784abe24c903 ("net: Add decrypted field to skb")
Cc: stable@vger.kernel.org
Signed-off-by: Todd Freed <toddfreed@meta.com>
---

Notes:
    This supersedes the 2-patch nf-next series "netfilter: don't send
    decrypted skbs in clear text":
    https://lore.kernel.org/netfilter-devel/20261111003111.3826942-1-toddfreed@meta.com
    
     - Patch 2/2, "netfilter: reject: don't reply to decrypted skbs",
       reproduces on net/main, so it is resent here to nf as a fix, reduced
       to the ICMP errors.
     - Patch 1/2, "netfilter: bridge: don't refragment decrypted skbs", is
       dropped. I could not reproduce it on mlx5, neither on net/main nor
       with the socket-less PSP series: the device doesn't decrypt PSP in IP
       fragments.

 net/ipv4/netfilter/nf_reject_ipv4.c | 7 +++++++
 net/ipv6/netfilter/nf_reject_ipv6.c | 7 +++++++
 2 files changed, 14 insertions(+)

diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
index 7cb33af671e2..4d89ec6a4a91 100644
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -118,6 +118,13 @@ struct sk_buff *nf_reject_skb_v4_unreach(struct net *net,
 	if (!nf_reject_iphdr_validate(oldskb))
 		return NULL;
 
+	/* Don't send the decrypted part of an skb onto the network: the
+	 * device decrypted a received skb, and this reply quotes it. Only
+	 * received skbs get here (bridge, netdev ingress).
+	 */
+	if (unlikely(skb_is_decrypted(oldskb)))
+		return NULL;
+
 	/* IP header checks: fragment. */
 	if (ip_hdr(oldskb)->frag_off & htons(IP_OFFSET))
 		return NULL;
diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
index 5e08d8529cc8..fc30569b1f4d 100644
--- a/net/ipv6/netfilter/nf_reject_ipv6.c
+++ b/net/ipv6/netfilter/nf_reject_ipv6.c
@@ -144,6 +144,13 @@ struct sk_buff *nf_reject_skb_v6_unreach(struct net *net,
 	if (!nf_reject_ip6hdr_validate(oldskb))
 		return NULL;
 
+	/* Don't send the decrypted part of an skb onto the network: the
+	 * device decrypted a received skb, and this reply quotes it. Only
+	 * received skbs get here (bridge, netdev ingress).
+	 */
+	if (unlikely(skb_is_decrypted(oldskb)))
+		return NULL;
+
 	/* Don't reply to ICMPV6_DEST_UNREACH with ICMPV6_DEST_UNREACH */
 	if (nf_skb_is_icmp6_unreach(oldskb))
 		return NULL;

base-commit: 734bef548a96e8774d6eef5dfa2026c6edc4e80b
-- 
2.53.1-Meta

