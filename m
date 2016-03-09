From: FaTe <gokuvsvegita@gmail.com>
Subject: [PATCH] libip6t_hbh: Add translation to nft
Date: Wed, 9 Mar 2016 12:42:45 +0530
Message-ID: <56DFCCED.8040909@gmail.com>
References: <20160307212141.GA10594@sonyv> <20160308105346.GB4008@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:33324 "EHLO
	mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbcCIHM2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Mar 2016 02:12:28 -0500
Received: by mail-pf0-f179.google.com with SMTP id 124so33207588pfg.0
        for <netfilter-devel@vger.kernel.org>; Tue, 08 Mar 2016 23:12:28 -0800 (PST)
In-Reply-To: <20160308105346.GB4008@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Added translation for hbh module .

Note: Currently, --hbh-opts support dont exist in nftables .

Example :
$ ip6tables-translate -A INPUT -m hbh --hbh-len 40
nft add rule ip6 filter INPUT hbh hdrlength  40 counter

$ sudo ip6tables-translate -A INPUT -m hbh ! --hbh-len 40
nft add rule ip6 filter INPUT hbh hdrlength  != 40 counter

Signed-off-by: Piyush Pangtey <gokuvsvegita@gmail.com>
---
 extensions/libip6t_hbh.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/extensions/libip6t_hbh.c b/extensions/libip6t_hbh.c
index c0389ed..98dcade 100644
--- a/extensions/libip6t_hbh.c
+++ b/extensions/libip6t_hbh.c
@@ -164,6 +164,27 @@ static void hbh_save(const void *ip, const struct xt_entry_match *match)
 	print_options(optinfo->optsnr, (uint16_t *)optinfo->opts);
 }
 
+static int hbh_xlate(const struct xt_entry_match *match, struct xt_xlate *xl,
+		     int numeric)
+{
+	const struct ip6t_opts *optinfo = (struct ip6t_opts *)match->data;
+
+	if (optinfo->flags & IP6T_OPTS_LEN) {
+		xt_xlate_add(xl," hbh hdrlength %s %u",
+			    (optinfo->invflags & IP6T_OPTS_INV_LEN) ? " !=" :
+			    "", optinfo->hdrlen);
+	} else {
+		return 0;
+	}
+
+	if (optinfo->flags & IP6T_OPTS_OPTS)
+		return 0;
+
+	xt_xlate_add(xl, " ");
+
+	return 1;
+
+}
 static struct xtables_match hbh_mt6_reg = {
 	.name 		= "hbh",
 	.version	= XTABLES_VERSION,
@@ -175,6 +196,7 @@ static struct xtables_match hbh_mt6_reg = {
 	.save		= hbh_save,
 	.x6_parse	= hbh_parse,
 	.x6_options	= hbh_opts,
+	.xlate 		= hbh_xlate,
 };
 
 void
-- 
1.9.1
