Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0979A3ACF02
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Sep 2026 09:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788515867; cv=none; b=X+9w/IYdHQ292+OyyEhqKQ2UJOSFxpOxPKepP9JoWUCSDUTWhbZyAFJgxJvQnrWYvit4j8cDSaML+DMb86tJo8lnV+xYISd8jHis8+y2xhUXyDyhBZ/y5aOVla9fDU2K92MRKoOeXuw/MgH4FrDKok01NjXDun7QKYjKnH2k668=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788515867; c=relaxed/simple;
	bh=c8iL4F4AvRnPGrQ9jKtuKS8yJG/9Swj5aQhvs0fW0xI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fMo1DPkF/5XVWqPPDO54ne3sVLUKRqgQzVz7N21AGXck1QtdKb3+XLADTBBzdC5aAQZkzvJTNyVqu9ZFk+DTXnmJKjS01oQsvtHYFDXe9FRRc375mWkKlrgR6sda7LDoxaYV3zeCgh8g8rB/JBf6MFDednA4bF1Sg14lcY8AXrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id B568D6025B; Fri, 04 Sep 2026 11:57:36 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf] netfilter: nft_payload: restrict checksum offsets to known values
Date: Fri,  4 Sep 2026 11:57:23 +0200
Message-ID: <20260904095723.18368-1-fw@strlen.de>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We need to prevent userspace from corrupting e.g. tcp->doff, because
many locations in conntrack and conntrack helpers rely on
nf_conntrack_in() having validated the packet headers.
nft_payload allows to alter headers later which invalidates this
assumption.

The 'Fixes' commit restricts writes to safe fields, but there is
another side channel: the checksum location.

Restrict this too.  Reported via sashiko/gemini.

v2: add missing IPPROTO_ICMP handling, else 'icmp code set 42' won't
update icmp checksum.

Fixes: 112e447d17f7 ("netfilter: validate L4 headers after userspace packet writes")
Assisted-by: Claude:claude-opus-4-6
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 I pushed an update to stateless_nat to catch this.

 net/netfilter/nft_payload.c | 39 ++++++++++++++++++++++++++++++-------
 1 file changed, 32 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index e315d35f73d4..f732e2d61f8c 100644
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
@@ -1008,11 +1009,13 @@ static bool nft_payload_validate_inet_csum_offset(const struct nft_ctx *ctx,
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
+		    priv->csum_offset == offsetof(struct icmp6hdr, icmp6_cksum))
+			return true;
+
+		return false;
 	case NFT_PAYLOAD_INNER_HEADER:
 		return true;
 	case NFT_PAYLOAD_TUN_HEADER:
@@ -1046,6 +1049,27 @@ static bool nft_payload_csum_nh_write_ok(const struct nft_payload_set *priv,
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
@@ -1055,9 +1079,10 @@ static bool nft_payload_csum_write_ok(const struct nft_pktinfo *pkt,
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
2.55.0

