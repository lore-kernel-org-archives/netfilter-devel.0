From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH, RFC] Modify NFLOG to be able to use it with older libnetfilter_log
Date: Mon, 21 Apr 2008 23:52:57 +0200
Message-ID: <12088147772676-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: kaber@trash.net, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:50290 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752794AbYDUVw7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Apr 2008 17:52:59 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

NFLOG has been modified to support GID display. There is a problem as this
feature is only available in latest subversion of libnetfilter_log. This
patch made this feature optional:
 * It detects if system support the nflog_get_gid() function
 * Compilation of nflog_get_gid() related code is conditional

BR,
---
 configure.in                      |    4 ++++
 input/packet/ulogd_inppkt_NFLOG.c |    3 ++-
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/configure.in b/configure.in
index a70848c..7a6d705 100644
--- a/configure.in
+++ b/configure.in
@@ -41,6 +41,10 @@ AC_CHECK_HEADER([libnetfilter_log/linux_nfnetlink_log.h], [AC_MSG_RESULT([found]
 AC_CHECK_HEADER([libnetfilter_conntrack/libnetfilter_conntrack.h], [AC_MSG_RESULT([found])],
 		[AC_MSG_ERROR([libnetfilter_conntrack Version 0.0.11 or later needed])])
 
+AC_CHECK_LIB([netfilter_log], [nflog_get_gid],
+	     AC_DEFINE_UNQUOTED([HAVE_NFLOG_GET_GID],[1],[libnetfilter_log has GID support]),,
+	     [-lnfnetlink])
+
 
 CT_CHECK_POSTGRES_DB()
 AM_CONDITIONAL(HAVE_PGSQL, test "x$PQLIBPATH" != "x")
diff --git a/input/packet/ulogd_inppkt_NFLOG.c b/input/packet/ulogd_inppkt_NFLOG.c
index 13f59a7..a510cba 100644
--- a/input/packet/ulogd_inppkt_NFLOG.c
+++ b/input/packet/ulogd_inppkt_NFLOG.c
@@ -353,11 +353,12 @@ interp_packet(struct ulogd_pluginstance *upi, struct nflog_data *ldata)
 		ret[NFLOG_KEY_OOB_UID].u.value.ui32 = uid;
 		ret[NFLOG_KEY_OOB_UID].flags |= ULOGD_RETF_VALID;
 	}
+#ifdef HAVE_NFLOG_GET_GID
 	if (nflog_get_gid(ldata, &gid) == 0) {
 		ret[NFLOG_KEY_OOB_GID].u.value.ui32 = gid;
 		ret[NFLOG_KEY_OOB_GID].flags |= ULOGD_RETF_VALID;
 	}
-
+#endif
 	if (nflog_get_seq(ldata, &seq) == 0) {
 		ret[NFLOG_KEY_OOB_SEQ_LOCAL].u.value.ui32 = seq;
 		ret[NFLOG_KEY_OOB_SEQ_LOCAL].flags |= ULOGD_RETF_VALID;
-- 
1.5.2.5

