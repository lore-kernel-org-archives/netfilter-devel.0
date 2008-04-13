From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 2.6.25 1/1]: ipt_CLUSTERIP: fix race between clusterip_config_find_get
 and _entry_put
Date: Sun, 13 Apr 2008 22:21:59 +0200
Message-ID: <48026B67.1040706@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080909030700070602020707"
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51915 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbYDMUZ1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 13 Apr 2008 16:25:27 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080909030700070602020707
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit



--------------080909030700070602020707
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

commit 441771f9b568a1d8dafcd556aca21b1386e2858c
Author: Pavel Emelyanov <xemul@openvz.org>
Date:   Sun Apr 13 06:54:33 2008 +0200

    [NETFILTER]: ipt_CLUSTERIP: fix race between clusterip_config_find_get and _entry_put
    
    Consider we are putting a clusterip_config entry with the "entries"
    count == 1, and on the other CPU there's a clusterip_config_find_get
    in progress:
    
    CPU1:							CPU2:
    clusterip_config_entry_put:				clusterip_config_find_get:
    if (atomic_dec_and_test(&c->entries)) {
    	/* true */
    							read_lock_bh(&clusterip_lock);
    							c = __clusterip_config_find(clusterip);
    							/* found - it's still in list */
    							...
    							atomic_inc(&c->entries);
    							read_unlock_bh(&clusterip_lock);
    
    	write_lock_bh(&clusterip_lock);
    	list_del(&c->list);
    	write_unlock_bh(&clusterip_lock);
    	...
    	dev_put(c->dev);
    
    Oops! We have an entry returned by the clusterip_config_find_get,
    which is a) not in list b) has a stale dev pointer.
    
    The problems will happen when the CPU2 will release the entry - it
    will remove it from the list for the 2nd time, thus spoiling it, and
    will put a stale dev pointer.
    
    The fix is to make atomic_dec_and_test under the clusterip_lock.
    
    Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 52926c8..a12dd32 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -82,8 +82,8 @@ clusterip_config_put(struct clusterip_config *c)
 static inline void
 clusterip_config_entry_put(struct clusterip_config *c)
 {
+	write_lock_bh(&clusterip_lock);
 	if (atomic_dec_and_test(&c->entries)) {
-		write_lock_bh(&clusterip_lock);
 		list_del(&c->list);
 		write_unlock_bh(&clusterip_lock);
 
@@ -96,7 +96,9 @@ clusterip_config_entry_put(struct clusterip_config *c)
 #ifdef CONFIG_PROC_FS
 		remove_proc_entry(c->pde->name, c->pde->parent);
 #endif
+		return;
 	}
+	write_unlock_bh(&clusterip_lock);
 }
 
 static struct clusterip_config *

--------------080909030700070602020707--
