From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD2 PATCH 07/11] Fix warning about integer format.
Date: Sun, 27 Jul 2008 15:51:22 +0200
Message-ID: <1217166686-28508-8-git-send-email-eric@inl.fr>
References: <20080723162746.GB31572@bayen.regit.org>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:43811 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751970AbYG0Nv3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Jul 2008 09:51:29 -0400
In-Reply-To: <20080723162746.GB31572@bayen.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch uses PRIu64 and PRId64 macros from inttypes.h to have a correct
definition of 64 bit integer format for 64bits and 32bits arch.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 util/db.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/util/db.c b/util/db.c
index 68dcc31..61c31a3 100644
--- a/util/db.c
+++ b/util/db.c
@@ -32,6 +32,7 @@
 #include <netinet/in.h>
 #include <arpa/inet.h>
 #include <time.h>
+#include <inttypes.h>
 
 #include <ulogd/ulogd.h>
 #include <ulogd/db.h>
@@ -254,7 +255,7 @@ static int __interp_db(struct ulogd_pluginstance *upi)
 			sprintf(di->stmt_ins, "%d,", res->u.value.i32);
 			break;
 		case ULOGD_RET_INT64:
-			sprintf(di->stmt_ins, "%lld,", res->u.value.i64);
+			sprintf(di->stmt_ins, "%" PRId64 ",", res->u.value.i64);
 			break;
 		case ULOGD_RET_UINT8:
 			sprintf(di->stmt_ins, "%u,", res->u.value.ui8);
@@ -268,7 +269,7 @@ static int __interp_db(struct ulogd_pluginstance *upi)
 			sprintf(di->stmt_ins, "%u,", res->u.value.ui32);
 			break;
 		case ULOGD_RET_UINT64:
-			sprintf(di->stmt_ins, "%llu,", res->u.value.ui64);
+			sprintf(di->stmt_ins, "%" PRIu64 ",", res->u.value.ui64);
 			break;
 		case ULOGD_RET_BOOL:
 			sprintf(di->stmt_ins, "'%d',", res->u.value.b);
-- 
1.5.4.3

