From: Yuxuan Shui <yshuiv7@gmail.com>
Subject: [libnftnl RFC PATCH] set: Add nft_set_elems_nlmsg_build_payload_check
Date: Fri, 14 Mar 2014 13:33:52 +0000
Message-ID: <1394804032-6273-1-git-send-email-yshuiv7@gmail.com>
Cc: Yuxuan Shui <yshuiv7@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:39869 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198AbaCNNeL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 Mar 2014 09:34:11 -0400
Received: by mail-pb0-f41.google.com with SMTP id jt11so2618720pbb.14
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Mar 2014 06:34:11 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The new function is nft_set_elems_nlmsg_build_payload_check, which
checks if the buffer is large enough to hold the payload and returns
true on success. This function can be used to guard against buffer
overflow.
---
 include/libnftnl/set.h |  2 ++
 src/libnftnl.map       |  2 ++
 src/set_elem.c         | 73 ++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 77 insertions(+)

diff --git a/include/libnftnl/set.h b/include/libnftnl/set.h
index fcb1a7e..0eafc5b 100644
--- a/include/libnftnl/set.h
+++ b/include/libnftnl/set.h
@@ -104,6 +104,8 @@ bool nft_set_elem_attr_is_set(const struct nft_set_elem *s, uint16_t attr);
 #define nft_set_elem_nlmsg_build_hdr	nft_nlmsg_build_hdr
 void nft_set_elems_nlmsg_build_payload(struct nlmsghdr *nlh, struct nft_set *s);
 void nft_set_elem_nlmsg_build_payload(struct nlmsghdr *nlh, struct nft_set_elem *e);
+bool nft_set_elems_nlmsg_build_payload_check(struct nlmsghdr *nlh, size_t buflen, struct nft_set *s);
+bool nft_set_elem_nlmsg_build_payload_check(struct nlmsghdr *nlh, size_t buflen, struct nft_set_elem *e);
 
 int nft_set_elem_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_set_elem *s);
 
diff --git a/src/libnftnl.map b/src/libnftnl.map
index 7c4e6ca..746d0c7 100644
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -161,6 +161,7 @@ global:
   nft_set_elem_attr_get_str;
   nft_set_elem_attr_get_u32;
   nft_set_elem_nlmsg_build_payload;
+  nft_set_elem_nlmsg_build_payload_check;
   nft_set_elem_nlmsg_parse;
   nft_set_elem_parse;
   nft_set_elem_parse_file;
@@ -168,6 +169,7 @@ global:
   nft_set_elem_fprinf;
 
   nft_set_elems_nlmsg_build_payload;
+  nft_set_elems_nlmsg_build_payload_check;
   nft_set_elems_nlmsg_parse;
 
   nft_set_elems_foreach;
diff --git a/src/set_elem.c b/src/set_elem.c
index ff2c9d5..3b67265 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -191,6 +191,48 @@ void nft_set_elem_nlmsg_build_payload(struct nlmsghdr *nlh,
 	}
 }
 
+bool nft_set_elem_nlmsg_build_payload_check(struct nlmsghdr *nlh, size_t buflen,
+				      struct nft_set_elem *e)
+{
+	if (e->flags & (1 << NFT_SET_ELEM_ATTR_FLAGS))
+		if (!mnl_attr_put_u32_check(nlh, buflen, NFTA_SET_ELEM_FLAGS, htonl(e->set_elem_flags)))
+			return false;
+	if (e->flags & (1 << NFT_SET_ELEM_ATTR_KEY)) {
+		struct nlattr *nest1;
+
+		nest1 = mnl_attr_nest_start_check(nlh, buflen, NFTA_SET_ELEM_KEY);
+		if (nest1 == NULL ||
+		    !mnl_attr_put_check(nlh, buflen, NFTA_DATA_VALUE, e->key.len, e->key.val))
+			return false;
+		mnl_attr_nest_end(nlh, nest1);
+	}
+	if (e->flags & (1 << NFT_SET_ELEM_ATTR_VERDICT)) {
+		struct nlattr *nest1, *nest2;
+
+		nest1 = mnl_attr_nest_start(nlh, NFTA_SET_ELEM_DATA);
+		nest2 = mnl_attr_nest_start(nlh, NFTA_DATA_VERDICT);
+		if (nest1 == NULL || nest2 == NULL ||
+		    !mnl_attr_put_u32_check(nlh, buflen, NFTA_VERDICT_CODE, htonl(e->data.verdict)))
+			return false;
+		if (e->flags & (1 << NFT_SET_ELEM_ATTR_CHAIN))
+			if (!mnl_attr_put_strz_check(nlh, buflen, NFTA_VERDICT_CHAIN, e->data.chain))
+				return false;
+
+		mnl_attr_nest_end(nlh, nest1);
+		mnl_attr_nest_end(nlh, nest2);
+	}
+	if (e->flags & (1 << NFT_SET_ELEM_ATTR_DATA)) {
+		struct nlattr *nest1;
+
+		nest1 = mnl_attr_nest_start_check(nlh, buflen, NFTA_SET_ELEM_DATA);
+		if (nest1 == NULL ||
+		    !mnl_attr_put_check(nlh, buflen, NFTA_DATA_VALUE, e->data.len, e->data.val))
+			return false;
+		mnl_attr_nest_end(nlh, nest1);
+	}
+	return true;
+}
+
 void nft_set_elems_nlmsg_build_payload(struct nlmsghdr *nlh, struct nft_set *s)
 {
 	struct nft_set_elem *elem;
@@ -214,6 +256,37 @@ void nft_set_elems_nlmsg_build_payload(struct nlmsghdr *nlh, struct nft_set *s)
 }
 EXPORT_SYMBOL(nft_set_elems_nlmsg_build_payload);
 
+bool nft_set_elems_nlmsg_build_payload_check(struct nlmsghdr *nlh, size_t buflen, struct nft_set *s)
+{
+	struct nft_set_elem *elem;
+	struct nlattr *nest1;
+	int i = 0;
+	bool ret = true;
+
+	if (s->flags & (1 << NFT_SET_ATTR_NAME))
+		ret = ret && mnl_attr_put_strz_check(nlh, buflen, NFTA_SET_ELEM_LIST_SET, s->name);
+	if (s->flags & (1 << NFT_SET_ATTR_TABLE))
+		ret = ret && mnl_attr_put_strz_check(nlh, buflen, NFTA_SET_ELEM_LIST_TABLE, s->table);
+	if (!ret)
+		return false;
+
+	nest1 = mnl_attr_nest_start_check(nlh, buflen, NFTA_SET_ELEM_LIST_ELEMENTS);
+	if (nest1 == NULL)
+		return false;
+	list_for_each_entry(elem, &s->element_list, head) {
+		struct nlattr *nest2;
+
+		nest2 = mnl_attr_nest_start_check(nlh, buflen, ++i);
+		if (nest2 == NULL ||
+		    !nft_set_elem_nlmsg_build_payload_check(nlh, buflen, elem))
+			return false;
+		mnl_attr_nest_end(nlh, nest2);
+	}
+	mnl_attr_nest_end(nlh, nest1);
+	return true;
+}
+EXPORT_SYMBOL(nft_set_elems_nlmsg_build_payload_check);
+
 static int nft_set_elem_parse_attr_cb(const struct nlattr *attr, void *data)
 {
 	const struct nlattr **tb = data;
-- 
1.9.0

