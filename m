From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH conntrackd 2/2] conntrackd: CommitTimeout breaks DisableExternalCache set On
Date: Fri, 10 Mar 2017 10:41:48 +0100
Message-ID: <1489138908-3822-2-git-send-email-pablo@netfilter.org>
References: <1489138908-3822-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41556 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936004AbdCJJl6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Mar 2017 04:41:58 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2D8E419664F
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Mar 2017 10:41:55 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1D538DA729
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Mar 2017 10:41:55 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8DE59DA817
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Mar 2017 10:41:52 +0100 (CET)
In-Reply-To: <1489138908-3822-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch introduces a new evaluate() function that can be used to spot
inconsistent configurations.

Don't allow CommitTimeout with DisableExternalCache On since this
results in EINVAL errors. CommitTimeout makes no sense with no external
cache.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/conntrackd.h |  1 +
 src/main.c           | 11 +++++++++++
 src/run.c            | 13 +++++++++++++
 3 files changed, 25 insertions(+)

diff --git a/include/conntrackd.h b/include/conntrackd.h
index f995f4b69b72..27e43db871bf 100644
--- a/include/conntrackd.h
+++ b/include/conntrackd.h
@@ -300,6 +300,7 @@ extern struct ct_mode stats_mode;
 
 /* These live in run.c */
 void killer(int foo);
+int evaluate(void);
 int init(void);
 void select_main_loop(void);
 
diff --git a/src/main.c b/src/main.c
index febeaa929f6b..1a57cf8c886c 100644
--- a/src/main.c
+++ b/src/main.c
@@ -382,6 +382,17 @@ int main(int argc, char *argv[])
 	}
 
 	/*
+	 * Evaluate configuration
+	 */
+	if (evaluate() == -1) {
+		dlog(LOG_ERR, "conntrackd cannot start, please review your "
+		     "configuration");
+		close_log();
+		unlink(CONFIG(lockfile));
+		exit(EXIT_FAILURE);
+	}
+
+	/*
 	 * initialization process
 	 */
 
diff --git a/src/run.c b/src/run.c
index b71369b5bc75..1fe6cbaaff6f 100644
--- a/src/run.c
+++ b/src/run.c
@@ -221,6 +221,19 @@ static void local_cb(void *data)
 	do_local_server_step(&STATE(local), NULL, local_handler);
 }
 
+int evaluate(void)
+{
+	if (CONFIG(sync).external_cache_disable &&
+	    CONFIG(commit_timeout)) {
+		dlog(LOG_WARNING, "`CommitTimeout' can't be combined with "
+		     "`DisableExternalCache', ignoring this option. "
+		     "Fix your configuration file.");
+		CONFIG(commit_timeout) = 0;
+	}
+
+	return 0;
+}
+
 int
 init(void)
 {
-- 
2.1.4

