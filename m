From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftnl PATCH 2/2] examples: nft-events: use new events wrappers
Date: Tue, 15 Apr 2014 11:40:35 +0200
Message-ID: <20140415094035.23739.59645.stgit@nfdev.cica.es>
References: <20140415094030.23739.71580.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:60772 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750899AbaDOJkn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Apr 2014 05:40:43 -0400
In-Reply-To: <20140415094030.23739.71580.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Let's use the new event wrappers in the events example.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 examples/nft-events.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/examples/nft-events.c b/examples/nft-events.c
index 989f4bd..9d33295 100644
--- a/examples/nft-events.c
+++ b/examples/nft-events.c
@@ -22,6 +22,7 @@
 #include <libnftnl/chain.h>
 #include <libnftnl/rule.h>
 #include <libnftnl/set.h>
+#include <libnftnl/common.h>
 
 static int table_cb(const struct nlmsghdr *nlh, int type)
 {
@@ -40,7 +41,8 @@ static int table_cb(const struct nlmsghdr *nlh, int type)
 	}
 
 	nft_table_snprintf(buf, sizeof(buf), t, NFT_OUTPUT_DEFAULT, 0);
-	printf("[%s]\t%s\n", type == NFT_MSG_NEWTABLE ? "NEW" : "DEL", buf);
+	nft_event_fprintf(stdout, buf, NFT_OUTPUT_DEFAULT, type);
+	fprintf(stdout, "\n");
 
 err_free:
 	nft_table_free(t);
@@ -65,7 +67,8 @@ static int rule_cb(const struct nlmsghdr *nlh, int type)
 	}
 
 	nft_rule_snprintf(buf, sizeof(buf), t, NFT_OUTPUT_DEFAULT, 0);
-	printf("[%s]\t%s\n", type == NFT_MSG_NEWRULE ? "NEW" : "DEL", buf);
+	nft_event_fprintf(stdout, buf, NFT_OUTPUT_DEFAULT, type);
+	fprintf(stdout, "\n");
 
 err_free:
 	nft_rule_free(t);
@@ -90,7 +93,8 @@ static int chain_cb(const struct nlmsghdr *nlh, int type)
 	}
 
 	nft_chain_snprintf(buf, sizeof(buf), t, NFT_OUTPUT_DEFAULT, 0);
-	printf("[%s]\t%s\n", type == NFT_MSG_NEWCHAIN ? "NEW" : "DEL", buf);
+	nft_event_fprintf(stdout, buf, NFT_OUTPUT_DEFAULT, type);
+	fprintf(stdout, "\n");
 
 err_free:
 	nft_chain_free(t);
@@ -115,7 +119,8 @@ static int set_cb(const struct nlmsghdr *nlh, int type)
 	}
 
 	nft_set_snprintf(buf, sizeof(buf), t, NFT_OUTPUT_DEFAULT, 0);
-	printf("[%s]\t%s\n", type == NFT_MSG_NEWSET ? "NEW" : "DEL", buf);
+	nft_event_fprintf(stdout, buf, NFT_OUTPUT_DEFAULT, type);
+	fprintf(stdout, "\n");
 
 err_free:
 	nft_set_free(t);
@@ -141,7 +146,8 @@ static int setelem_cb(const struct nlmsghdr *nlh, int type)
 	}
 
 	nft_set_snprintf(buf, sizeof(buf), s, NFT_OUTPUT_DEFAULT, 0);
-	printf("[%s]\t%s\n", type == NFT_MSG_NEWSETELEM ? "NEW" : "DEL", buf);
+	nft_event_fprintf(stdout, buf, NFT_OUTPUT_DEFAULT, type);
+	fprintf(stdout, "\n");
 
 err_free:
 	nft_set_free(s);

