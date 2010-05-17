From: "Dmitry V. Levin" <ldv@altlinux.org>
Subject: [PATCH] MASQUERADE: fix --to-ports parser
Date: Tue, 18 May 2010 00:09:55 +0400
Message-ID: <20100517200955.GB17408@wo.int.altlinux.org>
References: <20100219033019.GB25665@wo.int.altlinux.org> <4BED339D.60007@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vint.altlinux.org ([194.107.17.35]:44595 "EHLO
	vint.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754852Ab0EQUR6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 May 2010 16:17:58 -0400
Content-Disposition: inline
In-Reply-To: <4BED339D.60007@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Rewrite port range validator to use xtables_strtoui() and
xtables_param_act().  Original check failed to recognize
such port range errors as "1a-2" and "1-2a".
Also, original parser erroneously denied using port 0,
which is now allowed.

Signed-off-by: Dmitry V. Levin <ldv@altlinux.org>
---
 extensions/libipt_MASQUERADE.c |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/extensions/libipt_MASQUERADE.c b/extensions/libipt_MASQUERADE.c
index 9d7fc17..3386ff3 100644
--- a/extensions/libipt_MASQUERADE.c
+++ b/extensions/libipt_MASQUERADE.c
@@ -38,34 +38,34 @@ static void MASQUERADE_init(struct xt_entry_target *t)
 static void
 parse_ports(const char *arg, struct nf_nat_multi_range *mr)
 {
-	const char *dash;
-	int port;
+	char *end;
+	unsigned int port, maxport;
 
 	mr->range[0].flags |= IP_NAT_RANGE_PROTO_SPECIFIED;
 
-	port = atoi(arg);
-	if (port <= 0 || port > 65535)
-		xtables_error(PARAMETER_PROBLEM, "Port \"%s\" not valid\n", arg);
+	if (!xtables_strtoui(arg, &end, &port, 0, UINT16_MAX))
+		xtables_param_act(XTF_BAD_VALUE, "MASQUERADE", "--to-ports", arg);
 
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
+		if (!xtables_strtoui(end + 1, NULL, &maxport, 0, UINT16_MAX))
+			break;
 
-		maxport = atoi(dash + 1);
-		if (maxport == 0 || maxport > 65535)
-			xtables_error(PARAMETER_PROBLEM,
-				   "Port `%s' not valid\n", dash+1);
 		if (maxport < port)
-			/* People are stupid.  Present reader excepted. */
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
+	xtables_param_act(XTF_BAD_VALUE, "MASQUERADE", "--to-ports", arg);
 }
 
 static int MASQUERADE_parse(int c, char **argv, int invert, unsigned int *flags,
-- 
ldv
