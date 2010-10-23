From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 08/13] attr: string functions should take char *
Date: Sat, 23 Oct 2010 07:44:45 +0200
Message-ID: <1287812691-14470-9-git-send-email-jengelh@medozas.de>
References: <1287812691-14470-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:55123 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580Ab0JWFpI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 Oct 2010 01:45:08 -0400
In-Reply-To: <1287812691-14470-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I do not quite see the point of using strlen in conjunction with
non-string data; so let's use char * as argument types to catch
misuses.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/libmnl/libmnl.h |    4 ++--
 src/attr.c              |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/libmnl/libmnl.h b/include/libmnl/libmnl.h
index 0442d05..a61a0b1 100644
--- a/include/libmnl/libmnl.h
+++ b/include/libmnl/libmnl.h
@@ -81,8 +81,8 @@ extern void mnl_attr_put_u8(struct nlmsghdr *nlh, uint16_t type, uint8_t data);
 extern void mnl_attr_put_u16(struct nlmsghdr *nlh, uint16_t type, uint16_t data);
 extern void mnl_attr_put_u32(struct nlmsghdr *nlh, uint16_t type, uint32_t data);
 extern void mnl_attr_put_u64(struct nlmsghdr *nlh, uint16_t type, uint64_t data);
-extern void mnl_attr_put_str(struct nlmsghdr *nlh, uint16_t type, const void *data);
-extern void mnl_attr_put_str_null(struct nlmsghdr *nlh, uint16_t type, const void *data);
+extern void mnl_attr_put_str(struct nlmsghdr *nlh, uint16_t type, const char *data);
+extern void mnl_attr_put_str_null(struct nlmsghdr *nlh, uint16_t type, const char *data);
 
 /* TLV attribute nesting */
 extern struct nlattr *mnl_attr_nest_start(struct nlmsghdr *nlh, uint16_t type);
diff --git a/src/attr.c b/src/attr.c
index f77f239..06d6367 100644
--- a/src/attr.c
+++ b/src/attr.c
@@ -443,7 +443,7 @@ void mnl_attr_put_u64(struct nlmsghdr *nlh, uint16_t type, uint64_t data)
  * This function updates the length field of the Netlink message (nlmsg_len)
  * by adding the size (header + payload) of the new attribute.
  */
-void mnl_attr_put_str(struct nlmsghdr *nlh, uint16_t type, const void *data)
+void mnl_attr_put_str(struct nlmsghdr *nlh, uint16_t type, const char *data)
 {
 	mnl_attr_put(nlh, type, strlen(data), data);
 }
@@ -460,7 +460,7 @@ void mnl_attr_put_str(struct nlmsghdr *nlh, uint16_t type, const void *data)
  * This function updates the length field of the Netlink message (nlmsg_len)
  * by adding the size (header + payload) of the new attribute.
  */
-void mnl_attr_put_str_null(struct nlmsghdr *nlh, uint16_t type, const void *data)
+void mnl_attr_put_str_null(struct nlmsghdr *nlh, uint16_t type, const char *data)
 {
 	mnl_attr_put(nlh, type, strlen(data)+1, data);
 }
-- 
1.7.1

