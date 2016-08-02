From: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Subject: [PATCH iptables] xtables-compat: fix comments listing
Date: Tue,  2 Aug 2016 16:29:47 +0200
Message-ID: <20160802142947.1388-1-pablombg@gmail.com>
Cc: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34411 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933719AbcHBQjg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Aug 2016 12:39:36 -0400
Received: by mail-wm0-f67.google.com with SMTP id q128so31892989wma.1
        for <netfilter-devel@vger.kernel.org>; Tue, 02 Aug 2016 09:39:35 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ip[6]tables-compat -L was not printing the comments since commit
d64ef34a9961 ("iptables-compat: use nft built-in comments support").

This patch solves the issue.

Signed-off-by: Pablo M. Bermudo Garay <pablombg@gmail.com>
---
 iptables/nft-shared.c | 26 ++++++++++++++++++++++++++
 iptables/nft.c        | 32 ++++++++++++++++++++++++++++++++
 iptables/nft.h        |  1 +
 3 files changed, 59 insertions(+)

diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 4007cbc..68e5c55 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -525,6 +525,32 @@ void nft_rule_to_iptables_command_state(struct nftnl_rule *r,
 
 	nftnl_expr_iter_destroy(iter);
 
+	if (nftnl_rule_is_set(r, NFTNL_RULE_USERDATA)) {
+		const void *data;
+		uint32_t len;
+		struct xtables_match *match;
+		struct xt_entry_match *m;
+
+		data = nftnl_rule_get_data(r, NFTNL_RULE_USERDATA, &len);
+		match = xtables_find_match("comment", XTF_TRY_LOAD,
+					   &cs->matches);
+		if (match == NULL)
+			return;
+
+		m = calloc(1, sizeof(struct xt_entry_match) + len);
+		if (m == NULL) {
+			fprintf(stderr, "OOM");
+			exit(EXIT_FAILURE);
+		}
+
+		memcpy(&m->data, get_comment(data, len), len);
+		m->u.match_size = len + XT_ALIGN(sizeof(struct xt_entry_match));
+		m->u.user.revision = 0;
+		strcpy(m->u.user.name, match->name);
+
+		match->m = m;
+	}
+
 	if (cs->target != NULL)
 		cs->jumpto = cs->target->name;
 	else if (cs->jumpto != NULL)
diff --git a/iptables/nft.c b/iptables/nft.c
index 65ca2b4..e385293 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1034,6 +1034,38 @@ int add_comment(struct nftnl_rule *r, const char *comment)
 	return 0;
 }
 
+static int parse_udata_cb(const struct nftnl_udata *attr, void *data)
+{
+	unsigned char *value = nftnl_udata_get(attr);
+	uint8_t type = nftnl_udata_type(attr);
+	uint8_t len = nftnl_udata_len(attr);
+	const struct nftnl_udata **tb = data;
+
+	switch (type) {
+	case UDATA_TYPE_COMMENT:
+		if (value[len - 1] != '\0')
+			return -1;
+		break;
+	default:
+		return 0;
+	}
+	tb[type] = attr;
+	return 0;
+}
+
+char *get_comment(const void *data, uint32_t data_len)
+{
+	const struct nftnl_udata *tb[UDATA_TYPE_MAX + 1] = {};
+
+	if (nftnl_udata_parse(data, data_len, parse_udata_cb, tb) < 0)
+		return NULL;
+
+	if (!tb[UDATA_TYPE_COMMENT])
+		return NULL;
+
+	return nftnl_udata_get(tb[UDATA_TYPE_COMMENT]);
+}
+
 void add_compat(struct nftnl_rule *r, uint32_t proto, bool inv)
 {
 	nftnl_rule_set_u32(r, NFTNL_RULE_COMPAT_PROTO, proto);
diff --git a/iptables/nft.h b/iptables/nft.h
index 8867434..52f2136 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -105,6 +105,7 @@ int add_target(struct nftnl_rule *r, struct xt_entry_target *t);
 int add_jumpto(struct nftnl_rule *r, const char *name, int verdict);
 int add_action(struct nftnl_rule *r, struct iptables_command_state *cs, bool goto_set);
 int add_comment(struct nftnl_rule *r, const char *comment);
+char *get_comment(const void *data, uint32_t data_len);
 
 enum nft_rule_print {
 	NFT_RULE_APPEND,
-- 
2.9.2

