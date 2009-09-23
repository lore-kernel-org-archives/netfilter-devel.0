From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/3] iprange: roll address parsing into a loop
Date: Wed, 23 Sep 2009 23:26:33 +0200
Message-ID: <1253741194-26060-4-git-send-email-jengelh@medozas.de>
References: <1253741194-26060-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:52875 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397AbZIWV0g (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Sep 2009 17:26:36 -0400
In-Reply-To: <1253741194-26060-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

A small cleanup.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_iprange.c |   36 ++++++++++++++++--------------------
 1 files changed, 16 insertions(+), 20 deletions(-)

diff --git a/extensions/libxt_iprange.c b/extensions/libxt_iprange.c
index c585766..9e544ea 100644
--- a/extensions/libxt_iprange.c
+++ b/extensions/libxt_iprange.c
@@ -34,33 +34,29 @@ static void
 iprange_parse_spec(const char *from, const char *to, union nf_inet_addr *range,
 		   uint8_t family, const char *optname)
 {
+	const char *spec[2] = {from, to};
 	struct in6_addr *ia6;
 	struct in_addr *ia4;
+	unsigned int i;
 
 	memset(range, 0, sizeof(union nf_inet_addr) * 2);
 
 	if (family == NFPROTO_IPV6) {
-		ia6 = xtables_numeric_to_ip6addr(from);
-		if (ia6 == NULL)
-			xtables_param_act(XTF_BAD_VALUE, "iprange",
-				optname, from);
-		range[0].in6 = *ia6;
-		ia6 = xtables_numeric_to_ip6addr(to);
-		if (ia6 == NULL)
-			xtables_param_act(XTF_BAD_VALUE, "iprange",
-				optname, to);
-		range[1].in6 = *ia6;
+		for (i = 0; i < ARRAY_SIZE(spec); ++i) {
+			ia6 = xtables_numeric_to_ip6addr(spec[i]);
+			if (ia6 == NULL)
+				xtables_param_act(XTF_BAD_VALUE, "iprange",
+					optname, spec[i]);
+			range[i].in6 = *ia6;
+		}
 	} else {
-		ia4 = xtables_numeric_to_ipaddr(from);
-		if (ia4 == NULL)
-			xtables_param_act(XTF_BAD_VALUE, "iprange",
-				optname, from);
-		range[0].in = *ia4;
-		ia4 = xtables_numeric_to_ipaddr(to);
-		if (ia4 == NULL)
-			xtables_param_act(XTF_BAD_VALUE, "iprange",
-				optname, to);
-		range[1].in = *ia4;
+		for (i = 0; i < ARRAY_SIZE(spec); ++i) {
+			ia4 = xtables_numeric_to_ipaddr(spec[i]);
+			if (ia4 == NULL)
+				xtables_param_act(XTF_BAD_VALUE, "iprange",
+					optname, spec[i]);
+			range[i].in = *ia4;
+		}
 	}
 }
 
-- 
1.6.4.4

