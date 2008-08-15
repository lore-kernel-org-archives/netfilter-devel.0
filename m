From: Jan Engelhardt <jengelh@medozas.de>
Subject: src: flatten casts in libxt_mac
Date: Fri, 15 Aug 2008 18:56:34 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0808151856170.26696@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:33903 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbYHOW4g (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Aug 2008 18:56:36 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit bea784eff0e167fc8ba28e6ff6d216d95def610b
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Fri Aug 15 18:48:35 2008 -0400

src: flatten casts in libxt_mac

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_mac.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/extensions/libxt_mac.c b/extensions/libxt_mac.c
index a842ee9..bc91f0f 100644
--- a/extensions/libxt_mac.c
+++ b/extensions/libxt_mac.c
@@ -74,7 +74,7 @@ mac_parse(int c, char **argv, int invert, unsigned int *flags,
 	return 1;
 }
 
-static void print_mac(unsigned char macaddress[ETH_ALEN])
+static void print_mac(const unsigned char macaddress[ETH_ALEN])
 {
 	unsigned int i;
 
@@ -96,22 +96,25 @@ static void mac_check(unsigned int flags)
 static void
 mac_print(const void *ip, const struct xt_entry_match *match, int numeric)
 {
+	const struct xt_mac_info *info = (void *)match->data;
 	printf("MAC ");
 
-	if (((struct xt_mac_info *)match->data)->invert)
+	if (info->invert)
 		printf("! ");
 	
-	print_mac(((struct xt_mac_info *)match->data)->srcaddr);
+	print_mac(info->srcaddr);
 }
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
 static void mac_save(const void *ip, const struct xt_entry_match *match)
 {
-	if (((struct xt_mac_info *)match->data)->invert)
+	const struct xt_mac_info *info = (void *)match->data;
+
+	if (info->invert)
 		printf("! ");
 
 	printf("--mac-source ");
-	print_mac(((struct xt_mac_info *)match->data)->srcaddr);
+	print_mac(info->srcaddr);
 }
 
 static struct xtables_match mac_match = {

