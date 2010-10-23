From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 13/13] attr: rename str_null from NULL away
Date: Sat, 23 Oct 2010 07:44:50 +0200
Message-ID: <1287812691-14470-14-git-send-email-jengelh@medozas.de>
References: <1287812691-14470-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:55129 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752794Ab0JWFpN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 Oct 2010 01:45:13 -0400
In-Reply-To: <1287812691-14470-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

A small little pedantism: NULL (as in, the pointer) isn't NUL (as in,
the character with value zero, '\0'). I propose to rename it to strz,
for the zero-terminated string (sometimes referred to as ASCIZ string,
but of course C isn't tied to ASCII).

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 examples/genl/genl-family-get.c |    2 +-
 include/libmnl/libmnl.h         |    2 +-
 src/attr.c                      |    8 ++++----
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/examples/genl/genl-family-get.c b/examples/genl/genl-family-get.c
index b015466..be8da3c 100644
--- a/examples/genl/genl-family-get.c
+++ b/examples/genl/genl-family-get.c
@@ -204,7 +204,7 @@ int main(int argc, char *argv[])
 	genl->version = 1;
 
 	mnl_attr_put_u32(nlh, CTRL_ATTR_FAMILY_ID, GENL_ID_CTRL);
-	mnl_attr_put_str_null(nlh, CTRL_ATTR_FAMILY_NAME, argv[1]);
+	mnl_attr_put_strz(nlh, CTRL_ATTR_FAMILY_NAME, argv[1]);
 
 	nl = mnl_socket_open(NETLINK_GENERIC);
 	if (nl == NULL) {
diff --git a/include/libmnl/libmnl.h b/include/libmnl/libmnl.h
index a32fb1d..7094af2 100644
--- a/include/libmnl/libmnl.h
+++ b/include/libmnl/libmnl.h
@@ -89,7 +89,7 @@ extern void mnl_attr_put_u16(struct nlmsghdr *nlh, uint16_t type, uint16_t data)
 extern void mnl_attr_put_u32(struct nlmsghdr *nlh, uint16_t type, uint32_t data);
 extern void mnl_attr_put_u64(struct nlmsghdr *nlh, uint16_t type, uint64_t data);
 extern void mnl_attr_put_str(struct nlmsghdr *nlh, uint16_t type, const char *data);
-extern void mnl_attr_put_str_null(struct nlmsghdr *nlh, uint16_t type, const char *data);
+extern void mnl_attr_put_strz(struct nlmsghdr *nlh, uint16_t type, const char *data);
 
 /* TLV attribute nesting */
 extern struct nlattr *mnl_attr_nest_start(struct nlmsghdr *nlh, uint16_t type);
diff --git a/src/attr.c b/src/attr.c
index 06d6367..c60e1f4 100644
--- a/src/attr.c
+++ b/src/attr.c
@@ -449,18 +449,18 @@ void mnl_attr_put_str(struct nlmsghdr *nlh, uint16_t type, const char *data)
 }
 
 /**
- * mnl_attr_put_str_null - add string attribute to netlink message
+ * mnl_attr_put_strz - add string attribute to netlink message
  * \param nlh pointer to the netlink message
  * \param type netlink attribute type
  * \param data pointer to string data that is stored by the new attribute
  *
- * This function is similar to mnl_attr_put_str, but it includes the NUL
- * terminator at the end of the string.
+ * This function is similar to mnl_attr_put_str, but it includes the
+ * NUL/zero ('\0') terminator at the end of the string.
  *
  * This function updates the length field of the Netlink message (nlmsg_len)
  * by adding the size (header + payload) of the new attribute.
  */
-void mnl_attr_put_str_null(struct nlmsghdr *nlh, uint16_t type, const char *data)
+void mnl_attr_put_strz(struct nlmsghdr *nlh, uint16_t type, const char *data)
 {
 	mnl_attr_put(nlh, type, strlen(data)+1, data);
 }
-- 
1.7.1

