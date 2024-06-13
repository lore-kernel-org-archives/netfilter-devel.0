Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A432254916;
	Thu, 13 Jun 2024 01:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718240556; cv=none; b=JJQR/kzfphkndzdHlvnZtACF6pjX9vXjcI4TxghFSaHNnzsCHUGlBqxiq9n7aGI/HOhXyHQI1fCGF+bfhD2jA9vKu4pzp15olcySQufxwpm32TsUrp1X0rfE+aCPvzA0vxtvJI07A4lIlaUbCLJrl1uBxXo/hibKAeAxDSrl32U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718240556; c=relaxed/simple;
	bh=D/35qoHg+afsM4ckBCpupXNi5mzxsh3ZUITiECP3n5w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=l3hvy1AyHLVfNmO58hcnu0n9lTqnRh+loxwGXS44KzWfNGpm5fpK2oCeq73C8DgR/DYk7uSoMj56O9dNT/dUGVkyffteeFuPQzCXtzXoWl1BTucceU5mM0mhby3Ut4tCBJABr2QZDALgrFnPHZN1oIcPzwdJLwOpyoMDX+0/leE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,4.19.x 25/40] netfilter: nf_tables: disable toggling dormant table state more than once
Date: Thu, 13 Jun 2024 03:01:54 +0200
Message-Id: <20240613010209.104423-26-pablo@netfilter.org>
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

commit c9bd26513b3a11b3adb3c2ed8a31a01a87173ff1 upstream.

nft -f -<<EOF
add table ip t
add table ip t { flags dormant; }
add chain ip t c { type filter hook input priority 0; }
add table ip t
EOF

Triggers a splat from nf core on next table delete because we lose
track of right hook register state:

WARNING: CPU: 2 PID: 1597 at net/netfilter/core.c:501 __nf_unregister_net_hook
RIP: 0010:__nf_unregister_net_hook+0x41b/0x570
 nf_unregister_net_hook+0xb4/0xf0
 __nf_tables_unregister_hook+0x160/0x1d0
[..]

The above should have table in *active* state, but in fact no
hooks were registered.

Reject on/off/on games rather than attempting to fix this.

Fixes: 179d9ba5559a ("netfilter: nf_tables: fix table flag updates")
Reported-by: "Lee, Cherie-Anne" <cherie.lee@starlabs.sg>
Cc: Bing-Jhong Billy Jheng <billy@starlabs.sg>
Cc: info@starlabs.sg
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f2d84621f6f9..d7993ac8222d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -893,6 +893,10 @@ static int nf_tables_updtable(struct nft_ctx *ctx)
 	if (flags == ctx->table->flags)
 		return 0;
 
+	/* No dormant off/on/off/on games in single transaction */
+	if (ctx->table->flags & __NFT_TABLE_F_UPDATE)
+		return -EINVAL;
+
 	trans = nft_trans_alloc(ctx, NFT_MSG_NEWTABLE,
 				sizeof(struct nft_trans_table));
 	if (trans == NULL)
-- 
2.30.2

