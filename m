From: Amin Azez <azez@ufomechanic.net>
Subject: ipt_recent fix
Date: Fri, 17 Feb 2006 17:37:53 +0000
Message-ID: <dt51lh$b63$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040003050006030608070305"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

This is a multi-part message in MIME format.
--------------040003050006030608070305
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Here is a fix for ipt_recent.

The problem is that curr_table[x].hash_entry=0 (for all x)

So all pristine (never used) curr_table entries claim to have hash pos 0.

So when we add new items to the hash and do:
  hash_table[r_list[location].hash_entry] = -1;
to use the oldest (used or unused) location - if it is unused we trash 
anything that really has hash pos 0 already allocated.

This can be reproduced with this:

# iptables -A FORWARD -d 1.1.1.1 -m recent --name TEST1 --set
# G=1 ; while test $G -lt 17 ; do echo $G ; echo 1.1.1.$G> \
  /proc/net/ipt_recent/TEST1 ; G=$(($G+1)) ; dmesg -c ; cat \
  /proc/net/ipt_recent/TEST1  | head ; done > x

the 13th item has hash of 0 and gets trashed when the 14th item is added 
without this patch.

We should only trash it then if we _know_ it has been used before and 
therefore is REALLY at the position it claims...

This patch makes sure that items claiming to have a hash entry really do 
have that hash entry before destroying that hash entry.

This patch also adds counting of the number of hash entries in 
preparation for conditions based on the number of entries in the recent 
table rule; patch for that to follow next week.

Any comments on this?

Sam

--------------040003050006030608070305
Content-Type: text/x-patch;
 name="ipt_recent.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipt_recent.patch"

--- ./net/ipv4/netfilter/ipt_recent.c.nolimit	2006-02-15 16:34:20.000000000 +0000
+++ ./net/ipv4/netfilter/ipt_recent.c	2006-02-17 17:23:00.000000000 +0000
@@ -70,7 +70,11 @@
 /* Structure of our linked list of tables of recent lists. */
 struct recent_ip_tables {
 	char name[IPT_RECENT_NAME_LEN];
+	/* number of entries in list *table */
+	int entry_count;
+	/* number of reference to this structure from iptables rules */
 	int count;
+	/* an index increased with each operation which maps time_info[x].position to a position in table */
 	int time_pos;
 	struct recent_ip_list *table;
 	struct recent_ip_tables *next;
@@ -139,6 +143,7 @@
 	curr_table = (struct recent_ip_tables*) data;
 
 	spin_lock_bh(&curr_table->list_lock);
+	len += sprintf(buffer+len,"count=%d\n",curr_table->entry_count);
 	for(count = 0; count < ip_list_tot; count++) {
 		if(!curr_table->table[count].addr) continue;
 		last_len = len;
@@ -216,6 +221,7 @@
 		used += 5;
 		spin_lock_bh(&curr_table->list_lock);
 		curr_table->time_pos = 0;
+		curr_table->entry_count = 0;
 		for(count = 0; count < ip_list_hash_size; count++) {
 			curr_table->hash_table[count] = -1;
 		}
@@ -500,7 +506,27 @@
 
 		/* New item found and IPT_RECENT_SET, so we need to add it */
 		location = time_info[curr_table->time_pos].position;
-		hash_table[r_list[location].hash_entry] = -1;
+		/* 
+		   location is the next slot in r_list that we will use. 
+		   Maybe it is already used and we need to remove it fromthe hash.
+		   If it is used then: 
+		   1) hash_table[r_list[location].hash_entry]=location
+		   Which is to say that anything claiming to have a hash entry
+		   should also be pointed to BY that hash entry.
+		     This only comes up becase by default r_list[x].hash_entry=0
+		   i.e. all items claim to have hash entry 0, so if a real
+		   item has hash slot 0 it gets trashed because of lies.
+		   SO: If r_list[location].hash_entry]==0 we are in warning condition
+		   and need to double check that hash_table reciprocates before we
+		   set the hash_table entry to -1 (it may not really belong)
+		   This would work; 
+		     if (r_list[location].hash_entry!=0 || hash_table[0]==location) hash_table[r_list[location].hash_entry] = -1; 
+		   but we want to combine with a counter for new entries
+		*/
+		/* increase counter if this is a new item */
+		if (hash_table[r_list[location].hash_entry]!=location) curr_table->entry_count++;
+		else hash_table[r_list[location].hash_entry] = -1;
+
 		hash_table[hash_result] = location;
 		memset(r_list[location].last_pkts,0,ip_pkt_list_tot*sizeof(u_int32_t));
 		r_list[location].time_pos = curr_table->time_pos;
@@ -633,6 +659,7 @@
 			r_list[location].ttl = 0;
 			memset(r_list[location].last_pkts,0,ip_pkt_list_tot*sizeof(u_int32_t));
 			r_list[location].oldest_pkt = 0;
+			curr_table->entry_count--;
 			ans = !info->invert;
 		}
 		spin_unlock_bh(&curr_table->list_lock);
@@ -719,6 +746,7 @@
 	curr_table->next = NULL;
 	curr_table->count = 1;
 	curr_table->time_pos = 0;
+	curr_table->entry_count = 0;
 	strncpy(curr_table->name,info->name,IPT_RECENT_NAME_LEN);
 	curr_table->name[IPT_RECENT_NAME_LEN-1] = '\0';
 

--------------040003050006030608070305--
