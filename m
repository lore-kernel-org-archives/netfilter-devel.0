From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH 1/3 libnftnl] chain: Fix bug. Check correct attribute
Date: Thu, 16 Jun 2016 12:20:10 +0200
Message-ID: <20160616102012.32036-1-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:45670 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690AbcFPKUX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jun 2016 06:20:23 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Carlos Falgueras Garc=C3=ADa <carlosfg@riseup.net>
---
 src/chain.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/chain.c b/src/chain.c
index f55dfa1..bfffbe0 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -219,7 +219,7 @@ int nftnl_chain_set_data(struct nftnl_chain *c, uin=
t16_t attr,
 			xfree(c->dev);
=20
 		c->dev =3D strdup(data);
-		if (!c->type)
+		if (!c->dev)
 			return -1;
 		break;
 	}
--=20
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
