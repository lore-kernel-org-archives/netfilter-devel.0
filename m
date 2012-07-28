From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 1/7] iptables-restore: warn about -t in rule lines
Date: Sat, 28 Jul 2012 19:21:03 +0200
Message-ID: <1343496069-5442-2-git-send-email-jengelh@inai.de>
References: <1343496069-5442-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:34338 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752948Ab2G1RVQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 28 Jul 2012 13:21:16 -0400
In-Reply-To: <1343496069-5442-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

save-restore syntax uses *table, not -t table.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 iptables/ip6tables-restore.c |    3 +--
 iptables/iptables-restore.c  |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/iptables/ip6tables-restore.c b/iptables/ip6tables-restore.c
index 3894d68..614ff0f 100644
--- a/iptables/ip6tables-restore.c
+++ b/iptables/ip6tables-restore.c
@@ -417,8 +417,7 @@ int ip6tables_restore_main(int argc, char *argv[])
 					if (!strncmp(param_buffer, "-t", 2)
                                             || !strncmp(param_buffer, "--table", 8)) {
 						xtables_error(PARAMETER_PROBLEM,
-						   "Line %u seems to have a "
-						   "-t table option.\n", line);
+						   "The -t option (seen in line %u) cannot be used in ip6tables-restore.\n", line);
 						exit(1);
 					}
 
diff --git a/iptables/iptables-restore.c b/iptables/iptables-restore.c
index 034f960..294e4b8 100644
--- a/iptables/iptables-restore.c
+++ b/iptables/iptables-restore.c
@@ -417,8 +417,7 @@ iptables_restore_main(int argc, char *argv[])
 					if (!strncmp(param_buffer, "-t", 2)
 					    || !strncmp(param_buffer, "--table", 8)) {
 						xtables_error(PARAMETER_PROBLEM,
-						   "Line %u seems to have a "
-						   "-t table option.\n", line);
+						   "The -t option (seen in line %u) cannot be used in iptables-restore.\n", line);
 						exit(1);
 					}
 
-- 
1.7.7

