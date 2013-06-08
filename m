From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [PATCH v2] nft: fix leak of iterators
Date: Sat, 08 Jun 2013 14:24:35 +0200
Message-ID: <20130608122435.4354.49219.stgit@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:56347 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab3FHMYt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 8 Jun 2013 08:24:49 -0400
Received: by mail-wg0-f44.google.com with SMTP id m15so2700759wgh.11
        for <netfilter-devel@vger.kernel.org>; Sat, 08 Jun 2013 05:24:47 -0700 (PDT)
Received: from [127.0.0.1] ([46.182.90.145])
        by mx.google.com with ESMTPSA id eq15sm2084352wic.4.2013.06.08.05.24.45
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Sat, 08 Jun 2013 05:24:47 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fix leak of iterators
Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 iptables/nft.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index c18999b..5a0b814 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1112,6 +1112,7 @@ next:
 		c = nft_chain_list_iter_next(iter);
 	}
 
+	nft_chain_list_iter_destroy(iter);
 	nft_chain_list_free(list);
 
 	return 1;
@@ -1200,6 +1201,7 @@ next:
 		r = nft_rule_list_iter_next(iter);
 	}
 
+	nft_rule_list_iter_destroy(iter);
 	nft_rule_list_free(list);
 
 	/* the core expects 1 for success and 0 for error */
@@ -1276,6 +1278,8 @@ int nft_rule_flush(struct nft_handle *h, const char *chain, const char *table)
 next:
 		c = nft_chain_list_iter_next(iter);
 	}
+	
+	nft_chain_list_iter_destroy(iter);
 
 err:
 	nft_chain_list_free(list);
@@ -1390,6 +1394,8 @@ next:
 		c = nft_chain_list_iter_next(iter);
 	}
 
+	nft_chain_list_iter_destroy(iter);
+
 err:
 	nft_chain_list_free(list);
 

