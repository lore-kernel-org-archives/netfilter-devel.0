From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] Fix hang on netfilter module unload
Date: Mon, 14 Mar 2005 21:06:41 -0800
Message-ID: <20050315050641.GA334@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="gBBFr7Ir9EOA20Yy"
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

At module unload time, we use ip_conntrack_count to determine how many
conntracks need to be destroyed before we can unload.  get_next_corpse
looks in the hash tables and unconfirmed list for the conntracks until
ip_conntrack_count == 0.  

Unfortunately, conntracks occasionally get pinned by an skb which for
some reason or another won't go away.  So ct_general->use never reduces
to 1 for these conntracks, and they do not appear in either the
hashes or the unconfirmed list.  As such, we loop around forever at
i_see_dead_people trying to kill a conntrack which we will never find.

The below patch attempts to fix this by doing two things:

1) when a conntrack is removed from the hashes in clean_from_lists,
   add it to a new 'cleaned' list, similar to how the unconfirmed list
   works.  This ensures that we never lose sight of a conntrack --
   it moves from unconfirmed->hashed->cleaned in its lifetime.
   get_next_corpse now checks the cleaned list for conntracks also.

2) change get_next_corpse to set the usage count of conntracks to
   1 once they are found.  Otherwise, these pinned conntracks will never
   be able to be removed, since use will be > 1 

Without the below, I can trivially hang a box on module unload by
using NetworkManager on FC3 -- seems to be related to the DHCP process.
With this patch, unload works every time.

This fixes Netfilter bugzilla #91 and Redhat bugzilla #112630.

Phil

Signed-off-by: Phil Oester <kernel@linuxace.com>




--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-unload

diff -ruN linux-orig/net/ipv4/netfilter/ip_conntrack_core.c linux-new/net/ipv4/netfilter/ip_conntrack_core.c
--- linux-orig/net/ipv4/netfilter/ip_conntrack_core.c	2005-03-02 02:37:30.000000000 -0500
+++ linux-new/net/ipv4/netfilter/ip_conntrack_core.c	2005-03-14 20:18:46.289349488 -0500
@@ -74,6 +74,7 @@
 struct ip_conntrack ip_conntrack_untracked;
 unsigned int ip_ct_log_invalid;
 static LIST_HEAD(unconfirmed);
+static LIST_HEAD(cleaned);
 static int ip_conntrack_vmalloc;
 
 DEFINE_PER_CPU(struct ip_conntrack_stat, ip_conntrack_stat);
@@ -216,6 +217,9 @@
 	LIST_DELETE(&ip_conntrack_hash[ho], &ct->tuplehash[IP_CT_DIR_ORIGINAL]);
 	LIST_DELETE(&ip_conntrack_hash[hr], &ct->tuplehash[IP_CT_DIR_REPLY]);
 
+	/* Overload tuple linked list to put us in cleaned list. */
+	list_add(&ct->tuplehash[IP_CT_DIR_ORIGINAL].list, &cleaned);
+
 	/* Destroy all pending expectations */
 	remove_expectations(ct);
 }
@@ -247,11 +251,9 @@
 	 * too. */
 	remove_expectations(ct);
 
-	/* We overload first tuple to link into unconfirmed list. */
-	if (!is_confirmed(ct)) {
-		BUG_ON(list_empty(&ct->tuplehash[IP_CT_DIR_ORIGINAL].list));
-		list_del(&ct->tuplehash[IP_CT_DIR_ORIGINAL].list);
-	}
+	/* We overload first tuple to link into unconfirmed or cleaned list.
+	   Will always be on one or the other at this point */
+	list_del(&ct->tuplehash[IP_CT_DIR_ORIGINAL].list);
 
 	CONNTRACK_STAT_INC(delete);
 	WRITE_UNLOCK(&ip_conntrack_lock);
@@ -1019,8 +1021,11 @@
 	if (!h)
 		h = LIST_FIND_W(&unconfirmed, do_iter,
 				struct ip_conntrack_tuple_hash *, iter, data);
+	if (!h)
+		h = LIST_FIND_W(&cleaned, do_iter,
+				struct ip_conntrack_tuple_hash *, iter, data);
 	if (h)
-		atomic_inc(&tuplehash_to_ctrack(h)->ct_general.use);
+		atomic_set(&tuplehash_to_ctrack(h)->ct_general.use, 1);
 	WRITE_UNLOCK(&ip_conntrack_lock);
 
 	return h;

--gBBFr7Ir9EOA20Yy--
