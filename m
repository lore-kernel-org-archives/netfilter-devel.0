From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH] extensions: libip6t_ah: Add translation to nft
Date: Thu, 31 Dec 2015 22:55:28 +0530
Message-ID: <20151231172528.GA11909@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:36255 "EHLO
	mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbbLaRZf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Dec 2015 12:25:35 -0500
Received: by mail-pf0-f175.google.com with SMTP id 65so113673664pff.3
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Dec 2015 09:25:35 -0800 (PST)
Received: from gmail.com ([223.176.168.63])
        by smtp.gmail.com with ESMTPSA id 2sm98064101pfl.56.2015.12.31.09.25.32
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Thu, 31 Dec 2015 09:25:33 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for AH to nftables.

Examples:

$ sudo ip6tables-translate -A INPUT -m ah --ahspi 500 -j DROP
nft add rule ip6 filter INPUT ah spi 500 counter drop

$ sudo ip6tables-translate -A INPUT -m ah --ahspi 500:550 -j DROP
nft add rule ip6 filter INPUT ah spi 500-550 counter drop

$ sudo ip6tables-translate -A INPUT -m ah ! --ahlen 120
nft add rule ip6 filter INPUT ah hdrlength != 120 counter

$ sudo ip6tables-translate -A INPUT -m ah --ahres
nft add rule ip6 filter INPUT ah reserved 1 counter

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 extensions/libip6t_ah.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/extensions/libip6t_ah.c b/extensions/libip6t_ah.c
index 174d6d1..f7c30f4 100644
--- a/extensions/libip6t_ah.c
+++ b/extensions/libip6t_ah.c
@@ -128,6 +128,32 @@ static void ah_save(const void *ip, const struct xt_entry_match *match)
 		printf(" --ahres");
 }
 
+static int ah_xlate(const struct xt_entry_match *match,
+		    struct xt_buf *buf, int numeric)
+{
+	const struct ip6t_ah *ahinfo = (struct ip6t_ah *)match->data;
+
+	if (!(ahinfo->spis[0] == 0 && ahinfo->spis[1] == 0xFFFFFFFF)) {
+		xt_buf_add(buf, "ah spi%s ",
+			   (ahinfo->invflags & IP6T_AH_INV_SPI) ? " !=" : "");
+	if (ahinfo->spis[0] != ahinfo->spis[1])
+		xt_buf_add(buf, "%u-%u ", ahinfo->spis[0], ahinfo->spis[1]);
+	else
+		xt_buf_add(buf, "%u ", ahinfo->spis[0]);
+	}
+
+	if (ahinfo->hdrlen != 0 || (ahinfo->invflags & IP6T_AH_INV_LEN)) {
+		xt_buf_add(buf, "ah hdrlength%s %u ",
+			   (ahinfo->invflags & IP6T_AH_INV_LEN) ? " !=" : "",
+			   ahinfo->hdrlen);
+	}
+
+	if (ahinfo->hdrres != 0)
+		xt_buf_add(buf, "ah reserved %u ", ahinfo->hdrres);
+
+	return 1;
+}
+
 static struct xtables_match ah_mt6_reg = {
 	.name          = "ah",
 	.version       = XTABLES_VERSION,
@@ -140,6 +166,7 @@ static struct xtables_match ah_mt6_reg = {
 	.save          = ah_save,
 	.x6_parse      = ah_parse,
 	.x6_options    = ah_opts,
+	.xlate	       = ah_xlate,
 };
 
 void
-- 
1.9.1

