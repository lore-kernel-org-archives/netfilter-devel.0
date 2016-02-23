From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH] comment: Add translation to nft
Date: Wed, 24 Feb 2016 01:19:34 +0530
Message-ID: <20160223194934.GA19483@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:36567 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754796AbcBWTtl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Feb 2016 14:49:41 -0500
Received: by mail-pa0-f44.google.com with SMTP id yy13so115351322pab.3
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Feb 2016 11:49:41 -0800 (PST)
Received: from gmail.com ([106.215.170.91])
        by smtp.gmail.com with ESMTPSA id m16sm45953400pfi.75.2016.02.23.11.49.38
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Tue, 23 Feb 2016 11:49:39 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for match comment to nftables.
This patch also adds the relevant infrastructure for carrying out
the translation.

Example:

$ sudo iptables-translate -A INPUT -s 192.168.0.0 -m comment --comment "A privatized IP block"
nft add rule ip filter INPUT ip saddr 192.168.0.0 counter comment \"A privatized IP block\"

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 extensions/libxt_comment.c | 13 +++++++++++++
 include/xtables.h          |  1 +
 iptables/nft-ipv4.c        |  6 ++++++
 iptables/nft-ipv6.c        |  6 ++++++
 libxtables/xtables.c       |  5 +++++
 5 files changed, 31 insertions(+)

diff --git a/extensions/libxt_comment.c b/extensions/libxt_comment.c
index 6ed2ff9..464ca09 100644
--- a/extensions/libxt_comment.c
+++ b/extensions/libxt_comment.c
@@ -48,6 +48,18 @@ comment_save(const void *ip, const struct xt_entry_match *match)
 	xtables_save_string(commentinfo->comment);
 }
 
+static int
+comment_xlate(const struct xt_entry_match *match,
+	      struct xt_xlate *xl, int numeric)
+{
+	struct xt_comment_info *commentinfo = (void *)match->data;
+
+	commentinfo->comment[XT_MAX_COMMENT_LEN-1] = '\0';
+        xt_xlate_add_comment(xl, commentinfo->comment);
+
+	return 1;
+}
+
 static struct xtables_match comment_match = {
 	.family		= NFPROTO_UNSPEC,
 	.name		= "comment",
@@ -59,6 +71,7 @@ static struct xtables_match comment_match = {
 	.save 		= comment_save,
 	.x6_parse	= xtables_option_parse,
 	.x6_options	= comment_opts,
+	.xlate		= comment_xlate,
 };
 
 void _init(void)
diff --git a/include/xtables.h b/include/xtables.h
index 6fd3bdf..e219c9f 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -574,6 +574,7 @@ struct xt_xlate *xt_xlate_alloc(int size);
 void xt_xlate_free(struct xt_xlate *xl);
 void xt_xlate_add(struct xt_xlate *xl, const char *fmt, ...);
 void xt_xlate_add_comment(struct xt_xlate *xl, const char *comment);
+const char *xt_xlate_get_comment(struct xt_xlate *xl);
 const char *xt_xlate_get(struct xt_xlate *xl);
 
 #ifdef XTABLES_INTERNAL
diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index 5e2857d..3c41755 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -433,6 +433,7 @@ static int nft_ipv4_xlate(const void *data, struct xt_xlate *xl)
 {
 	const struct iptables_command_state *cs = data;
 	int ret;
+	const char *comment;
 
 	if (cs->fw.ip.iniface[0] != '\0') {
 		xt_xlate_add(xl, "iifname %s%s ",
@@ -484,6 +485,11 @@ static int nft_ipv4_xlate(const void *data, struct xt_xlate *xl)
 	/* Always add counters per rule, as in iptables */
 	xt_xlate_add(xl, "counter ");
 
+	comment = xt_xlate_get_comment(xl);
+
+	if (strcmp(comment, ""))
+		xt_xlate_add(xl, "comment \\\"%s\\\" ", comment);
+
 	ret = xlate_action(cs, !!(cs->fw.ip.flags & IPT_F_GOTO), xl);
 
 	return ret;
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index bbf289b..8912f1d 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -393,6 +393,7 @@ static int nft_ipv6_xlate(const void *data, struct xt_xlate *xl)
 {
 	const struct iptables_command_state *cs = data;
 	int ret;
+	const char *comment;
 
 	if (cs->fw6.ipv6.iniface[0] != '\0') {
 		xt_xlate_add(xl, "iifname %s%s ",
@@ -435,6 +436,11 @@ static int nft_ipv6_xlate(const void *data, struct xt_xlate *xl)
 	/* Always add counters per rule, as in iptables */
 	xt_xlate_add(xl, "counter ");
 
+	comment = xt_xlate_get_comment(xl);
+
+	if (strcmp(comment, ""))
+		xt_xlate_add(xl, "comment \\\"%s\\\" ", comment);
+
 	ret = xlate_action(cs, !!(cs->fw6.ipv6.flags & IP6T_F_GOTO), xl);
 
 	return ret;
diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index c4b86f5..decd7be 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -2045,6 +2045,11 @@ void xt_xlate_add_comment(struct xt_xlate *xl, const char *comment)
 	xl->comment[NFT_USERDATA_MAXLEN - 1] = '\0';
 }
 
+const char *xt_xlate_get_comment(struct xt_xlate *xl)
+{
+	return xl->comment;
+}
+
 const char *xt_xlate_get(struct xt_xlate *xl)
 {
 	return xl->buf.data;
-- 
1.9.1

