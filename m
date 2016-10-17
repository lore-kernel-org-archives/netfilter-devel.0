From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl] set_elem: don't add NFTA_SET_ELEM_LIST_ELEMENTS attribute if set is empty
Date: Mon, 17 Oct 2016 17:53:04 +0200
Message-ID: <1476719584-19170-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52024 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964849AbcJQPxW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Oct 2016 11:53:22 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E137B1022A1
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2016 17:53:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D26CFDA841
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2016 17:53:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 94021DA841
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2016 17:53:12 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If the set is empty, don't send an empty NFTA_SET_ELEM_LIST_ELEMENTS
netlink attributes with no elements.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/set_elem.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/set_elem.c b/src/set_elem.c
index 46fb7c6e424b..4d2b4f6074b7 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -304,6 +304,9 @@ void nftnl_set_elems_nlmsg_build_payload(struct nlmsghdr *nlh, struct nftnl_set
 
 	nftnl_set_elem_nlmsg_build_def(nlh, s);
 
+	if (list_empty(&s->element_list))
+		return;
+
 	nest1 = mnl_attr_nest_start(nlh, NFTA_SET_ELEM_LIST_ELEMENTS);
 	list_for_each_entry(elem, &s->element_list, head)
 		nftnl_set_elem_build(nlh, elem, ++i);
-- 
2.1.4

