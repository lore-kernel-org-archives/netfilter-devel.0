From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftnl PATCH] set_elems: delete void EXPORT_SYMBOL
Date: Wed, 19 Mar 2014 17:53:26 +0100
Message-ID: <20140319165326.3656.88730.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:37917 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755729AbaCSQxg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Mar 2014 12:53:36 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

There is no function called 'nft_set_elem_nlmsg_parse()'.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 include/libnftnl/set.h |    2 --
 src/libnftnl.map       |    1 -
 src/set_elem.c         |    1 -
 3 files changed, 4 deletions(-)

diff --git a/include/libnftnl/set.h b/include/libnftnl/set.h
index fcb1a7e..a975f1c 100644
--- a/include/libnftnl/set.h
+++ b/include/libnftnl/set.h
@@ -105,8 +105,6 @@ bool nft_set_elem_attr_is_set(const struct nft_set_elem *s, uint16_t attr);
 void nft_set_elems_nlmsg_build_payload(struct nlmsghdr *nlh, struct nft_set *s);
 void nft_set_elem_nlmsg_build_payload(struct nlmsghdr *nlh, struct nft_set_elem *e);
 
-int nft_set_elem_nlmsg_parse(const struct nlmsghdr *nlh, struct nft_set_elem *s);
-
 int nft_set_elem_parse(struct nft_set_elem *e, enum nft_parse_type type,
 		       const char *data, struct nft_parse_err *err);
 int nft_set_elem_parse_file(struct nft_set_elem *e, enum nft_parse_type type,
diff --git a/src/libnftnl.map b/src/libnftnl.map
index 7c4e6ca..b11db67 100644
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -161,7 +161,6 @@ global:
   nft_set_elem_attr_get_str;
   nft_set_elem_attr_get_u32;
   nft_set_elem_nlmsg_build_payload;
-  nft_set_elem_nlmsg_parse;
   nft_set_elem_parse;
   nft_set_elem_parse_file;
   nft_set_elem_snprintf;
diff --git a/src/set_elem.c b/src/set_elem.c
index ff2c9d5..b71a916 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -291,7 +291,6 @@ static int nft_set_elems_parse2(struct nft_set *s, const struct nlattr *nest)
 
 	return ret;
 }
-EXPORT_SYMBOL(nft_set_elem_nlmsg_parse);
 
 static int
 nft_set_elem_list_parse_attr_cb(const struct nlattr *attr, void *data)

