From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH] extensions: libip6t_hbh: Add translation to nft
Date: Wed, 2 Mar 2016 03:22:43 +0530
Message-ID: <20160301215243.GA19576@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:32857 "EHLO
	mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbcCAVwu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Mar 2016 16:52:50 -0500
Received: by mail-pf0-f182.google.com with SMTP id 124so58501625pfg.0
        for <netfilter-devel@vger.kernel.org>; Tue, 01 Mar 2016 13:52:50 -0800 (PST)
Received: from gmail.com ([223.183.15.73])
        by smtp.gmail.com with ESMTPSA id u90sm47703292pfa.60.2016.03.01.13.52.48
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Tue, 01 Mar 2016 13:52:49 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for module hop-by-hop to nftables.
Full translation of this match awaits the support for --hbh-opts option.

Examples:

$ sudo ip6tables-translate -A INPUT -m hbh --hbh-len 33
nft add rule ip6 filter INPUT hbh hdrlength 33 counter

$ sudo ip6tables-translate -A INPUT -m hbh ! --hbh-len 33
nft add rule ip6 filter INPUT hbh hdrlength != 33 counter

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 extensions/libip6t_hbh.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/extensions/libip6t_hbh.c b/extensions/libip6t_hbh.c
index c0389ed..f968036 100644
--- a/extensions/libip6t_hbh.c
+++ b/extensions/libip6t_hbh.c
@@ -164,6 +164,22 @@ static void hbh_save(const void *ip, const struct xt_entry_match *match)
 	print_options(optinfo->optsnr, (uint16_t *)optinfo->opts);
 }
 
+static int hbh_xlate(const struct xt_entry_match *match,
+		     struct xt_xlate *xl, int numeric)
+{
+	const struct ip6t_opts *optinfo = (struct ip6t_opts *)match->data;
+
+	xt_xlate_add(xl, "hbh ");
+
+	if (optinfo->flags & IP6T_OPTS_LEN) {
+		xt_xlate_add(xl, "hdrlength%s %u ",
+			     optinfo->invflags & IP6T_OPTS_INV_LEN ? " !=" : "",
+			     optinfo->hdrlen);
+	}
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
1.9.1

