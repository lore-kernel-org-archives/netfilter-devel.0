From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCHv3] extensions: libip6t_frag: Add translation to nft
Date: Tue, 7 Jun 2016 09:33:13 +0200
Message-ID: <20160607073309.GA9381@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33104 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbcFGHdR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jun 2016 03:33:17 -0400
Received: by mail-wm0-f66.google.com with SMTP id r5so3576910wmr.0
        for <netfilter-devel@vger.kernel.org>; Tue, 07 Jun 2016 00:33:17 -0700 (PDT)
Received: from sonyv ([195.235.183.164])
        by smtp.gmail.com with ESMTPSA id u4sm23977560wjz.4.2016.06.07.00.33.15
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Tue, 07 Jun 2016 00:33:15 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for frag to nftables. According to the --fraglen code:

	case O_FRAGLEN:
		/*
		 * As of Linux 3.0, the kernel does not check for
		 * fraglen at all.
		 */

In addition, the kernel code doesn't show any reference to the flag
IP6T_FRAG_LEN, so this option is deprecated and won't be translated to
nft.

Examples:

$ sudo iptables-translate -t filter -A INPUT -m frag --fragid 100:200 -j ACCEPT
nft add rule ip6 filter INPUT frag id 100-200 counter accept

$ sudo iptables-translate -t filter -A INPUT -m frag --fragid 100 --fragres --fragmore -j ACCEPT
nft add rule ip6 filter INPUT frag id 100 frag reserved 1 frag more-fragments 1 counter accept

$ sudo iptables-translate -t filter -A INPUT -m frag ! --fragid 100:200 -j ACCEPT
nft add rule ip6 filter INPUT frag id != 100-200 counter accept

$ sudo iptables-translate -t filter -A INPUT -m frag --fragid 100:200 --fraglast -j ACCEPT
nft add rule ip6 filter INPUT frag id 100-200 frag more-fragments 1 counter accept

$ sudo iptables-translate -t filter -A INPUT -m frag --fragid 100:200 --fragfirst -j ACCEPT
nft add rule ip6 filter INPUT frag id 100-200 frag frag-off 0 counter accept

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
Changes in v2:
        - Include translation for fragfirst and fraglast.
        - fraglen is marked as deprecated.
Changes in v3:
	- Ignore completely IP6T_FRAG_LEN.

 extensions/libip6t_frag.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/extensions/libip6t_frag.c b/extensions/libip6t_frag.c
index 023df62..7871fb9 100644
--- a/extensions/libip6t_frag.c
+++ b/extensions/libip6t_frag.c
@@ -173,6 +173,35 @@ static void frag_save(const void *ip, const struct xt_entry_match *match)
 		printf(" --fraglast");
 }
 
+static int frag_xlate(const void *ip, const struct xt_entry_match *match,
+		      struct xt_xlate *xl, int numeric)
+{
+	const struct ip6t_frag *fraginfo = (struct ip6t_frag *)match->data;
+
+	if (!(fraginfo->ids[0] == 0 && fraginfo->ids[1] == 0xFFFFFFFF)) {
+		xt_xlate_add(xl, "frag id %s",
+			     (fraginfo->invflags & IP6T_FRAG_INV_IDS) ?
+			     "!= " : "");
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
+	if (fraginfo->flags & IP6T_FRAG_FST)
+		xt_xlate_add(xl, "frag frag-off 0 ");
+
+	if ((fraginfo->flags & IP6T_FRAG_MF) ||
+	    (fraginfo->flags & IP6T_FRAG_NMF))
+		xt_xlate_add(xl, "frag more-fragments 1 ");
+
+	return 1;
+}
+
 static struct xtables_match frag_mt6_reg = {
 	.name          = "frag",
 	.version       = XTABLES_VERSION,
@@ -185,6 +214,7 @@ static struct xtables_match frag_mt6_reg = {
 	.save          = frag_save,
 	.x6_parse      = frag_parse,
 	.x6_options    = frag_opts,
+	.xlate	       = frag_xlate,
 };
 
 void
-- 
2.7.0

