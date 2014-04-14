From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5/5] extensions: libxt_state: add translation to nft
Date: Mon, 14 Apr 2014 12:41:06 +0200
Message-ID: <1397472066-13011-6-git-send-email-pablo@netfilter.org>
References: <1397472066-13011-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45240 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754721AbaDNKlS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2014 06:41:18 -0400
In-Reply-To: <1397472066-13011-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 extensions/libxt_conntrack.c |   38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index 128bbd2..4154464 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -1156,6 +1156,43 @@ static void state_save(const void *ip, const struct xt_entry_match *match)
 	state_print_state(sinfo->statemask);
 }
 
+static void state_xlate_print(struct xt_buf *buf, unsigned int statemask)
+{
+	const char *sep = "";
+
+	if (statemask & XT_CONNTRACK_STATE_INVALID) {
+		xt_buf_add(buf, "%s%s", sep, "invalid");
+		sep = ",";
+	}
+	if (statemask & XT_CONNTRACK_STATE_BIT(IP_CT_NEW)) {
+		xt_buf_add(buf, "%s%s", sep, "new");
+		sep = ",";
+	}
+	if (statemask & XT_CONNTRACK_STATE_BIT(IP_CT_RELATED)) {
+		xt_buf_add(buf, "%s%s", sep, "related");
+		sep = ",";
+	}
+	if (statemask & XT_CONNTRACK_STATE_BIT(IP_CT_ESTABLISHED)) {
+		xt_buf_add(buf, "%s%s", sep, "established");
+		sep = ",";
+	}
+	if (statemask & XT_CONNTRACK_STATE_UNTRACKED) {
+		xt_buf_add(buf, "%s%s", sep, "untracked");
+		sep = ",";
+	}
+}
+
+static int state_xlate(const struct xt_entry_match *match, struct xt_buf *buf)
+{
+	const struct xt_conntrack_mtinfo3 *sinfo = (const void *)match->data;
+
+	xt_buf_add(buf, "ct state %s", sinfo->invert_flags & XT_CONNTRACK_STATE ?
+					"!= " : "");
+	state_xlate_print(buf, sinfo->state_mask);
+	xt_buf_add(buf, " ");
+	return 1;
+}
+
 static struct xtables_match conntrack_mt_reg[] = {
 	{
 		.version       = XTABLES_VERSION,
@@ -1306,6 +1343,7 @@ static struct xtables_match conntrack_mt_reg[] = {
 		.save          = state_save,
 		.x6_parse      = state_ct23_parse,
 		.x6_options    = state_opts,
+		.xlate         = state_xlate,
 	},
 	{
 		.family        = NFPROTO_UNSPEC,
-- 
1.7.10.4

