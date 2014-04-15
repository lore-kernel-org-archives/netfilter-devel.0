From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftnl PATCH 2/2] examples: nft-events: use new events wrappers
Date: Tue, 15 Apr 2014 14:50:37 +0200
Message-ID: <20140415125036.2590.93069.stgit@nfdev.cica.es>
References: <20140415125030.2590.5501.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:54066 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754753AbaDOMup (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Apr 2014 08:50:45 -0400
In-Reply-To: <20140415125030.2590.5501.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Let's use the new event wrappers in the events example.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 examples/nft-events.c |   45 +++++++++++++++++++++++++++++++--------------
 1 file changed, 31 insertions(+), 14 deletions(-)

diff --git a/examples/nft-events.c b/examples/nft-events.c
index 989f4bd..6177f95 100644
--- a/examples/nft-events.c
+++ b/examples/nft-events.c
@@ -22,11 +22,31 @@
 #include <libnftnl/chain.h>
 #include <libnftnl/rule.h>
 #include <libnftnl/set.h>
+#include <libnftnl/common.h>
+
+static uint32_t event2flag(uint32_t event)
+{
+	switch (event) {
+	case NFT_MSG_NEWTABLE:
+	case NFT_MSG_NEWCHAIN:
+	case NFT_MSG_NEWRULE:
+	case NFT_MSG_NEWSET:
+	case NFT_MSG_NEWSETELEM:
+		return (1 << NFT_OUTPUT_FLAG_EVENTNEW);
+	case NFT_MSG_DELTABLE:
+	case NFT_MSG_DELCHAIN:
+	case NFT_MSG_DELRULE:
+	case NFT_MSG_DELSET:
+	case NFT_MSG_DELSETELEM:
+		return (1 << NFT_OUTPUT_FLAG_EVENTDEL);
+	}
+
+	return 0;
+}
 
 static int table_cb(const struct nlmsghdr *nlh, int type)
 {
 	struct nft_table *t;
-	char buf[4096];
 
 	t = nft_table_alloc();
 	if (t == NULL) {
@@ -39,8 +59,8 @@ static int table_cb(const struct nlmsghdr *nlh, int type)
 		goto err_free;
 	}
 
-	nft_table_snprintf(buf, sizeof(buf), t, NFT_OUTPUT_DEFAULT, 0);
-	printf("[%s]\t%s\n", type == NFT_MSG_NEWTABLE ? "NEW" : "DEL", buf);
+	nft_table_fprintf(stdout, t, NFT_OUTPUT_DEFAULT, event2flag(type));
+	fprintf(stdout, "\n");
 
 err_free:
 	nft_table_free(t);
@@ -51,7 +71,6 @@ err:
 static int rule_cb(const struct nlmsghdr *nlh, int type)
 {
 	struct nft_rule *t;
-	char buf[4096];
 
 	t = nft_rule_alloc();
 	if (t == NULL) {
@@ -64,8 +83,8 @@ static int rule_cb(const struct nlmsghdr *nlh, int type)
 		goto err_free;
 	}
 
-	nft_rule_snprintf(buf, sizeof(buf), t, NFT_OUTPUT_DEFAULT, 0);
-	printf("[%s]\t%s\n", type == NFT_MSG_NEWRULE ? "NEW" : "DEL", buf);
+	nft_rule_fprintf(stdout, t, NFT_OUTPUT_DEFAULT, event2flag(type));
+	fprintf(stdout, "\n");
 
 err_free:
 	nft_rule_free(t);
@@ -76,7 +95,6 @@ err:
 static int chain_cb(const struct nlmsghdr *nlh, int type)
 {
 	struct nft_chain *t;
-	char buf[4096];
 
 	t = nft_chain_alloc();
 	if (t == NULL) {
@@ -89,8 +107,8 @@ static int chain_cb(const struct nlmsghdr *nlh, int type)
 		goto err_free;
 	}
 
-	nft_chain_snprintf(buf, sizeof(buf), t, NFT_OUTPUT_DEFAULT, 0);
-	printf("[%s]\t%s\n", type == NFT_MSG_NEWCHAIN ? "NEW" : "DEL", buf);
+	nft_chain_fprintf(stdout, t, NFT_OUTPUT_DEFAULT, event2flag(type));
+	fprintf(stdout, "\n");
 
 err_free:
 	nft_chain_free(t);
@@ -114,8 +132,8 @@ static int set_cb(const struct nlmsghdr *nlh, int type)
 		goto err_free;
 	}
 
-	nft_set_snprintf(buf, sizeof(buf), t, NFT_OUTPUT_DEFAULT, 0);
-	printf("[%s]\t%s\n", type == NFT_MSG_NEWSET ? "NEW" : "DEL", buf);
+	nft_set_fprintf(stdout, t, NFT_OUTPUT_DEFAULT, event2flag(type));
+	fprintf(stdout, "\n");
 
 err_free:
 	nft_set_free(t);
@@ -127,7 +145,6 @@ static int setelem_cb(const struct nlmsghdr *nlh, int type)
 {
 
 	struct nft_set *s;
-	char buf[4096];
 
 	s = nft_set_alloc();
 	if (s == NULL) {
@@ -140,8 +157,8 @@ static int setelem_cb(const struct nlmsghdr *nlh, int type)
 		goto err_free;
 	}
 
-	nft_set_snprintf(buf, sizeof(buf), s, NFT_OUTPUT_DEFAULT, 0);
-	printf("[%s]\t%s\n", type == NFT_MSG_NEWSETELEM ? "NEW" : "DEL", buf);
+	nft_set_fprintf(stdout, s, NFT_OUTPUT_DEFAULT, event2flag(type));
+	fprintf(stdout, "\n");
 
 err_free:
 	nft_set_free(s);

