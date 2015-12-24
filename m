From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH] extensions: libipt_ah: Add translation to nft
Date: Thu, 24 Dec 2015 23:00:58 +0530
Message-ID: <20151224173058.GA6563@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:34972 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535AbbLXRbH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Dec 2015 12:31:07 -0500
Received: by mail-pa0-f44.google.com with SMTP id jx14so124369120pad.2
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Dec 2015 09:31:06 -0800 (PST)
Received: from gmail.com ([106.203.109.187])
        by smtp.gmail.com with ESMTPSA id 2sm12251775pft.5.2015.12.24.09.31.03
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Thu, 24 Dec 2015 09:31:04 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for Authentication Header to nftables.

Examples:

$ sudo iptables-translate -A INPUT -p 51 -m ah --ahspi 500 -j DROP
nft add rule ip filter INPUT ah spi 500 counter drop

$ sudo iptables-translate -A INPUT -p 51 -m ah --ahspi 500:600 -j DROP
nft add rule ip filter INPUT ah spi 500-600 counter drop

$ sudo iptables-translate -A INPUT -p 51 -m ah ! --ahspi 50 -j DROP
nft add rule ip filter INPUT ah spi != 50 counter drop

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 extensions/libipt_ah.c | 37 ++++++++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 9 deletions(-)

diff --git a/extensions/libipt_ah.c b/extensions/libipt_ah.c
index a490729..b55079e 100644
--- a/extensions/libipt_ah.c
+++ b/extensions/libipt_ah.c
@@ -52,15 +52,15 @@ print_spis(const char *name, uint32_t min, uint32_t max,
 			printf("%u", min);
 		} else {
 			printf("s:%s", inv);
-			printf("%u",min);
+			printf("%u", min);
 			printf(":");
-			printf("%u",max);
+			printf("%u", max);
 		}
 	}
 }
 
 static void ah_print(const void *ip, const struct xt_entry_match *match,
-                     int numeric)
+		     int numeric)
 {
 	const struct ipt_ah *ah = (struct ipt_ah *)match->data;
 
@@ -92,18 +92,37 @@ static void ah_save(const void *ip, const struct xt_entry_match *match)
 
 }
 
+static int ah_xlate(const struct xt_entry_match *match,
+		    struct xt_buf *buf, int numeric)
+{
+	const struct ipt_ah *ahinfo = (struct ipt_ah *)match->data;
+
+	if (!(ahinfo->spis[0] == 0 && ahinfo->spis[1] == 0xFFFFFFFF)) {
+		xt_buf_add(buf, "ah spi%s ",
+			   (ahinfo->invflags & IPT_AH_INV_SPI) ? " !=" : "");
+		if (ahinfo->spis[0] != ahinfo->spis[1])
+			xt_buf_add(buf, "%u-%u ", ahinfo->spis[0],
+				   ahinfo->spis[1]);
+		else
+			xt_buf_add(buf, "%u ", ahinfo->spis[0]);
+	}
+
+	return 1;
+}
+
 static struct xtables_match ah_mt_reg = {
-	.name 		= "ah",
-	.version 	= XTABLES_VERSION,
+	.name		= "ah",
+	.version	= XTABLES_VERSION,
 	.family		= NFPROTO_IPV4,
 	.size		= XT_ALIGN(sizeof(struct ipt_ah)),
-	.userspacesize 	= XT_ALIGN(sizeof(struct ipt_ah)),
-	.help 		= ah_help,
+	.userspacesize	= XT_ALIGN(sizeof(struct ipt_ah)),
+	.help		= ah_help,
 	.init		= ah_init,
-	.print 		= ah_print,
-	.save 		= ah_save,
+	.print		= ah_print,
+	.save		= ah_save,
 	.x6_parse	= ah_parse,
 	.x6_options	= ah_opts,
+	.xlate		= ah_xlate,
 };
 
 void
-- 
1.9.1

