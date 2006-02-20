From: Amin Azez <azez@ufomechanic.net>
Subject: [patch] ipt_recent
Date: Mon, 20 Feb 2006 16:12:39 +0000
Message-ID: <43F9EA77.4060208@ufomechanic.net>
References: <dt51lh$b63$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070908040600060603060106"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <dt51lh$b63$1@sea.gmane.org>
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
--------------070908040600060603060106
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This patch fixes the previously mentioned bug in ipt_recent and adds:

--lt n  # check less than n items in list
--gt n  # checks more than n items in list
--eq n  # check exactly n items in list

Which can be prefixed with ! to invert.

These preconditions are checked before any other conditions in 
ipt_recent, and their failure will prevent any other actions or checks 
from being considered.

Thus it is possible to make decisions based on the size of the 
ipt_recent list (number of IP addresses in it).

iptables.recent.patch is the userland patch
ipt_recent.patch is a patch on kernel 2.6.11.7

Sam


--------------070908040600060603060106
Content-Type: text/x-patch;
 name="iptables.recent.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="iptables.recent.patch"

--- extensions/libipt_recent.man.nolimit	2006-02-20 13:55:58.000000000 +0000
+++ extensions/libipt_recent.man	2006-02-20 14:10:25.000000000 +0000
@@ -9,6 +9,21 @@
 Specify the list to use for the commands. If no name is given then 'DEFAULT'
 will be used.
 .TP
+[\fB!\fR] \fB--eq \ficount\fR
+Requires as a precondition that the number of IP entries in the list
+is equal to (or not !) count. No other options are considered if
+this is not true.
+.TP
+[\fB!\fR] \fB--lt \ficount\fR
+Requires as a precondition that the number of IP entries in the list
+is less than count (or not !). No other options are considered if
+this is not true.
+.TP
+[\fB!\fR] \fB--gt \ficount\fR
+Requires as a precondition that the number of IP entries in the list
+is greater than count (or not !). No other options are considered if
+this is not true.
+.TP
 [\fB!\fR] \fB--set\fR
 This will add the source address of the packet to the list. If the
 source address is already in the list, this will update the existing
--- extensions/libipt_recent.c.orig	2006-02-20 15:42:26.000000000 +0000
+++ extensions/libipt_recent.c	2006-02-20 15:45:23.000000000 +0000
@@ -33,6 +33,9 @@
 	{ .name = "name",     .has_arg = 1, .flag = 0, .val = 208 },
 	{ .name = "rsource",  .has_arg = 0, .flag = 0, .val = 209 },
 	{ .name = "rdest",    .has_arg = 0, .flag = 0, .val = 210 },
+	{ .name = "eq",       .has_arg = 1, .flag = 0, .val = 211 },
+	{ .name = "lt",       .has_arg = 1, .flag = 0, .val = 212 },
+	{ .name = "gt",       .has_arg = 1, .flag = 0, .val = 213 },
 	{ .name = 0,          .has_arg = 0, .flag = 0, .val = 0   }
 };
 
