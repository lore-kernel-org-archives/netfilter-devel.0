From: Stephane Ouellette <ouellettes@videotron.ca>
Subject: [PATCH] Recent Match - Possible memory leaks + Possible buffer
 overflow with strncpy()
Date: Tue, 29 Oct 2002 13:11:54 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3DBECF6A.3040903@videotron.ca>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_5wr8ZvKWaIgT2F2/P1JJ/g)"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.

--Boundary_(ID_5wr8ZvKWaIgT2F2/P1JJ/g)
Content-type: text/plain; charset=us-ascii; format=flowed
Content-transfer-encoding: 7BIT

Folks,

   the attached patch fixes for the recent match two issues:

1- using strncpy() does not garantee that the destination string will be 
NULL-terminated

2- If a vmalloc() fails, the previously allocated memory blocks are not 
freed.

Enjoy !


--Boundary_(ID_5wr8ZvKWaIgT2F2/P1JJ/g)
Content-type: text/plain; name=recent.patch
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=recent.patch

diff -aruN linux-2.4.20-pre10-ac2/include/linux/netfilter_ipv4/ipt_recent.h linux-2.4.20-pre10-ac2-new/include/linux/netfilter_ipv4/ipt_recent.h
--- linux-2.4.20-pre10-ac2/include/linux/netfilter_ipv4/ipt_recent.h	2002-10-24 12:06:54.000000000 -0400
+++ linux-2.4.20-pre10-ac2-new/include/linux/netfilter_ipv4/ipt_recent.h	2002-10-24 12:28:42.000000000 -0400
@@ -1,6 +1,8 @@
 #ifndef _IPT_RECENT_H
 #define _IPT_RECENT_H
 
+#define NAME_LEN  200
+
 const static int IPT_RECENT_CHECK = 1;
 const static int IPT_RECENT_SET = 2;
 const static int IPT_RECENT_UPDATE = 4;
@@ -15,7 +17,7 @@
 	u_int32_t   hit_count;
 	u_int8_t    check_set;
 	u_int8_t    invert;
-	char        name[200];
+	char        name[NAME_LEN];
 	u_int8_t    side;
 };
 
