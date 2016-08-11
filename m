From: Phil Sutter <phil@nwl.cc>
Subject: [libnftnl PATCH 1/7] set: prevent memleak in nftnl_jansson_parse_set_info()
Date: Fri, 12 Aug 2016 01:33:33 +0200
Message-ID: <1470958419-32602-2-git-send-email-phil@nwl.cc>
References: <1470958419-32602-1-git-send-email-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org, Phil Sutter <psutter@redhat.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:50953 "EHLO mail.nwl.cc"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774AbcHKXeE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Aug 2016 19:34:04 -0400
In-Reply-To: <1470958419-32602-1-git-send-email-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Phil Sutter <psutter@redhat.com>

During list populating, in error case the function returns without
freeing the newly allocated 'elem' object, thereby losing any references
to it.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/set.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/src/set.c b/src/set.c
index 5f7245855db53..7a41e8caeb3c0 100644
--- a/src/set.c
+++ b/src/set.c
@@ -610,12 +610,12 @@ static int nftnl_jansson_parse_set_info(struct nftnl_set *s, json_t *tree,
 				return -1;
 
 			json_elem = json_array_get(array, i);
-			if (json_elem == NULL)
-				return -1;
-
-			if (nftnl_jansson_set_elem_parse(elem,
-						       json_elem, err) < 0)
+			if (json_elem == NULL ||
+			    nftnl_jansson_set_elem_parse(elem,
+							 json_elem, err) < 0) {
+				free(elem);
 				return -1;
+			}
 
 			list_add_tail(&elem->head, &s->element_list);
 		}
-- 
2.8.2

