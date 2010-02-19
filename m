From: "Dmitry V. Levin" <ldv@altlinux.org>
Subject: [PATCH] REDIRECT: Fix --to-ports parser
Date: Fri, 19 Feb 2010 04:31:22 +0300
Message-ID: <20100219013122.GA31860@wo.int.altlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vint.altlinux.org ([194.107.17.35]:45602 "EHLO
	vint.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113Ab0BSBbY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Feb 2010 20:31:24 -0500
Received: from wo.int.altlinux.org (wo.int.altlinux.org [192.168.1.4])
	by vint.altlinux.org (Postfix) with ESMTP id 84021226C001
	for <netfilter-devel@vger.kernel.org>; Fri, 19 Feb 2010 01:31:23 +0000 (UTC)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Rewrite port range validator to use xtables_strtoui() and
xtables_param_act().  Original check failed to recognize
several types of port range errors, including:
"-1", "-1a", "-1-a", "a-1", "1a-2", "1-2a", etc.
Also, original parser erroneously denied using port 0,
which is now allowed.

Signed-off-by: Dmitry V. Levin <ldv@altlinux.org>
---
 extensions/libipt_REDIRECT.c |   40 ++++++++++++++++++----------------------
 1 files changed, 18 insertions(+), 22 deletions(-)

diff --git a/extensions/libipt_REDIRECT.c b/extensions/libipt_REDIRECT.c
index d39f0bd..3dfcadf 100644
--- a/extensions/libipt_REDIRECT.c
+++ b/extensions/libipt_REDIRECT.c
@@ -39,40 +39,36 @@ static void REDIRECT_init(struct xt_entry_target *t)
 static void
 parse_ports(const char *arg, struct nf_nat_multi_range *mr)
 {
-	const char *dash;
-	int port;
+	char *end;
+	unsigned int port, maxport;
 
 	mr->range[0].flags |= IP_NAT_RANGE_PROTO_SPECIFIED;
 
-	if (strchr(arg, '.'))
-		xtables_error(PARAMETER_PROBLEM, "IP address not permitted\n");
+	if (!xtables_strtoui(arg, &end, &port, 0, UINT16_MAX) &&
+	    (port = xtables_service_to_port(arg, NULL)) == (unsigned)-1)
+		xtables_param_act(XTF_BAD_VALUE, "REDIRECT", "--to-ports", arg);
 
-	port = atoi(arg);
-	if (port == 0)
-		port = xtables_service_to_port(arg, NULL);
-
-	if (port == 0 || port > 65535)
-		xtables_error(PARAMETER_PROBLEM, "Port \"%s\" not valid\n", arg);
-
-	dash = strchr(arg, '-');
-	if (!dash) {
+	switch (*end) {
+	case '\0':
 		mr->range[0].min.tcp.port
 			= mr->range[0].max.tcp.port
 			= htons(port);
-	} else {
-		int maxport;
+		return;
+	case '-':
+		if (!xtables_strtoui(end + 1, NULL, &maxport, 0, UINT16_MAX) &&
+		    (maxport = xtables_service_to_port(end + 1, NULL)) == (unsigned)-1)
+			break;
 
-		maxport = atoi(dash + 1);
-		if (maxport == 0 || maxport > 65535)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Port `%s' not valid\n", dash+1);
 		if (maxport < port)
-			/* People are stupid. */
-			xtables_error(PARAMETER_PROBLEM,
-				   "Port range `%s' funky\n", arg);
+			break;
+
 		mr->range[0].min.tcp.port = htons(port);
 		mr->range[0].max.tcp.port = htons(maxport);
+		return;
+	default:
+		break;
 	}
+	xtables_param_act(XTF_BAD_VALUE, "REDIRECT", "--to-ports", arg);
 }
 
 static int REDIRECT_parse(int c, char **argv, int invert, unsigned int *flags,
-- 
ldv
