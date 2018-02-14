From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl] set_elem: nftnl_set_elems_parse() returns 0 if set is empty
Date: Wed, 14 Feb 2018 20:13:05 +0100
Message-ID: <20180214191305.2201-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52864 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1162350AbeBNTNL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Feb 2018 14:13:11 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 60FFCDA848
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Feb 2018 20:13:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 52D8DDA727
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Feb 2018 20:13:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 58502DA727
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Feb 2018 20:13:08 +0100 (CET)
Received: from salvia.here (129.166.216.87.static.jazztel.es [87.216.166.129])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 1CB164265A2F
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Feb 2018 20:13:08 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Instead of -1, which results n misleading error propagate to the caller
with errno == 0 (success).

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/set_elem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/set_elem.c b/src/set_elem.c
index e02a38791c9a..1ac53dadbb75 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -490,7 +490,7 @@ nftnl_set_elem_list_parse_attr_cb(const struct nlattr *attr, void *data)
 static int nftnl_set_elems_parse(struct nftnl_set *s, const struct nlattr *nest)
 {
 	struct nlattr *attr;
-	int ret = -1;
+	int ret = 0;
 
 	mnl_attr_for_each_nested(attr, nest) {
 		if (mnl_attr_get_type(attr) != NFTA_LIST_ELEM)
-- 
2.11.0

