Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 515DA6AFAE;
	Thu, 13 Jun 2024 11:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279216; cv=none; b=oi4jno61HSmwXaO2oGih5hB+8oSE0ApbbkvKbyBPZVu1bDp+4bSB8aUvLkE1BWAeGNdypchvysvaBILXs5/WoI3EneAqCcFQ8dL73VTtADREXzVoeJxiQ8Haf5oir+B6HgaCSCtTu8/lc8bZk+E+qxXm31oVuA0LMVtFQqa+LSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279216; c=relaxed/simple;
	bh=1dKMl+MQeu+vS88q8H3Suq9gh5CfAGHOiU/wPx41slQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CXzgWzM7J6GUgkuM5GDWg8ydOgj/tktX2mP+0Jqp270eLvR/PVeMiTuhHTgCq5YQtxKhzwKLNzLDHm9QJG/lP1q1R0LxW2+ZdBGVaQQbMsD7YuKpGMpbbcA3GSxmkzVrRkFpxczrv9LFEVHI74zswUZwMwqh1n4w13QnDQsqnHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gbyu2le3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gbyu2le3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB128C2BBFC;
	Thu, 13 Jun 2024 11:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279216;
	bh=1dKMl+MQeu+vS88q8H3Suq9gh5CfAGHOiU/wPx41slQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gbyu2le3Xtj03BSnTP0Ad2AKMqs6ERXD5wqvHtO5OknZLdQCljX0rc+tGhHyhD+v9
	 /t3Ues+QZk501vBypXZtEdAW+aQ9EQw43YWljU1AwxD5lXSKS7YZsLvRST3iHqckx5
	 182wWDoOl8aipAubepBN6knuKH6cIPCdO8js54T8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lee, Cherie-Anne" <cherie.lee@starlabs.sg>,
	Bing-Jhong Billy Jheng <billy@starlabs.sg>,
	info@starlabs.sg,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 4.19 183/213] netfilter: nf_tables: disable toggling dormant table state more than once
Date: Thu, 13 Jun 2024 13:33:51 +0200
Message-ID: <20240613113235.041765697@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -893,6 +893,10 @@ static int nf_tables_updtable(struct nft
 	if (flags == ctx->table->flags)
 		return 0;
 
+	/* No dormant off/on/off/on games in single transaction */
+	if (ctx->table->flags & __NFT_TABLE_F_UPDATE)
+		return -EINVAL;
+
 	trans = nft_trans_alloc(ctx, NFT_MSG_NEWTABLE,
 				sizeof(struct nft_trans_table));
 	if (trans == NULL)


