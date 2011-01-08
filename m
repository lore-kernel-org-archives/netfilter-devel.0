From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 12/13] libxtables: do some option structure checking
Date: Sat,  8 Jan 2011 16:20:13 +0100
Message-ID: <1294500015-10691-13-git-send-email-jengelh@medozas.de>
References: <1294500015-10691-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:32919 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752770Ab1AHPU3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 8 Jan 2011 10:20:29 -0500
In-Reply-To: <1294500015-10691-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

libxt_recent's use of numeric values >200 always looked worrisome. Now
here is a validation routine for such.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 xtables.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/xtables.c b/xtables.c
index 5b7526c..f8014a6 100644
--- a/xtables.c
+++ b/xtables.c
@@ -730,6 +730,17 @@ static int compatible_target_revision(const char *name, uint8_t revision)
 	return compatible_revision(name, revision, afinfo->so_rev_target);
 }
 
+static void xtables_check_options(const char *name, const struct option *opt)
+{
+	for (; opt->name != NULL; ++opt)
+		if (opt->val < 0 || opt->val >= XT_OPTION_OFFSET_SCALE) {
+			fprintf(stderr, "%s: Extension %s uses invalid "
+			        "option value %d\n",xt_params->program_name,
+			        name, opt->val);
+			exit(1);
+		}
+}
+
 void xtables_register_match(struct xtables_match *me)
 {
 	struct xtables_match **i, *old;
@@ -760,6 +771,9 @@ void xtables_register_match(struct xtables_match *me)
 		exit(1);
 	}
 
+	if (me->extra_opts != NULL)
+		xtables_check_options(me->name, me->extra_opts);
+
 	/* ignore not interested match */
 	if (me->family != afinfo->family && me->family != AF_UNSPEC)
 		return;
@@ -845,6 +859,9 @@ void xtables_register_target(struct xtables_target *me)
 		exit(1);
 	}
 
+	if (me->extra_opts != NULL)
+		xtables_check_options(me->name, me->extra_opts);
+
 	/* ignore not interested target */
 	if (me->family != afinfo->family && me->family != AF_UNSPEC)
 		return;
-- 
1.7.1

