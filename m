Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D273B48CFC;
	Mon,  8 Jun 2026 17:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780938453; cv=none; b=gWqlNRRW8c8IQFDoWxvQqYs7upbESqZqSYXHtMuH/9zui0M/ZEghsk5M2A+MOKntMJHU0COLXf4JDFWzFVg7/kRc2lbKTm0YnILfqtfgmHCmsVyd1OaRPbpIG25gwudRp7yqTndmPoDVDm3Zf8GtjOrd9yw+twwpBO2/B/qBO+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780938453; c=relaxed/simple;
	bh=Qv2L2nWbYIwR+EgyVjmSHgTCjSgLtzxD2PHwVESrJ7w=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=onAtW825M3UEE4kJhMEPxa+jZRggyjGB+M5/Vb0EpZswXC4I0KOJTqSOrcir5+5tqWKVGNSPUKd+rlKD6mJJuBTzD9lBuVAAHWLlQ55q0MBGnrgXoSm4g4bDYBR8X+Ha9Fc5INdtx8xpIKmlVnGhClW4G4doUHE2ryAAvtq1t6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B/1jPyft; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B/1jPyft"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAEE01F00893;
	Mon,  8 Jun 2026 17:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780938452;
	bh=8TJOARFLPWWDDuoaBMQD1pAOToEPT0+pMS39POI6GXw=;
	h=From:Date:Subject:To:Cc;
	b=B/1jPyftAZKyO2vqjOF/CtK3xnpae2/axZtrPKwMpof+sCdzjwMm+2YtdEU0+JIrK
	 IUAXJv99sMCbpMe8DEgF9Y2ZL7cU8A/qLB9Ko4dWHWpVMpUb1vIhMBCKT7W/hBz5Yr
	 Sw2xUCw35pKbc6l37NX6ZtEGSRgNwnsUx2Xw4TaaO9VROtaIZfcgOEtumHg6labnVt
	 2zc/wAyYdEbxx1n7SXnjEAms7t4xC1/snNvwedbkAsEg+G7GM/NgFEzYDN0ndK781e
	 J9eN7y+FU2Pcz0TpauSSGQbXdq/3EAaA8JJzqh4hjEq21wlqOAxSt55z4K47R3CC1J
	 FuFM2elUOWqqA==
From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Mon, 08 Jun 2026 19:06:52 +0200
Subject: [PATCH nf] netfilter: flowtable: use pskb_may_pull() in
 nf_flow_ip6_tunnel_proto()
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260608-b4-nf_flow_ip6_tunnel_proto-update-v1-1-782c7052c8fd@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x3NQQrCMBBA0auUWTsQYwzRq4iExk50oExCkmqh9
 O4NLt/m/w0qFaYK92GDQl+unKTjfBrg9RnlTchTN2ilrbLKYTAo0cc5/Txn69siQrPPJbWES57
 GRuiCNTd1cfoaDPRQLhR5/U8eIBGe+34AI/6de3gAAAA=
X-Change-ID: 20260608-b4-nf_flow_ip6_tunnel_proto-update-8b64903825b4
To: Pablo Neira Ayuso <pablo@netfilter.org>, 
 Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
 netdev@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>
X-Mailer: b4 0.14.3

Switch nf_flow_ip6_tunnel_proto() from skb_header_pointer() to
pskb_may_pull() for header validation, aligning it with the approach
used in nf_flow_ip4_tunnel_proto().
Move ctx->offset update inside the IPPROTO_IPV6 conditional block since
it should only be adjusted when a tunnel is actually detected.
While at it, use nexthdr instead of the hardcoded IPPROTO_IPV6 constant
when setting ctx->tun.proto.

Fixes: d98103575dcdd ("netfilter: flowtable: Add IP6IP6 rx sw acceleration")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 net/netfilter/nf_flow_table_ip.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 9c05a50d6013..2946399ab715 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -347,15 +347,15 @@ static bool nf_flow_ip6_tunnel_proto(struct nf_flowtable_ctx *ctx,
 				     struct sk_buff *skb)
 {
 #if IS_ENABLED(CONFIG_IPV6)
-	struct ipv6hdr *ip6h, _ip6h;
+	struct ipv6hdr *ip6h;
 	__be16 frag_off;
 	u8 nexthdr;
 	int hdrlen;
 
-	ip6h = skb_header_pointer(skb, ctx->offset, sizeof(*ip6h), &_ip6h);
-	if (!ip6h)
+	if (!pskb_may_pull(skb, sizeof(*ip6h) + ctx->offset))
 		return false;
 
+	ip6h = (struct ipv6hdr *)(skb_network_header(skb) + ctx->offset);
 	if (ip6h->hop_limit <= 1)
 		return false;
 
@@ -367,9 +367,9 @@ static bool nf_flow_ip6_tunnel_proto(struct nf_flowtable_ctx *ctx,
 
 	if (nexthdr == IPPROTO_IPV6) {
 		ctx->tun.hdr_size = hdrlen;
-		ctx->tun.proto = IPPROTO_IPV6;
+		ctx->tun.proto = nexthdr;
+		ctx->offset += ctx->tun.hdr_size;
 	}
-	ctx->offset += ctx->tun.hdr_size;
 
 	return true;
 #else

---
base-commit: 9772589b57e44aedc240211c5c3f7a684a034d3a
change-id: 20260608-b4-nf_flow_ip6_tunnel_proto-update-8b64903825b4

Best regards,
-- 
Lorenzo Bianconi <lorenzo@kernel.org>

