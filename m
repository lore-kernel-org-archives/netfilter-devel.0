From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 5/7] iptables: warn when parameter limit is exceeded
Date: Mon, 31 Jan 2011 03:12:50 +0100
Message-ID: <1296439973-16089-6-git-send-email-jengelh@medozas.de>
References: <1296439973-16089-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:45282 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752757Ab1AaCNC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Jan 2011 21:13:02 -0500
In-Reply-To: <1296439973-16089-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

While testing many match extensions in a single rule, I ran into this
error not warned about. Arguments were just ignored, causing
surprising "Need to specify an argument to --whatever" when the
argument was in fact given on the command line.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 ip6tables-restore.c |    5 ++++-
 iptables-restore.c  |    5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/ip6tables-restore.c b/ip6tables-restore.c
index cea5f36..9948cd6 100644
--- a/ip6tables-restore.c
+++ b/ip6tables-restore.c
@@ -103,8 +103,11 @@ static int add_argv(char *what) {
 		newargv[newargc] = strdup(what);
 		newargc++;
 		return 1;
-	} else
+	} else {
+		xtables_error(PARAMETER_PROBLEM,
+			"Parser cannot handle more arguments\n");
 		return 0;
+	}
 }
 
 static void free_argv(void) {
diff --git a/iptables-restore.c b/iptables-restore.c
index bf80e78..519d480 100644
--- a/iptables-restore.c
+++ b/iptables-restore.c
@@ -103,8 +103,11 @@ static int add_argv(char *what) {
 		newargv[newargc] = strdup(what);
 		newargc++;
 		return 1;
-	} else 
+	} else {
+		xtables_error(PARAMETER_PROBLEM,
+			"Parser cannot handle more arguments\n");
 		return 0;
+	}
 }
 
 static void free_argv(void) {
-- 
1.7.1

