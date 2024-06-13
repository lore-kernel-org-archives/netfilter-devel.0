Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B40B88526C;
	Thu, 13 Jun 2024 01:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718240563; cv=none; b=kCzluJCfrcrwj9fOc1+BAQAKn7h2mFJ9LUnZkRkUm2Fzks+mWREad1pxPKjg0uTKAs3B/IULmypHPtaoZjfqqFCkgZVvD3QCzsgjtDwsWDB8tqKoVPzdPgcC8sLK4TbG9M1X4q7/i3Gp4FvQLg4L0fLz+Lj6tXtZol//0qXh7BM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718240563; c=relaxed/simple;
	bh=qpnW9D4RiYGnTjcpZB7HIWdn3WKueaKgOosxQd7dihI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ALUNcRHw0CFfv1TMpGbW74HikiETO15ecH/jBAZRgE3eesnN2MS282jXMjQ7NU2JjP4WeUAVzJ52Y1kv6dKpNMCtmInsCtcCUEQ2CGwXLBiHjdfVTK1drBVUZUh2GgU7Fbx4CRyOrKNogWV/tWZHQuuY2qj+3dvBTfpO7kMYH3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,4.19.x 36/40] netfilter: nf_tables: allow NFPROTO_INET in nft_(match/target)_validate()
Date: Thu, 13 Jun 2024 03:02:05 +0200
Message-Id: <20240613010209.104423-37-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240613010209.104423-1-pablo@netfilter.org>
References: <20240613010209.104423-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ignat Korchagin <ignat@cloudflare.com>

[ Upstream commit 7e0f122c65912740327e4c54472acaa5f85868cb ]

Commit d0009effa886 ("netfilter: nf_tables: validate NFPROTO_* family") added
some validation of NFPROTO_* families in the nft_compat module, but it broke
the ability to use legacy iptables modules in dual-stack nftables.

While with legacy iptables one had to independently manage IPv4 and IPv6
tables, with nftables it is possible to have dual-stack tables sharing the
rules. Moreover, it was possible to use rules based on legacy iptables
match/target modules in dual-stack nftables.

As an example, the program from [2] creates an INET dual-stack family table
using an xt_bpf based rule, which looks like the following (the actual output
was generated with a patched nft tool as the current nft tool does not parse
dual stack tables with legacy match rules, so consider it for illustrative
purposes only):

table inet testfw {
  chain input {
    type filter hook prerouting priority filter; policy accept;
    bytecode counter packets 0 bytes 0 accept
  }
}

After d0009effa886 ("netfilter: nf_tables: validate NFPROTO_* family") we get
EOPNOTSUPP for the above program.

Fix this by allowing NFPROTO_INET for nft_(match/target)_validate(), but also
restrict the functions to classic iptables hooks.

Changes in v3:
  * clarify that upstream nft will not display such configuration properly and
    that the output was generated with a patched nft tool
  * remove example program from commit description and link to it instead
  * no code changes otherwise

Changes in v2:
  * restrict nft_(match/target)_validate() to classic iptables hooks
  * rewrite example program to use unmodified libnftnl

Fixes: d0009effa886 ("netfilter: nf_tables: validate NFPROTO_* family")
Link: https://lore.kernel.org/all/Zc1PfoWN38UuFJRI@calendula/T/#mc947262582c90fec044c7a3398cc92fac7afea72 [1]
Link: https://lore.kernel.org/all/20240220145509.53357-1-ignat@cloudflare.com/ [2]
Reported-by: Jordan Griege <jgriege@cloudflare.com>
Signed-off-by: Ignat Korchagin <ignat@cloudflare.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_compat.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 6b66518ef3f7..b2d9f794936e 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -321,10 +321,20 @@ static int nft_target_validate(const struct nft_ctx *ctx,
 
 	if (ctx->family != NFPROTO_IPV4 &&
 	    ctx->family != NFPROTO_IPV6 &&
+	    ctx->family != NFPROTO_INET &&
 	    ctx->family != NFPROTO_BRIDGE &&
 	    ctx->family != NFPROTO_ARP)
 		return -EOPNOTSUPP;
 
+	ret = nft_chain_validate_hooks(ctx->chain,
+				       (1 << NF_INET_PRE_ROUTING) |
+				       (1 << NF_INET_LOCAL_IN) |
+				       (1 << NF_INET_FORWARD) |
+				       (1 << NF_INET_LOCAL_OUT) |
+				       (1 << NF_INET_POST_ROUTING));
+	if (ret)
+		return ret;
+
 	if (nft_is_base_chain(ctx->chain)) {
 		const struct nft_base_chain *basechain =
 						nft_base_chain(ctx->chain);
@@ -568,10 +578,20 @@ static int nft_match_validate(const struct nft_ctx *ctx,
 
 	if (ctx->family != NFPROTO_IPV4 &&
 	    ctx->family != NFPROTO_IPV6 &&
+	    ctx->family != NFPROTO_INET &&
 	    ctx->family != NFPROTO_BRIDGE &&
 	    ctx->family != NFPROTO_ARP)
 		return -EOPNOTSUPP;
 
+	ret = nft_chain_validate_hooks(ctx->chain,
+				       (1 << NF_INET_PRE_ROUTING) |
+				       (1 << NF_INET_LOCAL_IN) |
+				       (1 << NF_INET_FORWARD) |
+				       (1 << NF_INET_LOCAL_OUT) |
+				       (1 << NF_INET_POST_ROUTING));
+	if (ret)
+		return ret;
+
 	if (nft_is_base_chain(ctx->chain)) {
 		const struct nft_base_chain *basechain =
 						nft_base_chain(ctx->chain);
-- 
2.30.2

