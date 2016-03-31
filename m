From: Guruswamy Basavaiah <guru2018@gmail.com>
Subject: [PATCH] iptables-translate: Moving printing of nft to individual
 commands.
Date: Thu, 31 Mar 2016 15:56:55 +0530
Message-ID: <20160331102654.GA14649@inbhdhcp21574.apac.nsn-net.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:35125 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbcCaK1A (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Mar 2016 06:27:00 -0400
Received: by mail-wm0-f45.google.com with SMTP id 191so120982163wmq.0
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Mar 2016 03:26:59 -0700 (PDT)
Received: from inbhdhcp21574.apac.nsn-net.net ([62.159.77.167])
        by smtp.gmail.com with ESMTPSA id e19sm24167128wmd.1.2016.03.31.03.26.57
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Thu, 31 Mar 2016 03:26:58 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Moving printing of "nft" to individual commands.

At present the "nft" is not printed, if iptables command is translated into
multiple commads.

Before this patch:
sudo ./iptables-translate -A INPUT --source "40.0.0.1, 30.0.0.1" --dest "20.0.0.1, 60.0.0.1" -j ACCEPT
nft add rule ip filter INPUT ip saddr 40.0.0.1 ip daddr 20.0.0.1 counter accept
add rule ip filter INPUT ip saddr 40.0.0.1 ip daddr 60.0.0.1 counter accept
add rule ip filter INPUT ip saddr 30.0.0.1 ip daddr 20.0.0.1 counter accept
add rule ip filter INPUT ip saddr 30.0.0.1 ip daddr 60.0.0.1 counter accept

After this patch:
sudo ./iptables-translate -A INPUT --source "40.0.0.1, 30.0.0.1" --dest "20.0.0.1, 60.0.0.1" -j ACCEPT
nft add rule ip filter INPUT ip saddr 40.0.0.1 ip daddr 20.0.0.1 counter accept
nft add rule ip filter INPUT ip saddr 40.0.0.1 ip daddr 60.0.0.1 counter accept
nft add rule ip filter INPUT ip saddr 30.0.0.1 ip daddr 20.0.0.1 counter accept
nft add rule ip filter INPUT ip saddr 30.0.0.1 ip daddr 60.0.0.1 counter accept

Signed-off-by: Guruswamy Basavaiah <guru2018@gmail.com>
---
 iptables/xtables-translate.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
index 354357c..569c26e 100644
--- a/iptables/xtables-translate.c
+++ b/iptables/xtables-translate.c
@@ -107,10 +107,10 @@ static int nft_rule_xlate_add(struct nft_handle *h,
 	int ret;
 
 	if (append) {
-		xt_xlate_add(xl, "add rule %s %s %s ",
+		xt_xlate_add(xl, "nft add rule %s %s %s ",
 			   family2str[h->family], p->table, p->chain);
 	} else {
-		xt_xlate_add(xl, "insert rule %s %s %s ",
+		xt_xlate_add(xl, "nft insert rule %s %s %s ",
 			   family2str[h->family], p->table, p->chain);
 	}
 
@@ -193,7 +193,6 @@ static int do_command_xlate(struct nft_handle *h, int argc, char *argv[],
 
 	do_parse(h, argc, argv, &p, &cs, &args);
 
-	printf("nft ");
 	switch (p.command) {
 	case CMD_APPEND:
 		ret = 1;
@@ -217,10 +216,10 @@ static int do_command_xlate(struct nft_handle *h, int argc, char *argv[],
 		break;
 	case CMD_FLUSH:
 		if (p.chain) {
-			printf("flush chain %s %s %s\n",
+			printf("nft flush chain %s %s %s\n",
 				family2str[h->family], p.table, p.chain);
 		} else {
-			printf("flush table %s %s\n",
+			printf("nft flush table %s %s\n",
 				family2str[h->family], p.table);
 		}
 		ret = 1;
@@ -232,7 +231,7 @@ static int do_command_xlate(struct nft_handle *h, int argc, char *argv[],
 	case CMD_LIST:
 	case CMD_LIST|CMD_ZERO:
 	case CMD_LIST|CMD_ZERO_NUM:
-		printf("list table %s %s\n",
+		printf("nft list table %s %s\n",
 		       family2str[h->family], p.table);
 		ret = 1;
 		break;
@@ -241,12 +240,12 @@ static int do_command_xlate(struct nft_handle *h, int argc, char *argv[],
 	case CMD_LIST_RULES|CMD_ZERO_NUM:
 		break;
 	case CMD_NEW_CHAIN:
-		printf("add chain %s %s %s\n",
+		printf("nft add chain %s %s %s\n",
 		       family2str[h->family], p.table, p.chain);
 		ret = 1;
 		break;
 	case CMD_DELETE_CHAIN:
-		printf("delete chain %s %s %s\n",
+		printf("nft delete chain %s %s %s\n",
 		       family2str[h->family], p.table, p.chain);
 		ret = 1;
 		break;
-- 
2.5.0

