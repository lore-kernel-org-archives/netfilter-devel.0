From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/3] utils: use sizeof(buf) over hardcoded number
Date: Sat, 18 Dec 2010 21:16:10 +0100
Message-ID: <1292703371-15946-4-git-send-email-jengelh@medozas.de>
References: <1292703371-15946-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:47386 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932205Ab0LRUQP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 18 Dec 2010 15:16:15 -0500
In-Reply-To: <1292703371-15946-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 qa/test_filter.c         |    2 +-
 utils/conntrack_dump.c   |    2 +-
 utils/conntrack_events.c |    2 +-
 utils/conntrack_filter.c |    2 +-
 utils/conntrack_get.c    |    2 +-
 utils/ctexp_events.c     |    2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/qa/test_filter.c b/qa/test_filter.c
index 42d067f..35fdbec 100644
--- a/qa/test_filter.c
+++ b/qa/test_filter.c
@@ -14,7 +14,7 @@ static int event_cb(enum nf_conntrack_msg_type type,
 	static int n = 0;
 	char buf[1024];
 
-	nfct_snprintf(buf, 1024, ct, type, NFCT_O_PLAIN, NFCT_OF_TIME);
+	nfct_snprintf(buf, sizeof(buf), ct, type, NFCT_O_PLAIN, NFCT_OF_TIME);
 	printf("%s\n", buf);
 
 	if (++n == 10)
diff --git a/utils/conntrack_dump.c b/utils/conntrack_dump.c
index 4ef9168..a15acc1 100644
--- a/utils/conntrack_dump.c
+++ b/utils/conntrack_dump.c
@@ -10,7 +10,7 @@ static int cb(enum nf_conntrack_msg_type type,
 {
 	char buf[1024];
 
-	nfct_snprintf(buf, 1024, ct, NFCT_T_UNKNOWN, NFCT_O_DEFAULT, NFCT_OF_SHOW_LAYER3);
+	nfct_snprintf(buf, sizeof(buf), ct, NFCT_T_UNKNOWN, NFCT_O_DEFAULT, NFCT_OF_SHOW_LAYER3);
 	printf("%s\n", buf);
 
 	return NFCT_CB_CONTINUE;
diff --git a/utils/conntrack_events.c b/utils/conntrack_events.c
index ab3125c..1f115e2 100644
--- a/utils/conntrack_events.c
+++ b/utils/conntrack_events.c
@@ -11,7 +11,7 @@ static int event_cb(enum nf_conntrack_msg_type type,
 	static int n = 0;
 	char buf[1024];
 
-	nfct_snprintf(buf, 1024, ct, type, NFCT_O_XML, NFCT_OF_TIME);
+	nfct_snprintf(buf, sizeof(buf), ct, type, NFCT_O_XML, NFCT_OF_TIME);
 	printf("%s\n", buf);
 
 	if (++n == 10)
diff --git a/utils/conntrack_filter.c b/utils/conntrack_filter.c
index 0252fbf..b05c37c 100644
--- a/utils/conntrack_filter.c
+++ b/utils/conntrack_filter.c
@@ -12,7 +12,7 @@ static int event_cb(enum nf_conntrack_msg_type type,
 	static int n = 0;
 	char buf[1024];
 
-	nfct_snprintf(buf, 1024, ct, type, NFCT_O_PLAIN, NFCT_OF_TIME);
+	nfct_snprintf(buf, sizeof(buf), ct, type, NFCT_O_PLAIN, NFCT_OF_TIME);
 	printf("%s\n", buf);
 
 	if (++n == 10)
diff --git a/utils/conntrack_get.c b/utils/conntrack_get.c
index 5595794..33c836b 100644
--- a/utils/conntrack_get.c
+++ b/utils/conntrack_get.c
@@ -11,7 +11,7 @@ static int cb(enum nf_conntrack_msg_type type,
 {
 	char buf[1024];
 
-	nfct_snprintf(buf, 1024, ct, NFCT_T_UNKNOWN, NFCT_O_DEFAULT, NFCT_OF_SHOW_LAYER3);
+	nfct_snprintf(buf, sizeof(buf), ct, NFCT_T_UNKNOWN, NFCT_O_DEFAULT, NFCT_OF_SHOW_LAYER3);
 	printf("%s\n", buf);
 
 	return NFCT_CB_CONTINUE;
diff --git a/utils/ctexp_events.c b/utils/ctexp_events.c
index 1df5729..ec459e4 100644
--- a/utils/ctexp_events.c
+++ b/utils/ctexp_events.c
@@ -11,7 +11,7 @@ ct_event_cb(enum nf_conntrack_msg_type type,struct nf_conntrack *ct, void *data)
 {
 	char buf[1024];
 
-	nfct_snprintf(buf, 1024, ct, type, NFCT_O_PLAIN, NFCT_OF_TIME);
+	nfct_snprintf(buf, sizeof(buf), ct, type, NFCT_O_PLAIN, NFCT_OF_TIME);
 	printf("[CT] %s\n", buf);
 
 	if (++n == 20)
-- 
1.7.1

