Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=31.154.135.10
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793565554;
	b=0zbInudTppvWv+E4enFBYXmRLfxzQgWx+odzSzkGVArU+NewW6e1ig422MGa4Ne8r3AM
	 CdF8ZXBH9TrY7UdjI7Tp4BnWfDIT1axaI7SaHAdBW4nIVJoYTEtrTvsFWNvx78RMunx5q
	 5Yb35pA0SeegHMQa+RncpNZP97w3waQr4dZdhzZ26DLtl3A/uMeTppaSJzkr4U7ZBCWhv
	 hO1nTYLSGdwKeb3DLgngxU/qJTIy5TFIsShwGp1NefQBJLUd/GcDprpZ2XYSW3HXegke2
	 UBYjVPaD7Ue8niz5mJthUIjnpVDlZ03VBGOc+aO83gryXCoGMpcXdYLijK5OPNnNQyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793565554;
	h=DMARC-Filter:Received:Received:Received:Received:Received:
	 DKIM-Filter:DKIM-Signature:X-Virus-Scanned:Received:Received:From:To:
	 Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f12GvK4K9WQjL6wlwMGIcMqtamCD8C1zQuXEXdPFvWQ=;
	b=VfmyhJY0FmiM2AkinhC4N3pmStM2aIzgP9KxVBOwg4jQ+KkBxZR/JiMH3jS3zjeXNZCw
	 VpRE8dWpE5knlN2Jk8cRgpf8c+fQ25pL65GbV+Ps1FQd+GDWFTSw4bUJyIftal/B5EZLC
	 h1maBFxXP8tgt1ZaRnNdz8hf10w2PWq7QJIny5cd9aYVeQVfEV3SOQVEPfwUHJpmT1mzm
	 9frZIJJjB7QArA1a4ITh0KdwWexRc/mZedQ4XrLH8BcAn1ym4ZJLxwWpf/4DESzqi1sen
	 q2iE2UooI6kZ9TCg4HJFjAYTZFfL/18u2a2l6ILEh/p7zqyynj5r3PKkxFhZnzBMFoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=inango-systems.com;
	spf=pass smtp.mailfrom=inango-systems.com;
	dkim=pass header.d=inango-systems.com header.i=@inango-systems.com header.a=rsa-sha256 header.s=45A440E0-D841-11E8-B985-5FCC721607E0 header.b=bdi13AGX;
	arc=none smtp.remote-ip=31.154.135.10
