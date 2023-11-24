Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 358AD3173F;
	Fri, 24 Nov 2023 19:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BQb406v0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5DCCC433C7;
	Fri, 24 Nov 2023 19:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852965;
	bh=RjaRb+W5SYuOwF0oZG3ZyIIgiJRxB8ZvZTKXKnEZRZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BQb406v0+2jak0TUqFfLBIkQf/eUyJSAvGzrzpJoRl5v1iJR39RtxMOiz+GjmlUdZ
	 kKos+e/zJQptmvwrU+MAEsfrf0IHeqwKc4jdnHQZpPVQL/r8ZaVI6VTLivZvkQREhU
	 RwygjZHXV7SKt/qWEOJsLUgt81zKf7ahoxBViM8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lee, Cherie-Anne" <cherie.lee@starlabs.sg>,
	Bing-Jhong Billy Jheng <billy@starlabs.sg>,
	info@starlabs.sg,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 5.10 193/193] netfilter: nf_tables: disable toggling dormant table state more than once
Date: Fri, 24 Nov 2023 17:55:20 +0000
Message-ID: <20231124171954.906195817@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171947.127438872@linuxfoundation.org>
References: <20231124171947.127438872@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1099,6 +1099,10 @@ static int nf_tables_updtable(struct nft
 	if (flags == ctx->table->flags)
 		return 0;
 
+	/* No dormant off/on/off/on games in single transaction */
+	if (ctx->table->flags & __NFT_TABLE_F_UPDATE)
+		return -EINVAL;
+
 	trans = nft_trans_alloc(ctx, NFT_MSG_NEWTABLE,
 				sizeof(struct nft_trans_table));
 	if (trans == NULL)


