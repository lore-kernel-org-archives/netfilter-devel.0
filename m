From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 09/13] callback: mnl_cb_run should use a void *
Date: Sat, 23 Oct 2010 07:44:46 +0200
Message-ID: <1287812691-14470-10-git-send-email-jengelh@medozas.de>
References: <1287812691-14470-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:55125 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752659Ab0JWFpJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 Oct 2010 01:45:09 -0400
In-Reply-To: <1287812691-14470-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Because in most cases, it won't be a nul-terminated string :)

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/libmnl/libmnl.h |    4 ++--
 src/callback.c          |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/libmnl/libmnl.h b/include/libmnl/libmnl.h
index a61a0b1..d35e1c1 100644
--- a/include/libmnl/libmnl.h
+++ b/include/libmnl/libmnl.h
@@ -141,10 +141,10 @@ extern int mnl_attr_parse_nested(const struct nlattr *attr, mnl_attr_cb_t cb, vo
 
 typedef int (*mnl_cb_t)(const struct nlmsghdr *nlh, void *data);
 
-extern int mnl_cb_run(const char *buf, size_t numbytes, unsigned int seq,
+extern int mnl_cb_run(const void *buf, size_t numbytes, unsigned int seq,
 		      unsigned int portid, mnl_cb_t cb_data, void *data);
 
-extern int mnl_cb_run2(const char *buf, size_t numbytes, unsigned int seq,
+extern int mnl_cb_run2(const void *buf, size_t numbytes, unsigned int seq,
 		       unsigned int portid, mnl_cb_t cb_data, void *data,
 		       mnl_cb_t *cb_ctl_array, unsigned int cb_ctl_array_len);
 
diff --git a/src/callback.c b/src/callback.c
index f5a6112..4a8fa2d 100644
--- a/src/callback.c
+++ b/src/callback.c
@@ -74,12 +74,12 @@ static const mnl_cb_t default_cb_array[NLMSG_MIN_TYPE] = {
  * is set to ESRCH. If the sequence number is not the expected, errno is set
  * to EPROTO.
  */
-int mnl_cb_run2(const char *buf, size_t numbytes, unsigned int seq,
+int mnl_cb_run2(const void *buf, size_t numbytes, unsigned int seq,
 		unsigned int portid, mnl_cb_t cb_data, void *data,
 		mnl_cb_t *cb_ctl_array, unsigned int cb_ctl_array_len)
 {
 	int ret = MNL_CB_OK, len = numbytes;
-	struct nlmsghdr *nlh = (struct nlmsghdr *)buf;
+	const struct nlmsghdr *nlh = buf;
 
 	while (mnl_nlmsg_ok(nlh, len)) {
 		/* check message source */
@@ -136,7 +136,7 @@ out:
  *
  * This function propagates the callback return value.
  */
-int mnl_cb_run(const char *buf, size_t numbytes, unsigned int seq,
+int mnl_cb_run(const void *buf, size_t numbytes, unsigned int seq,
 	       unsigned int portid, mnl_cb_t cb_data, void *data)
 {
 	return mnl_cb_run2(buf, numbytes, seq, portid, cb_data, data, NULL, 0);
-- 
1.7.1

