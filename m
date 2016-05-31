From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCH] extensions: libxt_ipcomp: Add translation to nft
Date: Wed, 1 Jun 2016 00:06:59 +0200
Message-ID: <20160531220657.GA31779@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36703 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755348AbcEaWHE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 31 May 2016 18:07:04 -0400
Received: by mail-wm0-f68.google.com with SMTP id q62so1301745wmg.3
        for <netfilter-devel@vger.kernel.org>; Tue, 31 May 2016 15:07:02 -0700 (PDT)
Received: from sonyv (128.red-176-84-210.dynamicip.rima-tde.net. [176.84.210.128])
        by smtp.gmail.com with ESMTPSA id e8sm31666543wma.2.2016.05.31.15.07.01
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Tue, 31 May 2016 15:07:01 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation of ipcomp to nftables.

First value of the parameter 'ipcompspi' will be translated to 'cpi'
parameter in nftables. Parameter 'compres' is not supported in nftables.

Examples:

$ sudo iptables-translate -t filter -A INPUT -m ipcomp --ipcompspi 0x12 -j ACCEPT
nft add rule ip filter INPUT comp cpi 18 counter accept

$ sudo iptables-translate -t filter -A INPUT -m ipcomp ! --ipcompspi 0x12 -j ACCEPT
nft add rule ip filter INPUT comp cpi != 18 counter accept

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
 extensions/libxt_ipcomp.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/extensions/libxt_ipcomp.c b/extensions/libxt_ipcomp.c
index b157e7b..19b251a 100644
--- a/extensions/libxt_ipcomp.c
+++ b/extensions/libxt_ipcomp.c
@@ -95,6 +95,18 @@ static void comp_save(const void *ip, const struct xt_entry_match *match)
 		printf(" --compres");
 }
 
+static int comp_xlate(const void *ip, const struct xt_entry_match *match,
+			struct xt_xlate *xl, int numeric)
+{
+	const struct xt_ipcomp *compinfo = (struct xt_ipcomp *)match->data;
+
+	xt_xlate_add(xl, "comp cpi %s%u ",
+		     (compinfo->invflags & XT_IPCOMP_INV_SPI) ? "!= " : "",
+		     compinfo->spis[0]);
+
+	return 1;
+}
+
 static struct xtables_match comp_mt_reg = {
 	.name          = "ipcomp",
 	.version       = XTABLES_VERSION,
@@ -106,6 +118,7 @@ static struct xtables_match comp_mt_reg = {
 	.save          = comp_save,
 	.x6_parse      = comp_parse,
 	.x6_options    = comp_opts,
+	.xlate         = comp_xlate,
 };
 
 void
-- 
2.7.0

