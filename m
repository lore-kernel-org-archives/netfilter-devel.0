From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCHv2] extensions: libip6t_frag: Add translation to nft
Date: Mon, 6 Jun 2016 21:25:46 +0200
Message-ID: <20160606192543.GA4818@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35843 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370AbcFFTZu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jun 2016 15:25:50 -0400
Received: by mail-wm0-f65.google.com with SMTP id m124so17774804wme.3
        for <netfilter-devel@vger.kernel.org>; Mon, 06 Jun 2016 12:25:50 -0700 (PDT)
Received: from sonyv (cli-5b7e49a2.wholesale.adamo.es. [91.126.73.162])
        by smtp.gmail.com with ESMTPSA id x124sm15609933wmg.24.2016.06.06.12.25.48
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Mon, 06 Jun 2016 12:25:48 -0700 (PDT)
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

 extensions/libip6t_frag.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/extensions/libip6t_frag.c b/extensions/libip6t_frag.c
index 023df62..0a24eae 100644
--- a/extensions/libip6t_frag.c
+++ b/extensions/libip6t_frag.c
@@ -173,6 +173,38 @@ static void frag_save(const void *ip, const struct xt_entry_match *match)
 		printf(" --fraglast");
 }
 
+static int frag_xlate(const void *ip, const struct xt_entry_match *match,
+		      struct xt_xlate *xl, int numeric)
+{
+	const struct ip6t_frag *fraginfo = (struct ip6t_frag *)match->data;
+
+	if (fraginfo->flags & IP6T_FRAG_LEN)
+		return 0;
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
@@ -185,6 +217,7 @@ static struct xtables_match frag_mt6_reg = {
 	.save          = frag_save,
 	.x6_parse      = frag_parse,
 	.x6_options    = frag_opts,
+	.xlate	       = frag_xlate,
 };
 
 void
-- 
2.7.0

