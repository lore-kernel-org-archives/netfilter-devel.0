From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables PATCH] nft: arp: inhibate -l option so only a fixed size arhln is in use
Date: Wed,  6 Nov 2013 13:51:09 +0200
Message-ID: <1383738669-25602-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:62594 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932535Ab3KFLvj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Nov 2013 06:51:39 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a temporary fallback mechanism until variable interface hardware
address length can be handled through nftables.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/xtables-arp.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/iptables/xtables-arp.c b/iptables/xtables-arp.c
index 18f285c..97dbca9 100644
--- a/iptables/xtables-arp.c
+++ b/iptables/xtables-arp.c
@@ -272,7 +272,8 @@ static int getmac_and_mask(char *from, char *to, char *mask)
 	return 0;
 }
 
-static int getlength_and_mask(char *from, uint8_t *to, uint8_t *mask)
+/* Necessary when -l will be supported */
+/*static int getlength_and_mask(char *from, uint8_t *to, uint8_t *mask)
 {
 	char *p, *buffer;
 	int i;
@@ -290,7 +291,7 @@ static int getlength_and_mask(char *from, uint8_t *to, uint8_t *mask)
 		return -1;
 	*to = (uint8_t)i;
 	return 0;
-}
+}*/
 
 static int get16_and_mask(char *from, uint16_t *to, uint16_t *mask, int base)
 {
@@ -974,6 +975,9 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table)
 	    demand-load a protocol. */
 	opterr = 0;
 
+	/*-l is currently not supported: falling back to a fixed sized arhln*/
+	fw.arp.arhln = 6;
+
 	while ((c = getopt_long(argc, argv,
 	   "-A:D:R:I:L::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:l:i:vnt:m:c:",
 					   opts, NULL)) != -1) {
@@ -1140,11 +1144,13 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table)
 			break;
 
 		case 'l':/* hardware length */
-			check_inverse(optarg, &invert, &optind, argc);
+			xtables_error(PARAMETER_PROBLEM, "not supported");
+
+			/*check_inverse(optarg, &invert, &optind, argc);
 			set_option(&options, OPT_H_LENGTH, &fw.arp.invflags,
 				   invert);
 			getlength_and_mask(argv[optind - 1], &fw.arp.arhln,
-					   &fw.arp.arhln_mask);
+					   &fw.arp.arhln_mask);*/
 			break;
 
 		case 8:/* protocol length */
-- 
1.8.4.2

