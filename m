From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH] extensions: libxt_mac: Add translation to nft
Date: Tue, 22 Dec 2015 18:06:17 +0530
Message-ID: <20151222123617.GA8413@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:35900 "EHLO
	mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476AbbLVMgY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Dec 2015 07:36:24 -0500
Received: by mail-pf0-f182.google.com with SMTP id o64so105943594pfb.3
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2015 04:36:23 -0800 (PST)
Received: from gmail.com ([171.50.109.40])
        by smtp.gmail.com with ESMTPSA id d26sm17166760pfb.22.2015.12.22.04.36.21
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Tue, 22 Dec 2015 04:36:22 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for module mac to nftables.

Examples:

$ sudo iptables-translate -A INPUT -m mac --mac-source 0a:12:3e:4f:b2:c6 -j DROP
nft add rule ip filter INPUT  ether saddr 0A:12:3E:4F:B2:C6 counter drop

$ sudo iptables-translate -A INPUT -p tcp --dport 80 -m mac --mac-source 0a:12:3e:4f:b2:c6 -j ACCEPT
nft add rule ip filter INPUT tcp dport 80  ether saddr 0A:12:3E:4F:B2:C6 counter accept

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 extensions/libxt_mac.c | 31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_mac.c b/extensions/libxt_mac.c
index f171d15..8aae700 100644
--- a/extensions/libxt_mac.c
+++ b/extensions/libxt_mac.c
@@ -50,11 +50,12 @@ static void
 mac_print(const void *ip, const struct xt_entry_match *match, int numeric)
 {
 	const struct xt_mac_info *info = (void *)match->data;
+
 	printf(" MAC");
 
 	if (info->invert)
 		printf(" !");
-	
+
 	print_mac(info->srcaddr);
 }
 
@@ -69,9 +70,34 @@ static void mac_save(const void *ip, const struct xt_entry_match *match)
 	print_mac(info->srcaddr);
 }
 
+static void print_mac_xlate(const unsigned char *macaddress,
+			    struct xt_buf *buf)
+{
+	unsigned int i;
+
+	xt_buf_add(buf, " %02X", macaddress[0]);
+	for (i = 1; i < ETH_ALEN; ++i)
+		xt_buf_add(buf, ":%02X", macaddress[i]);
+	xt_buf_add(buf, " ");
+}
+
+static int mac_xlate(const struct xt_entry_match *match,
+		     struct xt_buf *buf, int numeric)
+{
+	const struct xt_mac_info *info = (void *)match->data;
+
+	if (info->invert)
+		xt_buf_add(buf, " !=");
+
+	xt_buf_add(buf, " ether saddr");
+	print_mac_xlate(info->srcaddr, buf);
+
+	return 1;
+}
+
 static struct xtables_match mac_match = {
 	.family		= NFPROTO_UNSPEC,
- 	.name		= "mac",
+	.name		= "mac",
 	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_mac_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_mac_info)),
@@ -80,6 +106,7 @@ static struct xtables_match mac_match = {
 	.print		= mac_print,
 	.save		= mac_save,
 	.x6_options	= mac_opts,
+	.xlate		= mac_xlate,
 };
 
 void _init(void)
-- 
1.9.1

