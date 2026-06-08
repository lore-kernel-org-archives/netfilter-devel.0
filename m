Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DDC035C181;
	Mon,  8 Jun 2026 12:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780922025; cv=none; b=jRWFgMyHthFiWbE+XETsVrUinpTlHx0KWXIj6QfxlC99ORJmYKt+ECccMykmoa7UDt3yECFuxDa51qlkncRKwMMZ0gPLsWTqpMqYU/pUi0oLuobV+iXwm4XOWxM8amySAT+nF6G7173fuMELlTgFzls3ze6Zaevr4W556Xjqcqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780922025; c=relaxed/simple;
	bh=NipiNWpuUPNzMXlPNmWquXOAltGxU+4lqK4kT7PJA0M=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=ZzPQlJhUUDclXotZoM2rQlxCE4MGNxhj1piZTG7tVQZV2XZbeMbetsN9EroZWMAOzQI73KpYCwe9BDDQoTB17ugXLORIf0qbfc5SvJhN8B3BomLKy41Z5ISvtFyW9d/1QiCvFp1flNR6Fj7hT2QiAhRBHOuywaE/eWLJv+ToSL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HjKg3Cti; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HjKg3Cti"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AFCF1F00893;
	Mon,  8 Jun 2026 12:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780922023;
	bh=+zkD/s7AAUadUqWPr+fk+LTvm/vsGqXBnoPGDjCLi9I=;
	h=From:Date:Subject:To:Cc;
	b=HjKg3CtiRvn5dGyQCSntNrvAP3lb77YNCRFfw+RQhX36/msyC0+RMNJY+pjZPd2D5
	 XcNb25V7wRlK7TSVtEzrL0Z47yvd79X6S1BDVkh9+AYf5LqK7WT9qjxZL6lDvpw9hu
	 L/xiXgUnEQ5kk8A4gp70WJS9p+PhlDioAJXzoQ0p+zJfyI6oBLEdWuust3yxO6CqVl
	 QA9gLAIpw4HD/m9ZrBcRHC6KUIsNk+rolV5PlWItKGdlJajjgCIMRB/cOQG/eB01Fa
	 iHABKJuCubEk2w+lSkJXryBbwvPtl9ORxk3jB9CdcVgdozpjxhlMtTsC9mkmAA5Wcw
	 GlG7puOlIZJ2w==
From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Mon, 08 Jun 2026 14:33:23 +0200
Subject: [PATCH nf v2] netfilter: flowtable: Validate iph->ihl in
 nf_flow_ip4_tunnel_proto()
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260608-nf_flow_ip4_tunnel_proto-update-v2-1-d409295b8788@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/42NTQ6CMBBGr0JmbU1bEMWV9zCkAZmBRtM204Iaw
 t1tOIHL7yfvrRCRLUa4FiswLjZa73LQhwIeU+dGFHbIGbTUtazlSTgy9PJvY0Nl0uwcvkxgn7y
 Yw9AlFH2p6NwT1dQ3kCmBkexnN9zBEbS5m2xMnr+7dFH78jd/UUKJZsBK61KSvMjbEzm/jp5Ha
 Ldt+wFObCZb0wAAAA==
X-Change-ID: 20260605-nf_flow_ip4_tunnel_proto-update-b31f7bff6fb9
To: Pablo Neira Ayuso <pablo@netfilter.org>, 
 Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, Lorenzo Bianconi <lorenzo@kernel.org>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
 netdev@vger.kernel.org
X-Mailer: b4 0.14.3

Add sanity check for iph->ihl field in nf_flow_ip4_tunnel_proto() before
using it to compute the header size, avoiding out-of-bounds access with
malformed IP headers.
While at it, use iph->protocol instead of the hardcoded IPPROTO_IPIP
constant when setting ctx->tun.proto and reference ctx->tun.hdr_size
when updating ctx->offset.

Fixes: ab427db178858 ("netfilter: flowtable: Add IPIP rx sw acceleration")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
Changes in v2:
- Roll back to pskb_may_pull() instead of using skb_header_pointer().
- Link to v1: https://lore.kernel.org/r/20260605-nf_flow_ip4_tunnel_proto-update-v1-1-9de42230f080@kernel.org
---
 net/netfilter/nf_flow_table_ip.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 9c05a50d6013..ef5d319e58d4 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -326,8 +326,10 @@ static bool nf_flow_ip4_tunnel_proto(struct nf_flowtable_ctx *ctx,
 		return false;
 
 	iph = (struct iphdr *)(skb_network_header(skb) + ctx->offset);
-	size = iph->ihl << 2;
+	if (iph->ihl < 5)
+		return false;
 
+	size = iph->ihl << 2;
 	if (ip_is_fragment(iph) || unlikely(ip_has_options(size)))
 		return false;
 
@@ -335,9 +337,9 @@ static bool nf_flow_ip4_tunnel_proto(struct nf_flowtable_ctx *ctx,
 		return false;
 
 	if (iph->protocol == IPPROTO_IPIP) {
-		ctx->tun.proto = IPPROTO_IPIP;
+		ctx->tun.proto = iph->protocol;
 		ctx->tun.hdr_size = size;
-		ctx->offset += size;
+		ctx->offset += ctx->tun.hdr_size;
 	}
 
 	return true;

---
base-commit: 9772589b57e44aedc240211c5c3f7a684a034d3a
change-id: 20260605-nf_flow_ip4_tunnel_proto-update-b31f7bff6fb9

Best regards,
-- 
Lorenzo Bianconi <lorenzo@kernel.org>

