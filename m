From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/3] build: restore --disable-ipv6 functionality on system w/o v6 headers
Date: Thu, 29 Oct 2009 19:11:15 +0100
Message-ID: <1256839878-24358-2-git-send-email-jengelh@medozas.de>
References: <1256839878-24358-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:56277 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754125AbZJ2SLR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Oct 2009 14:11:17 -0400
In-Reply-To: <1256839878-24358-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Olaf Rempel <razzor@kopf-tisch.de>

Commit 332e4acc (iptables: accept multiple IP address specifications
for -s, d) broke the --disable-ipv6 configure option.

> ./.libs/libxtables.so: undefined reference to `in6addr_any'

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 xtables.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/xtables.c b/xtables.c
index 4520124..bda49f8 100644
--- a/xtables.c
+++ b/xtables.c
@@ -1484,6 +1484,7 @@ void
 xtables_ip6parse_multiple(const char *name, struct in6_addr **addrpp,
 		      struct in6_addr **maskpp, unsigned int *naddrs)
 {
+	static const struct in6_addr zero_addr;
 	struct in6_addr *addrp;
 	char buf[256], *p;
 	unsigned int len, i, j, n, count = 1;
@@ -1526,7 +1527,7 @@ xtables_ip6parse_multiple(const char *name, struct in6_addr **addrpp,
 		memcpy(*maskpp + i, addrp, sizeof(*addrp));
 
 		/* if a null mask is given, the name is ignored, like in "any/0" */
-		if (memcmp(*maskpp + i, &in6addr_any, sizeof(in6addr_any)) == 0)
+		if (memcmp(*maskpp + i, &zero_addr, sizeof(zero_addr)) == 0)
 			strcpy(buf, "::");
 
 		addrp = ip6parse_hostnetwork(buf, &n);
-- 
1.6.5.1

