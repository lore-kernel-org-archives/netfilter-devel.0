Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.145.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794357126;
	b=VXtBxJnVtWZtDQz0+jWOjstJpdCAvpSckNR3QhxTv/VDA7LTfxROEvdR4ziR6Qdl9UdV
	 fQBH9XaCZ17gLa6t5mVGBoTkBhFIyzAvczuwpb52zE+uYuoxs//7TbGUATt+N6rHq2SaD
	 1mqpU0vi4Km5zd/UcZqo4fkAuW66RR/wmlpMM7LfUknlULeotn06UQBYXV9TeQdi2FRC0
	 T8PHqZbyLrR4U2/uRXqdx0/8Z9dF1C4zq2Bfx6sI5fIB0IiU6QN6KjrqpJmUoFiTYASS7
	 FjcKeEr2Rn3v+MebbCZl1Qvo6Tv/brfnRYK1GJFxEV1+5G36iextJLAn6IOxeoapfHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794357126;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version;
	bh=5FzTcpNvaCOJGu4VzhfeYUhORz6w1DeoC+Q6w5zsFY4=;
	b=FJyqo/hx++OLt6V0L067mq4DJsz6uonJ0J/IsqANks0EnT3vVRw/bUf3SENrWAJvpAlh
	 oximwg45JWk9OD9qmJ8+cEo17Y6UQc1Ad+P4PV47W/l+dQ50B4fgQjT4I756g5ttE2JP1
	 v7eEez6ym00jYjt8/VSHyn3V0SCqIgpE9h+jKm7NAB+amuRyKk/3yN/JGS7GQly+eoQtJ
	 QbxDMw7b3Vjk4GEfFIiFHzdvO5ImgcBTVQVjGHNhUfaaSGdY8Ulca8J/Up/uVRbTVUCt6
	 +8zy7hFKY9vcO5+QpsJayR8yIeJpCVrOZYZOx2eOaZ7+n6QeHmogZhkAjzr3oaOdXGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=kMnzAUW6;
	arc=none smtp.remote-ip=67.231.145.42
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9C0606A320;
	Wed, 11 Nov 2026 00:32:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1D9C0606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=kMnzAUW6
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AAMK3Ns2810143;
	Tue, 10 Nov 2026 16:31:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=5FzTcpNvaCOJGu4VzhfeYUhORz6w1DeoC+Q6w
	5zsFY4=; b=kMnzAUW6orr66NxjSIuhzAKFmkIwPKFA/vFHrS98NjWlUqDtibUTf
	sH2DpZ7TQKMngDSv2zM0y5cRfIJkLCKigCjwSQsMQBJlNcbc8zDCp4uxwBKkkPyF
	dnlgry9u5xhY6vqbgb+OOq1F/DNtEvYgKuQRzb1Q2IQfkExxbSeCtgcNh7mhg76O
	odpIr0l6rVmSyV82AL7/JWqPi6N/7YrLuFaZ01dQq8NX4T2hkgbW+KZnXpGqV66u
	XBtB5+yfTA8nHnsJirdzF/9hSkwpUkbU1pQKJU6hdaiO5mi2GtkBRmd032iuHfRQ
	QpykrzPe6BvZQxjeZGq31vvN6ymEgNlQA==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4hv7vgk9pa-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 10 Nov 2026 16:31:46 -0800 (PST)
