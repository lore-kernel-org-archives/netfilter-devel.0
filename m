From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/5] nlmsg: use bool for all _ok functions
Date: Thu, 11 Nov 2010 00:08:02 +0100
Message-ID: <1289430485-16467-4-git-send-email-jengelh@medozas.de>
References: <1289430485-16467-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:56314 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757270Ab0KJXIK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Nov 2010 18:08:10 -0500
In-Reply-To: <1289430485-16467-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/libmnl/libmnl.h |    4 ++--
 src/attr.c              |    2 +-
 src/nlmsg.c             |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/libmnl/libmnl.h b/include/libmnl/libmnl.h
index 37c502a..43388e5 100644
--- a/include/libmnl/libmnl.h
+++ b/include/libmnl/libmnl.h
@@ -52,7 +52,7 @@ extern struct nlmsghdr *mnl_nlmsg_put_header(void *buf);
 extern void *mnl_nlmsg_put_extra_header(struct nlmsghdr *nlh, size_t size);
 
 /* Netlink message iterators */
-extern int mnl_nlmsg_ok(const struct nlmsghdr *nlh, int len);
+extern bool mnl_nlmsg_ok(const struct nlmsghdr *nlh, int len);
 extern struct nlmsghdr *mnl_nlmsg_next(const struct nlmsghdr *nlh, int *len);
 
 /* Netlink sequence tracking */
@@ -121,7 +121,7 @@ extern int mnl_attr_validate(const struct nlattr *attr, enum mnl_attr_data_type
 extern int mnl_attr_validate2(const struct nlattr *attr, enum mnl_attr_data_type type, size_t len);
 
 /* TLV iterators */
-extern int mnl_attr_ok(const struct nlattr *attr, int len);
+extern bool mnl_attr_ok(const struct nlattr *attr, int len);
 extern struct nlattr *mnl_attr_next(const struct nlattr *attr, int *len);
 
 #define mnl_attr_for_each(attr, nlh, offset)			\
diff --git a/src/attr.c b/src/attr.c
index c60e1f4..69fda0b 100644
--- a/src/attr.c
+++ b/src/attr.c
@@ -90,7 +90,7 @@ void *mnl_attr_get_payload(const struct nlattr *attr)
  * The len parameter may be negative in the case of malformed messages during
  * attribute iteration, that is why we use a signed integer.
  */
-int mnl_attr_ok(const struct nlattr *attr, int len)
+bool mnl_attr_ok(const struct nlattr *attr, int len)
 {
 	return len >= (int)sizeof(struct nlattr) &&
 	       attr->nla_len >= sizeof(struct nlattr) &&
diff --git a/src/nlmsg.c b/src/nlmsg.c
index f89a9ec..b5c5c29 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -156,7 +156,7 @@ void *mnl_nlmsg_get_payload_offset(const struct nlmsghdr *nlh, size_t offset)
  * The len parameter may become negative in malformed messages during message
  * iteration, that is why we use a signed integer.
  */
-int mnl_nlmsg_ok(const struct nlmsghdr *nlh, int len)
+bool mnl_nlmsg_ok(const struct nlmsghdr *nlh, int len)
 {
 	return len >= (int)sizeof(struct nlmsghdr) &&
 	       nlh->nlmsg_len >= sizeof(struct nlmsghdr) &&
-- 
1.7.1

