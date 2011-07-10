From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/6] libxtables: ignore whitespace in the multiaddress argument parser
Date: Sun, 10 Jul 2011 20:22:14 +0200
Message-ID: <1310322139-28505-3-git-send-email-jengelh@medozas.de>
References: <1310322139-28505-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:58434 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756317Ab1GJSWX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 10 Jul 2011 14:22:23 -0400
In-Reply-To: <1310322139-28505-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

References: http://bugzilla.netfilter.org/show_bug.cgi?id=727
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 iptables/xtables.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/iptables/xtables.c b/iptables/xtables.c
index 3b17395..0f02592 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -1314,6 +1314,8 @@ void xtables_ipparse_multiple(const char *name, struct in_addr **addrpp,
 	loop = name;
 
 	for (i = 0; i < count; ++i) {
+		while (isspace(*loop))
+			++loop;
 		next = strchr(loop, ',');
 		if (next != NULL)
 			len = next - loop;
@@ -1628,6 +1630,8 @@ xtables_ip6parse_multiple(const char *name, struct in6_addr **addrpp,
 	loop = name;
 
 	for (i = 0; i < count /*NB: count can grow*/; ++i) {
+		while (isspace(*loop))
+			++loop;
 		next = strchr(loop, ',');
 		if (next != NULL)
 			len = next - loop;
-- 
1.7.3.4

