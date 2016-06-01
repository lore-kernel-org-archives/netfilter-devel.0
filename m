From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCH] extensions: libip6t_hbh: Add translation to nft
Date: Thu, 2 Jun 2016 00:08:08 +0200
Message-ID: <20160601220804.GA3515@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35992 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbcFAWIN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Jun 2016 18:08:13 -0400
Received: by mail-wm0-f66.google.com with SMTP id q62so10586684wmg.3
        for <netfilter-devel@vger.kernel.org>; Wed, 01 Jun 2016 15:08:13 -0700 (PDT)
Received: from sonyv ([213.143.50.104])
        by smtp.gmail.com with ESMTPSA id f186sm36574703wma.13.2016.06.01.15.08.11
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Wed, 01 Jun 2016 15:08:11 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for Hop-By-Hop header to nftables. Hbh options are not
supported yet in nft.

$ sudo ip6tables-translate -t filter -A INPUT -m hbh --hbh-len 22
nft add rule ip6 filter INPUT hbh hdrlength 22 counter

$ sudo ip6tables-translate -t filter -A INPUT -m hbh ! --hbh-len 22
nft add rule ip6 filter INPUT hbh hdrlength != 22 counter

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
 extensions/libip6t_hbh.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/extensions/libip6t_hbh.c b/extensions/libip6t_hbh.c
index c0389ed..416681d 100644
--- a/extensions/libip6t_hbh.c
+++ b/extensions/libip6t_hbh.c
@@ -164,6 +164,22 @@ static void hbh_save(const void *ip, const struct xt_entry_match *match)
 	print_options(optinfo->optsnr, (uint16_t *)optinfo->opts);
 }
 
+static int hbh_xlate(const void *ip, const struct xt_entry_match *match,
+		     struct xt_xlate *xl, int numeric)
+{
+	const struct ip6t_opts *optinfo = (struct ip6t_opts *)match->data;
+
+	if (!(optinfo->flags & IP6T_OPTS_LEN) ||
+	    (optinfo->flags & IP6T_OPTS_OPTS))
+		return 0;
+
+	xt_xlate_add(xl, "hbh hdrlength %s%u ",
+		     (optinfo->invflags & IP6T_OPTS_INV_LEN) ? "!= " : "",
+		     optinfo->hdrlen);
+
+	return 1;
+}
+
 static struct xtables_match hbh_mt6_reg = {
 	.name 		= "hbh",
 	.version	= XTABLES_VERSION,
@@ -175,6 +191,7 @@ static struct xtables_match hbh_mt6_reg = {
 	.save		= hbh_save,
 	.x6_parse	= hbh_parse,
 	.x6_options	= hbh_opts,
+	.xlate		= hbh_xlate,
 };
 
 void
-- 
2.7.0

