From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables PATCH v2] xtables: arp: Parse properly target's options
Date: Thu,  3 Oct 2013 16:00:47 +0300
Message-ID: <1380805247-12362-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:51538 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753125Ab3JCNAx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Oct 2013 09:00:53 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Without this, target never gets its options parsed, so it's a bug.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/xtables-arp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/iptables/xtables-arp.c b/iptables/xtables-arp.c
index 8072d90..411a699 100644
--- a/iptables/xtables-arp.c
+++ b/iptables/xtables-arp.c
@@ -1317,6 +1317,10 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table)
 			exit_tryhelp(2);
 
 		default:
+			if (target) {
+				xtables_option_tpcall(c, argv,
+						      invert, target, &fw);
+			}
 			break;
 		}
 		invert = FALSE;
@@ -1325,8 +1329,6 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table)
 	if (target)
 		xtables_option_tfcall(target);
 
-	/* Fix me: must put inverse options checking here --MN */
-
 	if (optind < argc)
 		xtables_error(PARAMETER_PROBLEM,
 			      "unknown arguments found on commandline");
-- 
1.8.3.2

