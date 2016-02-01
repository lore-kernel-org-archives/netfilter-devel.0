From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH] comment: Add translation to nft
Date: Mon, 1 Feb 2016 11:31:52 +0530
Message-ID: <20160201060152.GA10787@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:32878 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbcBAGCA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Feb 2016 01:02:00 -0500
Received: by mail-pa0-f45.google.com with SMTP id cy9so76141409pac.0
        for <netfilter-devel@vger.kernel.org>; Sun, 31 Jan 2016 22:02:00 -0800 (PST)
Received: from gmail.com ([106.204.142.24])
        by smtp.gmail.com with ESMTPSA id tv6sm39923927pab.4.2016.01.31.22.01.57
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Sun, 31 Jan 2016 22:01:58 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for match comment to nftables.

Example:

$ sudo iptables-translate -A INPUT -s 192.168.0.0 -m comment --comment "A privatized IP block"
nft add rule ip filter INPUT ip saddr 192.168.0.0 counter comment \"A privatized IP block\"

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 extensions/libxt_comment.c | 13 +++++++++++++
 iptables/nft-ipv4.c        | 17 +++++++++++++++--
 2 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_comment.c b/extensions/libxt_comment.c
index 6ed2ff9..e80336c 100644
--- a/extensions/libxt_comment.c
+++ b/extensions/libxt_comment.c
@@ -48,6 +48,18 @@ comment_save(const void *ip, const struct xt_entry_match *match)
 	xtables_save_string(commentinfo->comment);
 }
 
+static int
+comment_xlate(const struct xt_entry_match *match,
+	      struct xt_buf *buf, int numeric)
+{
+	struct xt_comment_info *commentinfo = (void *)match->data;
+
+	commentinfo->comment[XT_MAX_COMMENT_LEN-1] = '\0';
+	xt_buf_add(buf, "comment \\\"%s\\\" ", commentinfo->comment);
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
diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index ede8f17..612b4f6 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -433,6 +433,7 @@ static int nft_ipv4_xlate(const void *data, struct xt_buf *buf)
 {
 	const struct iptables_command_state *cs = data;
 	int ret;
+	bool comm = false;
 
 	if (cs->fw.ip.iniface[0] != '\0') {
 		xt_buf_add(buf, "iifname %s%s ",
@@ -477,12 +478,24 @@ static int nft_ipv4_xlate(const void *data, struct xt_buf *buf)
 			   inet_ntoa(cs->fw.ip.dst));
 	}
 
+	/*
+	 * Add counter for match comment as prefix
+	 */
+	if (strcmp(cs->matches->match->name, "comment") == 0) {
+		comm = true;
+		xt_buf_add(buf, "counter ");
+	}
+
 	ret = xlate_matches(cs, buf);
 	if (!ret)
 		return ret;
 
-	/* Always add counters per rule, as in iptables */
-	xt_buf_add(buf, "counter ");
+	/*
+	 * Always add counters per rule, as in iptables
+	 * except for the match comment
+	 */
+	if (!comm)
+		xt_buf_add(buf, "counter ");
 
 	ret = xlate_action(cs, !!(cs->fw.ip.flags & IPT_F_GOTO), buf);
 
-- 
1.9.1

