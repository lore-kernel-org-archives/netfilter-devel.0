From: Chieh-Min Wang <chiehmin18@gmail.com>
Subject: [PATCH conntrack-tools] conntrack: Show multiple CPUs stats from proc
Date: Mon, 21 Aug 2017 22:38:26 +0800
Message-ID: <1503326306-23437-1-git-send-email-chiehmin18@gmail.com>
Cc: Chieh-Min Wang <chiehmin18@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f54.google.com ([74.125.83.54]:37970 "EHLO
        mail-pg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753856AbdHUOic (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Aug 2017 10:38:32 -0400
Received: by mail-pg0-f54.google.com with SMTP id m133so19025291pga.5
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Aug 2017 07:38:32 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When read cpu conntrack stats from /proc/net/stat/nf_conntrack,
it only shows stats from cpu0.

This patch list all cpus' conntrack stats like what `nfexp_stats_cb` did.
---
 src/conntrack.c | 33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index 8d19cca..3ec10d6 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -1794,6 +1794,7 @@ static int display_proc_conntrack_stats(void)
 	char buf[4096], *token, *nl;
 	char output[CT_STATS_ENTRIES_MAX][CT_STATS_STRING_MAX];
 	unsigned int value[CT_STATS_ENTRIES_MAX], i, max;
+	int cpu;
 
 	fd = fopen(CT_STATS_PROC, "r");
 	if (fd == NULL)
@@ -1817,25 +1818,27 @@ static int display_proc_conntrack_stats(void)
 	}
 	max = i;
 
-	if (fgets(buf, sizeof(buf), fd) == NULL) {
-		ret = -1;
-		goto out_err;
-	}
-
-	nl = strchr(buf, '\n');
-	while (nl != NULL) {
-		*nl = '\0';
+	for (cpu=0; fgets(buf, sizeof(buf), fd) != NULL; cpu++) {
 		nl = strchr(buf, '\n');
+		while (nl != NULL) {
+			*nl = '\0';
+			nl = strchr(buf, '\n');
+		}
+		token = strtok(buf, " ");
+		for (i=0; token != NULL && i<CT_STATS_ENTRIES_MAX; i++) {
+			value[i] = (unsigned int) strtol(token, (char**) NULL, 16);
+			token = strtok(NULL, " ");
+		}
+
+		printf("cpu=%-4u\t", cpu);
+		for (i=0; i<max; i++)
+			printf("%s=%u ", output[i], value[i]);
+		printf("\n");
 	}
-	token = strtok(buf, " ");
-	for (i=0; token != NULL && i<CT_STATS_ENTRIES_MAX; i++) { 
-		value[i] = (unsigned int) strtol(token, (char**) NULL, 16);
-		token = strtok(NULL, " ");
+	if (cpu == 0) {
+		ret = -1;
 	}
 
-	for (i=0; i<max; i++)
-		printf("%-10s\t\t%-8u\n", output[i], value[i]);
-
 out_err:
 	fclose(fd);
 	return ret;
-- 
2.7.4

