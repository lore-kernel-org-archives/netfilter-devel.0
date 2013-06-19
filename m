From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [PATCH] nft: loop optimization
Date: Wed, 19 Jun 2013 13:14:23 +0200
Message-ID: <20130619111423.7135.60976.stgit@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:32888 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933666Ab3FSLO0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Jun 2013 07:14:26 -0400
Received: by mail-we0-f178.google.com with SMTP id u53so4244381wes.23
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Jun 2013 04:14:24 -0700 (PDT)
Received: from [127.0.0.1] ([46.182.90.24])
        by mx.google.com with ESMTPSA id fv11sm8439498wic.11.2013.06.19.04.14.22
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Wed, 19 Jun 2013 04:14:23 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch prevent in some functions to continue looping after the chain is found.

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 iptables/nft.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index d51f2f3..42bf50f 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1275,6 +1275,8 @@ int nft_rule_flush(struct nft_handle *h, const char *chain, const char *table)
 
 		__nft_rule_flush(h, table_name, chain_name);
 
+		if (chain != NULL)
+			break;
 next:
 		c = nft_chain_list_iter_next(iter);
 	}
@@ -1390,6 +1392,9 @@ int nft_chain_user_del(struct nft_handle *h, const char *chain, const char *tabl
 			break;
 
 		deleted_ctr++;
+
+		if (chain != NULL)
+			break;
 next:
 		c = nft_chain_list_iter_next(iter);
 	}
@@ -2893,6 +2898,8 @@ int nft_chain_zero_counters(struct nft_handle *h, const char *chain,
 		if (ret < 0)
 			perror("mnl_talk:nft_chain_zero_counters");
 
+		if (chain != NULL)
+			break;
 next:
 		c = nft_chain_list_iter_next(iter);
 	}

