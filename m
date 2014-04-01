From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftnl PATCH] examples: complete nft-events example
Date: Tue, 01 Apr 2014 14:06:44 +0200
Message-ID: <20140401120643.4333.51861.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:51293 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751600AbaDAMGw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Apr 2014 08:06:52 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Complete nft-events example by adding a basic set & set_elem event
notification.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 examples/nft-events.c |   60 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/examples/nft-events.c b/examples/nft-events.c
index 150346a..989f4bd 100644
--- a/examples/nft-events.c
+++ b/examples/nft-events.c
@@ -21,6 +21,7 @@
 #include <libnftnl/table.h>
 #include <libnftnl/chain.h>
 #include <libnftnl/rule.h>
+#include <libnftnl/set.h>
 
 static int table_cb(const struct nlmsghdr *nlh, int type)
 {
@@ -97,6 +98,57 @@ err:
 	return MNL_CB_OK;
 }
 
+static int set_cb(const struct nlmsghdr *nlh, int type)
+{
+	struct nft_set *t;
+	char buf[4096];
+
+	t = nft_set_alloc();
+	if (t == NULL) {
+		perror("OOM");
+		goto err;
+	}
+
+	if (nft_set_nlmsg_parse(nlh, t) < 0) {
+		perror("nft_set_nlmsg_parse");
+		goto err_free;
+	}
+
+	nft_set_snprintf(buf, sizeof(buf), t, NFT_OUTPUT_DEFAULT, 0);
+	printf("[%s]\t%s\n", type == NFT_MSG_NEWSET ? "NEW" : "DEL", buf);
+
+err_free:
+	nft_set_free(t);
+err:
+	return MNL_CB_OK;
+}
+
+static int setelem_cb(const struct nlmsghdr *nlh, int type)
+{
+
+	struct nft_set *s;
+	char buf[4096];
+
+	s = nft_set_alloc();
+	if (s == NULL) {
+		perror("OOM");
+		goto err;
+	}
+
+	if (nft_set_elems_nlmsg_parse(nlh, s) < 0) {
+		perror("nft_set_nlmsg_parse");
+		goto err_free;
+	}
+
+	nft_set_snprintf(buf, sizeof(buf), s, NFT_OUTPUT_DEFAULT, 0);
+	printf("[%s]\t%s\n", type == NFT_MSG_NEWSETELEM ? "NEW" : "DEL", buf);
+
+err_free:
+	nft_set_free(s);
+err:
+	return MNL_CB_OK;
+}
+
 static int events_cb(const struct nlmsghdr *nlh, void *data)
 {
 	int ret = MNL_CB_OK;
@@ -115,6 +167,14 @@ static int events_cb(const struct nlmsghdr *nlh, void *data)
 	case NFT_MSG_DELRULE:
 		ret = rule_cb(nlh, type);
 		break;
+	case NFT_MSG_NEWSET:
+	case NFT_MSG_DELSET:
+		ret = set_cb(nlh, type);
+		break;
+	case NFT_MSG_NEWSETELEM:
+	case NFT_MSG_DELSETELEM:
+		ret = setelem_cb(nlh, type);
+		break;
 	}
 
 	return ret;

