From: Eric Leblond <eric@regit.org>
Subject: [libnftables PATCH 2/3] nft-events: add newline to output
Date: Tue,  4 Jun 2013 10:05:22 +0200
Message-ID: <1370333124-11674-3-git-send-email-eric@regit.org>
References: <1370333124-11674-1-git-send-email-eric@regit.org>
Cc: Eric Leblond <eric@regit.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:50701 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab3FDIFn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Jun 2013 04:05:43 -0400
In-Reply-To: <1370333124-11674-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds a new line to messages to be sure that they are
printed to the shell as soon as they occur. This also fixes the
display of output.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 examples/nft-events.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/examples/nft-events.c b/examples/nft-events.c
index aa8c85e..5550c70 100644
--- a/examples/nft-events.c
+++ b/examples/nft-events.c
@@ -39,7 +39,7 @@ static int table_cb(const struct nlmsghdr *nlh, int type)
 	}
 
 	nft_table_snprintf(buf, sizeof(buf), t, NFT_TABLE_O_DEFAULT, 0);
-	printf("[%s]\t%s", type == NFT_MSG_NEWTABLE ? "NEW" : "DEL", buf);
+	printf("[%s]\t%s\n", type == NFT_MSG_NEWTABLE ? "NEW" : "DEL", buf);
 
 err_free:
 	nft_table_free(t);
@@ -64,7 +64,7 @@ static int rule_cb(const struct nlmsghdr *nlh, int type)
 	}
 
 	nft_rule_snprintf(buf, sizeof(buf), t, NFT_RULE_O_DEFAULT, 0);
-	printf("[%s]\t%s", type == NFT_MSG_NEWRULE ? "NEW" : "DEL", buf);
+	printf("[%s]\t%s\n", type == NFT_MSG_NEWRULE ? "NEW" : "DEL", buf);
 
 err_free:
 	nft_rule_free(t);
@@ -89,7 +89,7 @@ static int chain_cb(const struct nlmsghdr *nlh, int type)
 	}
 
 	nft_chain_snprintf(buf, sizeof(buf), t, NFT_CHAIN_O_DEFAULT, 0);
-	printf("[%s]\t%s", type == NFT_MSG_NEWCHAIN ? "NEW" : "DEL", buf);
+	printf("[%s]\t%s\n", type == NFT_MSG_NEWCHAIN ? "NEW" : "DEL", buf);
 
 err_free:
 	nft_chain_free(t);
-- 
1.7.10.4

