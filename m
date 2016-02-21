From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH 2/2] extensions: libip6t_mh: Add translation to nft
Date: Mon, 22 Feb 2016 00:23:45 +0530
Message-ID: <755537e264168d96942df92fa94329aed502a253.1456080369.git.shivanib134@gmail.com>
References: <2cf9af3607f9af0ee203060ddbaae655b66a1085.1456080369.git.shivanib134@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:34133 "EHLO
	mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbcBUSyc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 21 Feb 2016 13:54:32 -0500
Received: by mail-pf0-f177.google.com with SMTP id x65so79965751pfb.1
        for <netfilter-devel@vger.kernel.org>; Sun, 21 Feb 2016 10:54:32 -0800 (PST)
Received: from gmail.com ([116.202.36.30])
        by smtp.gmail.com with ESMTPSA id q85sm31302185pfq.81.2016.02.21.10.54.29
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Sun, 21 Feb 2016 10:54:31 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <2cf9af3607f9af0ee203060ddbaae655b66a1085.1456080369.git.shivanib134@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for mobility header to nftables.

Examples:

$ sudo ip6tables-translate -A INPUT -p mh --mh-type 1 -j ACCEPT
nft add rule ip6 filter INPUT meta l4proto mobility-header mh type 1 counter accept

$ sudo ip6tables-translate -A INPUT -p mh --mh-type 1:3 -j ACCEPT
nft add rule ip6 filter INPUT meta l4proto mobility-header mh type 1-3 counter accept

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 extensions/libip6t_mh.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/extensions/libip6t_mh.c b/extensions/libip6t_mh.c
index 686a293..e0c214c 100644
--- a/extensions/libip6t_mh.c
+++ b/extensions/libip6t_mh.c
@@ -202,6 +202,26 @@ static void mh_save(const void *ip, const struct xt_entry_match *match)
 		printf(" --mh-type %u", mhinfo->types[0]);
 }
 
+static int mh_xlate(const struct xt_entry_match *match,
+		    struct xt_xlate *xl, int numeric)
+{
+	const struct ip6t_mh *mhinfo = (struct ip6t_mh *)match->data;
+
+	if (mhinfo->types[0] == 0 && mhinfo->types[1] == 0xFF)
+		return 1;
+
+	if (mhinfo->types[0] != mhinfo->types[1])
+		xt_xlate_add(xl, "mh type %s%u-%u ",
+			     mhinfo->invflags & IP6T_MH_INV_TYPE ? "!= " : "",
+			     mhinfo->types[0], mhinfo->types[1]);
+	else
+		xt_xlate_add(xl, "mh type %s%u ",
+			     mhinfo->invflags & IP6T_MH_INV_TYPE ? "!= " : "",
+			     mhinfo->types[0]);
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