diff -aruN linux-2.4.20-pre10-ac2/net/ipv4/netfilter/ipt_recent.c linux-2.4.20-pre10-ac2-new/net/ipv4/netfilter/ipt_recent.c
--- linux-2.4.20-pre10-ac2/net/ipv4/netfilter/ipt_recent.c	2002-10-24 12:06:54.000000000 -0400
+++ linux-2.4.20-pre10-ac2-new/net/ipv4/netfilter/ipt_recent.c	2002-10-24 13:11:30.000000000 -0400
@@ -69,7 +69,7 @@
 
 /* Structure of our linked list of tables of recent lists. */
 struct recent_ip_tables {
-	char name[200];
+	char name[NAME_LEN];
 	int count;
 	int side;
 	int time_pos;
@@ -259,7 +259,7 @@
 	info.hit_count = 0;
 	info.check_set = check_set;
 	info.invert = 0;
-	strncpy(info.name,curr_table->name,200);
+	strncpy(info.name,curr_table->name,NAME_LEN);
 
 	skb.nh.iph = kmalloc(sizeof(struct iphdr),GFP_ATOMIC);
 	if(!skb.nh.iph) { return -ENOMEM; }
@@ -322,7 +322,7 @@
 	/* Find the right table */
 	spin_lock_bh(&recent_lock);
 	curr_table = r_tables;
-	while( (last_table = curr_table) && strncmp(info->name,curr_table->name,200) && (curr_table = curr_table->next) );
+	while( (last_table = curr_table) && strncmp(info->name,curr_table->name,NAME_LEN) && (curr_table = curr_table->next) );
 
 	if(debug) printk(KERN_INFO "ipt_recent: match(): table found('%s')\n",info->name);
 
@@ -585,7 +585,7 @@
 	/* Look for an entry with this name already created */
 	/* Finds the end of the list and the entry before the end if current name does not exist */
 	curr_table = r_tables;
-	while( (last_table = curr_table) && strncmp(info->name,curr_table->name,200) && (curr_table = curr_table->next) );
+	while( (last_table = curr_table) && strncmp(info->name,curr_table->name,NAME_LEN) && (curr_table = curr_table->next) );
 
 	/* If a table already exists just increment the count on that table and return */
 	if(curr_table) { 
@@ -598,18 +598,20 @@
 	/* Table with this name not found */
 	/* Allocate memory for new linked list item */
 
-	if(debug) printk(KERN_INFO "ipt_recent: checkentry: no table found (%s)\n",info->name);
-
-	if(debug) printk(KERN_INFO "ipt_recent: checkentry: Allocationg %d for link-list entry.\n",sizeof(struct recent_ip_tables));
+	if(debug) {
+		printk(KERN_INFO "ipt_recent: checkentry: no table found (%s)\n",info->name);
+		printk(KERN_INFO "ipt_recent: checkentry: Allocationg %d for link-list entry.\n",sizeof(struct recent_ip_tables));
+	}
 
 	curr_table = vmalloc(sizeof(struct recent_ip_tables));
-	if(curr_table == NULL) { spin_unlock_bh(&recent_lock); return -ENOMEM; }
+	if(curr_table == NULL) goto out1;
 
 	curr_table->list_lock = SPIN_LOCK_UNLOCKED;
 	curr_table->next = NULL;
 	curr_table->count = 1;
 	curr_table->time_pos = 0;
-	strncpy(curr_table->name,info->name,200);
+	strncpy(curr_table->name,info->name,NAME_LEN-1);
+	curr_table->name[NAME_LEN-1] = 0;  // Garantee a NULL-terminated string
 
 	if(info->side != IPT_RECENT_SOURCE && info->side != IPT_RECENT_DEST) 
 		curr_table->side = IPT_RECENT_SOURCE;
@@ -622,7 +624,8 @@
 			info->name);
 
 	curr_table->table = vmalloc(sizeof(struct recent_ip_list)*ip_list_tot);
-	if(curr_table->table == NULL) { spin_unlock_bh(&recent_lock); return -ENOMEM; }
+	if(curr_table->table == NULL) goto out2;
+
 	memset(curr_table->table,0,sizeof(struct recent_ip_list)*ip_list_tot);
 	if(debug) printk(KERN_INFO "ipt_recent: checkentry: Allocating %d for pkt_list.\n",
 			sizeof(u_int32_t)*ip_pkt_list_tot*ip_list_tot);
@@ -631,8 +634,7 @@
 	if(debug) printk(KERN_INFO "ipt_recent: checkentry: After pkt_list allocation.\n");
 	if(hold == NULL) { 
 		printk(KERN_INFO "ipt_recent: checkentry: unable to allocate for pkt_list.\n");
-		vfree(curr_table->table); spin_unlock_bh(&recent_lock);
-		return -ENOMEM;
+		goto out3;
 	}
 	for(c = 0; c < ip_list_tot; c++) {
 		curr_table->table[c].last_pkts = hold + c*ip_pkt_list_tot;
@@ -643,6 +645,8 @@
 			sizeof(int)*ip_list_hash_size);
 
 	curr_table->hash_table = vmalloc(sizeof(int)*ip_list_hash_size);
+	if(curr_table->hash_table == NULL) goto out4;
+
 	for(c = 0; c < ip_list_hash_size; c++) {
 		curr_table->hash_table[c] = -1;
 	}
@@ -652,6 +656,8 @@
 			sizeof(struct time_info_list)*ip_list_tot);
 
 	curr_table->time_info = vmalloc(sizeof(struct time_info_list)*ip_list_tot);
+	if(curr_table->time_info == NULL) goto out5;
+
 	for(c = 0; c < ip_list_tot; c++) {
 		curr_table->time_info[c].position = c;
 		curr_table->time_info[c].time = 0;
@@ -659,13 +665,9 @@
 
 	/* Create our proc 'status' entry. */
 	curr_table->status_proc = create_proc_entry(curr_table->name, 0644, proc_net_ipt_recent);
-	if (curr_table->status_proc) curr_table->status_proc->owner = THIS_MODULE;
-	else {
-		vfree(curr_table->table);
-		vfree(curr_table);
-		vfree(hold);
-		return -ENOMEM;
-	}
+	if (curr_table->status_proc == NULL) goto out6;
+
+	curr_table->status_proc->owner = THIS_MODULE;
 	curr_table->status_proc->read_proc = ip_recent_get_info;
 	curr_table->status_proc->write_proc = ip_recent_ctrl;
 	curr_table->status_proc->data = curr_table;
@@ -678,6 +680,20 @@
 	if(debug) printk(KERN_INFO "ipt_recent: checkentry() left.\n");
 
 	return 1;
+
+out6:
+	vfree(curr_table->time_info);
+out5:
+	vfree(curr_table->hash_table);
+out4:
+	vfree(hold);
+out3:
+	vfree(curr_table->table);	
+out2:
+	vfree(curr_table);	
+out1:
+	spin_unlock_bh(&recent_lock);
+	return -ENOMEM;
 }
 
 /* This function is called in the event that a rule matching this module is
@@ -708,7 +724,7 @@
 		spin_unlock_bh(&recent_lock);
 		return;
 	}
-	while( strncmp(info->name,curr_table->name,200) && (last_table = curr_table) && (curr_table = curr_table->next) );
+	while( strncmp(info->name,curr_table->name,NAME_LEN) && (last_table = curr_table) && (curr_table = curr_table->next) );
 
 	/* If a table does not exist then do nothing and return */
 	if(!curr_table) { 

--Boundary_(ID_5wr8ZvKWaIgT2F2/P1JJ/g)--
