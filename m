From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH] comment: Add translation to nft
Date: Tue, 16 Feb 2016 01:40:28 +0530
Message-ID: <20160215201027.GA13257@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:35431 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbcBOULG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Feb 2016 15:11:06 -0500
Received: by mail-pa0-f41.google.com with SMTP id ho8so91476812pac.2
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Feb 2016 12:11:06 -0800 (PST)
Received: from gmail.com ([116.202.38.191])
        by smtp.gmail.com with ESMTPSA id r62sm25684431pfr.26.2016.02.15.12.11.03
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Mon, 15 Feb 2016 12:11:05 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for match comment to nftables.

Example:

$ sudo iptables-translate -A INPUT -s 192.168.0.0 -m comment --comment "A privatized IP block"
nft add rule ip filter INPUT ip saddr 192.168.0.0 counter comment \"A privatized IP block\"

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 extensions/libxt_comment.c | 14 ++++++++++++++
 iptables/nft-ipv4.c        | 17 +++++++++++++++--
 iptables/nft-ipv6.c        | 17 +++++++++++++++--
 3 files changed, 44 insertions(+), 4 deletions(-)

diff --git a/extensions/libxt_comment.c b/extensions/libxt_comment.c
index 6ed2ff9..0461924 100644
--- a/extensions/libxt_comment.c
+++ b/extensions/libxt_comment.c
@@ -48,6 +48,19 @@ comment_save(const void *ip, const struct xt_entry_match *match)
 	xtables_save_string(commentinfo->comment);
 }
 
+static int
+comment_xlate(const struct xt_entry_match *match,
+	      struct xt_xlate *xl, int numeric)
+{
+	struct xt_comment_info *commentinfo = (void *)match->data;
+
+	commentinfo->comment[XT_MAX_COMMENT_LEN-1] = '\0';
+	xt_xlate_add_comment(xl, commentinfo->comment);
+	xt_xlate_add(xl, "comment \\\"%s\\\" ", commentinfo->comment);
+
+	return 1;
+}
+
 static struct xtables_match comment_match = {
 	.family		= NFPROTO_UNSPEC,
 	.name		= "comment",
@@ -59,6 +72,7 @@ static struct xtables_match comment_match = {
 	.save 		= comment_save,
 	.x6_parse	= xtables_option_parse,
 	.x6_options	= comment_opts,
+	.xlate		= comment_xlate,
 };
 
 void _init(void)
diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index 5e2857d..f816a8a 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -433,6 +433,7 @@ static int nft_ipv4_xlate(const void *data, struct xt_xlate *xl)
 {
 	const struct iptables_command_state *cs = data;
 	int ret;
+	bool comm = false;
 
 	if (cs->fw.ip.iniface[0] != '\0') {
 		xt_xlate_add(xl, "iifname %s%s ",
@@ -477,12 +478,24 @@ static int nft_ipv4_xlate(const void *data, struct xt_xlate *xl)
 			   inet_ntoa(cs->fw.ip.dst));
 	}
 
+	/*
+	 * Add counter for match comment as prefix
+	 */
+	if (strcmp(cs->matches->match->name, "comment") == 0) {
+		comm = true;
+		xt_xlate_add(xl, "counter ");
+	}
+
 	ret = xlate_matches(cs, xl);
 	if (!ret)
 		return ret;
 
-	/* Always add counters per rule, as in iptables */
-	xt_xlate_add(xl, "counter ");
+	/*
+	 * Always add counters per rule, as in iptables
+	 * except for match comment
+	 */
+	if (!comm)
+		xt_xlate_add(xl, "counter ");
 
 	ret = xlate_action(cs, !!(cs->fw.ip.flags & IPT_F_GOTO), xl);
 
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index 0ee7957..edc572c 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -393,6 +393,7 @@ static int nft_ipv6_xlate(const void *data, struct xt_xlate *xl)
 {
 	const struct iptables_command_state *cs = data;
 	int ret;
+	bool comm = false;
 
 	if (cs->fw6.ipv6.iniface[0] != '\0') {
 		xt_xlate_add(xl, "iifname %s%s ",
@@ -428,12 +429,24 @@ static int nft_ipv6_xlate(const void *data, struct xt_xlate *xl)
 	xlate_ipv6_addr("ip6 daddr", &cs->fw6.ipv6.dst,
 			cs->fw6.ipv6.invflags & IP6T_INV_DSTIP, xl);
 
+	/*
+	 * Add counter as prefix for match comment
+	 */
+	if (strcmp(cs->matches->match->name, "comment") == 0) {
+		comm = true;
+		xt_xlate_add(xl, "counter ");
+	}
+
 	ret = xlate_matches(cs, xl);
 	if (!ret)
 		return ret;
 
-	/* Always add counters per rule, as in iptables */
-	xt_xlate_add(xl, "counter ");
+	/*
+	 * Always add counters per rule, as in iptables
+	 * except for match comment
+	 */
+	if (!comm)
+		xt_xlate_add(xl, "counter ");
 
 	ret = xlate_action(cs, !!(cs->fw6.ipv6.flags & IP6T_F_GOTO), xl);
 
-- 
1.9.1

