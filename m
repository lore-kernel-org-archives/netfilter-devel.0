From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 7/7] iptables: remove more redundant casts
Date: Mon, 31 Jan 2011 03:12:52 +0100
Message-ID: <1296439973-16089-8-git-send-email-jengelh@medozas.de>
References: <1296439973-16089-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:45288 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752757Ab1AaCNE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Jan 2011 21:13:04 -0500
In-Reply-To: <1296439973-16089-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 ip6tables-restore.c |    4 +---
 iptables-restore.c  |    4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/ip6tables-restore.c b/ip6tables-restore.c
index d8a45da..44a051f 100644
--- a/ip6tables-restore.c
+++ b/ip6tables-restore.c
@@ -83,9 +83,7 @@ static int parse_counters(char *string, struct ip6t_counters *ctr)
 	unsigned long long pcnt, bcnt;
 	int ret;
 
-	ret = sscanf(string, "[%llu:%llu]",
-		     (unsigned long long *)&pcnt,
-		     (unsigned long long *)&bcnt);
+	ret = sscanf(string, "[%llu:%llu]", &pcnt, &bcnt);
 	ctr->pcnt = pcnt;
 	ctr->bcnt = bcnt;
 	return ret == 2;
diff --git a/iptables-restore.c b/iptables-restore.c
index cd23cfa..e2d1859 100644
--- a/iptables-restore.c
+++ b/iptables-restore.c
@@ -83,9 +83,7 @@ static int parse_counters(char *string, struct ipt_counters *ctr)
 	unsigned long long pcnt, bcnt;
 	int ret;
 
-	ret = sscanf(string, "[%llu:%llu]",
-		     (unsigned long long *)&pcnt,
-		     (unsigned long long *)&bcnt);
+	ret = sscanf(string, "[%llu:%llu]", &pcnt, &bcnt);
 	ctr->pcnt = pcnt;
 	ctr->bcnt = bcnt;
 	return ret == 2;
-- 
1.7.1

