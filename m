From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.4 3/8]: fix return values of ipt_recent checkentry
Date: Fri, 04 Mar 2005 13:18:45 +0100
Message-ID: <42285225.4030608@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
 name="03.diff"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline;
 filename="03.diff"
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

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2005/03/04 00:27:31+01:00 kaber@coreworks.de 
#   [NETFILTER]: fix return values of ipt_recent checkentry
#   
#   Backport from 2.6, original patch from Rusty:
#   
#   Peejix's nfsim test for ipt_recent, written two days ago, revealed this bugs
#   with ipt_recent: checkentry() returns true or false, not an error.  (Maybe it
#   should, but that's a much larger change).  Also, make hash_func() static.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ipt_recent.c
#   2005/03/04 00:27:29+01:00 kaber@coreworks.de +9 -9
#   [NETFILTER]: fix return values of ipt_recent checkentry
#   
#   Backport from 2.6, original patch from Rusty:
#   
#   Peejix's nfsim test for ipt_recent, written two days ago, revealed this bugs
#   with ipt_recent: checkentry() returns true or false, not an error.  (Maybe it
#   should, but that's a much larger change).  Also, make hash_func() static.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv4/netfilter/ipt_recent.c b/net/ipv4/netfilter/ipt_recent.c
--- a/net/ipv4/netfilter/ipt_recent.c	2005-03-04 01:52:03 +01:00
+++ b/net/ipv4/netfilter/ipt_recent.c	2005-03-04 01:52:03 +01:00
@@ -108,7 +108,7 @@
       int *hotdrop);
 
 /* Function to hash a given address into the hash table of table_size size */
-int hash_func(unsigned int addr, int table_size)
+static int hash_func(unsigned int addr, int table_size)
 {
 	int result = 0;
 	unsigned int value = addr;
@@ -716,7 +716,7 @@
 #endif
 
 	curr_table = vmalloc(sizeof(struct recent_ip_tables));
-	if(curr_table == NULL) return -ENOMEM;
+	if(curr_table == NULL) return 0;
 
 	curr_table->list_lock = SPIN_LOCK_UNLOCKED;
 	curr_table->next = NULL;
@@ -733,7 +733,7 @@
 #endif
 
 	curr_table->table = vmalloc(sizeof(struct recent_ip_list)*ip_list_tot);
-	if(curr_table->table == NULL) { vfree(curr_table); return -ENOMEM; }
+	if(curr_table->table == NULL) { vfree(curr_table); return 0; }
 	memset(curr_table->table,0,sizeof(struct recent_ip_list)*ip_list_tot);
 #ifdef DEBUG
 	if(debug) printk(KERN_INFO RECENT_NAME ": checkentry: Allocating %d for pkt_list.\n",
@@ -748,7 +748,7 @@
 		printk(KERN_INFO RECENT_NAME ": checkentry: unable to allocate for pkt_list.\n");
 		vfree(curr_table->table); 
 		vfree(curr_table);
-		return -ENOMEM;
+		return 0;
 	}
 	for(c = 0; c < ip_list_tot; c++) {
 		curr_table->table[c].last_pkts = hold + c*ip_pkt_list_tot;
@@ -766,7 +766,7 @@
 		vfree(hold);
 		vfree(curr_table->table); 
 		vfree(curr_table);
-		return -ENOMEM;
+		return 0;
 	}
 
 	for(c = 0; c < ip_list_hash_size; c++) {
@@ -786,7 +786,7 @@
 		vfree(hold);
 		vfree(curr_table->table); 
 		vfree(curr_table);
-		return -ENOMEM;
+		return 0;
 	}
 	for(c = 0; c < ip_list_tot; c++) {
 		curr_table->time_info[c].position = c;
@@ -830,7 +830,7 @@
 			if(debug) printk(KERN_INFO RECENT_NAME ": checkentry() create_proc failed, no tables.\n");
 #endif
 			spin_unlock_bh(&recent_lock);
-			return -ENOMEM;
+			return 0;
 		}
 		while( strncmp(info->name,curr_table->name,IPT_RECENT_NAME_LEN) && (last_table = curr_table) && (curr_table = curr_table->next) );
 		if(!curr_table) {
@@ -838,7 +838,7 @@
 			if(debug) printk(KERN_INFO RECENT_NAME ": checkentry() create_proc failed, table already destroyed.\n");
 #endif
 			spin_unlock_bh(&recent_lock);
-			return -ENOMEM;
+			return 0;
 		}
 		if(last_table) last_table->next = curr_table->next; else r_tables = curr_table->next;
 		spin_unlock_bh(&recent_lock);
@@ -847,7 +847,7 @@
 		vfree(hold);
 		vfree(curr_table->table);
 		vfree(curr_table);
-		return -ENOMEM;
+		return 0;
 	}
 	
 	curr_table->status_proc->owner = THIS_MODULE;
