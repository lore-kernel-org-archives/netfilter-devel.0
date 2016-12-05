From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl] set_elem: nftnl_set_elems_nlmsg_build_payload_iter()
Date: Mon,  5 Dec 2016 23:36:31 +0100
Message-ID: <1480977391-14941-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53938 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751311AbcLEWgx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Dec 2016 17:36:53 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 35B881DF5BD
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Dec 2016 23:36:52 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 281E8DA841
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Dec 2016 23:36:52 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 379F2DA841
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Dec 2016 23:36:50 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Similar to a24e4b21ee33 ("set_elem: don't add NFTA_SET_ELEM_LIST_ELEMENTS
attribute if set is empty"). This is required by the set flush support.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/set_elem.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/src/set_elem.c b/src/set_elem.c
index 4d2b4f6074b7..083c597e2f8e 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -813,6 +813,10 @@ int nftnl_set_elems_nlmsg_build_payload_iter(struct nlmsghdr *nlh,
 
 	nftnl_set_elem_nlmsg_build_def(nlh, iter->set);
 
+	/* This set is empty, don't add an empty list element nest. */
+	if (list_empty(&iter->set->element_list))
+		return ret;
+
 	nest1 = mnl_attr_nest_start(nlh, NFTA_SET_ELEM_LIST_ELEMENTS);
 	elem = nftnl_set_elems_iter_next(iter);
 	while (elem != NULL) {
-- 
2.1.4

