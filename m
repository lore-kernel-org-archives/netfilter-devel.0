From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [patch] iptables-1.4.3.1: unabled to restore ! -s 192.168.1.0/24
 match
Date: Sat, 4 Apr 2009 13:40:09 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0904041334001.13174@fbirervta.pbzchgretzou.qr>
References: <49C8DB3B.909@netfilter.org> <1238838634.31963.578.camel@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Peter Volkov <pva@gentoo.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:55182 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbZDDLkN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 4 Apr 2009 07:40:13 -0400
In-Reply-To: <1238838634.31963.578.camel@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Saturday 2009-04-04 11:50, Peter Volkov wrote:

>Hi. We've received bug report about broken ! -s 192.168.1.0/24 match:
>http://bugs.gentoo.org/264089

I combined your two patches, added the missing ip6 parts and used
the default iptables spacing idioms.


Pablo: This is available through the 'plus' branch at 
git://dev.medozas.de/iptables.


parent 9c0fa7d8c84dc2478bd36d31b328b697fbe4d0af (v1.4.3.1-7-g9c0fa7d)
commit b1d968c30dde563c2738fdacb723c18232fb5ccb
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Sat Apr 4 13:28:40 2009 +0200

iptables: print negation extrapositioned

This patch combines the two referenced ones by Peter. I did a quick
extra audit to spot and fix the missing ip6tables parts. (People like
to forget ip6tables it seems.) Extension modules were, to the best of
my knowledge, already audited in v1.4.3-rc1-10-gcea9f71.

Reported-by: Yar Odin <yarodin@gmail.com>
References: http://bugs.gentoo.org/264089
Reported-by: Peter Volkov <pva@gentoo.org>
References: http://marc.info/?l=netfilter-devel&m=123883867907935&w=2
References: http://marc.info/?l=netfilter-devel&m=123883992508943&w=2
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 ip6tables.c |   12 ++++++------
 iptables.c  |   12 ++++++------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/ip6tables.c b/ip6tables.c
index 54366b0..35067f8 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -1006,7 +1006,7 @@ print_iface(char letter, const char *iface, const unsigned char *mask,
 	if (mask[0] == 0)
 		return;
 
-	printf("-%c %s", letter, invert ? "! " : "");
+	printf("%s-%c ", invert ? "! " : "", letter);
 
 	for (i = 0; i < IFNAMSIZ; i++) {
 		if (mask[i] != 0) {
@@ -1033,19 +1033,19 @@ static void print_proto(u_int16_t proto, int invert)
 
 		struct protoent *pent = getprotobynumber(proto);
 		if (pent) {
-			printf("-p %s%s ",
+			printf("%s-p %s ",
 			       invertstr, pent->p_name);
 			return;
 		}
 
 		for (i = 0; xtables_chain_protos[i].name != NULL; ++i)
 			if (xtables_chain_protos[i].num == proto) {
-				printf("-p %s%s ",
+				printf("%s-p %s ",
 				       invertstr, xtables_chain_protos[i].name);
 				return;
 			}
 
-		printf("-p %s%u ", invertstr, proto);
+		printf("%s-p %u ", invertstr, proto);
 	}
 }
 
@@ -1081,9 +1081,9 @@ static void print_ip(char *prefix, const struct in6_addr *ip, const struct in6_a
 	if (l == 0 && !invert)
 		return;
 
-	printf("%s %s%s",
-		prefix,
+	printf("%s%s %s",
 		invert ? "! " : "",
+		prefix,
 		inet_ntop(AF_INET6, ip, buf, sizeof buf));
 
 	if (l == -1)
diff --git a/iptables.c b/iptables.c
index 3449dec..649baf4 100644
--- a/iptables.c
+++ b/iptables.c
@@ -1006,18 +1006,18 @@ static void print_proto(u_int16_t proto, int invert)
 
 		struct protoent *pent = getprotobynumber(proto);
 		if (pent) {
-			printf("-p %s%s ", invertstr, pent->p_name);
+			printf("%s-p %s ", invertstr, pent->p_name);
 			return;
 		}
 
 		for (i = 0; xtables_chain_protos[i].name != NULL; ++i)
 			if (xtables_chain_protos[i].num == proto) {
-				printf("-p %s%s ",
+				printf("%s-p %s ",
 				       invertstr, xtables_chain_protos[i].name);
 				return;
 			}
 
-		printf("-p %s%u ", invertstr, proto);
+		printf("%s-p %u ", invertstr, proto);
 	}
 }
 
@@ -1039,7 +1039,7 @@ print_iface(char letter, const char *iface, const unsigned char *mask,
 	if (mask[0] == 0)
 		return;
 
-	printf("-%c %s", letter, invert ? "! " : "");
+	printf("%s-%c ", invert ? "! " : "", letter);
 
 	for (i = 0; i < IFNAMSIZ; i++) {
 		if (mask[i] != 0) {
@@ -1089,9 +1089,9 @@ static void print_ip(char *prefix, u_int32_t ip, u_int32_t mask, int invert)
 	if (!mask && !ip && !invert)
 		return;
 
-	printf("%s %s%u.%u.%u.%u",
-		prefix,
+	printf("%s%s %u.%u.%u.%u",
 		invert ? "! " : "",
+		prefix,
 		IP_PARTS(ip));
 
 	if (mask == 0xFFFFFFFFU) {
-- 
# Created with git-export-patch
