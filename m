From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 1/8] netfilter: fix return values of ipt_recent checkentry
Date: Fri, 31 Dec 2004 22:35:57 +1100
Message-ID: <1104492958.2791.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Andrew Morton <akpm@osdl.org>
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

[ With DaveM away for a week and Linus ignoring patches, I though I'd
send these eight minor bugfixes through you for inclusions asap.
Thanks. ]

Name: Fix return values of ipt_recent checkentry
Status: Tested under nfsim
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Peejix's nfsim test for ipt_recent, written two days ago, revealed
this bugs with ipt_recent: checkentry() returns true or false, not an
error.  (Maybe it should, but that's a much larger change).  Also,
make hash_func() static.

Index: linux-2.6.10-bk1-Netfilter/net/ipv4/netfilter/ipt_recent.c
===================================================================
--- linux-2.6.10-bk1-Netfilter.orig/net/ipv4/netfilter/ipt_recent.c	2004-12-31 20:23:35.042329016 +1100
+++ linux-2.6.10-bk1-Netfilter/net/ipv4/netfilter/ipt_recent.c	2004-12-31 20:24:20.218461200 +1100
@@ -107,7 +107,7 @@
       int *hotdrop);
 
 /* Function to hash a given address into the hash table of table_size size */
-int hash_func(unsigned int addr, int table_size)
+static int hash_func(unsigned int addr, int table_size)
 {
 	int result = 0;
 	unsigned int value = addr;
@@ -713,7 +713,7 @@
 #endif
 
 	curr_table = vmalloc(sizeof(struct recent_ip_tables));
-	if(curr_table == NULL) return -ENOMEM;
+	if(curr_table == NULL) return 0;
 
 	spin_lock_init(&curr_table->list_lock);
 	curr_table->next = NULL;
@@ -730,7 +730,7 @@
 #endif
 
 	curr_table->table = vmalloc(sizeof(struct recent_ip_list)*ip_list_tot);
-	if(curr_table->table == NULL) { vfree(curr_table); return -ENOMEM; }
+	if(curr_table->table == NULL) { vfree(curr_table); return 0; }
 	memset(curr_table->table,0,sizeof(struct recent_ip_list)*ip_list_tot);
 #ifdef DEBUG
 	if(debug) printk(KERN_INFO RECENT_NAME ": checkentry: Allocating %d for pkt_list.\n",
@@ -745,7 +745,7 @@
 		printk(KERN_INFO RECENT_NAME ": checkentry: unable to allocate for pkt_list.\n");
 		vfree(curr_table->table); 
 		vfree(curr_table);
-		return -ENOMEM;
+		return 0;
 	}
 	for(c = 0; c < ip_list_tot; c++) {
 		curr_table->table[c].last_pkts = hold + c*ip_pkt_list_tot;
@@ -763,7 +763,7 @@
 		vfree(hold);
 		vfree(curr_table->table); 
 		vfree(curr_table);
-		return -ENOMEM;
+		return 0;
 	}
 
 	for(c = 0; c < ip_list_hash_size; c++) {
@@ -783,7 +783,7 @@
 		vfree(hold);
 		vfree(curr_table->table); 
 		vfree(curr_table);
-		return -ENOMEM;
+		return 0;
 	}
 	for(c = 0; c < ip_list_tot; c++) {
 		curr_table->time_info[c].position = c;
@@ -827,7 +827,7 @@
 			if(debug) printk(KERN_INFO RECENT_NAME ": checkentry() create_proc failed, no tables.\n");
 #endif
 			spin_unlock_bh(&recent_lock);
-			return -ENOMEM;
+			return 0;
 		}
 		while( strncmp(info->name,curr_table->name,IPT_RECENT_NAME_LEN) && (last_table = curr_table) && (curr_table = curr_table->next) );
 		if(!curr_table) {
@@ -835,7 +835,7 @@
 			if(debug) printk(KERN_INFO RECENT_NAME ": checkentry() create_proc failed, table already destroyed.\n");
 #endif
 			spin_unlock_bh(&recent_lock);
-			return -ENOMEM;
+			return 0;
 		}
 		if(last_table) last_table->next = curr_table->next; else r_tables = curr_table->next;
 		spin_unlock_bh(&recent_lock);
@@ -844,7 +844,7 @@
 		vfree(hold);
 		vfree(curr_table->table);
 		vfree(curr_table);
-		return -ENOMEM;
+		return 0;
 	}
 	
 	curr_table->status_proc->owner = THIS_MODULE;

-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
