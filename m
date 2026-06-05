Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A439B416D11;
	Fri,  5 Jun 2026 16:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780678091; cv=none; b=boh6y7HXtq9fsFn3d54yO5Khn6Zdt18KjCheO3K6SpdijOxqVWv3zgdme2HSS+OpcMRAB+5jrMj0umJNv4FQQt+ts4dhtTIkE0BIHBDrkEnuG1eKKxsxgIUar9gBGBeN71ivH6JxFmmW9YHcxBtphvhMYOrYS9CPiSvTYCDGh3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780678091; c=relaxed/simple;
	bh=L12zN332I92MvNM9UxWwKc8LP852nIsJRf/OVsmGYnc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=KMQVHJ7gl/iOjhE2wky2ptk3/L6vVd4sNnnI0ZJCh6BjRvdIgs1WhYNKy7H8rI2GUZ/3gXGKoSjPEmvT7o9KqIUufEEetQOKb+0yyoSEyfK1WhzF+wUpkYVYjWPmAz+KJDtQnpofRZX2hoy8Sb6r4x4yqVP2Kzi6KridhoWScxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z2yMU8NR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z2yMU8NR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D2E21F00893;
	Fri,  5 Jun 2026 16:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780678089;
	bh=v5tPOCoS4u/BnwalvSfGaAsQN8smT4gdZFQcmM0aeME=;
	h=From:Date:Subject:To:Cc;
	b=Z2yMU8NRmyTxSJ6I88bKgKbu1ejvG/lCN8Ve5zckAKMZpsXsnnFjnRU6Fgw3509gy
	 cb3E3Qy1/UVCeDd6tVHQNf47NMU/HbliT6HZItaWVwR/03yPfdL5cCDLCkPdpuPyxa
	 cizF5YgkdDS+gcCupBVTX4m27V9A3STiorz+fMKVYoh0wjfhnbtwd21ZQkAxc3fRnX
	 zZDh/rP72qMsawAAovkMFFAtJguag58l0NerQ17WsVt9nlWROqdbMXhsGeE0ZzgSNH
	 uY8DsiYC2IIWEpgN0Mo+K2SFBwmFMMtjg1qGAB3e32a11KCQVTdyvOvvvI44AAX9BG
	 phWH98dkYY2FQ==
From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Fri, 05 Jun 2026 18:47:48 +0200
Subject: [PATCH nf] netfilter: flowtable: Validate iph->ihl in
 nf_flow_ip4_tunnel_proto()
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260605-nf_flow_ip4_tunnel_proto-update-v1-1-9de42230f080@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x3NQQqDMBBA0avIrA1E26boVUSC0Zl2QCYhiVUQ7
 97g8m3+PyFhZEzQVydE/HFiLwVNXcH8neSDipdiaHVrtNEvJWRp9bvl8LR5E8HVhuizV1tYpoz
 KPRp6OyJDroNSCRGJj/swgBCM1/UHkXgHcnUAAAA=
X-Change-ID: 20260605-nf_flow_ip4_tunnel_proto-update-b31f7bff6fb9
To: Pablo Neira Ayuso <pablo@netfilter.org>, 
 Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
 netdev@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>
X-Mailer: b4 0.14.3

Add sanity check for iph->ihl field in nf_flow_ip4_tunnel_proto routine.
Moreover, similar to nf_flow_ip6_tunnel_proto(), rely on
skb_header_pointer() to validate skb header layout.

Fixes: ab427db178858 ("netfilter: flowtable: Add IPIP rx sw acceleration")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 net/netfilter/nf_flow_table_ip.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 9c05a50d6013..9684c19da37a 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -319,15 +319,17 @@ static unsigned int nf_flow_xmit_xfrm(struct sk_buff *skb,
 static bool nf_flow_ip4_tunnel_proto(struct nf_flowtable_ctx *ctx,
 				     struct sk_buff *skb)
 {
-	struct iphdr *iph;
+	struct iphdr *iph, _iph;
 	u16 size;
 
-	if (!pskb_may_pull(skb, sizeof(*iph) + ctx->offset))
+	iph = skb_header_pointer(skb, ctx->offset, sizeof(*iph), &_iph);
+	if (!iph)
 		return false;
 
-	iph = (struct iphdr *)(skb_network_header(skb) + ctx->offset);
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
base-commit: 4aacf509e537a711fa71bca9f234e5eb6968850e
change-id: 20260605-nf_flow_ip4_tunnel_proto-update-b31f7bff6fb9

Best regards,
-- 
Lorenzo Bianconi <lorenzo@kernel.org>

