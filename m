From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables v2 PATCH] nft: arp: inhibate -l option so only a fixed size arhln is in use
Date: Thu,  7 Nov 2013 10:14:37 +0200
Message-ID: <1383812077-5096-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:43206 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010Ab3KGIOl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Nov 2013 03:14:41 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a temporary workaround mechanism until variable interface hardware
address length can be handled through nftables.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/xtables-arp.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/iptables/xtables-arp.c b/iptables/xtables-arp.c
index 18f285c..5ab0fb4 100644
--- a/iptables/xtables-arp.c
+++ b/iptables/xtables-arp.c
@@ -1145,6 +1145,13 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table)
 				   invert);
 			getlength_and_mask(argv[optind - 1], &fw.arp.arhln,
 					   &fw.arp.arhln_mask);
+
+			if (fw.arp.arhln != 6) {
+				xtables_error(PARAMETER_PROBLEM,
+					      "Only harware address length of"
+					      " 6 is supported currently.");
+			}
+
 			break;
 
 		case 8:/* protocol length */
-- 
1.8.4.2

