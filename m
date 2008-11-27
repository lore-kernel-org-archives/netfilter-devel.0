From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 06/29: netns ebtables: more cleanup during ebt_unregister_table()
Date: Thu, 27 Nov 2008 17:15:11 +0100 (MET)
Message-ID: <20081127161511.13891.54960.sendpatchset@x2.localnet>
References: <20081127161503.13891.62766.sendpatchset@x2.localnet>
Cc: netdev@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53357 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbYK0QPM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Nov 2008 11:15:12 -0500
In-Reply-To: <20081127161503.13891.62766.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit dbcdf85a2e3d2aa584dafd10b5a1f42764e673e7
Author: Alexey Dobriyan <adobriyan@gmail.com>
Date:   Tue Nov 4 14:28:04 2008 +0100

    netfilter: netns ebtables: more cleanup during ebt_unregister_table()
    
    Now that ebt_unregister_table() can be called during netns stop, and module
    pinning scheme can't prevent netns stop, do table cleanup by hand.
    
    Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 82e1752..fa108c4 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1209,6 +1209,10 @@ void ebt_unregister_table(struct ebt_table *table)
 	mutex_lock(&ebt_mutex);
 	list_del(&table->list);
 	mutex_unlock(&ebt_mutex);
+	EBT_ENTRY_ITERATE(table->private->entries, table->private->entries_size,
+			  ebt_cleanup_entry, NULL);
+	if (table->private->nentries)
+		module_put(table->me);
 	vfree(table->private->entries);
 	if (table->private->chainstack) {
 		for_each_possible_cpu(i)
