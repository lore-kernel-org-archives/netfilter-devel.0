From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH] libnftnl: set_elem: Fix memory leak
Date: Tue, 24 May 2016 17:17:07 +0200
Message-ID: <1464103027-18484-1-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:51768 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752428AbcEXPRV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2016 11:17:21 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

User data must be freed.

How to reproduce:
    > nft add table t
    > nft add set t s {type ipv4_addr\;}
    > valgrind nft add element t s {1.1.1.1}

Signed-off-by: Carlos Falgueras Garc=C3=ADa <carlosfg@riseup.net>
---
 src/set_elem.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/set_elem.c b/src/set_elem.c
index 353f21e..990be24 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -51,6 +51,9 @@ void nftnl_set_elem_free(struct nftnl_set_elem *s)
 	if (s->flags & (1 << NFTNL_SET_ELEM_EXPR))
 		nftnl_expr_free(s->expr);
=20
+	if (s->flags & (1 << NFTNL_SET_ELEM_USERDATA))
+		xfree(s->user.data);
+
 	xfree(s);
 }
 EXPORT_SYMBOL_ALIAS(nftnl_set_elem_free, nft_set_elem_free);
--=20
2.8.2

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
