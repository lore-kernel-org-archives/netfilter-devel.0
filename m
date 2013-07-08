From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH v2] iptables: allow service names in [DS]NAT targets
Date: Mon, 8 Jul 2013 09:46:06 -0700
Message-ID: <20130708164606.GA10203@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="LZvS9be/3tNcYl/X"
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:50871 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534Ab3GHQqL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Jul 2013 12:46:11 -0400
Received: by mail-pa0-f53.google.com with SMTP id tj12so4586929pac.12
        for <netfilter-devel@vger.kernel.org>; Mon, 08 Jul 2013 09:46:10 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

As reported by Alexander Hoogerhuis, the [DS]NAT targets do not allow use of
service names in the --to argument.  The same problem was fixed in the REDIRECT
target in commit 84d758b3 ("extensions: REDIRECT: fix --to-ports parser").
Use a similar fix here.

This closes bugzilla #514.

Phil

Signed-off-by: Phil Oester <kernel@linuxace.com>

---
v2: also handle IPv6 [DS]NAT targets


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-514

diff --git a/extensions/libip6t_DNAT.c b/extensions/libip6t_DNAT.c
index eaa6bf1..f842e40 100644
--- a/extensions/libip6t_DNAT.c
+++ b/extensions/libip6t_DNAT.c
@@ -46,7 +46,7 @@ static const struct xt_option_entry DNAT_opts[] = {
 static void
 parse_to(const char *orig_arg, int portok, struct nf_nat_range *range)
 {
-	char *arg, *start, *end = NULL, *colon = NULL, *dash, *error;
+	char *arg, *start, *end = "", *colon = NULL, *dash;
 	const struct in6_addr *ip;
 
 	arg = strdup(orig_arg);
@@ -60,8 +60,7 @@ parse_to(const char *orig_arg, int portok, struct nf_nat_range *range)
 		colon = strchr(arg, ':');
 		if (colon && strchr(colon+1, ':'))
 			colon = NULL;
-	}
-	else {
+	} else {
 		start++;
 		end = strchr(start, ']');
 		if (end == NULL)
@@ -73,7 +72,7 @@ parse_to(const char *orig_arg, int portok, struct nf_nat_range *range)
 	}
 
 	if (colon) {
-		int port;
+		unsigned int port, maxport;
 
 		if (!portok)
 			xtables_error(PARAMETER_PROBLEM,
@@ -81,34 +80,29 @@ parse_to(const char *orig_arg, int portok, struct nf_nat_range *range)
 
 		range->flags |= NF_NAT_RANGE_PROTO_SPECIFIED;
 
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
+			xtables_param_act(XTF_BAD_VALUE, "DNAT", "--to", colon);
 
-		dash = strchr(colon, '-');
-		if (!dash) {
+		switch (*end) {
+		case '\0':
 			range->min_proto.tcp.port
 				= range->max_proto.tcp.port
 				= htons(port);
-		} else {
-			int maxport;
+			break;
+		case '-':
+			if (!xtables_strtoui(end + 1, NULL, &maxport, 0, UINT16_MAX) &&
+			    (maxport = xtables_service_to_port(end + 1, NULL)) == (unsigned)-1)
+				xtables_param_act(XTF_BAD_VALUE, "DNAT", "--to", colon);
 
-			maxport = atoi(dash + 1);
-			if (maxport <= 0 || maxport > 65535)
-				xtables_error(PARAMETER_PROBLEM,
-					   "Port `%s' not valid\n", dash+1);
 			if (maxport < port)
-				/* People are stupid. */
-				xtables_error(PARAMETER_PROBLEM,
-					   "Port range `%s' funky\n", colon+1);
+				xtables_param_act(XTF_BAD_VALUE, "DNAT", "--to", colon);
+
 			range->min_proto.tcp.port = htons(port);
 			range->max_proto.tcp.port = htons(maxport);
+			break;
+		default:
+			xtables_param_act(XTF_BAD_VALUE, "DNAT", "--to", colon);
 		}
 		/* Starts with colon or [] colon? No IP info...*/
 		if (colon == arg || colon == arg+2) {
diff --git a/extensions/libip6t_SNAT.c b/extensions/libip6t_SNAT.c
index 7382ad0..ea46f1a 100644
--- a/extensions/libip6t_SNAT.c
+++ b/extensions/libip6t_SNAT.c
@@ -46,7 +46,7 @@ static const struct xt_option_entry SNAT_opts[] = {
 static void
 parse_to(const char *orig_arg, int portok, struct nf_nat_range *range)
 {
-	char *arg, *start, *end = NULL, *colon = NULL, *dash, *error;
+	char *arg, *start, *end = "", *colon = NULL, *dash;
 	const struct in6_addr *ip;
 
 	arg = strdup(orig_arg);
@@ -60,8 +60,7 @@ parse_to(const char *orig_arg, int portok, struct nf_nat_range *range)
 		colon = strchr(arg, ':');
 		if (colon && strchr(colon+1, ':'))
 			colon = NULL;
-	}
-	else {
+	} else {
 		start++;
 		end = strchr(start, ']');
 		if (end == NULL)
@@ -73,7 +72,7 @@ parse_to(const char *orig_arg, int portok, struct nf_nat_range *range)
 	}
 
 	if (colon) {
-		int port;
+		unsigned int port, maxport;
 
 		if (!portok)
 			xtables_error(PARAMETER_PROBLEM,
@@ -81,34 +80,29 @@ parse_to(const char *orig_arg, int portok, struct nf_nat_range *range)
 
 		range->flags |= NF_NAT_RANGE_PROTO_SPECIFIED;
 
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
+			xtables_param_act(XTF_BAD_VALUE, "SNAT", "--to", colon);
 
-		dash = strchr(colon, '-');
-		if (!dash) {
+		switch (*end) {
+		case '\0':
 			range->min_proto.tcp.port
 				= range->max_proto.tcp.port
 				= htons(port);
-		} else {
-			int maxport;
+			break;
+		case '-':
+			if (!xtables_strtoui(end + 1, NULL, &maxport, 0, UINT16_MAX) &&
+			    (maxport = xtables_service_to_port(end + 1, NULL)) == (unsigned)-1)
+				xtables_param_act(XTF_BAD_VALUE, "SNAT", "--to", colon);
 
-			maxport = atoi(dash + 1);
-			if (maxport <= 0 || maxport > 65535)
-				xtables_error(PARAMETER_PROBLEM,
-					   "Port `%s' not valid\n", dash+1);
 			if (maxport < port)
-				/* People are stupid. */
-				xtables_error(PARAMETER_PROBLEM,
-					   "Port range `%s' funky\n", colon+1);
+				xtables_param_act(XTF_BAD_VALUE, "SNAT", "--to", colon);
+
 			range->min_proto.tcp.port = htons(port);
 			range->max_proto.tcp.port = htons(maxport);
+			break;
+		default:
+			xtables_param_act(XTF_BAD_VALUE, "SNAT", "--to", colon);
 		}
 		/* Starts with colon or [] colon? No IP info...*/
 		if (colon == arg || colon == arg+2) {
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

--LZvS9be/3tNcYl/X--
