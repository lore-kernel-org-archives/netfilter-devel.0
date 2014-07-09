From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft-sync PATCH] mnl: delete erroneous memory free
Date: Wed, 09 Jul 2014 10:11:38 +0200
Message-ID: <20140709081138.8507.44225.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:43276 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751351AbaGIILt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Jul 2014 04:11:49 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

That memory free is erroneus.

In case the server is going to dump the internal ruleset, if it the ruleset
contains sets then we get a segfault.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/mnl.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/src/mnl.c b/src/mnl.c
index bd2227b..3bb3ade 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -341,7 +341,6 @@ struct nft_ruleset *mnl_ruleset_dump(struct mnl_socket *nf_sock)
 			}
 
 			nft_set_list_merge(complete_set_list, s);
-			nft_set_list_free(s);
 		}
 		o = nft_table_list_iter_next(it);
 	}

