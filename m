From: Janani Ravichandran <janani.rvchndrn@gmail.com>
Subject: [PATCH] extensions: libip6t_rt.c: Add translation to nft
Date: Sun, 6 Mar 2016 10:26:57 -0500
Message-ID: <20160306152657.GA2680@janani-Inspiron-3521>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:35643 "EHLO
	mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbcCFP1y (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 6 Mar 2016 10:27:54 -0500
Received: by mail-qk0-f174.google.com with SMTP id o6so38517393qkc.2
        for <netfilter-devel@vger.kernel.org>; Sun, 06 Mar 2016 07:27:53 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for rt for options --rt-type, --rt-segsleft and --rt-len.

Examples:

$ sudo ip6tables-translate -A INPUT -m rt --rt-type 0 -j DROP
nft add rule ip6 filter INPUT rt type 0 counter drop

$ sudo ip6tables-translate -A INPUT -m rt ! --rt-len 22 -j DROP
nft add rule ip6 filter INPUT rt hdrlength != 22 counter drop

$ sudo ip6tables-translate -A INPUT -m rt --rt-segsleft 26 -j ACCEPT
nft add rule ip6 filter INPUT rt seg-left 26 counter accept

The xlate function returns 0 for other options.

Signed-off-by: Janani Ravichandran <janani.rvchndrn@gmail.com>
---
 extensions/libip6t_rt.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/extensions/libip6t_rt.c b/extensions/libip6t_rt.c
index cada779..59adfad 100644
--- a/extensions/libip6t_rt.c
+++ b/extensions/libip6t_rt.c
@@ -245,6 +245,40 @@ static void rt_save(const void *ip, const struct xt_entry_match *match)
 
 }
 
+static int rt_xlate(const struct xt_entry_match *match, struct xt_xlate *xl,
+		    int numeric)
+{
+	const struct ip6t_rt *rtinfo = (struct ip6t_rt *)match->data;
+
+	if (rtinfo->flags & IP6T_RT_TYP) {
+		xt_xlate_add(xl, "rt type%s %u ",
+			     (rtinfo->invflags & IP6T_RT_INV_TYP) ? " !=" : "",
+			      rtinfo->rt_type);
+	}
+
+	if (!(rtinfo->segsleft[0] == 0 && rtinfo->segsleft[1] == 0xFFFFFFFF)) {
+		xt_xlate_add(xl, "rt seg-left%s ",
+			     (rtinfo->invflags & IP6T_RT_INV_SGS) ? " !=" : "");
+
+		if (rtinfo->segsleft[0] != rtinfo->segsleft[1])
+			xt_xlate_add(xl, "%u-%u ", rtinfo->segsleft[0],
+					rtinfo->segsleft[1]);
+		else
+			xt_xlate_add(xl, "%u ", rtinfo->segsleft[0]);
+	}
+
+	if (rtinfo->flags & IP6T_RT_LEN) {
+		xt_xlate_add(xl, "rt hdrlength%s %u ",
+			     (rtinfo->invflags & IP6T_RT_INV_LEN) ? " !=" : "",
+			      rtinfo->hdrlen);
+	}
+
+	if (rtinfo->flags & (IP6T_RT_RES | IP6T_RT_FST | IP6T_RT_FST_NSTRICT))
+		return 0;
+
+	return 1;
+}
+
 static struct xtables_match rt_mt6_reg = {
 	.name		= "rt",
 	.version	= XTABLES_VERSION,
@@ -257,6 +291,7 @@ static struct xtables_match rt_mt6_reg = {
 	.print		= rt_print,
 	.save		= rt_save,
 	.x6_options	= rt_opts,
+	.xlate		= rt_xlate,
 };
 
 void
-- 
2.7.0

