From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 2/8] Introduce RAWSTR type to avoid confusion in future developement.
Date: Sun,  9 Mar 2008 23:36:23 +0100
Message-ID: <12051021893499-git-send-email-eric@inl.fr>
References: <12051021893015-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:57595 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753304AbYCIWgc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Mar 2008 18:36:32 -0400
In-Reply-To: <12051021893015-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

IP2BIN filter convert IP address from host storage to a "binary" string which
can be use by MySQL. This is not strictly speaking raw data but it was of type
RAW.

Following remark from Hugo Mildenberger, I introduce in this patch a dedicated
type ULOGD_RET_RAWSTR. The main reason not to use a ULOGD_RET_STRING parameter
is that the paramater is not human readable.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 filter/ulogd_filter_IP2BIN.c |   12 ++++++------
 include/ulogd/ulogd.h        |    1 +
 util/db.c                    |    5 ++++-
 3 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/filter/ulogd_filter_IP2BIN.c b/filter/ulogd_filter_IP2BIN.c
index 9b0110e..33db6a2 100644
--- a/filter/ulogd_filter_IP2BIN.c
+++ b/filter/ulogd_filter_IP2BIN.c
@@ -82,32 +82,32 @@ static struct ulogd_key ip2bin_inp[] = {
 
 static struct ulogd_key ip2bin_keys[] = {
 	{
-		.type = ULOGD_RET_RAW,
+		.type = ULOGD_RET_RAWSTR,
 		.flags = ULOGD_RETF_FREE,
 		.name = "ip.saddr.bin",
 	},
 	{
-		.type = ULOGD_RET_RAW,
+		.type = ULOGD_RET_RAWSTR,
 		.flags = ULOGD_RETF_FREE,
 		.name = "ip.daddr.bin",
 	},
 	{
-		.type = ULOGD_RET_RAW,
+		.type = ULOGD_RET_RAWSTR,
 		.flags = ULOGD_RETF_FREE,
 		.name = "orig.ip.saddr.bin",
 	},
 	{
-		.type = ULOGD_RET_RAW,
+		.type = ULOGD_RET_RAWSTR,
 		.flags = ULOGD_RETF_FREE,
 		.name = "orig.ip.daddr.bin",
 	},
 	{
-		.type = ULOGD_RET_RAW,
+		.type = ULOGD_RET_RAWSTR,
 		.flags = ULOGD_RETF_FREE,
 		.name = "reply.ip.saddr.bin",
 	},
 	{
-		.type = ULOGD_RET_RAW,
+		.type = ULOGD_RET_RAWSTR,
 		.flags = ULOGD_RETF_FREE,
 		.name = "reply.ip.daddr.bin",
 	},
diff --git a/include/ulogd/ulogd.h b/include/ulogd/ulogd.h
index 8c052f2..39ac464 100644
--- a/include/ulogd/ulogd.h
+++ b/include/ulogd/ulogd.h
@@ -47,6 +47,7 @@
 /* types with length field */
 #define ULOGD_RET_STRING	0x8020
 #define ULOGD_RET_RAW		0x8030
+#define ULOGD_RET_RAWSTR	0x8040
 
 
 /* FLAGS */
diff --git a/util/db.c b/util/db.c
index d57ab6a..49f6c29 100644
--- a/util/db.c
+++ b/util/db.c
@@ -294,9 +294,12 @@ static int __interp_db(struct ulogd_pluginstance *upi)
 			}
 			sprintf(di->stmt_ins, "',");
 			break;
-		case ULOGD_RET_RAW:
+		case ULOGD_RET_RAWSTR:
 			sprintf(di->stmt_ins, "%s,", res->u.value.ptr);
 			break;
+		case ULOGD_RET_RAW:
+			ulogd_log(ULOGD_NOTICE,
+				"Unsupported RAW type is unsupported in SQL output");
 		default:
 			ulogd_log(ULOGD_NOTICE,
 				"unknown type %d for %s\n",
-- 
1.5.4.3

