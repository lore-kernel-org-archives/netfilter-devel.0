From: Florian Westphal <fw@strlen.de>
Subject: [PATCH iptables] policy: add nft translation for simple policy none/strict use case
Date: Sat, 27 Jan 2018 11:09:46 +0100
Message-ID: <20180127100946.29223-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:33076 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752152AbeA0KJw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 27 Jan 2018 05:09:52 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 extensions/libxt_policy.c      | 27 +++++++++++++++++++++++++++
 extensions/libxt_policy.txlate |  5 +++++
 2 files changed, 32 insertions(+)
 create mode 100644 extensions/libxt_policy.txlate

diff --git a/extensions/libxt_policy.c b/extensions/libxt_policy.c
index 0a64a80c..f9a4819c 100644
--- a/extensions/libxt_policy.c
+++ b/extensions/libxt_policy.c
@@ -376,6 +376,31 @@ static void policy6_save(const void *ip, const struct xt_entry_match *match)
 	}
 }
 
+static int policy_xlate(struct xt_xlate *xl,
+			const struct xt_xlate_mt_params *params)
+{
+	static const unsigned int allowed = XT_POLICY_MATCH_STRICT |
+					    XT_POLICY_MATCH_NONE |
+					    XT_POLICY_MATCH_IN;
+	static const struct xt_policy_elem empty;
+	const struct xt_policy_info *info = (const void *)params->match->data;
+
+	if ((info->flags & ~allowed) || info->len > 1)
+		return 0;
+
+	if (memcmp(&info->pol[0], &empty, sizeof(empty)))
+		return 0;
+
+	xt_xlate_add(xl, "meta secpath ");
+
+	if (info->flags & XT_POLICY_MATCH_NONE)
+		xt_xlate_add(xl, "missing");
+	else
+		xt_xlate_add(xl, "exists");
+
+	return 1;
+}
+
 static struct xtables_match policy_mt_reg[] = {
 	{
 		.name          = "policy",
@@ -389,6 +414,7 @@ static struct xtables_match policy_mt_reg[] = {
 		.print         = policy4_print,
 		.save          = policy4_save,
 		.x6_options    = policy_opts,
+		.xlate         = policy_xlate,
 	},
 	{
 		.name          = "policy",
@@ -402,6 +428,7 @@ static struct xtables_match policy_mt_reg[] = {
 		.print         = policy6_print,
 		.save          = policy6_save,
 		.x6_options    = policy_opts,
+		.xlate         = policy_xlate,
 	},
 };
 
diff --git a/extensions/libxt_policy.txlate b/extensions/libxt_policy.txlate
new file mode 100644
index 00000000..66788a76
--- /dev/null
+++ b/extensions/libxt_policy.txlate
@@ -0,0 +1,5 @@
+iptables-translate -A INPUT -m policy --pol ipsec --dir in
+nft add rule ip filter INPUT meta secpath exists counter
+
+iptables-translate -A INPUT -m policy --pol none --dir in
+nft add rule ip filter INPUT meta secpath missing counter
-- 
2.14.3

