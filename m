From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH] extensions: libip6t_mh: Add translation to nft
Date: Thu, 14 Jan 2016 23:10:09 +0530
Message-ID: <20160114174009.GA4252@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:33041 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931AbcANRkQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Jan 2016 12:40:16 -0500
Received: by mail-pa0-f54.google.com with SMTP id cy9so380238882pac.0
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Jan 2016 09:40:16 -0800 (PST)
Received: from gmail.com ([223.176.183.27])
        by smtp.gmail.com with ESMTPSA id v7sm10610060pfa.77.2016.01.14.09.40.13
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Thu, 14 Jan 2016 09:40:15 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for mobility header to nftables.

Examples:

$ sudo ip6tables-translate -A INPUT -p mh -j ACCEPT
nft add rule ip6 filter INPUT ip6 nexthdr mobility-header counter accept

$ sudo ip6tables-translate -A INPUT -p mh --mh-type 1 -j ACCEPT
nft add rule ip6 filter INPUT ip6 nexthdr mobility-header mh type 1 counter accept

$ sudo ip6tables-translate -A INPUT -p mh --mh-type 1:3 -j ACCEPT
nft add rule ip6 filter INPUT ip6 nexthdr mobility-header mh type 1-3 counter accept

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 extensions/libip6t_mh.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/extensions/libip6t_mh.c b/extensions/libip6t_mh.c
index 686a293..55ce028 100644
--- a/extensions/libip6t_mh.c
+++ b/extensions/libip6t_mh.c
@@ -202,6 +202,26 @@ static void mh_save(const void *ip, const struct xt_entry_match *match)
 		printf(" --mh-type %u", mhinfo->types[0]);
 }
 
+static int mh_xlate(const struct xt_entry_match *match,
+		    struct xt_buf *buf, int numeric)
+{
+	const struct ip6t_mh *mhinfo = (struct ip6t_mh *)match->data;
+
+	if (mhinfo->types[0] == 0 && mhinfo->types[1] == 0xFF)
+		return 0;
+
+	if (mhinfo->types[0] != mhinfo->types[1])
+		xt_buf_add(buf, "mh type%s %u-%u ",
+			   mhinfo->invflags & IP6T_MH_INV_TYPE ? " !=" : "",
+			   mhinfo->types[0], mhinfo->types[1]);
+	else
+		xt_buf_add(buf, "mh type%s %u ",
+			   mhinfo->invflags & IP6T_MH_INV_TYPE ? " !=" : "",
+			   mhinfo->types[0]);
+
+	return 1;
+}
+
 static const struct xt_option_entry mh_opts[] = {
 	{.name = "mh-type", .id = O_MH_TYPE, .type = XTTYPE_STRING,
 	 .flags = XTOPT_INVERT},
@@ -220,6 +240,7 @@ static struct xtables_match mh_mt6_reg = {
 	.print		= mh_print,
 	.save		= mh_save,
 	.x6_options	= mh_opts,
+	.xlate		= mh_xlate,
 };
 
 void _init(void)
-- 
1.9.1

