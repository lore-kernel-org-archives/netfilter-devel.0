From: kaber@trash.net
Subject: =?UTF-8?q?=5BPATCH=202/5=5D=20netfilter=3A=20nf=5Ftables=3A=20save=2048=20bits=20per=20rule?=
Date: Mon, 10 Dec 2012 18:20:09 +0100
Message-ID: <1355160012-13952-3-git-send-email-kaber@trash.net>
References: <1355160012-13952-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36282 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093Ab2LJRbl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Dec 2012 12:31:41 -0500
In-Reply-To: <1355160012-13952-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Patrick McHardy <kaber@trash.net>

We currently have a hole of 48 bits in the layout of struct nft_rule
because the increased handle size. Using 48 bits for the handle should
be enough to avoid overflow and allows to plug that hole.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/net/netfilter/nf_tables.h | 4 ++--
 1 Datei ge=C3=A4ndert, 2 Zeilen hinzugef=C3=BCgt(+), 2 Zeilen entfernt=
(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/=
nf_tables.h
index 2301b74..a3defd8 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -303,8 +303,8 @@ static inline void *nft_expr_priv(const struct nft_=
expr *expr)
 struct nft_rule {
 	struct list_head		list;
 	struct rcu_head			rcu_head;
-	u64				handle;
-	u16				dlen;
+	u64				handle:48,
+					dlen:16;
 	unsigned char			data[]
 		__attribute__((aligned(__alignof__(struct nft_expr))));
 };
--=20
1.7.11.7

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
