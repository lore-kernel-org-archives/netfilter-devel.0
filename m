From: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Subject: [PATCH iptables] iptables-compat: use nft built-in comments support
Date: Wed, 22 Jun 2016 19:07:01 +0200
Message-ID: <20160622170701.3399-1-pablombg@gmail.com>
Cc: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36759 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500AbcFVRIC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Jun 2016 13:08:02 -0400
Received: by mail-wm0-f66.google.com with SMTP id c82so3158802wme.3
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2016 10:07:55 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

After this patch, iptables-compat uses nft built-in comments support
instead of comment match.

This change simplifies the treatment of comments in nft after load a
rule set through iptables-compat-restore.

Signed-off-by: Pablo M. Bermudo Garay <pablombg@gmail.com>
---
 iptables/nft-ipv4.c | 13 +++++++++++--
 iptables/nft-ipv6.c | 13 +++++++++++--
 iptables/nft.c      | 26 ++++++++++++++++++++++++++
 iptables/nft.h      |  1 +
 4 files changed, 49 insertions(+), 4 deletions(-)

diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index cf985b7..814ca14 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -31,6 +31,7 @@ static int nft_ipv4_add(struct nftnl_rule *r, void *data)
 	struct iptables_command_state *cs = data;
 	struct xtables_rule_match *matchp;
 	uint32_t op;
+	int ret;
 
 	if (cs->fw.ip.iniface[0] != '\0') {
 		op = nft_invflags2cmp(cs->fw.ip.invflags, IPT_INV_VIA_IN);
@@ -74,8 +75,16 @@ static int nft_ipv4_add(struct nftnl_rule *r, void *data)
 	add_compat(r, cs->fw.ip.proto, cs->fw.ip.invflags);
 
 	for (matchp = cs->matches; matchp; matchp = matchp->next) {
-		if (add_match(r, matchp->match->m) < 0)
-			break;
+		/* Use nft built-in comments support instead of comment match */
+		if (strcmp(matchp->match->name, "comment") == 0) {
+			ret = add_comment(r, (char *)matchp->match->m->data);
+			if (ret < 0)
+				return ret;
+		} else {
+			ret = add_match(r, matchp->match->m);
+			if (ret < 0)
+				return ret;
+		}
 	}
 
 	/* Counters need to me added before the target, otherwise they are
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index 1150118..bfbf8df 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -30,6 +30,7 @@ static int nft_ipv6_add(struct nftnl_rule *r, void *data)
 	struct iptables_command_state *cs = data;
 	struct xtables_rule_match *matchp;
 	uint32_t op;
+	int ret;
 
 	if (cs->fw6.ipv6.iniface[0] != '\0') {
 		op = nft_invflags2cmp(cs->fw6.ipv6.invflags, IPT_INV_VIA_IN);
@@ -62,8 +63,16 @@ static int nft_ipv6_add(struct nftnl_rule *r, void *data)
 	add_compat(r, cs->fw6.ipv6.proto, cs->fw6.ipv6.invflags);
 
 	for (matchp = cs->matches; matchp; matchp = matchp->next) {
-		if (add_match(r, matchp->match->m) < 0)
-			break;
+		/* Use nft built-in comments support instead of comment match */
+		if (strcmp(matchp->match->name, "comment") == 0) {
+			ret = add_comment(r, (char *)matchp->match->m->data);
+			if (ret < 0)
+				return ret;
+		} else {
+			ret = add_match(r, matchp->match->m);
+			if (ret < 0)
+				return ret;
+		}
 	}
 
 	/* Counters need to me added before the target, otherwise they are
diff --git a/iptables/nft.c b/iptables/nft.c
index 68b4da3..c81bb0e 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -43,6 +43,7 @@
 #include <libnftnl/rule.h>
 #include <libnftnl/expr.h>
 #include <libnftnl/set.h>
+#include <libnftnl/udata.h>
 
 #include <netinet/in.h>	/* inet_ntoa */
 #include <arpa/inet.h>
@@ -1007,6 +1008,31 @@ int add_counters(struct nftnl_rule *r, uint64_t packets, uint64_t bytes)
 	return 0;
 }
 
+enum udata_type {
+	UDATA_TYPE_COMMENT,
+	__UDATA_TYPE_MAX,
+};
+#define UDATA_TYPE_MAX (__UDATA_TYPE_MAX - 1)
+
+int add_comment(struct nftnl_rule *r, const char *comment)
+{
+	struct nftnl_udata_buf *udata;
+
+	udata = nftnl_udata_buf_alloc(NFT_USERDATA_MAXLEN);
+	if (!udata)
+		return -ENOMEM;
+
+	if (!nftnl_udata_put_strz(udata, UDATA_TYPE_COMMENT, comment))
+		return -ENOMEM;
+	nftnl_rule_set_data(r, NFTNL_RULE_USERDATA,
+			    nftnl_udata_buf_data(udata),
+			    nftnl_udata_buf_len(udata));
+
+	nftnl_udata_buf_free(udata);
+
+	return 0;
+}
+
 void add_compat(struct nftnl_rule *r, uint32_t proto, bool inv)
 {
 	nftnl_rule_set_u32(r, NFTNL_RULE_COMPAT_PROTO, proto);
diff --git a/iptables/nft.h b/iptables/nft.h
index 281e1c6..9e02eeb 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -104,6 +104,7 @@ int add_match(struct nftnl_rule *r, struct xt_entry_match *m);
 int add_target(struct nftnl_rule *r, struct xt_entry_target *t);
 int add_jumpto(struct nftnl_rule *r, const char *name, int verdict);
 int add_action(struct nftnl_rule *r, struct iptables_command_state *cs, bool goto_set);
+int add_comment(struct nftnl_rule *r, const char *comment);
 
 enum nft_rule_print {
 	NFT_RULE_APPEND,
-- 
2.9.0

