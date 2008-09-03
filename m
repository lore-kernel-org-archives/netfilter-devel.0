From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD2 2/4] Suppress unused configuration variable.
Date: Wed,  3 Sep 2008 22:19:01 +0200
Message-ID: <1220473143-17957-3-git-send-email-eric@inl.fr>
References: <>
 <1220473143-17957-1-git-send-email-eric@inl.fr>
 <1220473143-17957-2-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:46787 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753321AbYICUsu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Sep 2008 16:48:50 -0400
In-Reply-To: <1220473143-17957-2-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch suppresses the "rmem" configuration variable which was
inherited from the original ULOG plugin and which is unused in the
NFLOG plugin.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 input/packet/ulogd_inppkt_NFLOG.c |   21 +++++++--------------
 1 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/input/packet/ulogd_inppkt_NFLOG.c b/input/packet/ulogd_inppkt_NFLOG.c
index ed01f04..200aab7 100644
--- a/input/packet/ulogd_inppkt_NFLOG.c
+++ b/input/packet/ulogd_inppkt_NFLOG.c
@@ -52,12 +52,6 @@ static struct config_keyset libulog_kset = {
 			.u.value = NFLOG_GROUP_DEFAULT,
 		},
 		{
-			.key	 = "rmem",
-			.type	 = CONFIG_TYPE_INT,
-			.options = CONFIG_OPT_NONE,
-			.u.value = NFLOG_RMEM_DEFAULT,
-		},
-		{
 			.key 	 = "addressfamily",
 			.type	 = CONFIG_TYPE_INT,
 			.options = CONFIG_OPT_NONE,
@@ -104,14 +98,13 @@ static struct config_keyset libulog_kset = {
 
 #define bufsiz_ce(x)	(x->ces[0])
 #define group_ce(x)	(x->ces[1])
-#define rmem_ce(x)	(x->ces[2])
-#define af_ce(x)	(x->ces[3])
-#define unbind_ce(x)	(x->ces[4])
-#define seq_ce(x)	(x->ces[5])
-#define seq_global_ce(x)	(x->ces[6])
-#define label_ce(x)	(x->ces[7])
-#define nlsockbufsize_ce(x) (x->ces[8])
-#define nlsockbufmaxsize_ce(x) (x->ces[9])
+#define af_ce(x)	(x->ces[2])
+#define unbind_ce(x)	(x->ces[3])
+#define seq_ce(x)	(x->ces[4])
+#define seq_global_ce(x)	(x->ces[5])
+#define label_ce(x)	(x->ces[6])
+#define nlsockbufsize_ce(x) (x->ces[7])
+#define nlsockbufmaxsize_ce(x) (x->ces[8])
 
 enum nflog_keys {
 	NFLOG_KEY_RAW_MAC = 0,
-- 
1.5.4.3

