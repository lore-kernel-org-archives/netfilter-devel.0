From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCH] extensions: libip6t_frag: Add translation to nft
Date: Thu, 2 Jun 2016 18:57:58 +0200
Message-ID: <20160602165756.GA21013@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35455 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481AbcFBQ6D (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Jun 2016 12:58:03 -0400
Received: by mail-wm0-f67.google.com with SMTP id e3so17340192wme.2
        for <netfilter-devel@vger.kernel.org>; Thu, 02 Jun 2016 09:58:02 -0700 (PDT)
Received: from sonyv (5.40.227.236.static.user.ono.com. [5.40.227.236])
        by smtp.gmail.com with ESMTPSA id q189sm2112707wmd.19.2016.06.02.09.58.00
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Thu, 02 Jun 2016 09:58:00 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for frag to nftables. Not supported yet in nft: fraglen,
fragfirst and fraglast.

Examples:

$ sudo iptables-translate -t filter -A INPUT -m frag --fragid 100:200 -j ACCEPT
nft add rule ip6 filter INPUT frag id 100-200 counter accept

$ sudo iptables-translate -t filter -A INPUT -m frag --fragid 100 --fragres --fragmore -j ACCEPT
nft add rule ip6 filter INPUT frag id 100 frag reserved 1 frag
more-fragments 1 counter accept

$ sudo iptables-translate -t filter -A INPUT -m frag ! --fragid 100:200 -j ACCEPT
nft add rule ip6 filter INPUT frag id != 100-200 counter accept

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
 extensions/libip6t_frag.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/extensions/libip6t_frag.c b/extensions/libip6t_frag.c
index 023df62..00ba00f 100644
--- a/extensions/libip6t_frag.c
+++ b/extensions/libip6t_frag.c
@@ -173,6 +173,36 @@ static void frag_save(const void *ip, const struct xt_entry_match *match)
 		printf(" --fraglast");
 }
 
+static int frag_xlate(const void *ip, const struct xt_entry_match *match,
+		      struct xt_xlate *xl, int numeric)
+{
+	const struct ip6t_frag *fraginfo = (struct ip6t_frag *)match->data;
+
+	if ((fraginfo->flags & IP6T_FRAG_LEN) ||
+	    (fraginfo->flags & IP6T_FRAG_FST) ||
+	    (fraginfo->flags & IP6T_FRAG_NMF)) {
+		return 0;
+	}
+
+	if (!(fraginfo->ids[0] == 0 && fraginfo->ids[1] == 0xFFFFFFFF)) {
+		xt_xlate_add(xl, "frag id %s",
+			(fraginfo->invflags & IP6T_FRAG_INV_IDS) ? "!= " : "");
+		if (fraginfo->ids[0] != fraginfo->ids[1])
+			xt_xlate_add(xl, "%u-%u ", fraginfo->ids[0],
+				     fraginfo->ids[1]);
+		else
+			xt_xlate_add(xl, "%u ", fraginfo->ids[0]);
+	}
+
+	if (fraginfo->flags & IP6T_FRAG_RES)
+		xt_xlate_add(xl, "frag reserved 1 ");
+
+	if (fraginfo->flags & IP6T_FRAG_MF)
+		xt_xlate_add(xl, "frag more-fragments 1 ");
+
+	return 1;
+}
+
 static struct xtables_match frag_mt6_reg = {
 	.name          = "frag",
 	.version       = XTABLES_VERSION,
@@ -185,6 +215,7 @@ static struct xtables_match frag_mt6_reg = {
 	.save          = frag_save,
 	.x6_parse      = frag_parse,
 	.x6_options    = frag_opts,
+	.xlate	       = frag_xlate,
 };
 
 void
-- 
2.7.0

