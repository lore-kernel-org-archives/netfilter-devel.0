Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792422188;
	b=BCt26keuyrOJ6+kh3773vLp8doBYspgVG0CDiivI9tbogK5Y6PQnON2xB4RCNI7/RZki
	 3cuiuuf1nAstJ9KrUXw4Yp71wysUaZ7gZvLqcw4HwAXo4PQek3JEnZXHydCaUEsbDulMu
	 nLeBThGAkvarFcB89UejBOoFsI2kAJKXDt7ryuzAzUM/+ZZy+AAH9cojNYojjuLRbFnNq
	 s1RLI1iZ4S5hPCAkoZ13Po8SfyLjkiPXjw79oa5X1b31h3Y7Q6kLD7TaSCmfm57pfk0dF
	 bH0EiSeuivGao6hXYMrGwPB515p9yqM6o3lmyg6Ywz51h3AGbpW9nHfKNE62d27yMgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792422188;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=NO/QAgPEr2LWUU2Z1qiLNJpJIA4pu0lHFz79MIU/6To=;
	b=bk7u+rVJreWDxSSJ2+8e+1l0llRM7Rkp15qoafsQQvG/NbdQTrYeqxJsP6N87yJPI/4l
	 wjD0EqoZu6bqkQ7mRem+9m09sWqrZW0QgH//eEsyPIcUjUfZwlmwLR32QGg5zOrNPlPml
	 Zs/srzRA9Ir0HOLmT3mlFILrhXULRf7YR6n7uHdTJVIHyiZ3ketAFUTtoY3803m4J5w27
	 BZ1WFKkUnlQRjPmxwdiPSfIW6DJsJ6ZHddtaWBqGD/A6PGn4cHdSFQfQViPkB4ZhLZvut
	 Clxnm8SMj5HpIS+G5W7eIFl9K7XyNg3ErbV9vyODyJDKXpmx3w6mA3iH08jafqgzLPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=vKcvGQ4r;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F0A8607D34E;
	Mon, 19 Oct 2026 15:03:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2F0A8607D34E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=vKcvGQ4r
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792422179;
	bh=NO/QAgPEr2LWUU2Z1qiLNJpJIA4pu0lHFz79MIU/6To=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vKcvGQ4rceH0yefPHBJMeACMGW89fPb15Z/YI+xO4zyYYg8Zxq1fXUzJg55TsNhD3
	 SJ1fSOgXnD1LUX6HFU/rtGEa3Mx4xp9v335dD8jHQ1FrK5qXP+uUbCdiUwcZ1TvVZT
	 0znyXylC128naJ1kIBBWN6OHZqxtg8MXEdurtMwUrhTGfwhNqCHDhQpPo7IuJPDHOk
	 iw3Zuvg8UbhhCTeY9udyPXlpYKayLSaOek/Oi9bQyMujVnTM5dLfAGf6mVat59bVUN
	 8zUKQIPb5RNPVI/HAwsGKP7VGN2/vXYTXbSHTHoX1xxLFAw3hBVlysPWB+C1lAJhCE
	 CX0HZqM/aEUKQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 4E82C6005E;
	Mon, 19 Oct 2026 17:02:59 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@kernel.org,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 02/10] netfilter: nft_payload: restrict checksum offsets to known values
Date: Mon, 19 Oct 2026 17:02:41 +0200
Message-ID: <20261019150249.1879516-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261019150249.1879516-1-pablo@netfilter.org>
References: <20261019150249.1879516-1-pablo@netfilter.org>
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

From: Florian Westphal <fw@strlen.de>

We need to prevent userspace from corrupting e.g. tcp->doff, because
many locations in conntrack and conntrack helpers rely on
nf_conntrack_in() having validated the packet headers.
nft_payload allows to alter headers later which invalidates this
assumption.

The 'Fixes' commit restricts writes to safe fields, but there is
another side channel: the checksum location.

Restrict this too.  Reported via sashiko/gemini.

Fixes: 112e447d17f7 ("netfilter: validate L4 headers after userspace packet writes")
Assisted-by: Claude:claude-opus-4-6
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_payload.c | 40 ++++++++++++++++++++++++++++++-------
 1 file changed, 33 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index e315d35f73d4..5b76af68b704 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -20,6 +20,7 @@
 #include <linux/tcp.h>
 #include <linux/udp.h>
 #include <net/gre.h>
+#include <linux/icmp.h>
 #include <linux/icmpv6.h>
 #include <linux/ip.h>
 #include <linux/ipv6.h>
@@ -1008,11 +1009,14 @@ static bool nft_payload_validate_inet_csum_offset(const struct nft_ctx *ctx,
 		if (priv->csum_flags) /* makes no sense, asks for "re-update" of L4 checksum */
 			return false;
 
-		/* no further check here; offset can't be negative so bogus
-		 * offsets can corrupt L4 or payload but not l3 headers.
-		 * We already allow arbitrary l4/inner payload writes.
-		 */
-		return true;
+		/* Validate csum_offset is one of the supported transport header checksums */
+		if (priv->csum_offset == offsetof(struct tcphdr, check) ||
+		    priv->csum_offset == offsetof(struct udphdr, check) ||
+		    priv->csum_offset == offsetof(struct icmphdr, checksum) ||
+		    priv->csum_offset == offsetof(struct icmp6hdr, icmp6_cksum))
+			return true;
+
+		return false;
 	case NFT_PAYLOAD_INNER_HEADER:
 		return true;
 	case NFT_PAYLOAD_TUN_HEADER:
@@ -1046,6 +1050,27 @@ static bool nft_payload_csum_nh_write_ok(const struct nft_payload_set *priv,
 	return false;
 }
 
+static bool nft_payload_csum_th_write_ok(const struct nft_payload_set *priv,
+					 const struct nft_pktinfo *pkt)
+{
+	if (!(pkt->flags & NFT_PKTINFO_L4PROTO))
+		return false;
+
+	switch (pkt->tprot) {
+	case IPPROTO_TCP:
+		return priv->csum_offset == offsetof(struct tcphdr, check);
+	case IPPROTO_UDP:
+	case IPPROTO_UDPLITE:
+		return priv->csum_offset == offsetof(struct udphdr, check);
+	case IPPROTO_ICMPV6:
+		return priv->csum_offset == offsetof(struct icmp6hdr, icmp6_cksum);
+	case IPPROTO_ICMP:
+		return priv->csum_offset == offsetof(struct icmphdr, checksum);
+	}
+
+	return false;
+}
+
 static bool nft_payload_csum_write_ok(const struct nft_pktinfo *pkt,
 				      const struct nft_payload_set *priv)
 {
@@ -1055,9 +1080,10 @@ static bool nft_payload_csum_write_ok(const struct nft_pktinfo *pkt,
 	case NFT_PAYLOAD_NETWORK_HEADER:
 		return nft_payload_csum_nh_write_ok(priv, pkt);
 	case NFT_PAYLOAD_TRANSPORT_HEADER:
+		return nft_payload_csum_th_write_ok(priv, pkt);
 	case NFT_PAYLOAD_INNER_HEADER:
-		/* neither offsets are validated, offsets cannot be
-		 * negative so real l3 headers cannot be mangled.
+		/* offset is not validated, offset cannot be
+		 * negative so real l3/l4 headers cannot be mangled.
 		 */
 		return true;
 	case NFT_PAYLOAD_TUN_HEADER:
-- 
2.47.3

