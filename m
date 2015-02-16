From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH iptables] xtables-compat: remove unused fields from bridge and arp families
Date: Mon, 16 Feb 2015 23:05:40 +0100
Message-ID: <1424124340-29640-1-git-send-email-pablo@netfilter.org>
Cc: arturo.borrero.glez@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52046 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467AbbBPWC3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Feb 2015 17:02:29 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

These two families only work under nft compat, so leave unset the fields
that we don't use. Basically, we need neither the module autoload code
nor the native get/setsockopt() revision infrastructure since we use the
one that nft_compat provides through nfnetlink.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 libxtables/xtables.c |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index 0200c7a..9df12ce 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -168,24 +168,17 @@ static const struct xtables_afinfo afinfo_ipv6 = {
 	.so_rev_target = IP6T_SO_GET_REVISION_TARGET,
 };
 
+/* Dummy families for arptables-compat and ebtables-compat. Leave structure
+ * fields that we don't use unset.
+ */
 static const struct xtables_afinfo afinfo_bridge = {
-	.kmod          = "eb_tables",
-	.proc_exists   = "/proc/net/eb_tables_names",
 	.libprefix     = "libebt_",
 	.family        = NFPROTO_BRIDGE,
-	.ipproto       = IPPROTO_IP,
-	.so_rev_match  = -1,
-	.so_rev_target = -1,
 };
 
 static const struct xtables_afinfo afinfo_arp = {
-	.kmod          = "arp_tables",
-	.proc_exists   = "/proc/net/eb_tables_names",
 	.libprefix     = "libarpt_",
 	.family        = NFPROTO_ARP,
-	.ipproto       = IPPROTO_IP,
-	.so_rev_match  = -1,
-	.so_rev_target = -1,
 };
 
 const struct xtables_afinfo *afinfo;
-- 
1.7.10.4

