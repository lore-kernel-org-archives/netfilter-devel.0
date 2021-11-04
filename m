Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 218CCC433EF
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Nov 2021 21:38:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09D7161213
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Nov 2021 21:38:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232191AbhKDVle (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 4 Nov 2021 17:41:34 -0400
Received: from mail.netfilter.org ([217.70.188.207]:38488 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231643AbhKDVle (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 Nov 2021 17:41:34 -0400
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 7CD0060831
        for <netfilter-devel@vger.kernel.org>; Thu,  4 Nov 2021 22:36:58 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnftnl 1/2] set: expose nftnl_set_elem_nlmsg_build()
Date:   Thu,  4 Nov 2021 22:38:10 +0100
Message-Id: <20211104213811.366540-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Expose a function to build one single set element netlink message.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/libnftnl/set.h | 2 ++
 src/libnftnl.map       | 4 ++++
 src/set_elem.c         | 9 +++++----
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/include/libnftnl/set.h b/include/libnftnl/set.h
index 1eae024c8523..e2e5795aa9b4 100644
--- a/include/libnftnl/set.h
+++ b/include/libnftnl/set.h
@@ -144,6 +144,8 @@ bool nftnl_set_elem_is_set(const struct nftnl_set_elem *s, uint16_t attr);
 #define nftnl_set_elem_nlmsg_build_hdr	nftnl_nlmsg_build_hdr
 void nftnl_set_elems_nlmsg_build_payload(struct nlmsghdr *nlh, struct nftnl_set *s);
 void nftnl_set_elem_nlmsg_build_payload(struct nlmsghdr *nlh, struct nftnl_set_elem *e);
+struct nlattr *nftnl_set_elem_nlmsg_build(struct nlmsghdr *nlh,
+					  struct nftnl_set_elem *elem, int i);
 
 int nftnl_set_elem_parse(struct nftnl_set_elem *e, enum nftnl_parse_type type,
 		       const char *data, struct nftnl_parse_err *err);
diff --git a/src/libnftnl.map b/src/libnftnl.map
index e707b89cfdfd..ad8f2af060ae 100644
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -383,3 +383,7 @@ LIBNFTNL_16 {
   nftnl_expr_add_expr;
   nftnl_expr_expr_foreach;
 } LIBNFTNL_15;
+
+LIBNFTNL_17 {
+  nftnl_set_elem_nlmsg_build;
+} LIBNFTNL_16;
diff --git a/src/set_elem.c b/src/set_elem.c
index 90632a298312..edcc4a271b24 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -388,8 +388,9 @@ static void nftnl_set_elem_nlmsg_build_def(struct nlmsghdr *nlh,
 		mnl_attr_put_strz(nlh, NFTA_SET_ELEM_LIST_TABLE, s->table);
 }
 
-static struct nlattr *nftnl_set_elem_build(struct nlmsghdr *nlh,
-					      struct nftnl_set_elem *elem, int i)
+EXPORT_SYMBOL(nftnl_set_elem_nlmsg_build);
+struct nlattr *nftnl_set_elem_nlmsg_build(struct nlmsghdr *nlh,
+					  struct nftnl_set_elem *elem, int i)
 {
 	struct nlattr *nest2;
 
@@ -414,7 +415,7 @@ void nftnl_set_elems_nlmsg_build_payload(struct nlmsghdr *nlh, struct nftnl_set
 
 	nest1 = mnl_attr_nest_start(nlh, NFTA_SET_ELEM_LIST_ELEMENTS);
 	list_for_each_entry(elem, &s->element_list, head)
-		nftnl_set_elem_build(nlh, elem, ++i);
+		nftnl_set_elem_nlmsg_build(nlh, elem, ++i);
 
 	mnl_attr_nest_end(nlh, nest1);
 }
@@ -898,7 +899,7 @@ int nftnl_set_elems_nlmsg_build_payload_iter(struct nlmsghdr *nlh,
 	nest1 = mnl_attr_nest_start(nlh, NFTA_SET_ELEM_LIST_ELEMENTS);
 	elem = nftnl_set_elems_iter_next(iter);
 	while (elem != NULL) {
-		nest2 = nftnl_set_elem_build(nlh, elem, ++i);
+		nest2 = nftnl_set_elem_nlmsg_build(nlh, elem, ++i);
 		if (nftnl_attr_nest_overflow(nlh, nest1, nest2)) {
 			/* Go back to previous not to miss this element */
 			iter->cur = list_entry(iter->cur->head.prev,
-- 
2.30.2

