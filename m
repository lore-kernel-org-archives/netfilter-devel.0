From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 08/12] libipt_[SD]NAT: avoid false error about multiple destinations specified
Date: Fri, 13 May 2011 02:47:32 +0200
Message-ID: <1305247657-29158-9-git-send-email-jengelh@medozas.de>
References: <1305247657-29158-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:54338 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759036Ab1EMAt3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 May 2011 20:49:29 -0400
In-Reply-To: <1305247657-29158-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

iptables-restore v1.4.10: DNAT: Multiple --to-destination not supported

xtables_option_parse sets cb->xflags already, so that it cannot be
directly used to test whether an option is being used for the second
time. Thus use a private option/flag (X_TO_DEST/SRC) that is not under
the control of xtables_option_parse.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libipt_DNAT.c |    9 ++++++---
 extensions/libipt_SNAT.c |    9 ++++++---
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/extensions/libipt_DNAT.c b/extensions/libipt_DNAT.c
index 8c4c9c2..3b55c69 100644
--- a/extensions/libipt_DNAT.c
+++ b/extensions/libipt_DNAT.c
@@ -12,8 +12,10 @@ enum {
 	O_TO_DEST = 0,
 	O_RANDOM,
 	O_PERSISTENT,
-	F_TO_DEST = 1 << O_TO_DEST,
-	F_RANDOM  = 1 << O_RANDOM,
+	O_X_TO_DEST, /* hidden flag */
+	F_TO_DEST   = 1 << O_TO_DEST,
+	F_RANDOM    = 1 << O_RANDOM,
+	F_X_TO_DEST = 1 << O_X_TO_DEST,
 };
 
 /* Dest NAT data consists of a multi-range, indicating where to map
@@ -164,7 +166,7 @@ static void DNAT_parse(struct xt_option_call *cb)
 	xtables_option_parse(cb);
 	switch (cb->entry->id) {
 	case O_TO_DEST:
-		if (cb->xflags & F_TO_DEST) {
+		if (cb->xflags & F_X_TO_DEST) {
 			if (!kernel_version)
 				get_kernel_version();
 			if (kernel_version > LINUX_VERSION(2, 6, 10))
@@ -175,6 +177,7 @@ static void DNAT_parse(struct xt_option_call *cb)
 		/* WTF do we need this for?? */
 		if (cb->xflags & F_RANDOM)
 			info->mr.range[0].flags |= IP_NAT_RANGE_PROTO_RANDOM;
+		cb->xflags |= F_X_TO_DEST;
 		break;
 	case O_RANDOM:
 		if (cb->xflags & F_TO_DEST)
diff --git a/extensions/libipt_SNAT.c b/extensions/libipt_SNAT.c
index 3691041..8023306 100644
--- a/extensions/libipt_SNAT.c
+++ b/extensions/libipt_SNAT.c
@@ -12,8 +12,10 @@ enum {
 	O_TO_SRC = 0,
 	O_RANDOM,
 	O_PERSISTENT,
-	F_TO_SRC = 1 << O_TO_SRC,
-	F_RANDOM = 1 << O_RANDOM,
+	O_X_TO_SRC,
+	F_TO_SRC   = 1 << O_TO_SRC,
+	F_RANDOM   = 1 << O_RANDOM,
+	F_X_TO_SRC = 1 << O_X_TO_SRC,
 };
 
 /* Source NAT data consists of a multi-range, indicating where to map
@@ -164,7 +166,7 @@ static void SNAT_parse(struct xt_option_call *cb)
 	xtables_option_parse(cb);
 	switch (cb->entry->id) {
 	case O_TO_SRC:
-		if (cb->xflags & F_TO_SRC) {
+		if (cb->xflags & F_X_TO_SRC) {
 			if (!kernel_version)
 				get_kernel_version();
 			if (kernel_version > LINUX_VERSION(2, 6, 10))
@@ -175,6 +177,7 @@ static void SNAT_parse(struct xt_option_call *cb)
 		/* WTF do we need this for?? */
 		if (cb->xflags & F_RANDOM)
 			info->mr.range[0].flags |= IP_NAT_RANGE_PROTO_RANDOM;
+		cb->xflags |= F_X_TO_SRC;
 		break;
 	case O_RANDOM:
 		if (cb->xflags & F_TO_SRC)
-- 
1.7.1

