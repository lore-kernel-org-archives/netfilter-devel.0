From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/6] libxtables: properly reject empty hostnames
Date: Sun, 10 Jul 2011 20:22:13 +0200
Message-ID: <1310322139-28505-2-git-send-email-jengelh@medozas.de>
References: <1310322139-28505-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:58432 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756314Ab1GJSWX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 10 Jul 2011 14:22:23 -0400
In-Reply-To: <1310322139-28505-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

An empty hostname in the address list of an -s/-d argument, which may
be the result of a typo, is interpreted as 0/0, which, when combined
with -j ACCEPT, leads to an undesired opening of the firewall.

References: http://bugzilla.netfilter.org/show_bug.cgi?id=727
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 iptables/xtables.c |   46 ++++++++++++++++++++--------------------------
 1 files changed, 20 insertions(+), 26 deletions(-)

diff --git a/iptables/xtables.c b/iptables/xtables.c
index c4b1c2a..3b17395 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -1299,7 +1299,7 @@ void xtables_ipparse_multiple(const char *name, struct in_addr **addrpp,
                               struct in_addr **maskpp, unsigned int *naddrs)
 {
 	struct in_addr *addrp;
-	char buf[256], *p;
+	char buf[256], *p, *next;
 	unsigned int len, i, j, n, count = 1;
 	const char *loop = name;
 
@@ -1314,23 +1314,17 @@ void xtables_ipparse_multiple(const char *name, struct in_addr **addrpp,
 	loop = name;
 
 	for (i = 0; i < count; ++i) {
-		if (loop == NULL)
-			break;
-		if (*loop == ',')
-			++loop;
-		if (*loop == '\0')
-			break;
-		p = strchr(loop, ',');
-		if (p != NULL)
-			len = p - loop;
+		next = strchr(loop, ',');
+		if (next != NULL)
+			len = next - loop;
 		else
 			len = strlen(loop);
-		if (len == 0 || sizeof(buf) - 1 < len)
-			break;
+		if (len > sizeof(buf) - 1)
+			xt_params->exit_err(PARAMETER_PROBLEM,
+				"Hostname too long");
 
 		strncpy(buf, loop, len);
 		buf[len] = '\0';
-		loop += len;
 		if ((p = strrchr(buf, '/')) != NULL) {
 			*p = '\0';
 			addrp = parse_ipmask(p + 1);
@@ -1368,6 +1362,9 @@ void xtables_ipparse_multiple(const char *name, struct in_addr **addrpp,
 		}
 		/* free what ipparse_hostnetwork had allocated: */
 		free(addrp);
+		if (next == NULL)
+			break;
+		loop = next + 1;
 	}
 	*naddrs = count;
 	for (i = 0; i < count; ++i)
@@ -1616,7 +1613,7 @@ xtables_ip6parse_multiple(const char *name, struct in6_addr **addrpp,
 {
 	static const struct in6_addr zero_addr;
 	struct in6_addr *addrp;
-	char buf[256], *p;
+	char buf[256], *p, *next;
 	unsigned int len, i, j, n, count = 1;
 	const char *loop = name;
 
@@ -1631,23 +1628,17 @@ xtables_ip6parse_multiple(const char *name, struct in6_addr **addrpp,
 	loop = name;
 
 	for (i = 0; i < count /*NB: count can grow*/; ++i) {
-		if (loop == NULL)
-			break;
-		if (*loop == ',')
-			++loop;
-		if (*loop == '\0')
-			break;
-		p = strchr(loop, ',');
-		if (p != NULL)
-			len = p - loop;
+		next = strchr(loop, ',');
+		if (next != NULL)
+			len = next - loop;
 		else
 			len = strlen(loop);
-		if (len == 0 || sizeof(buf) - 1 < len)
-			break;
+		if (len > sizeof(buf) - 1)
+			xt_params->exit_err(PARAMETER_PROBLEM,
+				"Hostname too long");
 
 		strncpy(buf, loop, len);
 		buf[len] = '\0';
-		loop += len;
 		if ((p = strrchr(buf, '/')) != NULL) {
 			*p = '\0';
 			addrp = parse_ip6mask(p + 1);
@@ -1681,6 +1672,9 @@ xtables_ip6parse_multiple(const char *name, struct in6_addr **addrpp,
 		}
 		/* free what ip6parse_hostnetwork had allocated: */
 		free(addrp);
+		if (next == NULL)
+			break;
+		loop = next + 1;
 	}
 	*naddrs = count;
 	for (i = 0; i < count; ++i)
-- 
1.7.3.4

