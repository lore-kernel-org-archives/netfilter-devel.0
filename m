From: kaber@trash.net
Subject: =?UTF-8?q?=5BPATCH=203/5=5D=20netfilter=3A=20nf=5Ftables=3A=20destroy=20anonymous=20sets=20immediately=20if=20binding=20fails?=
Date: Mon, 10 Dec 2012 18:20:10 +0100
Message-ID: <1355160012-13952-4-git-send-email-kaber@trash.net>
References: <1355160012-13952-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36284 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337Ab2LJRbl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Dec 2012 12:31:41 -0500
In-Reply-To: <1355160012-13952-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Patrick McHardy <kaber@trash.net>

Treat a failed binding similar to binding+unbinding and destroy the
set immediately to avoid leaving stray sets in the table.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 net/netfilter/nf_tables_api.c | 10 +++++++++-
 1 Datei ge=C3=A4ndert, 9 Zeilen hinzugef=C3=BCgt(+), 1 Zeile entfernt(=
-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_ap=
i.c
index 570b877..c0f0cf06e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1980,6 +1980,9 @@ int nf_tables_bind_set(const struct nft_ctx *ctx,=
 struct nft_set *set,
 {
 	struct nft_set_bind_check_args args;
=20
+	if (!list_empty(&set->bindings) && set->flags & NFT_SET_ANONYMOUS)
+		return -EBUSY;
+
 	if (set->flags & NFT_SET_MAP) {
 		args.iter.skip 	=3D 0;
 		args.iter.count	=3D 0;
@@ -1988,8 +1991,13 @@ int nf_tables_bind_set(const struct nft_ctx *ctx=
, struct nft_set *set,
 		args.ctx	=3D ctx;
=20
 		set->ops->walk(set, &args.iter);
-		if (args.iter.err < 0)
+		if (args.iter.err < 0) {
+			/* Destroy anonymous sets if binding fails */
+			if (set->flags & NFT_SET_ANONYMOUS)
+				nf_tables_set_destroy(ctx, set);
+
 			return args.iter.err;
+		}
 	}
=20
 	binding->chain =3D ctx->chain;
--=20
1.7.11.7

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
