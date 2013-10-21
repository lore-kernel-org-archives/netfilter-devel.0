From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftables] set_elem: fix access after free in case of parsing errors
Date: Mon, 21 Oct 2013 14:52:48 +0200
Message-ID: <1382359968-5345-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54396 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753331Ab3JUMw4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Oct 2013 08:52:56 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If this fails to parse a set element, stop the processing.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/set_elem.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/src/set_elem.c b/src/set_elem.c
index 5bb82f6..5ef46f2 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -298,8 +298,10 @@ static int nft_set_elems_parse2(struct nft_set *s, const struct nlattr *nest)
 			break;
 		}
         }
-	if (ret < 0)
+	if (ret < 0) {
 		xfree(e);
+		return -1;
+	}
 
 	/* Add this new element to this set */
 	list_add_tail(&e->head, &s->element_list);
-- 
1.7.10.4

