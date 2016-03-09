From: FaTe <gokuvsvegita@gmail.com>
Subject: [PATCH] libxt_multiport: Add translation to nft
Date: Wed, 9 Mar 2016 12:28:29 +0530
Message-ID: <56DFC995.7090009@gmail.com>
References: <20160307212141.GA10594@sonyv> <20160308105346.GB4008@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:34071 "EHLO
	mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbcCIG6O (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Mar 2016 01:58:14 -0500
Received: by mail-pf0-f170.google.com with SMTP id 129so32735976pfw.1
        for <netfilter-devel@vger.kernel.org>; Tue, 08 Mar 2016 22:58:13 -0800 (PST)
In-Reply-To: <20160308105346.GB4008@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Added translation for the match multiport.

Example :
$ iptables-translate -A INPUT -p tcp -m multiport --ports 3:4  -j ACCEPT
nft add rule ip filter INPUT ip protocol tcp dport { 3-4 } tcp sport { 3-4 }
counter accept

$ iptables-translate -A INPUT -p tcp -m multiport --sports http,ssh,ftp  -j
ACCEPT
nft add rule ip filter INPUT ip protocol tcp sport { 80,22,21 } counter accept

$ iptables-translate -A INPUT -p tcp -m multiport --dports 1024:2048  -j ACCEPT
nft add rule ip filter INPUT ip protocol tcp dport { 1024-2048 } counter accept

$  iptables-translate -A input -p tcp -m multiport --dports 1024:2048,2049:3333
-j ACCEPT
nft add rule ip filter input ip protocol tcp dport { 1024-2048,2049-3333 }
counter accept

Signed-off-by: Piyush Pangtey <gokuvsvegita@gmail.com>
---
 extensions/libxt_multiport.c | 171 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 170 insertions(+), 1 deletion(-)

diff --git a/extensions/libxt_multiport.c b/extensions/libxt_multiport.c
index 03af5a9..41e1e2b 100644
--- a/extensions/libxt_multiport.c
+++ b/extensions/libxt_multiport.c
@@ -18,6 +18,8 @@ enum {
 	F_ANY          = F_SOURCE_PORTS | F_DEST_PORTS | F_SD_PORTS,
 };
 
+static const char *xlate_proto;
+
 /* Function which prints out usage message. */
 static void multiport_help(void)
 {
@@ -150,8 +152,10 @@ check_proto(uint16_t pnum, uint8_t invflags)
 		xtables_error(PARAMETER_PROBLEM,
 			   "multiport only works with TCP, UDP, UDPLITE, SCTP and DCCP");
 
-	if ((proto = proto_to_name(pnum)) != NULL)
+	if ((proto = proto_to_name(pnum)) != NULL){
+		xlate_proto = proto;
 		return proto;
+	}
 	else if (!pnum)
 		xtables_error(PARAMETER_PROBLEM,
 			   "multiport needs `-p tcp', `-p udp', `-p udplite', "
@@ -468,6 +472,167 @@ static void multiport_save6_v1(const void *ip_void,
 	__multiport_save_v1(match, ip->proto);
 }
 
+static int multiport_xlate(const struct xt_entry_match *match, struct xt_xlate *xl,
+		       int numeric)
+{
+	const struct xt_multiport_v1 *multiinfo =
+		(const struct xt_multiport_v1 *)match->data;
+	unsigned int i;
+	bool have_multiple = false, have_invert = false;
+
+	if(xlate_proto != NULL){
+		if (multiinfo->count > 1)
+			have_multiple = true;
+		if (multiinfo->invert)
+			have_invert = true;
+		if (xlate_proto == NULL || (have_multiple && have_invert))
+			return 0;
+
+		switch (multiinfo->flags) {
+		case XT_MULTIPORT_SOURCE:
+			xt_xlate_add(xl,"sport %s%s",
+				    (have_invert == true) ? "!= " : "",
+				    (have_multiple == true) ? "{ " : "");
+			for (i = 0; i < multiinfo->count; i++) {
+				xt_xlate_add(xl, "%s", i ? "," : "");
+				xt_xlate_add(xl, "%u", multiinfo->ports[i]);
+			}
+			break;
+
+		case XT_MULTIPORT_DESTINATION:
+			xt_xlate_add(xl,"dport %s%s",
+				    (have_invert == true) ? "!= " : "",
+				    (have_multiple == true) ? "{ " : "");
+			for (i = 0; i < multiinfo->count; i++) {
+				xt_xlate_add(xl, "%s", i ? "," : "");
+				xt_xlate_add(xl, "%u", multiinfo->ports[i]);
+			}
+			break;
+
+		case XT_MULTIPORT_EITHER:
+			xt_xlate_add(xl,"dport %s%s",
+				    (have_invert == true) ? "!= " : "",
+				    (have_multiple == true) ? "{ " : "");
+			for (i = 0; i < multiinfo->count; i++) {
+				xt_xlate_add(xl, "%s", i ? "," : "");
+				xt_xlate_add(xl, "%u", multiinfo->ports[i]);
+			}
+			if (have_multiple)
+				xt_xlate_add(xl, " } ");
+			else
+				xt_xlate_add(xl, " ");
+
+			xt_xlate_add(xl,"%s sport %s%s", xlate_proto,
+				    (have_invert == true) ? "!= " : "",
+				    (have_multiple == true) ? "{ " : "");
+			for (i = 0; i < multiinfo->count; i++) {
+				xt_xlate_add(xl, "%s", i ? "," : "");
+				xt_xlate_add(xl, "%u", multiinfo->ports[i]);
+			}
+			break;
+
+
+		default:
+			return 0;
+		}
+		if (have_multiple)
+			xt_xlate_add(xl, " } ");
+		else
+			xt_xlate_add(xl, " ");
+	}
+
+
+	return 1;
+}
+
+static int multiport_xlate_v1(const struct xt_entry_match *match, struct xt_xlate *xl,
+		       int numeric)
+{
+	const struct xt_multiport_v1 *multiinfo =
+		(const struct xt_multiport_v1 *)match->data;
+	unsigned int i;
+	bool have_multiple = false, have_invert = false ;
+
+	if(xlate_proto != NULL){
+		if (multiinfo->count > 1)
+			have_multiple = true;
+		if (multiinfo->invert)
+			have_invert = true;
+		if (xlate_proto == NULL || (have_multiple && have_invert))
+			return 0;
+
+		switch (multiinfo->flags) {
+		case XT_MULTIPORT_SOURCE:
+			xt_xlate_add(xl,"sport %s%s",
+				    (have_invert == true) ? "!= " : "",
+				    (have_multiple == true) ? "{ " : "");
+			for (i = 0; i < multiinfo->count; i++) {
+				xt_xlate_add(xl, "%s", i ? "," : "");
+				xt_xlate_add(xl, "%u", multiinfo->ports[i]);
+		 	        if (multiinfo->pflags[i]) {
+				            xt_xlate_add(xl,"-%u",
+				            		multiinfo->ports[++i]);
+				}
+			}
+			break;
+
+		case XT_MULTIPORT_DESTINATION:
+			xt_xlate_add(xl,"dport %s%s",
+				    (have_invert == true) ? "!= " : "",
+				    (have_multiple == true) ? "{ " : "");
+			for (i = 0; i < multiinfo->count; i++) {
+				xt_xlate_add(xl, "%s", i ? "," : "");
+				xt_xlate_add(xl, "%u", multiinfo->ports[i]);
+		 	        if (multiinfo->pflags[i]) {
+				            xt_xlate_add(xl,"-%u",
+				            		multiinfo->ports[++i]);
+				}
+			}
+			break;
+
+		case XT_MULTIPORT_EITHER:
+			xt_xlate_add(xl,"dport %s%s",
+				    (have_invert == true) ? "!= " : "",
+				    (have_multiple == true) ? "{ " : "");
+			for (i = 0; i < multiinfo->count; i++) {
+				xt_xlate_add(xl, "%s", i ? "," : "");
+				xt_xlate_add(xl, "%u", multiinfo->ports[i]);
+		 	        if (multiinfo->pflags[i]) {
+				            xt_xlate_add(xl,"-%u",
+				            		multiinfo->ports[++i]);
+				}
+			}
+			if (have_multiple)
+				xt_xlate_add(xl, " } ");
+			else
+				xt_xlate_add(xl, " ");
+
+			xt_xlate_add(xl,"%s sport %s%s", xlate_proto,
+				    (have_invert == true) ? "!= " : "",
+				    (have_multiple == true) ? "{ " : "");
+			for (i = 0; i < multiinfo->count; i++) {
+				xt_xlate_add(xl, "%s", i ? "," : "");
+				xt_xlate_add(xl, "%u", multiinfo->ports[i]);
+		 	        if (multiinfo->pflags[i]) {
+				            xt_xlate_add(xl,"-%u",
+				            		multiinfo->ports[++i]);
+				}
+			}
+			break;
+
+		default:
+			return 0;
+		}
+		if (have_multiple)
+			xt_xlate_add(xl, " } ");
+		else
+			xt_xlate_add(xl, " ");
+	}
+
+
+	return 1;
+}
+
 static struct xtables_match multiport_mt_reg[] = {
 	{
 		.family        = NFPROTO_IPV4,
@@ -482,6 +647,7 @@ static struct xtables_match multiport_mt_reg[] = {
 		.print         = multiport_print,
 		.save          = multiport_save,
 		.x6_options    = multiport_opts,
+		.xlate	       = multiport_xlate,
 	},
 	{
 		.family        = NFPROTO_IPV6,
@@ -496,6 +662,7 @@ static struct xtables_match multiport_mt_reg[] = {
 		.print         = multiport_print6,
 		.save          = multiport_save6,
 		.x6_options    = multiport_opts,
+		.xlate         = multiport_xlate,
 	},
 	{
 		.family        = NFPROTO_IPV4,
@@ -510,6 +677,7 @@ static struct xtables_match multiport_mt_reg[] = {
 		.print         = multiport_print_v1,
 		.save          = multiport_save_v1,
 		.x6_options    = multiport_opts,
+		.xlate 	       = multiport_xlate_v1,
 	},
 	{
 		.family        = NFPROTO_IPV6,
@@ -524,6 +692,7 @@ static struct xtables_match multiport_mt_reg[] = {
 		.print         = multiport_print6_v1,
 		.save          = multiport_save6_v1,
 		.x6_options    = multiport_opts,
+		.xlate         = multiport_xlate_v1,
 	},
 };
 
-- 
1.9.1