Received: from localhost (2620:10d:c0a8:1b::2d) by mail.thefacebook.com
 (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Wed, 11 Nov
 2026 00:31:30 +0000
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
Subject: [PATCH nf-next v1 1/2] netfilter: bridge: don't refragment decrypted skbs
Date: Tue, 10 Nov 2026 16:31:10 -0800
Message-ID: <20261111003111.3826942-2-toddfreed@meta.com>
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
X-Proofpoint-GUID: Rt-9r7iz54On-3FUz-CUACgFYk7P_VMX
X-Proofpoint-ORIG-GUID: Rt-9r7iz54On-3FUz-CUACgFYk7P_VMX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDAwMSBTYWx0ZWRfXw2Gu2f5JwCiY
 tq1k0Uf0Aekyxrv3n6E4n3oztXo58xw6cl1i19B8hlFEY3KisvCA875lwywINUYtVE+yxCPMk59
 /5Tp0i9KvKNn7SmR5mQgcxDA1url/G8B77re2FfiDjSK/jyZefnPST9bRen9UQG6ZIC0pQYUB90
 sf3pzctZj9pk/qvtZLj95ZQYvOhnYyv3BhMiGEn7BlhQy+r3x/xEykgFue+8y2NJsIbkOUgAIdf
 4ofUjAyPbBz8DxvGNygd0rPlrqXw+2Ih9Rz5xI4XVPBUbsNv2BgpHQ47jH+V72dMZRSMKxNZryp
 GlR3bvDMHR4T4nO98kBLhjPHCeoBhfr8+Km12UUNuxnomVZjBAdDWdE3Ym7sIj++HmccZFb8FKw
 xZEgWLrB8LvS9qptzENt8SEj7UQ0JrnsvDgYWH6+so69HSdkU9cqD9X0Q8Gb9uvreJSrHYIg1CL
 tCmxSX3DMLH0QZamTYw==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDAwMSBTYWx0ZWRfX6Y8vzTJFpTXQ
 pEfSjX/gvjiV6HOlDMcWMwwpmXL97Jax6i2rWT9riue4zy85DUalh5/j5gtG9478SoqRQWcw5QN
 G33GHaXkns+eYMqbJwNd+VwWP3CDqFE=
X-Authority-Analysis: v=2.4 cv=feA4WEQF c=1 sm=1 tr=0 ts=6af3b772 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=03ozwUkBphtHgyqjj1sw:22 a=VabnemYjAAAA:8 a=JuoKQMhjErB6uDpvzdUA:9
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-10_07,2026-11-06_01,2025-10-01_01

on transmit, skb->decrypted means that the device must encrypt the skb
or drop it. this applies to psp offload and ktls offload. those
offloads cannot support fragments. they need the packet's l4 header, and
non-initial fragments do not have it. therefore, the ip stack doesn't
fragment decrypted skbs.

"net: don't fragment decrypted skbs" (net) drops decrypted skbs in
ip_do_fragment() and ip6_fragment(), instead of fragmenting them.

nf_conntrack_bridge refragments the packets it reassembled with its own
functions, which don't have that check: nf_br_ip_fragment() for ipv4,
and br_ip6_fragment() for ipv6. br_netfilter uses ip_do_fragment() and
ip6_fragment(), and is covered by the net patch.

a packet which a psp device decrypted, and which is bridged without
being re-encrypted, gets there if the peer sends ip fragments inside
psp: bridge conntrack reassembles them into one decrypted skb. its
fragments couldn't be encrypted, and the ones built from scratch don't
carry the decrypted mark, so they'd leave the bridge port in clear text.

drop decrypted skbs in nf_br_ip_fragment() and br_ip6_fragment(), as
the ip stack does.

Signed-off-by: Todd Freed <toddfreed@meta.com>
---
 net/bridge/netfilter/nf_conntrack_bridge.c | 6 ++++++
 net/ipv6/netfilter.c                       | 6 ++++++
 2 files changed, 12 insertions(+)

diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index b5444335b86f..0069734853fd 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -38,6 +38,12 @@ static int nf_br_ip_fragment(struct net *net, struct sock *sk,
 	struct iphdr *iph;
 	int err = 0;
 
+	/* PSP and TLS offload need the packet's L4 header, which non-initial
+	 * fragments do not have.
+	 */
+	if (unlikely(skb_is_decrypted(skb)))
+		goto blackhole;
+
 	/* for offloaded checksums cleanup checksum before fragmentation */
 	if (skb->ip_summed == CHECKSUM_PARTIAL) {
 		err = ip_check_csum_start(skb);
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index a7025ec87035..e538f1c8d602 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -124,6 +124,12 @@ int br_ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 	int hroom, err = 0;
 	__be32 frag_id;
 
+	/* PSP and TLS offload need the packet's L4 header, which non-initial
+	 * fragments do not have.
+	 */
+	if (unlikely(skb_is_decrypted(skb)))
+		goto blackhole;
+
 	err = ip6_find_1stfragopt(skb, &prevhdr);
 	if (err < 0)
 		goto blackhole;
-- 
2.53.0-Meta

