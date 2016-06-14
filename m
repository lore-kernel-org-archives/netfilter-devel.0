From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl 5/9] expr: data_reg: get rid of leftover perror() calls
Date: Tue, 14 Jun 2016 15:18:41 +0200
Message-ID: <1465910325-13286-5-git-send-email-pablo@netfilter.org>
References: <1465910325-13286-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55945 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647AbcFNNS5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Jun 2016 09:18:57 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 5093BE7DBD
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jun 2016 15:18:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 40E309EBA7
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jun 2016 15:18:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 37F479EBA7
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jun 2016 15:18:54 +0200 (CEST)
In-Reply-To: <1465910325-13286-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Let the client of this library decide when to display error messages.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/expr/data_reg.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index 6aa47bc..688823b 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -428,10 +428,8 @@ nftnl_parse_verdict(union nftnl_data_reg *data, const struct nlattr *attr, int *
 {
 	struct nlattr *tb[NFTA_VERDICT_MAX+1];
 
-	if (mnl_attr_parse_nested(attr, nftnl_verdict_parse_cb, tb) < 0) {
-		perror("mnl_attr_parse_nested");
+	if (mnl_attr_parse_nested(attr, nftnl_verdict_parse_cb, tb) < 0)
 		return -1;
-	}
 
 	if (!tb[NFTA_VERDICT_CODE])
 		return -1;
@@ -491,10 +489,9 @@ int nftnl_parse_data(union nftnl_data_reg *data, struct nlattr *attr, int *type)
 	struct nlattr *tb[NFTA_DATA_MAX+1] = {};
 	int ret = 0;
 
-	if (mnl_attr_parse_nested(attr, nftnl_data_parse_cb, tb) < 0) {
-		perror("mnl_attr_parse_nested");
+	if (mnl_attr_parse_nested(attr, nftnl_data_parse_cb, tb) < 0)
 		return -1;
-	}
+
 	if (tb[NFTA_DATA_VALUE]) {
 		if (type)
 			*type = DATA_VALUE;
-- 
2.1.4

