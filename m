From: Phil Sutter <phil@nwl.cc>
Subject: [libnftnl PATCH 5/6] src/set_elem: Don't return garbage in nftnl_set_elems_parse()
Date: Thu, 14 Dec 2017 20:40:24 +0100
Message-ID: <20171214194025.21334-6-phil@nwl.cc>
References: <20171214194025.21334-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:58082 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751952AbdLNTlD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 14 Dec 2017 14:41:03 -0500
In-Reply-To: <20171214194025.21334-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This might happen if netlink message is malformed (no nested attributes
are present), so treat this as an error and return -1 instead of
garbage to caller.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/set_elem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/set_elem.c b/src/set_elem.c
index e45dbc6bfe3e4..71c279a540860 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -490,7 +490,7 @@ nftnl_set_elem_list_parse_attr_cb(const struct nlattr *attr, void *data)
 static int nftnl_set_elems_parse(struct nftnl_set *s, const struct nlattr *nest)
 {
 	struct nlattr *attr;
-	int ret;
+	int ret = -1;
 
 	mnl_attr_for_each_nested(attr, nest) {
 		if (mnl_attr_get_type(attr) != NFTA_LIST_ELEM)
-- 
2.13.1

