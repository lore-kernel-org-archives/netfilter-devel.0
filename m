From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCH v3] extensions: libxt_multiport: Add translation to nft
Date: Tue, 31 May 2016 20:26:11 +0200
Message-ID: <20160531182607.GA17802@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35620 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755489AbcEaS0Q (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 31 May 2016 14:26:16 -0400
Received: by mail-wm0-f66.google.com with SMTP id e3so35163000wme.2
        for <netfilter-devel@vger.kernel.org>; Tue, 31 May 2016 11:26:15 -0700 (PDT)
Received: from sonyv ([91.126.73.162])
        by smtp.gmail.com with ESMTPSA id a81sm30685798wma.16.2016.05.31.11.26.13
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Tue, 31 May 2016 11:26:13 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for multiport to nftables, which it's supported natively.

Examples:

$ sudo iptables-translate -t filter -A INPUT -p tcp -m multiport --dports 80,81 -j ACCEPT
nft add rule ip filter INPUT ip protocol tcp tcp dport { 80,81} counter accept

$ sudo iptables-translate -t filter -A INPUT -p tcp -m multiport --dports 80:88 -j ACCEPT
nft add rule ip filter INPUT ip protocol tcp tcp dport 80-88 counter accept

$ sudo iptables-translate -t filter -A INPUT -p tcp -m multiport ! --dports 80:88 -j ACCEPT
nft add rule ip filter INPUT ip protocol tcp tcp dport != 80-88 counter accept

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
Changes in v2:
	- Add curley brackets to lists and range of ports.
Changes in v3:
	- Avoid {} in port ranges

 extensions/libxt_multiport.c | 118 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 118 insertions(+)

diff --git a/extensions/libxt_multiport.c b/extensions/libxt_multiport.c
index 03af5a9..869ce37 100644
--- a/extensions/libxt_multiport.c
+++ b/extensions/libxt_multiport.c
@@ -468,6 +468,120 @@ static void multiport_save6_v1(const void *ip_void,
 	__multiport_save_v1(match, ip->proto);
 }
 
+static int __multiport_xlate(const void *ip, const struct xt_entry_match *match,
+			     struct xt_xlate *xl, int numeric)
+{
+	const struct xt_multiport *multiinfo
+		= (const struct xt_multiport *)match->data;
+	unsigned int i;
+
+	switch (multiinfo->flags) {
+	case XT_MULTIPORT_SOURCE:
+		xt_xlate_add(xl, "sport ");
+		break;
+	case XT_MULTIPORT_DESTINATION:
+		xt_xlate_add(xl, "dport ");
+		break;
+	case XT_MULTIPORT_EITHER:
+		return 0;
+	}
+
+	if (multiinfo->count > 1)
+		xt_xlate_add(xl, "{ ");
+
+	for (i = 0; i < multiinfo->count; i++)
+		xt_xlate_add(xl, "%s%u", i ? "," : "", multiinfo->ports[i]);
+
+	if (multiinfo->count > 1)
+		xt_xlate_add(xl, "}");
+
+	xt_xlate_add(xl, " ");
+
+	return 1;
+}
+
+static int multiport_xlate(const void *ip, const struct xt_entry_match *match,
+			   struct xt_xlate *xl, int numeric)
+{
+	uint8_t proto = ((const struct ipt_ip *)ip)->proto;
+
+	xt_xlate_add(xl, "%s ", proto_to_name(proto));
+	return __multiport_xlate(ip, match, xl, numeric);
+}
+
+static int multiport_xlate6(const void *ip, const struct xt_entry_match *match,
+			    struct xt_xlate *xl, int numeric)
+{
+	uint8_t proto = ((const struct ip6t_ip6 *)ip)->proto;
+
+	xt_xlate_add(xl, "%s ", proto_to_name(proto));
+	return __multiport_xlate(ip, match, xl, numeric);
+}
+
+static int __multiport_xlate_v1(const void *ip,
+				const struct xt_entry_match *match,
+				struct xt_xlate *xl, int numeric)
+{
+	const struct xt_multiport_v1 *multiinfo
+		= (const struct xt_multiport_v1 *)match->data;
+	unsigned int i;
+
+	switch (multiinfo->flags) {
+	case XT_MULTIPORT_SOURCE:
+		xt_xlate_add(xl, "sport ");
+		break;
+	case XT_MULTIPORT_DESTINATION:
+		xt_xlate_add(xl, "dport ");
+		break;
+	case XT_MULTIPORT_EITHER:
+		return 0;
+	}
+
+	if (multiinfo->invert)
+		xt_xlate_add(xl, "!= ");
+	
+	if (multiinfo->count > 2 || 
+	    (multiinfo->count > 1 && !multiinfo->pflags[0])) {
+		xt_xlate_add(xl, "{ ");
+		if (multiinfo->invert)
+			return 0;
+	}
+
+	for (i = 0; i < multiinfo->count; i++) {
+		xt_xlate_add(xl, "%s%u", i ? "," : "", multiinfo->ports[i]);
+		if (multiinfo->pflags[i])
+			xt_xlate_add(xl, "-%u", multiinfo->ports[++i]);
+	}
+
+	if (multiinfo->count > 2 ||
+	    (multiinfo->count > 1 && !multiinfo->pflags[0]))
+		xt_xlate_add(xl, "}");
+
+	xt_xlate_add(xl, " ");
+
+	return 1;
+}
+
+static int multiport_xlate_v1(const void *ip,
+			      const struct xt_entry_match *match,
+			      struct xt_xlate *xl, int numeric)
+{
+	uint8_t proto = ((const struct ipt_ip *)ip)->proto;
+
+	xt_xlate_add(xl, "%s ", proto_to_name(proto));
+	return __multiport_xlate_v1(ip, match, xl, numeric);
+}
+
+static int multiport_xlate6_v1(const void *ip,
+			       const struct xt_entry_match *match,
+			       struct xt_xlate *xl, int numeric)
+{
+	uint8_t proto = ((const struct ip6t_ip6 *)ip)->proto;
+
+	xt_xlate_add(xl, "%s ", proto_to_name(proto));
+	return __multiport_xlate_v1(ip, match, xl, numeric);
+}
+
 static struct xtables_match multiport_mt_reg[] = {
 	{
 		.family        = NFPROTO_IPV4,
@@ -482,6 +596,7 @@ static struct xtables_match multiport_mt_reg[] = {
 		.print         = multiport_print,
 		.save          = multiport_save,
 		.x6_options    = multiport_opts,
+		.xlate         = multiport_xlate,
 	},
 	{
 		.family        = NFPROTO_IPV6,
@@ -496,6 +611,7 @@ static struct xtables_match multiport_mt_reg[] = {
 		.print         = multiport_print6,
 		.save          = multiport_save6,
 		.x6_options    = multiport_opts,
+		.xlate         = multiport_xlate6,
 	},
 	{
 		.family        = NFPROTO_IPV4,
@@ -510,6 +626,7 @@ static struct xtables_match multiport_mt_reg[] = {
 		.print         = multiport_print_v1,
 		.save          = multiport_save_v1,
 		.x6_options    = multiport_opts,
+		.xlate         = multiport_xlate_v1,
 	},
 	{
 		.family        = NFPROTO_IPV6,
@@ -524,6 +641,7 @@ static struct xtables_match multiport_mt_reg[] = {
 		.print         = multiport_print6_v1,
 		.save          = multiport_save6_v1,
 		.x6_options    = multiport_opts,
+		.xlate         = multiport_xlate6_v1,
 	},
 };
 
-- 
2.7.0

