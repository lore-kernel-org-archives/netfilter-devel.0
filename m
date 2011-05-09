From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 04/13] extensions: remove bogus use of XT_GETOPT_TABLEEND
Date: Mon,  9 May 2011 11:37:02 +0200
Message-ID: <1304933832-16412-5-git-send-email-jengelh@medozas.de>
References: <1304933832-16412-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:51664 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205Ab1EIJhT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 May 2011 05:37:19 -0400
In-Reply-To: <1304933832-16412-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Commit v1.4.8-36-g32b8e61 added this end marker in a little too many
places: at non-getopt places. Fix that.

Also change the definition of XT_GETOPT_TABLEEND to reference a struct
getopt member by name so that this cannot happen again.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_TCPOPTSTRIP.c |    2 +-
 extensions/libxt_rateest.c     |    2 +-
 include/xtables.h.in           |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/extensions/libxt_TCPOPTSTRIP.c b/extensions/libxt_TCPOPTSTRIP.c
index 43320d1..6897857 100644
--- a/extensions/libxt_TCPOPTSTRIP.c
+++ b/extensions/libxt_TCPOPTSTRIP.c
@@ -34,7 +34,7 @@ static const struct tcp_optionmap tcp_optionmap[] = {
 	{"sack",           "Selective ACK",        TCPOPT_SACK},
 	{"timestamp",      "Timestamp",            TCPOPT_TIMESTAMP},
 	{"md5",            "MD5 signature",        TCPOPT_MD5SIG},
-	XT_GETOPT_TABLEEND,
+	{NULL},
 };
 
 static void tcpoptstrip_tg_help(void)
diff --git a/extensions/libxt_rateest.c b/extensions/libxt_rateest.c
index 6998c01..e70edc6 100644
--- a/extensions/libxt_rateest.c
+++ b/extensions/libxt_rateest.c
@@ -80,7 +80,7 @@ static const struct rate_suffix {
 	{ "GBps",	8000000000. },
 	{ "TiBps",	8.*1024.*1024.*1024.*1024. },
 	{ "TBps",	8000000000000. },
-	XT_GETOPT_TABLEEND,
+	{NULL},
 };
 
 static int
diff --git a/include/xtables.h.in b/include/xtables.h.in
index 0cd9f9f..da8d84c 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -346,7 +346,7 @@ struct xtables_globals
 	void (*exit_err)(enum xtables_exittype status, const char *msg, ...) __attribute__((noreturn, format(printf,2,3)));
 };
 
-#define XT_GETOPT_TABLEEND {NULL}
+#define XT_GETOPT_TABLEEND {.name = NULL, .has_arg = false}
 
 #ifdef __cplusplus
 extern "C" {
-- 
1.7.1

