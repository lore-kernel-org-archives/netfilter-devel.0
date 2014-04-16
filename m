From: Ana Rey <anarey@gmail.com>
Subject: [iptables PATCH] extensions: udp: add translation to nft
Date: Wed, 16 Apr 2014 09:19:40 +0200
Message-ID: <a23cb222241de735c0f1bd19492ed7ea752b65f8.1397632430.git.anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:46971 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754769AbaDPHTv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Apr 2014 03:19:51 -0400
Received: by mail-we0-f170.google.com with SMTP id w61so10567048wes.15
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Apr 2014 00:19:50 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Some examples:

 $ sudo iptables-translate -A INPUT -p udp -i eth0 --sport 53 -j ACCEPT
add rule ip filter INPUT iifname eth0 udp sport 53 counter accept

 $ sudo ./iptables-translate -A OUTPUT -p udp -o eth0 --dport 53:66 -j DROP
add rule ip filter OUTPUT oifname eth0 udp dport 53-66 counter drop

 $ sudo ./iptables-translate -I OUTPUT -p udp -d 8.8.8.8 -j ACCEPT
nft insert rule ip filter OUTPUT ip protocol udp ip daddr 8.8.8.8 counter accept

Sign-off-by: Ana Rey <anarey@gmail.com>
---
 extensions/libxt_udp.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/extensions/libxt_udp.c b/extensions/libxt_udp.c
index b9f39ee..f3532ef 100644
--- a/extensions/libxt_udp.c
+++ b/extensions/libxt_udp.c
@@ -152,6 +152,39 @@ static void udp_save(const void *ip, const struct xt_entry_match *match)
 	}
 }
 
+static int udp_xlate(const struct xt_entry_match *match, struct xt_buf *buf)
+{
+	const struct xt_udp *udpinfo = (struct xt_udp *)match->data;
+
+	if (udpinfo->spts[0] != 0 || udpinfo->spts[1] != 0xFFFF) {
+		if (udpinfo->spts[0] != udpinfo->spts[1])
+			xt_buf_add(buf,"udp sport %s%u-%u ",
+				   udpinfo->invflags & XT_UDP_INV_SRCPT ?
+					 "!= ": "",
+				   udpinfo->spts[0], udpinfo->spts[1]);
+		else
+			xt_buf_add(buf, "udp sport %s%u ",
+				   udpinfo->invflags & XT_UDP_INV_SRCPT ?
+					 "!= ": "",
+				   udpinfo->spts[0]);
+	}
+
+	if (udpinfo->dpts[0] != 0 || udpinfo->dpts[1] != 0xFFFF) {
+		if (udpinfo->dpts[0]  != udpinfo->dpts[1])
+			xt_buf_add(buf,"udp dport %s%u-%u ",
+				   udpinfo->invflags & XT_UDP_INV_SRCPT ?
+					 "!= ": "",
+				   udpinfo->dpts[0], udpinfo->dpts[1]);
+		else
+			xt_buf_add(buf,"udp dport %s%u ",
+				   udpinfo->invflags & XT_UDP_INV_SRCPT ?
+					 "!= ": "",
+				   udpinfo->dpts[0]);
+	}
+
+	return 1;
+}
+
 static struct xtables_match udp_match = {
 	.family		= NFPROTO_UNSPEC,
 	.name		= "udp",
@@ -164,6 +197,7 @@ static struct xtables_match udp_match = {
 	.save		= udp_save,
 	.x6_parse	= udp_parse,
 	.x6_options	= udp_opts,
+	.xlate		= udp_xlate,
 };
 
 void
-- 
1.9.0

