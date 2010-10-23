From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 12/13] nlmsg: use bool return type for yes-no functions
Date: Sat, 23 Oct 2010 07:44:49 +0200
Message-ID: <1287812691-14470-13-git-send-email-jengelh@medozas.de>
References: <1287812691-14470-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:55132 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580Ab0JWFpM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 Oct 2010 01:45:12 -0400
In-Reply-To: <1287812691-14470-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/libmnl/libmnl.h |    7 +++++--
 src/nlmsg.c             |   18 +++++++++---------
 2 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/include/libmnl/libmnl.h b/include/libmnl/libmnl.h
index b64306a..a32fb1d 100644
--- a/include/libmnl/libmnl.h
+++ b/include/libmnl/libmnl.h
@@ -5,6 +5,9 @@
 #include <stdint.h>
 #include <sys/socket.h> /* for sa_family_t */
 #include <linux/netlink.h>
+#ifndef __cplusplus
+#	include <stdbool.h>
+#endif
 
 #ifdef __cplusplus
 extern "C" {
@@ -50,10 +53,10 @@ extern int mnl_nlmsg_ok(const struct nlmsghdr *nlh, int len);
 extern struct nlmsghdr *mnl_nlmsg_next(const struct nlmsghdr *nlh, int *len);
 
 /* Netlink sequence tracking */
-extern int mnl_nlmsg_seq_ok(const struct nlmsghdr *nlh, unsigned int seq);
+extern bool mnl_nlmsg_seq_ok(const struct nlmsghdr *nlh, unsigned int seq);
 
 /* Netlink portID checking */
-extern int mnl_nlmsg_portid_ok(const struct nlmsghdr *nlh, unsigned int portid);
+extern bool mnl_nlmsg_portid_ok(const struct nlmsghdr *nlh, unsigned int portid);
 
 /* Netlink message getters */
 extern void *mnl_nlmsg_get_payload(const struct nlmsghdr *nlh);
diff --git a/src/nlmsg.c b/src/nlmsg.c
index 535f4b5..f89a9ec 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -6,7 +6,7 @@
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
  */
-
+#include <stdbool.h>
 #include <stdio.h>
 #include <ctype.h>
 #include <errno.h>
@@ -200,8 +200,8 @@ void *mnl_nlmsg_get_payload_tail(const struct nlmsghdr *nlh)
  * \param nlh current netlink message that we are handling
  * \param seq last sequence number used to send a message
  *
- * This functions returns 1 if the sequence tracking is fulfilled, otherwise
- * 0 is returned. We skip the tracking for netlink messages whose sequence
+ * This functions returns true if the sequence tracking is fulfilled, otherwise
+ * false is returned. We skip the tracking for netlink messages whose sequence
  * number is zero since it is usually reserved for event-based kernel
  * notifications. On the other hand, if seq is set but the message sequence
  * number is not set (i.e. this is an event message coming from kernel-space),
@@ -209,9 +209,9 @@ void *mnl_nlmsg_get_payload_tail(const struct nlmsghdr *nlh)
  * socket to send commands to kernel-space (that we want to track) and to
  * listen to events (that we do not track).
  */
-int mnl_nlmsg_seq_ok(const struct nlmsghdr *nlh, unsigned int seq)
+bool mnl_nlmsg_seq_ok(const struct nlmsghdr *nlh, unsigned int seq)
 {
-	return nlh->nlmsg_seq && seq ? nlh->nlmsg_seq == seq : 1;
+	return nlh->nlmsg_seq && seq ? nlh->nlmsg_seq == seq : true;
 }
 
 /**
@@ -219,8 +219,8 @@ int mnl_nlmsg_seq_ok(const struct nlmsghdr *nlh, unsigned int seq)
  * \param nlh current netlink message that we are handling
  * \param seq netlink portid that we want to check
  *
- * This functions returns 1 if the origin is fulfilled, otherwise
- * 0 is returned.  We skip the tracking for netlink message whose portID 
+ * This functions returns true if the origin is fulfilled, otherwise
+ * false is returned. We skip the tracking for netlink message whose portID
  * is zero since it is reserved for event-based kernel notifications. On the
  * other hand, if portid is set but the message PortID is not (i.e. this
  * is an event message coming from kernel-space), then we also skip the
@@ -228,9 +228,9 @@ int mnl_nlmsg_seq_ok(const struct nlmsghdr *nlh, unsigned int seq)
  * to kernel-space (that we want to track) and to listen to events (that we
  * do not track).
  */
-int mnl_nlmsg_portid_ok(const struct nlmsghdr *nlh, unsigned int portid)
+bool mnl_nlmsg_portid_ok(const struct nlmsghdr *nlh, unsigned int portid)
 {
-	return nlh->nlmsg_pid && portid ? nlh->nlmsg_pid == portid : 1;
+	return nlh->nlmsg_pid && portid ? nlh->nlmsg_pid == portid : true;
 }
 
 /**
-- 
1.7.1

