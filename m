From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/3] iprange: warn on reverse range
Date: Wed, 23 Sep 2009 23:26:32 +0200
Message-ID: <1253741194-26060-3-git-send-email-jengelh@medozas.de>
References: <1253741194-26060-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:52873 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901AbZIWV0f (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Sep 2009 17:26:35 -0400
In-Reply-To: <1253741194-26060-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Reverse ranges like B-A cause packets to be generally never matched,
as an address S does not match >=B && <=A (except for the border case
where S=A=B).

The kernel module itself does not check for reverse ranges, and it
seems nicer to check that in userspace anyway.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_iprange.c |   51 +++++++++++++++++++++++++-------------------
 1 files changed, 29 insertions(+), 22 deletions(-)

diff --git a/extensions/libxt_iprange.c b/extensions/libxt_iprange.c
index fc9abbb..c585766 100644
--- a/extensions/libxt_iprange.c
+++ b/extensions/libxt_iprange.c
@@ -30,51 +30,58 @@ static const struct option iprange_mt_opts[] = {
 	{ .name = NULL }
 };
 
-static void iprange_parse_range(char *arg, union nf_inet_addr *range,
-				u_int8_t family, const char *optname)
+static void
+iprange_parse_spec(const char *from, const char *to, union nf_inet_addr *range,
+		   uint8_t family, const char *optname)
 {
 	struct in6_addr *ia6;
 	struct in_addr *ia4;
-	char *dash;
 
 	memset(range, 0, sizeof(union nf_inet_addr) * 2);
-	dash = strchr(arg, '-');
-	if (dash != NULL)
-		*dash = '\0';
 
 	if (family == NFPROTO_IPV6) {
-		ia6 = xtables_numeric_to_ip6addr(arg);
+		ia6 = xtables_numeric_to_ip6addr(from);
 		if (ia6 == NULL)
 			xtables_param_act(XTF_BAD_VALUE, "iprange",
-				optname, arg);
+				optname, from);
 		range[0].in6 = *ia6;
-		if (dash == NULL) {
-			range[1] = range[0];
-			return;
-		}
-		ia6 = xtables_numeric_to_ip6addr(dash + 1);
+		ia6 = xtables_numeric_to_ip6addr(to);
 		if (ia6 == NULL)
 			xtables_param_act(XTF_BAD_VALUE, "iprange",
-				optname, dash + 1);
+				optname, to);
 		range[1].in6 = *ia6;
 	} else {
-		ia4 = xtables_numeric_to_ipaddr(arg);
+		ia4 = xtables_numeric_to_ipaddr(from);
 		if (ia4 == NULL)
 			xtables_param_act(XTF_BAD_VALUE, "iprange",
-				optname, arg);
+				optname, from);
 		range[0].in = *ia4;
-		if (dash == NULL) {
-			range[1] = range[0];
-			return;
-		}
-		ia4 = xtables_numeric_to_ipaddr(dash + 1);
+		ia4 = xtables_numeric_to_ipaddr(to);
 		if (ia4 == NULL)
 			xtables_param_act(XTF_BAD_VALUE, "iprange",
-				optname, dash + 1);
+				optname, to);
 		range[1].in = *ia4;
 	}
 }
 
+static void iprange_parse_range(char *arg, union nf_inet_addr *range,
+				u_int8_t family, const char *optname)
+{
+	char *dash;
+
+	dash = strchr(arg, '-');
+	if (dash == NULL) {
+		iprange_parse_spec(arg, arg, range, family, optname);
+		return;
+	}
+
+	*dash = '\0';
+	iprange_parse_spec(arg, dash + 1, range, family, optname);
+	if (memcmp(&range[0], &range[1], sizeof(*range)) > 0)
+		fprintf(stderr, "xt_iprange: range %s-%s is reversed and "
+			"will never match\n", arg, dash + 1);
+}
+
 static int iprange_parse(int c, char **argv, int invert, unsigned int *flags,
                          const void *entry, struct xt_entry_match **match)
 {
-- 
1.6.4.4

