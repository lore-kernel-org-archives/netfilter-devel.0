From: Phil Sutter <phil@nwl.cc>
Subject: [iptables PATCH] extensions: libxt_conntrack: Fix 'state' translation to nft
Date: Tue,  7 Mar 2017 16:35:07 +0100
Message-ID: <20170307153507.14640-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:54135 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753429AbdCGPnW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Mar 2017 10:43:22 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

While translating a conntrack state match in old syntax, matches are
looked up by name, only. This returned the revision 0 entry since
matches are registered in reverse order of appearance in the array
passed to xtables_register_matches(). The problem is that revision 0
doesn't define an xlate callback.

Fix this by reordering the matches in conntrack_mt_reg so that the
highest revision one is found first.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
The strange thing here is that I'm pretty sure this has been working
once. My logs from playing with iptables-restore-translate from November
2016 indicate that. Yet I have not been able to find a point in iptables
git history in which it works.
---
 extensions/libxt_conntrack.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index 72c522004a7ea..60ce9d1dc0a2e 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -1507,6 +1507,19 @@ static struct xtables_match conntrack_mt_reg[] = {
 	{
 		.family        = NFPROTO_UNSPEC,
 		.name          = "state",
+		.revision      = 0,
+		.version       = XTABLES_VERSION,
+		.size          = XT_ALIGN(sizeof(struct xt_state_info)),
+		.userspacesize = XT_ALIGN(sizeof(struct xt_state_info)),
+		.help          = state_help,
+		.print         = state_print,
+		.save          = state_save,
+		.x6_parse      = state_parse,
+		.x6_options    = state_opts,
+	},
+	{
+		.family        = NFPROTO_UNSPEC,
+		.name          = "state",
 		.real_name     = "conntrack",
 		.revision      = 1,
 		.ext_flags     = XTABLES_EXT_ALIAS,
@@ -1550,19 +1563,6 @@ static struct xtables_match conntrack_mt_reg[] = {
 		.x6_options    = state_opts,
 		.xlate         = state_xlate,
 	},
-	{
-		.family        = NFPROTO_UNSPEC,
-		.name          = "state",
-		.revision      = 0,
-		.version       = XTABLES_VERSION,
-		.size          = XT_ALIGN(sizeof(struct xt_state_info)),
-		.userspacesize = XT_ALIGN(sizeof(struct xt_state_info)),
-		.help          = state_help,
-		.print         = state_print,
-		.save          = state_save,
-		.x6_parse      = state_parse,
-		.x6_options    = state_opts,
-	},
 };
 
 void _init(void)
-- 
2.11.0

