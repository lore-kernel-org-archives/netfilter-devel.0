From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [PATCH] nft: fix leak of iterators
Date: Wed, 05 Jun 2013 14:43:18 +0200
Message-ID: <20130605124318.4391.43073.stgit@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:61671 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449Ab3FEMnh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Jun 2013 08:43:37 -0400
Received: by mail-we0-f172.google.com with SMTP id q56so1253694wes.17
        for <netfilter-devel@vger.kernel.org>; Wed, 05 Jun 2013 05:43:35 -0700 (PDT)
Received: from [127.0.0.1] ([46.182.90.186])
        by mx.google.com with ESMTPSA id w8sm10871668wiz.0.2013.06.05.05.43.33
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Wed, 05 Jun 2013 05:43:35 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fix leak of iterators
Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 iptables/nft.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index c18999b..0ded02d 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1112,6 +1112,7 @@ next:
 		c = nft_chain_list_iter_next(iter);
 	}
 
+        nft_chain_list_iter_destroy(iter);
 	nft_chain_list_free(list);
 
 	return 1;
@@ -1200,6 +1201,7 @@ next:
 		r = nft_rule_list_iter_next(iter);
 	}
 
+        nft_chain_list_iter_destroy(list);
 	nft_rule_list_free(list);
 
 	/* the core expects 1 for success and 0 for error */
@@ -1278,6 +1280,7 @@ next:
 	}
 
 err:
+        nft_chain_list_iter_destroy(iter);
 	nft_chain_list_free(list);
 
 	/* the core expects 1 for success and 0 for error */
@@ -1391,6 +1394,7 @@ next:
 	}
 
 err:
+        nft_chain_list_iter_destroy(iter);
 	nft_chain_list_free(list);
 
 	/* chain not found */

