From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 7/8] extensions: add missing checks for specific flags
Date: Sat, 19 Feb 2011 20:04:17 +0100
Message-ID: <1298142259-11213-8-git-send-email-jengelh@medozas.de>
References: <1298142259-11213-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42368 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755469Ab1BSTEl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 19 Feb 2011 14:04:41 -0500
In-Reply-To: <1298142259-11213-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

With "!flags", any option will be accepted. The extensions however
want one very specific option to be used (or wrong help text).

Commits: DNAT: v1.3.8~23, osf: v1.4.6~3

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libipt_DNAT.c |    2 +-
 extensions/libipt_ECN.c  |    2 +-
 extensions/libxt_osf.c   |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/extensions/libipt_DNAT.c b/extensions/libipt_DNAT.c
index 34d3777..49c74e1 100644
--- a/extensions/libipt_DNAT.c
+++ b/extensions/libipt_DNAT.c
@@ -190,7 +190,7 @@ static int DNAT_parse(int c, char **argv, int invert, unsigned int *flags,
 
 static void DNAT_check(unsigned int flags)
 {
-	if (!flags)
+	if (!(flags & IPT_DNAT_OPT_DEST))
 		xtables_error(PARAMETER_PROBLEM,
 			   "You must specify --to-destination");
 }
diff --git a/extensions/libipt_ECN.c b/extensions/libipt_ECN.c
index 6bfc1b3..e1f29b6 100644
--- a/extensions/libipt_ECN.c
+++ b/extensions/libipt_ECN.c
@@ -97,7 +97,7 @@ static void ECN_check(unsigned int flags)
 {
 	if (!flags)
 		xtables_error(PARAMETER_PROBLEM,
-		           "ECN target: Parameter --ecn-tcp-remove is required");
+		           "ECN target: An operation is required");
 }
 
 static void ECN_print(const void *ip, const struct xt_entry_target *target,
diff --git a/extensions/libxt_osf.c b/extensions/libxt_osf.c
index a97884b..20acfea 100644
--- a/extensions/libxt_osf.c
+++ b/extensions/libxt_osf.c
@@ -114,7 +114,7 @@ static int osf_parse(int c, char **argv, int invert, unsigned int *flags,
 
 static void osf_final_check(unsigned int flags)
 {
-	if (!flags)
+	if (!(flags & XT_OSF_GENRE))
 		xtables_error(PARAMETER_PROBLEM,
 			      "OS fingerprint match: You must specify `--genre'");
 }
-- 
1.7.1

