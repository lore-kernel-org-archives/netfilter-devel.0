From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH v2] extensions: libxt_pkttype: Add translation to nft
Date: Fri, 25 Dec 2015 20:37:33 +0530
Message-ID: <20151225150733.GA3105@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f169.google.com ([209.85.192.169]:36165 "EHLO
	mail-pf0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048AbbLYPHk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Dec 2015 10:07:40 -0500
Received: by mail-pf0-f169.google.com with SMTP id 65so36946787pff.3
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Dec 2015 07:07:40 -0800 (PST)
Received: from gmail.com ([106.204.178.37])
        by smtp.gmail.com with ESMTPSA id t85sm60225381pfa.34.2015.12.25.07.07.37
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Fri, 25 Dec 2015 07:07:38 -0800 (PST)
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
Changes in v2:
	Add new structure to remove unneeded parameters

 extensions/libxt_pkttype.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/extensions/libxt_pkttype.c b/extensions/libxt_pkttype.c
index 1ed3b44..9dff248 100644
--- a/extensions/libxt_pkttype.c
+++ b/extensions/libxt_pkttype.c
@@ -21,6 +21,11 @@ struct pkttypes {
 	const char *help;
 };
 
+struct pkttypes_xlate {
+	const char *name;
+	unsigned char pkttype;
+};
+
 static const struct pkttypes supported_types[] = {
 	{"unicast", PACKET_HOST, 1, "to us"},
 	{"broadcast", PACKET_BROADCAST, 1, "to all"},
@@ -115,6 +120,37 @@ static void pkttype_save(const void *ip, const struct xt_entry_match *match)
 	print_pkttype(info);
 }
 
+static const struct pkttypes_xlate supported_types_xlate[] = {
+	{"unicast",	PACKET_HOST},
+	{"broadcast",	PACKET_BROADCAST},
+	{"multicast",	PACKET_MULTICAST},
+};
+
+static void print_pkttype_xlate(const struct xt_pkttype_info *info,
+				struct xt_buf *buf)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(supported_types_xlate); ++i)
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
@@ -126,6 +162,7 @@ static struct xtables_match pkttype_match = {
 	.save		= pkttype_save,
 	.x6_parse	= pkttype_parse,
 	.x6_options	= pkttype_opts,
+	.xlate		= pkttype_xlate,
 };
 
 void _init(void)
-- 
1.9.1

