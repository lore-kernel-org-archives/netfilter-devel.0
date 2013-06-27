From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] iptables: allow service names in [DS]NAT targets
Date: Thu, 27 Jun 2013 11:54:09 -0400
Message-ID: <20130627155409.GA8638@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="cNdxnHkX5QqsyA0e"
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:53051 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428Ab3F2DgH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Jun 2013 23:36:07 -0400
Received: by mail-pa0-f46.google.com with SMTP id fa11so3138999pad.33
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Jun 2013 20:36:06 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

As reported by Alexander Hoogerhuis, the [DS]NAT targets do not allow use of
service names in the --to argument.  The same problem was fixed in the REDIRECT
target in commit 84d758b3 ("extensions: REDIRECT: fix --to-ports parser").
Use a similar fix here.

This closes bugzilla #514.

Phil

Signed-off-by: Phil Oester <kernel@linuxace.com>



--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-514

diff --git a/extensions/libipt_DNAT.c b/extensions/libipt_DNAT.c
index ff18799..e452cfc 100644
--- a/extensions/libipt_DNAT.c
+++ b/extensions/libipt_DNAT.c
@@ -67,7 +67,7 @@ static struct xt_entry_target *
 parse_to(const char *orig_arg, int portok, struct ipt_natinfo *info)
 {
 	struct nf_nat_ipv4_range range;
-	char *arg, *colon, *dash, *error;
+	char *arg, *colon, *dash;
 	const struct in_addr *ip;
 
 	arg = strdup(orig_arg);
@@ -77,7 +77,8 @@ parse_to(const char *orig_arg, int portok, struct ipt_natinfo *info)
 	colon = strchr(arg, ':');
 
 	if (colon) {
-		int port;
+		char *end = "";
+		unsigned int port, maxport;
 
 		if (!portok)
 			xtables_error(PARAMETER_PROBLEM,
@@ -85,34 +86,29 @@ parse_to(const char *orig_arg, int portok, struct ipt_natinfo *info)
 
 		range.flags |= NF_NAT_RANGE_PROTO_SPECIFIED;
 
-		port = atoi(colon+1);
-		if (port <= 0 || port > 65535)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Port `%s' not valid\n", colon+1);
-
-		error = strchr(colon+1, ':');
-		if (error)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Invalid port:port syntax - use dash\n");
+		if (!xtables_strtoui(colon + 1, &end, &port, 0, UINT16_MAX) &&
+		    (port = xtables_service_to_port(colon + 1, NULL)) == (unsigned)-1)
+			xtables_param_act(XTF_BAD_VALUE, "DNAT", "--to", arg);
 
-		dash = strchr(colon, '-');
-		if (!dash) {
+		switch (*end) {
+		case '\0':
 			range.min.tcp.port
 				= range.max.tcp.port
 				= htons(port);
-		} else {
-			int maxport;
+			break;
+		case '-':
+			if (!xtables_strtoui(end + 1, NULL, &maxport, 0, UINT16_MAX) &&
+			    (maxport = xtables_service_to_port(end + 1, NULL)) == (unsigned)-1)
+				xtables_param_act(XTF_BAD_VALUE, "DNAT", "--to", arg);
 
-			maxport = atoi(dash + 1);
-			if (maxport <= 0 || maxport > 65535)
-				xtables_error(PARAMETER_PROBLEM,
-					   "Port `%s' not valid\n", dash+1);
 			if (maxport < port)
-				/* People are stupid. */
-				xtables_error(PARAMETER_PROBLEM,
-					   "Port range `%s' funky\n", colon+1);
+				xtables_param_act(XTF_BAD_VALUE, "DNAT", "--to", arg);
+
 			range.min.tcp.port = htons(port);
 			range.max.tcp.port = htons(maxport);
+			break;
+		default:
+			xtables_param_act(XTF_BAD_VALUE, "DNAT", "--to", arg);
 		}
 		/* Starts with a colon? No IP info...*/
 		if (colon == arg) {
diff --git a/extensions/libipt_SNAT.c b/extensions/libipt_SNAT.c
index 1a24f3d..01be677 100644
--- a/extensions/libipt_SNAT.c
+++ b/extensions/libipt_SNAT.c
@@ -67,7 +67,7 @@ static struct xt_entry_target *
 parse_to(const char *orig_arg, int portok, struct ipt_natinfo *info)
 {
 	struct nf_nat_ipv4_range range;
-	char *arg, *colon, *dash, *error;
+	char *arg, *colon, *dash;
 	const struct in_addr *ip;
 
 	arg = strdup(orig_arg);
@@ -77,7 +77,8 @@ parse_to(const char *orig_arg, int portok, struct ipt_natinfo *info)
 	colon = strchr(arg, ':');
 
 	if (colon) {
-		int port;
+		char *end = "";
+		unsigned int port, maxport;
 
 		if (!portok)
 			xtables_error(PARAMETER_PROBLEM,
@@ -85,34 +86,29 @@ parse_to(const char *orig_arg, int portok, struct ipt_natinfo *info)
 
 		range.flags |= NF_NAT_RANGE_PROTO_SPECIFIED;
 
-		port = atoi(colon+1);
-		if (port <= 0 || port > 65535)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Port `%s' not valid\n", colon+1);
-
-		error = strchr(colon+1, ':');
-		if (error)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Invalid port:port syntax - use dash\n");
+		if (!xtables_strtoui(colon + 1, &end, &port, 0, UINT16_MAX) &&
+		    (port = xtables_service_to_port(colon + 1, NULL)) == (unsigned)-1)
+			xtables_param_act(XTF_BAD_VALUE, "SNAT", "--to", arg);
 
-		dash = strchr(colon, '-');
-		if (!dash) {
+		switch (*end) {
+		case '\0':
 			range.min.tcp.port
 				= range.max.tcp.port
 				= htons(port);
-		} else {
-			int maxport;
+			break;
+		case '-':
+			if (!xtables_strtoui(end + 1, NULL, &maxport, 0, UINT16_MAX) &&
+			    (maxport = xtables_service_to_port(end + 1, NULL)) == (unsigned)-1)
+				xtables_param_act(XTF_BAD_VALUE, "SNAT", "--to", arg);
 
-			maxport = atoi(dash + 1);
-			if (maxport <= 0 || maxport > 65535)
-				xtables_error(PARAMETER_PROBLEM,
-					   "Port `%s' not valid\n", dash+1);
 			if (maxport < port)
-				/* People are stupid. */
-				xtables_error(PARAMETER_PROBLEM,
-					   "Port range `%s' funky\n", colon+1);
+				xtables_param_act(XTF_BAD_VALUE, "SNAT", "--to", arg);
+
 			range.min.tcp.port = htons(port);
 			range.max.tcp.port = htons(maxport);
+			break;
+		default:
+			xtables_param_act(XTF_BAD_VALUE, "SNAT", "--to", arg);
 		}
 		/* Starts with a colon? No IP info...*/
 		if (colon == arg) {

--cNdxnHkX5QqsyA0e--
