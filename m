From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 1/1] ip(6)tables-restore: make sure argv is NULL terminated
Date: Thu, 10 May 2012 17:42:47 +0200
Message-ID: <1336664567-4593-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:58172 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753102Ab2EJPk6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 May 2012 11:40:58 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Else, argv[argc] may point to free'd memory.

Some extensions, e.g. rateest, may fail to parse valid input
because argv[optind] (with optind == argc) is not NULL.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 iptables/ip6tables-restore.c |    2 +-
 iptables/iptables-restore.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/iptables/ip6tables-restore.c b/iptables/ip6tables-restore.c
index 92bdc30..3894d68 100644
--- a/iptables/ip6tables-restore.c
+++ b/iptables/ip6tables-restore.c
@@ -98,7 +98,7 @@ static int add_argv(char *what) {
 	DEBUGP("add_argv: %s\n", what);
 	if (what && newargc + 1 < ARRAY_SIZE(newargv)) {
 		newargv[newargc] = strdup(what);
-		newargc++;
+		newargv[++newargc] = NULL;
 		return 1;
 	} else {
 		xtables_error(PARAMETER_PROBLEM,
diff --git a/iptables/iptables-restore.c b/iptables/iptables-restore.c
index 6b1c792..034f960 100644
--- a/iptables/iptables-restore.c
+++ b/iptables/iptables-restore.c
@@ -97,7 +97,7 @@ static int add_argv(char *what) {
 	DEBUGP("add_argv: %s\n", what);
 	if (what && newargc + 1 < ARRAY_SIZE(newargv)) {
 		newargv[newargc] = strdup(what);
-		newargc++;
+		newargv[++newargc] = NULL;
 		return 1;
 	} else {
 		xtables_error(PARAMETER_PROBLEM,
-- 
1.7.3.4

