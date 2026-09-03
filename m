Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F37B2BE03B;
	Thu,  3 Sep 2026 00:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788396129; cv=none; b=QyoJwCenIDicMhTDn4NqEnuZmbdomvC5fuD+IomrW/5KUTIFlKBvH4vdaS0q1WJwygtOiRkDbaGO+vyhi+Afby1i0+bf3mPy25VFm72J3Kd7ntHDpg/UFPqrH3d3RkkWB+rqm5jiseJSb7RYK9Jv3nonA79GNvLaOKpiV5dEe4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788396129; c=relaxed/simple;
	bh=7F48GGueHHiZlMRgR27FTzJxfy4Ds8TJpOmwoWth1gw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GXtyRmYBGsHtXLABge/a+sSzMXVu/QrJDZJJEYbERauNNw9vHXbUlSEvDFo1+q/1RZ/Uv5e5KLAf+UqicyKdo2cBTWWBy2VVM6oQ3WDzh/wbsDcU07gK93bVAUuqW4S+qhxKPPJpUhFUebK0lWjs4dDea7lS3+vnAzpY9afzkok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=f0MAWfvG; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="f0MAWfvG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788396124;
	bh=KGrFjt5YPGTrTxX4mlTeL4qLQISN+Eq4vm9IJh0iFRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f0MAWfvGI+5PSnCv+gvtx9gC6tvtENOr05hKXkcaN5CrX7TLLxdNseNTHPEkestfH
	 QqizJpMdWYOiggz3IfUQuRe9PpkXk//Tnk9aaJK0eXVc9V/miMf0MqHNPqHaYmS+a/
	 zK16AU0qBfkQ4cfoJqMQg78MrFISsX8ENNjDLMWGsQEcIG6TRIFlKDx/0cyMbsdlJh
	 65XPW9SLrM7DBgKypiir84CVwDdVw42TaXNIGNTza/5yTBUO+7KDybKu0YpsBIHwWv
	 XbfKe7o5WuITGPQSKEnDH5gZ20QP5MlYDVWtRGYgVerQzU3x3xWrptzyyCC4o43CH8
	 VUBZ17h0eruUQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id EA40F607AE;
	Thu,  3 Sep 2026 02:42:03 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 07/12] netfilter: nft_payload: restrict checksum offsets to known values
Date: Thu,  3 Sep 2026 02:41:44 +0200
Message-ID: <20260903004149.1037028-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260903004149.1037028-1-pablo@netfilter.org>
References: <20260903004149.1037028-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
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
 net/netfilter/nft_payload.c | 36 +++++++++++++++++++++++++++++-------
 1 file changed, 29 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index e315d35f73d4..70f70a65e327 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -1008,11 +1008,13 @@ static bool nft_payload_validate_inet_csum_offset(const struct nft_ctx *ctx,
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
@@ -1046,6 +1048,25 @@ static bool nft_payload_csum_nh_write_ok(const struct nft_payload_set *priv,
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
+	}
+
+	return false;
+}
+
 static bool nft_payload_csum_write_ok(const struct nft_pktinfo *pkt,
 				      const struct nft_payload_set *priv)
 {
@@ -1055,9 +1076,10 @@ static bool nft_payload_csum_write_ok(const struct nft_pktinfo *pkt,
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

