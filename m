From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH] extensions: libxt_pkttype: Add translation to nft
Date: Wed, 23 Dec 2015 23:00:25 +0530
Message-ID: <20151223173024.GA2450@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:34262 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933078AbbLWRab (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Dec 2015 12:30:31 -0500
Received: by mail-pa0-f49.google.com with SMTP id uo6so30989824pac.1
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Dec 2015 09:30:31 -0800 (PST)
Received: from gmail.com ([223.176.154.121])
        by smtp.gmail.com with ESMTPSA id wo3sm53936566pab.25.2015.12.23.09.30.28
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Wed, 23 Dec 2015 09:30:30 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for packet type to nftables.

Examples:

$ sudo iptables-translate -A INPUT -m pkttype --pkt-type broadcast -j DROP
nft add rule ip filter INPUT pkttype broadcast counter drop

$ sudo iptables-translate -A INPUT -m pkttype ! --pkt-type unicast -j DROP
nft add rule ip filter INPUT pkttype != unicast counter drop

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 extensions/libxt_pkttype.c | 36 ++++++++++++++++++++++++++++++++++--
 1 file changed, 34 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_pkttype.c b/extensions/libxt_pkttype.c
index 1ed3b44..6b91e8a 100644
--- a/extensions/libxt_pkttype.c
+++ b/extensions/libxt_pkttype.c
@@ -102,7 +102,7 @@ static void pkttype_print(const void *ip, const struct xt_entry_match *match,
                           int numeric)
 {
 	const struct xt_pkttype_info *info = (const void *)match->data;
-	
+
 	printf(" PKTTYPE %s= ", info->invert ? "!" : "");
 	print_pkttype(info);
 }
@@ -110,11 +110,42 @@ static void pkttype_print(const void *ip, const struct xt_entry_match *match,
 static void pkttype_save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct xt_pkttype_info *info = (const void *)match->data;
-	
+
 	printf("%s --pkt-type ", info->invert ? " !" : "");
 	print_pkttype(info);
 }
 
+static const struct pkttypes supported_types_xlate[] = {
+	{"unicast", PACKET_HOST, 1, "to us"},
+	{"broadcast", PACKET_BROADCAST, 1, "to all"},
+	{"multicast", PACKET_MULTICAST, 1, "to group"},
+	};
+
+static void print_pkttype_xlate(const struct xt_pkttype_info *info,
+				struct xt_buf *buf)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(supported_types); ++i)
+		if (supported_types_xlate[i].pkttype == info->pkttype) {
+			xt_buf_add(buf, "%s ", supported_types_xlate[i].name);
+			return;
+		}
+
+	xt_buf_add(buf, "%d", info->pkttype);
+}
+
+static int pkttype_xlate(const struct xt_entry_match *match,
+			  struct xt_buf *buf, int numeric)
+{
+	const struct xt_pkttype_info *info = (const void *)match->data;
+
+	xt_buf_add(buf, "pkttype%s ", info->invert ? " !=" : "");
+	print_pkttype_xlate(info, buf);
+
+	return 1;
+}
+
 static struct xtables_match pkttype_match = {
 	.family		= NFPROTO_UNSPEC,
 	.name		= "pkttype",
@@ -126,6 +157,7 @@ static struct xtables_match pkttype_match = {
 	.save		= pkttype_save,
 	.x6_parse	= pkttype_parse,
 	.x6_options	= pkttype_opts,
+	.xlate		= pkttype_xlate,
 };
 
 void _init(void)
-- 
1.9.1

