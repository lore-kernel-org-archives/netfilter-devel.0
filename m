From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables (nft-compat) PATCH 3/8] xtables: Handle family is not related to Netlink family
Date: Tue, 11 Feb 2014 12:46:43 +0200
Message-ID: <1392115608-6733-4-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1392115608-6733-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:54423 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701AbaBKKrE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Feb 2014 05:47:04 -0500
In-Reply-To: <1392115608-6733-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

AF_INET vs NFPROTO_IPV4
AF_INET6 vs NFPROTO_IPV6

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/xtables-restore.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index c4af2c5..80bd724 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -475,12 +475,12 @@ xtables_restore_main(int family, const char *progname, int argc, char *argv[])
 
 int xtables_ip4_restore_main(int argc, char *argv[])
 {
-	return xtables_restore_main(NFPROTO_IPV4, "iptables-restore",
+	return xtables_restore_main(AF_INET, "iptables-restore",
 				    argc, argv);
 }
 
 int xtables_ip6_restore_main(int argc, char *argv[])
 {
-	return xtables_restore_main(NFPROTO_IPV6, "ip6tables-restore",
+	return xtables_restore_main(AF_INET6, "ip6tables-restore",
 				    argc, argv);
 }
-- 
1.8.3.2