@@ -42,6 +45,11 @@
 {
 	printf(
 "recent v%s options:\n"
+"    PRECONDITIONS               Only one precondition may be set.\n"
+"[!] --eq n                      Only match if the precondition is true that there are n items in the table\n"
+"[!] --lt n                      Only match if the precondition is true that there are less than n items in the table\n"
+"[!] --gt n                      Only match if the precondition is true that there are more than n items in the table\n"
+"                                The precondtion may be followed by:\n"
 "[!] --set                       Add source address to list, always matches.\n"
 "[!] --rcheck                    Match if source address in list.\n"
 "[!] --update                    Match if source address in list, also update last-seen time.\n"
@@ -155,6 +163,30 @@
 			info->side = IPT_RECENT_DEST;
 			break;
 
+		case 211:
+			if (info->check_count) exit_error(PARAMETER_PROBLEM,
+                                        "recent: only one of `--lt', `--gt' "
+                                        " or `--eq' may be set");
+			info->check_count |= IPT_RECENT_EQ | (invert?IPT_RECENT_INVERT:0);
+			info->entry_count=atoi(optarg);
+			break;
+
+		case 212:
+			if (info->check_count) exit_error(PARAMETER_PROBLEM,
+                                        "recent: only one of `--lt', `--gt' "
+                                        " or `--eq' may be set");
+			info->check_count |= IPT_RECENT_LT | (invert?IPT_RECENT_INVERT:0);
+			info->entry_count=atoi(optarg);
+			break;
+
+		case 213:
+			if (info->check_count) exit_error(PARAMETER_PROBLEM,
+                                        "recent: only one of `--lt', `--gt' "
+                                        " or `--eq' may be set");
+			info->check_count |= IPT_RECENT_GT | (invert?IPT_RECENT_INVERT:0);
+			info->entry_count=atoi(optarg);
+			break;
+
 		default:
 			return 0;
 	}
@@ -181,10 +213,18 @@
 {
 	struct ipt_recent_info *info = (struct ipt_recent_info *)match->data;
 
+	printf("recent: ");
+
+	/* handle the precondition first */
+	if (info->check_count) {
+	  if ((info->check_count & IPT_RECENT_EQ)==IPT_RECENT_EQ) printf("%s %d ",(info->check_count & IPT_RECENT_INVERT)?"!=":"==",info->entry_count);
+	  else if (info->check_count & IPT_RECENT_LT) printf("%s %d ",(info->check_count & IPT_RECENT_INVERT)?">=":"<",info->entry_count);
+	  else if (info->check_count & IPT_RECENT_GT) printf("%s %d ",(info->check_count & IPT_RECENT_INVERT)?"<=":">",info->entry_count);
+        }
+
 	if (info->invert)
 		fputc('!', stdout);
 
-	printf("recent: ");
 	if(info->check_set & IPT_RECENT_SET) printf("SET ");
 	if(info->check_set & IPT_RECENT_CHECK) printf("CHECK ");
 	if(info->check_set & IPT_RECENT_UPDATE) printf("UPDATE ");
@@ -203,6 +243,12 @@
 {
 	struct ipt_recent_info *info = (struct ipt_recent_info *)match->data;
 
+	/* handle the precondition first */
+	if (info->check_count) {
+	  if (info->check_count & IPT_RECENT_INVERT) printf("! ");
+	  if ((info->check_count & IPT_RECENT_EQ)==IPT_RECENT_EQ) printf("--eq %d ",info->entry_count);
+	  else if (info->check_count & IPT_RECENT_LT) printf("--lt %d ",info->entry_count);
+	}
 	if (info->invert)
 		printf("! ");
 

--------------070908040600060603060106
Content-Type: text/x-patch;
 name="ipt_recent.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipt_recent.patch"

--- ./net/ipv4/netfilter/ipt_recent.c.nolimit	2006-02-15 16:34:20.000000000 +0000
+++ ./net/ipv4/netfilter/ipt_recent.c	2006-02-20 16:06:17.000000000 +0000
@@ -5,7 +5,6 @@
 /* This software is distributed under the terms of the GPL, Version 2 */
 /* This copyright does not cover user programs that use kernel services
  * by normal system calls. */
-
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/proc_fs.h>
@@ -70,7 +69,11 @@
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
@@ -139,6 +142,7 @@
 	curr_table = (struct recent_ip_tables*) data;
 
 	spin_lock_bh(&curr_table->list_lock);
+	len += sprintf(buffer+len,"count=%d\n",curr_table->entry_count);
 	for(count = 0; count < ip_list_tot; count++) {
 		if(!curr_table->table[count].addr) continue;
 		last_len = len;
@@ -216,6 +220,7 @@
 		used += 5;
 		spin_lock_bh(&curr_table->list_lock);
 		curr_table->time_pos = 0;
+		curr_table->entry_count = 0;
 		for(count = 0; count < ip_list_hash_size; count++) {
 			curr_table->hash_table[count] = -1;
 		}
@@ -297,6 +302,8 @@
 	info->seconds = 0;
 	info->hit_count = 0;
 	info->check_set = check_set;
+	info->entry_count = 0;
+	info->check_count = 0;
 	info->invert = 0;
 	info->side = IPT_RECENT_SOURCE;
 	strncpy(info->name,curr_table->name,IPT_RECENT_NAME_LEN);
@@ -350,6 +357,10 @@
  * --hitcount -- Option to --rcheck/--update, only match if seen hitcount times
  *   -- matchinfo->hit_count
  * --seconds and --hitcount can be combined
+ * --lt -- Option to see if there are less-than so-many entries in the table altogether
+ * --gt -- Option to see if there are greater-than so-many entries in the table altogether
+ * --eq -- Option to see if there are exactly so-many entries in the table altogether
+ * --lt and --gt and --eq and be combined with --seconds but NOT --hitcount. 
  */
 static int
 match(const struct sk_buff *skb,
@@ -400,6 +411,18 @@
 	/* Table with this name not found, match impossible */
 	if(!curr_table) { return ans; }
 
+	/* If table content count doesn't match, then further checks are unneccessary */
+	if(info->check_count) {
+	  int uninvert=(0==(info->check_count & IPT_RECENT_INVERT));
+	  if((info->check_count & IPT_RECENT_EQ) == IPT_RECENT_EQ) {
+	    if(uninvert ^ (curr_table->entry_count==info->entry_count)) return 0;
+	  } else if (info->check_count & IPT_RECENT_LT) { 
+	    if(uninvert ^ (curr_table->entry_count<info->entry_count)) return 0;
+	  } else if (info->check_count & IPT_RECENT_GT) { 
+	    if(uninvert ^ (curr_table->entry_count>info->entry_count)) return 0;
+	  }; 
+	}
+
 	/* Make sure no one is changing the list while we work with it */
 	spin_lock_bh(&curr_table->list_lock);
 
@@ -500,7 +523,27 @@
 
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
@@ -633,6 +676,7 @@
 			r_list[location].ttl = 0;
 			memset(r_list[location].last_pkts,0,ip_pkt_list_tot*sizeof(u_int32_t));
 			r_list[location].oldest_pkt = 0;
+			curr_table->entry_count--;
 			ans = !info->invert;
 		}
 		spin_unlock_bh(&curr_table->list_lock);
@@ -719,6 +763,7 @@
 	curr_table->next = NULL;
 	curr_table->count = 1;
 	curr_table->time_pos = 0;
+	curr_table->entry_count = 0;
 	strncpy(curr_table->name,info->name,IPT_RECENT_NAME_LEN);
 	curr_table->name[IPT_RECENT_NAME_LEN-1] = '\0';
 
--- include/linux/netfilter_ipv4/ipt_recent.h.nolimit	2006-02-20 10:12:06.000000000 +0000
+++ include/linux/netfilter_ipv4/ipt_recent.h	2006-02-20 11:30:58.000000000 +0000
@@ -10,6 +10,11 @@
 #define IPT_RECENT_REMOVE 8
 #define IPT_RECENT_TTL   16
 
+#define IPT_RECENT_INVERT 1
+#define IPT_RECENT_LT	  2
+#define IPT_RECENT_GT	  4
+#define IPT_RECENT_EQ	  (IPT_RECENT_LT | IPT_RECENT_GT)
+
 #define IPT_RECENT_SOURCE 0
 #define IPT_RECENT_DEST   1
 
@@ -20,6 +25,8 @@
 	u_int32_t   hit_count;
 	u_int8_t    check_set;
 	u_int8_t    invert;
+	u_int8_t    check_count;
+	u_int32_t   entry_count;
 	char        name[IPT_RECENT_NAME_LEN];
 	u_int8_t    side;
 };

--------------070908040600060603060106--
