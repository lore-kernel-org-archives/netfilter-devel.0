From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH] extensions: libxt_esp: Add translation to nft
Date: Sun, 20 Dec 2015 23:43:21 +0530
Message-ID: <20151220181321.GA15015@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:33400 "EHLO
	mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbbLTSN3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Dec 2015 13:13:29 -0500
Received: by mail-pf0-f196.google.com with SMTP id 127so6325391pfd.0
        for <netfilter-devel@vger.kernel.org>; Sun, 20 Dec 2015 10:13:29 -0800 (PST)
Received: from gmail.com ([223.176.168.0])
        by smtp.gmail.com with ESMTPSA id cn1sm29227254pad.11.2015.12.20.10.13.26
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Sun, 20 Dec 2015 10:13:27 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for ESP Protocol to nftables.

Examples:

$ sudo iptables-translate -A FORWARD -p esp -j ACCEPT
nft add rule ip filter FORWARD ip protocol esp counter accept

$ sudo iptables-translate -A INPUT  --in-interface  wan --protocol esp -j ACCEPT
nft add rule ip filter INPUT iifname wan ip protocol esp counter accept

$ sudo iptables-translate -A INPUT -p 50 -m esp --espspi 500 -j DROP
nft add rule ip filter INPUT  esp spi 500 counter drop

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 extensions/libxt_esp.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_esp.c b/extensions/libxt_esp.c
index 294338b..1c198c6 100644
--- a/extensions/libxt_esp.c
+++ b/extensions/libxt_esp.c
@@ -79,10 +79,28 @@ static void esp_save(const void *ip, const struct xt_entry_match *match)
 
 }
 
+static int esp_xlate(const struct xt_entry_match *match,
+		     struct xt_buf *buf, int numeric)
+{
+	const struct xt_esp *espinfo = (struct xt_esp *)match->data;
+
+	if (!(espinfo->spis[0] == 0 && espinfo->spis[1] == 0xFFFFFFFF)) {
+		xt_buf_add(buf, "%s esp spi ",
+			   (espinfo->invflags & XT_ESP_INV_SPI) ? " !=" : "");
+		if (espinfo->spis[0] != espinfo->spis[1])
+			xt_buf_add(buf, "%u:%u ", espinfo->spis[0],
+				   espinfo->spis[1]);
+		else
+			xt_buf_add(buf, "%u ", espinfo->spis[0]);
+	}
+
+	return 1;
+}
+
 static struct xtables_match esp_match = {
 	.family		= NFPROTO_UNSPEC,
-	.name 		= "esp",
-	.version 	= XTABLES_VERSION,
+	.name		= "esp",
+	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_esp)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_esp)),
 	.help		= esp_help,
@@ -90,6 +108,7 @@ static struct xtables_match esp_match = {
 	.save		= esp_save,
 	.x6_parse	= esp_parse,
 	.x6_options	= esp_opts,
+	.xlate		= esp_xlate,
 };
 
 void
-- 
1.9.1

