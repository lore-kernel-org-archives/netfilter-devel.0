From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH 1/2] iptables: nft-ipv4: Remove suffix counter for comment
 module
Date: Tue, 22 Dec 2015 15:48:07 +0530
Message-ID: <da7c549c15f0f4c329f48367e7851ae29f8a143f.1450779140.git.shivanib134@gmail.com>
References: <cover.1450779140.git.shivanib134@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:34217 "EHLO
	mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932181AbbLVKSO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Dec 2015 05:18:14 -0500
Received: by mail-pf0-f181.google.com with SMTP id u7so57942970pfb.1
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2015 02:18:14 -0800 (PST)
Received: from gmail.com ([171.50.109.40])
        by smtp.gmail.com with ESMTPSA id v16sm40274882pfi.94.2015.12.22.02.18.11
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Tue, 22 Dec 2015 02:18:13 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <cover.1450779140.git.shivanib134@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Remove the counter as suffix for comment module as it should be used as
prefix for this case.

Example:

$ sudo nft add rule ip filter INPUT comment \"random comment\" counter
throws Error: syntax error, unexpected comment

$ sudo nft add rule ip filter INPUT counter comment \"random comment\"
gets accepted as a legit rule in nftables

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 iptables/nft-ipv4.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index f59f630..60720e0 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -100,7 +100,8 @@ static bool nft_ipv4_is_same(const void *data_a,
 	return is_same_interfaces(a->fw.ip.iniface, a->fw.ip.outiface,
 				  a->fw.ip.iniface_mask, a->fw.ip.outiface_mask,
 				  b->fw.ip.iniface, b->fw.ip.outiface,
-				  b->fw.ip.iniface_mask, b->fw.ip.outiface_mask);
+				  b->fw.ip.iniface_mask,
+				  b->fw.ip.outiface_mask);
 }
 
 static void get_frag(struct nft_rule_expr_iter *iter, bool *inv)
@@ -180,7 +181,7 @@ static void nft_ipv4_parse_payload(struct nft_rule_expr_iter *iter,
 {
 	struct iptables_command_state *cs = data;
 
-	switch(offset) {
+	switch (offset) {
 	struct in_addr addr;
 	uint8_t proto;
 	bool inv;
@@ -235,26 +236,26 @@ static void print_ipv4_addr(const struct iptables_command_state *cs,
 
 	fputc(cs->fw.ip.invflags & IPT_INV_SRCIP ? '!' : ' ', stdout);
 	if (cs->fw.ip.smsk.s_addr == 0L && !(format & FMT_NUMERIC))
-		printf(FMT("%-19s ","%s "), "anywhere");
+		printf(FMT("%-19s ", "%s "), "anywhere");
 	else {
 		if (format & FMT_NUMERIC)
 			strcpy(buf, xtables_ipaddr_to_numeric(&cs->fw.ip.src));
 		else
 			strcpy(buf, xtables_ipaddr_to_anyname(&cs->fw.ip.src));
 		strcat(buf, xtables_ipmask_to_numeric(&cs->fw.ip.smsk));
-		printf(FMT("%-19s ","%s "), buf);
+		printf(FMT("%-19s ", "%s "), buf);
 	}
 
 	fputc(cs->fw.ip.invflags & IPT_INV_DSTIP ? '!' : ' ', stdout);
 	if (cs->fw.ip.dmsk.s_addr == 0L && !(format & FMT_NUMERIC))
-		printf(FMT("%-19s ","-> %s"), "anywhere");
+		printf(FMT("%-19s ", "-> %s"), "anywhere");
 	else {
 		if (format & FMT_NUMERIC)
 			strcpy(buf, xtables_ipaddr_to_numeric(&cs->fw.ip.dst));
 		else
 			strcpy(buf, xtables_ipaddr_to_anyname(&cs->fw.ip.dst));
 		strcat(buf, xtables_ipmask_to_numeric(&cs->fw.ip.dmsk));
-		printf(FMT("%-19s ","-> %s"), buf);
+		printf(FMT("%-19s ", "-> %s"), buf);
 	}
 }
 
@@ -422,13 +423,13 @@ static int nft_ipv4_xlate(const void *data, struct xt_buf *buf)
 	}
 	if (cs->fw.ip.outiface[0] != '\0') {
 		xt_buf_add(buf, "oifname %s%s ",
-			   cs->fw.ip.invflags & IPT_INV_VIA_OUT? "!= " : "",
+			   cs->fw.ip.invflags & IPT_INV_VIA_OUT ? "!= " : "",
 			   cs->fw.ip.outiface);
 	}
 
 	if (cs->fw.ip.flags & IPT_F_FRAG) {
 		xt_buf_add(buf, "ip frag-off %s%x ",
-			   cs->fw.ip.invflags & IPT_INV_FRAG? "" : "!= ", 0);
+			   cs->fw.ip.invflags & IPT_INV_FRAG ? "" : "!= ", 0);
 	}
 
 	if (cs->fw.ip.proto != 0) {
@@ -462,8 +463,12 @@ static int nft_ipv4_xlate(const void *data, struct xt_buf *buf)
 	if (!ret)
 		return ret;
 
-	/* Always add counters per rule, as in iptables */
-	xt_buf_add(buf, "counter ");
+	/*
+	 * Always add counters as suffix per rule as in iptables
+	 * except for comment where it should be prefix
+	 */
+	if (strcmp(cs->matches->match->name, "comment"))
+		xt_buf_add(buf, "counter ");
 
 	ret = xlate_action(cs, !!(cs->fw.ip.flags & IPT_F_GOTO), buf);
 
-- 
1.9.1

