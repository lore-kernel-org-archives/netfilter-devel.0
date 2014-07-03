From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftnl PATCH] set_elem: use proper free function
Date: Thu, 03 Jul 2014 18:04:21 +0200
Message-ID: <20140703160421.13770.955.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:49823 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756403AbaGCQEd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Jul 2014 12:04:33 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Let's use the proper free function to liberate the set_elem,
so we avoid potential memory leaks.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/set_elem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/set_elem.c b/src/set_elem.c
index 3b27317..9e3c55f 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -290,7 +290,7 @@ static int nft_set_elems_parse2(struct nft_set *s, const struct nlattr *nest)
 		}
         }
 	if (ret < 0) {
-		xfree(e);
+		nft_set_elem_free(e);
 		return -1;
 	}
 