Received: from ksserv.inango.com (ksserv.inango.com [31.154.135.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF01606A325;
	Sun,  1 Nov 2026 20:39:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DDF01606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=inango-systems.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inango-systems.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=inango-systems.com header.i=@inango-systems.com header.a=rsa-sha256 header.s=45A440E0-D841-11E8-B985-5FCC721607E0 header.b=bdi13AGX
Received: from ksserv.inango.com (localhost [127.0.0.1])
	by ksserv.inango.com (Proxmox) with ESMTP id A9E15229FD;
	Sun,  1 Nov 2026 22:39:11 +0200 (IST)
Received: from mail.inango-systems.com (unknown [192.168.70.50])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by ksserv.inango.com (Proxmox) with ESMTPS id 705BB2296D;
	Sun,  1 Nov 2026 22:39:11 +0200 (IST)
Received: from localhost (localhost [127.0.0.1])
	by mail.inango-systems.com (Postfix) with ESMTP id CE4D1D645A5;
	Sun,  1 Nov 2026 22:39:00 +0200 (IST)
Received: from mail.inango-systems.com ([127.0.0.1])
 by localhost (mail.inango-systems.com [127.0.0.1]) (amavis, port 10032)
 with ESMTP id oW8Fll6GCSjQ; Sun,  1 Nov 2026 22:39:00 +0200 (IST)
Received: from localhost (localhost [127.0.0.1])
	by mail.inango-systems.com (Postfix) with ESMTP id A1699D645B1;
	Sun,  1 Nov 2026 22:39:00 +0200 (IST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.inango-systems.com A1699D645B1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=inango-systems.com;
	s=45A440E0-D841-11E8-B985-5FCC721607E0; t=1793565540;
	bh=f12GvK4K9WQjL6wlwMGIcMqtamCD8C1zQuXEXdPFvWQ=;
	h=From:To:Date:Message-ID:MIME-Version;
	b=bdi13AGX+OFvJBPBPRRhZL6QYnb7daCCAz35Z4In2F+AykZ+BmFvvEEOSL08SzAln
	 0I6j1MvNpB03U4jVDEW2FEy39m6KuI+gsTAQe6Gzt0ScIuagmGnCdpLI08Rbmdfqq8
	 DCAffIwzgR562S596dH8GcDLA4BtEaAAQLKQmlGY2jVgi483PWH3/B2PEV1vc5iG37
	 38zjW4u3pMPRCTk3Id8Sa3WKXo7kZc1SmfOYrCjt0OX+4W8IBVm2hzuDQrM/3Y7nTg
	 RVVslQPaykwC7ur2T873H2r4HX1hqzZWuAuCmyJpqJLmkzW189697vcnlPuiqbMYeb
	 qUVm+g5fDQb6Q==
X-Virus-Scanned: amavis at inango-systems.com
Received: from mail.inango-systems.com ([127.0.0.1])
 by localhost (mail.inango-systems.com [127.0.0.1]) (amavis, port 10026)
 with ESMTP id YwZS9exZrsbT; Sun,  1 Nov 2026 22:39:00 +0200 (IST)
Received: from steamdeck.inango.loc (unknown [193.37.156.111])
	by mail.inango-systems.com (Postfix) with ESMTPSA id C9E4AD645A5;
	Sun,  1 Nov 2026 22:38:34 +0200 (IST)
From: Nikolai Merinov <n.merinov@inango-systems.com>
To: netfilter-devel@vger.kernel.org
Cc: netdev@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kernel@vger.kernel.org,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Nikolai Merinov <n.merinov@inango-systems.com>
Subject: [PATCH 2/3] netfilter: ip6t_NPT: Align ICMPv6 error messages with RFC 6296 requirements
Date: Mon,  2 Nov 2026 00:37:15 +0400
Message-ID: <20261101203716.269343-3-n.merinov@inango-systems.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261101203716.269343-1-n.merinov@inango-systems.com>
References: <20261101203716.269343-1-n.merinov@inango-systems.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

From: Andrey Kuznetsov <a.kuznetsov@inango-systems.com>

The RFC 6296 has the following two requirements:

1. In section 3.2

> If the internal subnet number has no mapping, such as being 0xFFFF or
> simply not mapped, discard the datagram.  This SHOULD result in an ICMP
> Destination Unreachable.

2. In section 3.7

> Although any 16-bit portion of an IPv6 IID could contain 0xFFFF, an
> IID of all-ones is a reserved anycast identifier that should not be
> used on the network [RFC2526].  If an NPTv6 Translator discovers a
> datagram with an IID of all-zeros while performing address mapping,
> that datagram MUST be dropped, and an ICMPv6 Parameter Problem error
> SHOULD be generated [RFC4443].

Provide the following changes to ip6t_npt_map_pfx() implementation:

1. Change type from bool to u8. Function returns 0 on success and
   required ICMPv6 message code in case of failure.

2. Return ICMPV6_PARAMPROB when all IPv6 IID parts equal to CSUM_MANGLED_=
0.

3. Return ICMPV6_DEST_UNREACH when subnet equal to 0xFFFF or packet not
   mapped.

4. Restore partially modified packet before sending ICMP message reply.

Add code to send correct ICMP messages in SNMP and DNPT targets in case o=
f
ICMPV6_PARAMPROB and ICMPV6_DEST_UNREACH error statuses.

Suggested-by: Alena Romanova <a.romanova@inango-systems.com>
Signed-off-by: Andrey Kuznetsov <a.kuznetsov@inango-systems.com>
Co-developed-by: Nikolai Merinov <n.merinov@inango-systems.com>
Signed-off-by: Nikolai Merinov <n.merinov@inango-systems.com>
---
 net/ipv6/netfilter/ip6t_NPT.c | 76 ++++++++++++++++++++++++++---------
 1 file changed, 58 insertions(+), 18 deletions(-)

diff --git a/net/ipv6/netfilter/ip6t_NPT.c b/net/ipv6/netfilter/ip6t_NPT.=
c
index 6a939e1a9fbc..d8cc0cc0339e 100644
--- a/net/ipv6/netfilter/ip6t_NPT.c
+++ b/net/ipv6/netfilter/ip6t_NPT.c
@@ -36,13 +36,14 @@ static int ip6t_npt_checkentry(const struct xt_tgchk_=
param *par)
 	return 0;
 }
=20
-static bool ip6t_npt_map_pfx(const struct ip6t_npt_tginfo *npt,
-			     struct in6_addr *addr)
+static u8 ip6t_npt_map_pfx(const struct ip6t_npt_tginfo *npt,
+			   struct in6_addr *addr)
 {
 	unsigned int pfx_len;
-	unsigned int i, idx;
+	unsigned int i, j, idx;
 	__be32 mask;
 	__sum16 sum;
+	u8 ret =3D 0;
=20
 	pfx_len =3D max(npt->src_pfx_len, npt->dst_pfx_len);
 	for (i =3D 0; i < pfx_len; i +=3D 32) {
@@ -52,8 +53,11 @@ static bool ip6t_npt_map_pfx(const struct ip6t_npt_tgi=
nfo *npt,
 			mask =3D htonl((1 << (i - pfx_len + 32)) - 1);
=20
 		idx =3D i / 32;
-		if ((addr->s6_addr32[idx] & ~mask) !=3D npt->src_pfx.in6.s6_addr32[idx=
])
-			return false;
+
+		if ((addr->s6_addr32[idx] & ~mask) !=3D npt->src_pfx.in6.s6_addr32[idx=
]) {
+			ret =3D ICMPV6_DEST_UNREACH;
+			goto err;
+		}
=20
 		addr->s6_addr32[idx] &=3D mask;
 		addr->s6_addr32[idx] |=3D ~mask & npt->dst_pfx.in6.s6_addr32[idx];
@@ -61,16 +65,21 @@ static bool ip6t_npt_map_pfx(const struct ip6t_npt_tg=
info *npt,
=20
 	if (pfx_len <=3D 48) {
 		idx =3D 3;
-		if ((__force __sum16)addr->s6_addr16[idx] =3D=3D CSUM_MANGLED_0)
-			return false;
+		if ((__force __sum16)addr->s6_addr16[idx] =3D=3D CSUM_MANGLED_0) {
+			ret =3D ICMPV6_DEST_UNREACH;
+			goto err;
+		}
+
 	} else {
 		for (idx =3D 4; idx < ARRAY_SIZE(addr->s6_addr16); idx++) {
 			if ((__force __sum16)addr->s6_addr16[idx] !=3D
 			    CSUM_MANGLED_0)
 				break;
 		}
-		if (idx =3D=3D ARRAY_SIZE(addr->s6_addr16))
-			return false;
+		if (idx =3D=3D ARRAY_SIZE(addr->s6_addr16)) {
+			ret =3D ICMPV6_PARAMPROB;
+			goto err;
+		}
 	}
=20
 	sum =3D ~csum_fold(csum_add(csum_unfold((__force __sum16)addr->s6_addr1=
6[idx]),
@@ -79,7 +88,22 @@ static bool ip6t_npt_map_pfx(const struct ip6t_npt_tgi=
nfo *npt,
 		sum =3D 0;
 	*(__force __sum16 *)&addr->s6_addr16[idx] =3D sum;
=20
-	return true;
+	return 0;
+
+err:
+	/* Restore address value before sending ICMP error */
+	for (j =3D 0; j < i; j +=3D 32) {
+		if (pfx_len - j >=3D 32)
+			mask =3D 0;
+		else
+			mask =3D htonl((1 << (j - pfx_len + 32)) - 1);
+
+		idx =3D j / 32;
+
+		addr->s6_addr32[idx] &=3D mask;
+		addr->s6_addr32[idx] |=3D ~mask & npt->src_pfx.in6.s6_addr32[idx];
+	}
+	return ret;
 }
=20
 static struct ipv6hdr *icmpv6_bounced_ipv6hdr(struct sk_buff *skb,
@@ -105,10 +129,18 @@ ip6t_snpt_tg(struct sk_buff *skb, const struct xt_a=
ction_param *par)
 	struct ipv6hdr *bounced_hdr;
 	struct in6_addr bounced_pfx;
=20
-	if (!ip6t_npt_map_pfx(npt, &ipv6_hdr(skb)->saddr)) {
-		icmpv6_send(skb, ICMPV6_PARAMPROB, ICMPV6_HDR_FIELD,
-			    offsetof(struct ipv6hdr, saddr));
-		return NF_DROP;
+	switch (ip6t_npt_map_pfx(npt, &ipv6_hdr(skb)->saddr)) {
+	case ICMPV6_DEST_UNREACH:
+			icmpv6_send(skb, ICMPV6_DEST_UNREACH, ICMPV6_ADDR_UNREACH, 0);
+			return NF_DROP;
+		break;
+	case ICMPV6_PARAMPROB:
+			icmpv6_send(skb, ICMPV6_PARAMPROB, ICMPV6_HDR_FIELD,
+				    offsetof(struct ipv6hdr, saddr));
+			return NF_DROP;
+		break;
+	default:
+		break;
 	}
=20
 	/* rewrite dst addr of bounced packet which was sent to dst range */
@@ -130,10 +162,18 @@ ip6t_dnpt_tg(struct sk_buff *skb, const struct xt_a=
ction_param *par)
 	struct ipv6hdr *bounced_hdr;
 	struct in6_addr bounced_pfx;
=20
-	if (!ip6t_npt_map_pfx(npt, &ipv6_hdr(skb)->daddr)) {
-		icmpv6_send(skb, ICMPV6_PARAMPROB, ICMPV6_HDR_FIELD,
-			    offsetof(struct ipv6hdr, daddr));
-		return NF_DROP;
+	switch (ip6t_npt_map_pfx(npt, &ipv6_hdr(skb)->daddr)) {
+	case ICMPV6_DEST_UNREACH:
+			icmpv6_send(skb, ICMPV6_DEST_UNREACH, ICMPV6_ADDR_UNREACH, 0);
+			return NF_DROP;
+		break;
+	case ICMPV6_PARAMPROB:
+			icmpv6_send(skb, ICMPV6_PARAMPROB, ICMPV6_HDR_FIELD,
+				    offsetof(struct ipv6hdr, daddr));
+			return NF_DROP;
+		break;
+	default:
+		break;
 	}
=20
 	/* rewrite src addr of bounced packet which was sent from dst range */
--=20
2.55.0


