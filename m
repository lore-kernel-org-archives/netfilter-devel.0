From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 55/79: ebt_among: obtain match size through different means
Date: Wed,  8 Oct 2008 12:47:35 +0200 (MEST)
Message-ID: <20081008104735.10423.66877.sendpatchset@x2.localnet>
References: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46029 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754740AbYJHKrh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Oct 2008 06:47:37 -0400
In-Reply-To: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 815377fe344c799228ca6278613ca3100b069ad5
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Wed Oct 8 11:35:14 2008 +0200

    netfilter: ebt_among: obtain match size through different means
    
    The function signatures will be changed to match those of Xtables, and
    the datalen argument will be gone. ebt_among unfortunately relies on
    it, so we need to obtain it somehow.
    
    Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/bridge/netfilter/ebt_among.c b/net/bridge/netfilter/ebt_among.c
index 568c890..88b5c91 100644
--- a/net/bridge/netfilter/ebt_among.c
+++ b/net/bridge/netfilter/ebt_among.c
@@ -178,6 +178,8 @@ ebt_among_check(const char *tablename, unsigned int hookmask,
 		const struct ebt_entry *e, void *data,
 		unsigned int datalen)
 {
+	const struct ebt_entry_match *em =
+		container_of(data, const struct ebt_entry_match, data);
 	const struct ebt_among_info *info = data;
 	int expected_length = sizeof(struct ebt_among_info);
 	const struct ebt_mac_wormhash *wh_dst, *wh_src;
@@ -188,11 +190,11 @@ ebt_among_check(const char *tablename, unsigned int hookmask,
 	expected_length += ebt_mac_wormhash_size(wh_dst);
 	expected_length += ebt_mac_wormhash_size(wh_src);
 
-	if (datalen != EBT_ALIGN(expected_length)) {
+	if (em->match_size != EBT_ALIGN(expected_length)) {
 		printk(KERN_WARNING
 		       "ebtables: among: wrong size: %d "
 		       "against expected %d, rounded to %Zd\n",
-		       datalen, expected_length,
+		       em->match_size, expected_length,
 		       EBT_ALIGN(expected_length));
 		return false;
 	}
