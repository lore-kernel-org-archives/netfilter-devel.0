From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/9] libxt_quota: require --quota to be specified
Date: Sun, 27 Feb 2011 02:31:13 +0100
Message-ID: <1298770280-7652-4-git-send-email-jengelh@medozas.de>
References: <1298770280-7652-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:52517 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208Ab1B0Bba (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 26 Feb 2011 20:31:30 -0500
In-Reply-To: <1298770280-7652-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It is pretty pointless to use -m quota without specifying --quota.
There would be nothing left to count down on.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_quota.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/extensions/libxt_quota.c b/extensions/libxt_quota.c
index e6ed9bc..e3699ad 100644
--- a/extensions/libxt_quota.c
+++ b/extensions/libxt_quota.c
@@ -72,12 +72,19 @@ quota_parse(int c, char **argv, int invert, unsigned int *flags,
 
 		if (invert)
 			info->flags |= XT_QUOTA_INVERT;
-
+		*flags |= 1;
 		break;
 	}
 	return 1;
 }
 
+static void quota_check(unsigned int flags)
+{
+	if (flags == 0)
+		xtables_error(PARAMETER_PROBLEM,
+			"quota: the --quota argument must be specified\n");
+}
+
 static struct xtables_match quota_match = {
 	.family		= NFPROTO_UNSPEC,
 	.name		= "quota",
@@ -86,6 +93,7 @@ static struct xtables_match quota_match = {
 	.userspacesize	= offsetof(struct xt_quota_info, master),
 	.help		= quota_help,
 	.parse		= quota_parse,
+	.final_check	= quota_check,
 	.print		= quota_print,
 	.save		= quota_save,
 	.extra_opts	= quota_opts,
-- 
1.7.1

