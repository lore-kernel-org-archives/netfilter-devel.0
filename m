From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 3/4] iptables: always print mask in iptables-save
Date: Sun, 25 Nov 2007 02:06:42 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711250206250.25644@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0711250204360.25644@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:35704 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870AbXKYBGn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 24 Nov 2007 20:06:43 -0500
In-Reply-To: <Pine.LNX.4.64.0711250204360.25644@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


iptables prints the mask as a prefix length if it is valid;
This patch makes iptables-save do the same.

Also, iptables-save will always print "/32" in the "-s addr/32"
case now. This reduces the amount of code external parsing scripts
need to provide to properly parse iptables-save output.

ip6tables-save already does the right thing, so no change there.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 iptables-save.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

Index: iptables/iptables-save.c
===================================================================
--- iptables.orig/iptables-save.c
+++ iptables/iptables-save.c
@@ -141,6 +141,9 @@ static int print_match(const struct ipt_
 /* print a given ip including mask if neccessary */
 static void print_ip(char *prefix, u_int32_t ip, u_int32_t mask, int invert)
 {
+	u_int32_t bits, hmask = ntohl(mask);
+	int i;
+
 	if (!mask && !ip && !invert)
 		return;
 
@@ -149,10 +152,19 @@ static void print_ip(char *prefix, u_int
 		invert ? "! " : "",
 		IP_PARTS(ip));
 
-	if (mask != 0xffffffff) 
-		printf("/%u.%u.%u.%u ", IP_PARTS(mask));
+	if (mask == 0xFFFFFFFFU) {
+		printf("/32 ");
+		return;
+	}
+
+	i    = 32;
+	bits = 0xFFFFFFFEU;
+	while (--i >= 0 && hmask != bits)
+		bits <<= 1;
+	if (i >= 0)
+		printf("/%u ", i);
 	else
-		printf(" ");
+		printf("/%u.%u.%u.%u ", IP_PARTS(mask));
 }
 
 /* We want this to be readable, so only print out neccessary fields.
