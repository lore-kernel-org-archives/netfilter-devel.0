From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl] set_elem: add nft_set_elems_nlmsg_build_payload_iter()
Date: Wed, 23 Jul 2014 23:45:07 +0200
Message-ID: <1406151907-11282-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49238 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933386AbaGWVpE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jul 2014 17:45:04 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This new interface allows you to put as many set elements as possible
into a netlink message. The iterator stores the last element that has
fit into a netlink message, so you can continue adding more set elements
across several netlink messages.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/libnftnl/set.h |    3 ++
 src/libnftnl.map       |    4 +++
 src/set_elem.c         |   83 +++++++++++++++++++++++++++++++++++++++++-------
 3 files changed, 79 insertions(+), 11 deletions(-)

diff --git a/include/libnftnl/set.h b/include/libnftnl/set.h
index 4d08f16..4f2016d 100644
--- a/include/libnftnl/set.h
+++ b/include/libnftnl/set.h
@@ -121,4 +121,7 @@ struct nft_set_elem *nft_set_elems_iter_cur(struct nft_set_elems_iter *iter);
 struct nft_set_elem *nft_set_elems_iter_next(struct nft_set_elems_iter *iter);
 void nft_set_elems_iter_destroy(struct nft_set_elems_iter *iter);
 
+int nft_set_elems_nlmsg_build_payload_iter(struct nlmsghdr *nlh,
+					   struct nft_set_elems_iter *iter);
+
 #endif /* _LIBNFTNL_SET_H_ */
diff --git a/src/libnftnl.map b/src/libnftnl.map
index b11db67..e8c634f 100644
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -206,3 +206,7 @@ LIBNFTNL_1.1 {
   nft_set_attr_set_data;
   nft_set_attr_get_data;
 } LIBNFTNL_1.0;
+
+LIBNFTNL_1.2 {
+  nft_set_elems_nlmsg_build_payload_iter;
+} LIBNFTNL_1.1;
diff --git a/src/set_elem.c b/src/set_elem.c
index 197da73..93ecac6 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -197,27 +197,41 @@ void nft_set_elem_nlmsg_build_payload(struct nlmsghdr *nlh,
 	}
 }
 
-void nft_set_elems_nlmsg_build_payload(struct nlmsghdr *nlh, struct nft_set *s)
+static void nft_set_elem_nlmsg_build_def(struct nlmsghdr *nlh,
+					 struct nft_set *s)
 {
-	struct nft_set_elem *elem;
-	struct nlattr *nest1;
-	int i = 0;
-
 	if (s->flags & (1 << NFT_SET_ATTR_NAME))
 		mnl_attr_put_strz(nlh, NFTA_SET_ELEM_LIST_SET, s->name);
 	if (s->flags & (1 << NFT_SET_ATTR_ID))
 		mnl_attr_put_u32(nlh, NFTA_SET_ELEM_LIST_SET_ID, htonl(s->id));
 	if (s->flags & (1 << NFT_SET_ATTR_TABLE))
 		mnl_attr_put_strz(nlh, NFTA_SET_ELEM_LIST_TABLE, s->table);
+}
+
+static struct nlattr *nft_set_elem_attr_build(struct nlmsghdr *nlh,
+					      struct nft_set_elem *elem, int i)
+{
+	struct nlattr *nest2;
+
+	nest2 = mnl_attr_nest_start(nlh, i);
+	nft_set_elem_nlmsg_build_payload(nlh, elem);
+	mnl_attr_nest_end(nlh, nest2);
+
+	return nest2;
+}
+
+void nft_set_elems_nlmsg_build_payload(struct nlmsghdr *nlh, struct nft_set *s)
+{
+	struct nft_set_elem *elem;
+	struct nlattr *nest1;
+	int i = 0;
+
+	nft_set_elem_nlmsg_build_def(nlh, s);
 
 	nest1 = mnl_attr_nest_start(nlh, NFTA_SET_ELEM_LIST_ELEMENTS);
-	list_for_each_entry(elem, &s->element_list, head) {
-		struct nlattr *nest2;
+	list_for_each_entry(elem, &s->element_list, head)
+		nft_set_elem_attr_build(nlh, elem, ++i);
 
-		nest2 = mnl_attr_nest_start(nlh, ++i);
-		nft_set_elem_nlmsg_build_payload(nlh, elem);
-		mnl_attr_nest_end(nlh, nest2);
-	}
 	mnl_attr_nest_end(nlh, nest1);
 }
 EXPORT_SYMBOL(nft_set_elems_nlmsg_build_payload);
@@ -661,6 +675,7 @@ int nft_set_elem_foreach(struct nft_set *s,
 EXPORT_SYMBOL(nft_set_elem_foreach);
 
 struct nft_set_elems_iter {
+	struct nft_set			*set;
 	struct list_head		*list;
 	struct nft_set_elem		*cur;
 };
@@ -673,6 +688,7 @@ struct nft_set_elems_iter *nft_set_elems_iter_create(struct nft_set *s)
 	if (iter == NULL)
 		return NULL;
 
+	iter->set = s;
 	iter->list = &s->element_list;
 	iter->cur = list_entry(s->element_list.next, struct nft_set_elem, head);
 
@@ -703,3 +719,48 @@ void nft_set_elems_iter_destroy(struct nft_set_elems_iter *iter)
 	xfree(iter);
 }
 EXPORT_SYMBOL(nft_set_elems_iter_destroy);
+
+static bool nft_attr_nest_overflow(struct nlmsghdr *nlh,
+				   const struct nlattr *from,
+				   const struct nlattr *to)
+{
+	int len = (void *)to + to->nla_len - (void *)from;
+
+	/* The attribute length field is 16 bits long, thus the maximum payload
+	 * that an attribute can convey is UINT16_MAX. In case of overflow,
+	 * discard the last that did not fit into the attribute.
+	 */
+	if (len > UINT16_MAX) {
+		nlh->nlmsg_len -= to->nla_len;
+		return true;
+	}
+	return false;
+}
+
+int nft_set_elems_nlmsg_build_payload_iter(struct nlmsghdr *nlh,
+					   struct nft_set_elems_iter *iter)
+{
+	struct nft_set_elem *elem;
+	struct nlattr *nest1, *nest2;
+	int i = 0, ret = 0;
+
+	nft_set_elem_nlmsg_build_def(nlh, iter->set);
+
+	nest1 = mnl_attr_nest_start(nlh, NFTA_SET_ELEM_LIST_ELEMENTS);
+	elem = nft_set_elems_iter_next(iter);
+	while (elem != NULL) {
+		nest2 = nft_set_elem_attr_build(nlh, elem, ++i);
+		if (nft_attr_nest_overflow(nlh, nest1, nest2)) {
+			/* Go back to previous not to miss this element */
+			iter->cur = list_entry(iter->cur->head.prev,
+					       struct nft_set_elem, head);
+			ret = 1;
+			break;
+		}
+		elem = nft_set_elems_iter_next(iter);
+	}
+	mnl_attr_nest_end(nlh, nest1);
+
+	return ret;
+}
+EXPORT_SYMBOL(nft_set_elems_nlmsg_build_payload_iter);
-- 
1.7.10.4

