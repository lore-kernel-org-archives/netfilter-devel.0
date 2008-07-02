From: Jesper Dangaard Brouer <jdb@comx.dk>
Subject: [PATCH 1/2] Minor bugfix
Date: Wed, 02 Jul 2008 21:55:16 +0200
Message-ID: <1215028516.9467.2.camel@localhost.localdomain>
Reply-To: jdb@comx.dk
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>
To: Netfilter Developers <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from lanfw001a.cxnet.dk ([87.72.215.196]:33357 "EHLO
	lanfw001a.cxnet.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924AbYGBTzW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Jul 2008 15:55:22 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Minor bugfix, an extra check is needed if the tail element is a
builtin chain, as builtin chains are not sorted.

Signed-off-by: Jesper Dangaard Brouer <hawk@comx.dk>
---
 libiptc/libiptc.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
index d0f51b4..ec5317b 100644
--- a/libiptc/libiptc.c
+++ b/libiptc/libiptc.c
@@ -819,7 +819,8 @@ static void __iptcc_p_add_chain(TC_HANDLE_T h, struct chain_head *c,
 		list_add_tail(&c->list, &h->chains);
 	else {
 		ctail = list_entry(tail, struct chain_head, list);
-		if (strcmp(c->name, ctail->name) > 0)
+		if (strcmp(c->name, ctail->name) > 0 ||
+		    iptcc_is_builtin(ctail))
 			list_add_tail(&c->list, &h->chains);/* Already sorted*/
 		else
 			iptc_insert_chain(h, c);/* Was not sorted */
-- 
1.5.3


