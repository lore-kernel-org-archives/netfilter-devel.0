From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables PATCH] xtables: arp: Parse properly target's options
Date: Thu,  3 Oct 2013 15:26:17 +0300
Message-ID: <1380803177-11733-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:23882 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753615Ab3JCM0g (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Oct 2013 08:26:36 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Without this, target never gets its options parsed, so it's a bug.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/xtables-arp.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/iptables/xtables-arp.c b/iptables/xtables-arp.c
index 8072d90..147c371 100644
--- a/iptables/xtables-arp.c
+++ b/iptables/xtables-arp.c
@@ -1317,16 +1317,16 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table)
 			exit_tryhelp(2);
 
 		default:
+			if (target) {
+				xtables_option_tfcall(target);
+				xtables_option_tpcall(c, argv,
+						      invert, target, &fw);
+			}
 			break;
 		}
 		invert = FALSE;
 	}
 
-	if (target)
-		xtables_option_tfcall(target);
-
-	/* Fix me: must put inverse options checking here --MN */
-
 	if (optind < argc)
 		xtables_error(PARAMETER_PROBLEM,
 			      "unknown arguments found on commandline");
-- 
1.8.3.2

