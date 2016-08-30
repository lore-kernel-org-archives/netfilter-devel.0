From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl] set: fix incorrect maximum set description attribute
Date: Tue, 30 Aug 2016 20:05:02 +0200
Message-ID: <1472580302-4159-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43018 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751158AbcH3SFZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Aug 2016 14:05:25 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4FF8EC0B4A
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Aug 2016 20:05:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 420431B3344
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Aug 2016 20:05:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 569101B3555
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Aug 2016 20:05:17 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Maximum set description attribute is NFTA_SET_DESC_MAX, instead of
NFTA_SET_MAX.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/set.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/set.c b/src/set.c
index 47b6ef4..4581e3f 100644
--- a/src/set.c
+++ b/src/set.c
@@ -423,7 +423,7 @@ static int nftnl_set_desc_parse_attr_cb(const struct nlattr *attr, void *data)
 	const struct nlattr **tb = data;
 	int type = mnl_attr_get_type(attr);
 
-	if (mnl_attr_type_valid(attr, NFTA_SET_MAX) < 0)
+	if (mnl_attr_type_valid(attr, NFTA_SET_DESC_MAX) < 0)
 		return MNL_CB_OK;
 
 	switch (type) {
-- 
2.1.4

