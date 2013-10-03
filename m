From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables PATCH 3/3] xtables: arp: Do not add a useless prefix for afinfo_arp
Date: Thu,  3 Oct 2013 12:52:57 +0300
Message-ID: <1380793977-9730-4-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1380793977-9730-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:10353 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753913Ab3JCJxJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Oct 2013 05:53:09 -0400
In-Reply-To: <1380793977-9730-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Let's use libxt_ as it should, since CLASSIFY and now mangle targets
(the 2 only targets xtables-arp is going to use) are libxt_ prefixed.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/xtables-arp-standalone.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/xtables-arp-standalone.c b/iptables/xtables-arp-standalone.c
index 8d4679f..a9c880f 100644
--- a/iptables/xtables-arp-standalone.c
+++ b/iptables/xtables-arp-standalone.c
@@ -47,7 +47,7 @@ extern const char *program_version, *program_name;
 static const struct xtables_afinfo afinfo_arp = {
         .kmod          = "arp_tables",
         .proc_exists   = "/proc/net/arp_tables_names",
-        .libprefix     = "libarp_",
+        .libprefix     = "libxt_",
         .family        = NFPROTO_ARP,
         .ipproto       = IPPROTO_IP,
         .so_rev_match  = -1,
-- 
1.8.3.2

