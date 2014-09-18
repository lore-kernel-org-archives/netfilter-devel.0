From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftnl 2/3] set: fix set nlmsg desc parsing
Date: Thu, 18 Sep 2014 20:18:19 +0200
Message-ID: <1411064300-4433-2-git-send-email-arturo.borrero.glez@gmail.com>
References: <1411064300-4433-1-git-send-email-arturo.borrero.glez@gmail.com>
Cc: pablo@netfilter.org, kaber@trash.net,
	Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:55925 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932117AbaIRSS7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Sep 2014 14:18:59 -0400
In-Reply-To: <1411064300-4433-1-git-send-email-arturo.borrero.glez@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In commit [ff62959](set: add support for set mechanism selection) the
support for parsing the nested attribute (NFTA_SET_DESC) was invalid.

This patch address the issue.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/set.c |   22 ++--------------------
 1 file changed, 2 insertions(+), 20 deletions(-)

diff --git a/src/set.c b/src/set.c
index 3c38334..223ddec 100644
--- a/src/set.c
+++ b/src/set.c
@@ -340,7 +340,7 @@ static int nft_set_desc_parse_attr_cb(const struct nlattr *attr, void *data)
 static int nft_set_desc_parse(struct nft_set *s,
 			      const struct nlattr *attr)
 {
-	struct nlattr *tb[NFTA_SET_MAX+1] = {};
+	struct nlattr *tb[NFTA_SET_DESC_MAX + 1] = {};
 
 	if (mnl_attr_parse_nested(attr, nft_set_desc_parse_attr_cb, tb) < 0)
 		return -1;
@@ -353,24 +353,6 @@ static int nft_set_desc_parse(struct nft_set *s,
 	return 0;
 }
 
-static int nft_set_nlmsg_desc_parse(const struct nlattr *nest,
-				    struct nft_set *s)
-{
-	struct nlattr *attr;
-	int ret = 0;
-
-	mnl_attr_for_each_nested(attr, nest) {
-		if (mnl_attr_get_type(attr) != NFTA_SET_DESC)
-			return -1;
-
-		ret = nft_set_desc_parse(s, attr);
-		if (ret != 0)
-			break;
-	}
-
-	return ret;
-}
-
 int nft_set_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_set *s)
 {
 	struct nlattr *tb[NFTA_SET_MAX+1] = {};
@@ -417,7 +399,7 @@ int nft_set_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_set *s)
 		s->flags |= (1 << NFT_SET_ATTR_POLICY);
 	}
 	if (tb[NFTA_SET_DESC])
-		ret = nft_set_nlmsg_desc_parse(tb[NFTA_SET_DESC], s);
+		ret = nft_set_desc_parse(s, tb[NFTA_SET_DESC]);
 
 	s->family = nfg->nfgen_family;
 	s->flags |= (1 << NFT_SET_ATTR_FAMILY);
-- 
1.7.10.4

