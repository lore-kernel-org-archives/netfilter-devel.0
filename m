From: Patrick McHardy <kaber@trash.net>
Subject: {PATCH]: fix expectation eviction order
Date: Sun, 28 Sep 2003 23:36:41 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F775469.6070107@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070208040101020907050407"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
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
--------------070208040101020907050407
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi Harald,
this patch fixes the order in which expectations are evicted when a helper
specifies IP_CT_HELPER_F_REUSE_EXPECT. Currently each new expectation
is added at the beginning of the masters sibling list and when max_expected
is reached the first non-established one on the list is reused (which gives
LIFO behaviour).

This patch
- adds new expectation at end of masters sibling list
- uses list_for_each_entry for finding oldest one
- changes nat-core to walk backwards through sibling list when calling 
nat-helpers
  help function so offsets are valid even if a packet is mangled 
multiple times
  (assuming multiple expectations from one packet have increasing offsets).

Tested:
- Expectations are evicted in correct order
- NAT helpers are called in correct order in case of multiple 
expectation from one packet

Attached are patches for 2.4 and 2.6, they are basically the same except 
for the offset.

Best regards,
Patrick

--------------070208040101020907050407
Content-Type: text/plain;
 name="2.4-expect-evict-order.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="2.4-expect-evict-order.diff"

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.1134  -> 1.1135 
#	net/ipv4/netfilter/ip_conntrack_core.c	1.26    -> 1.27   
#	net/ipv4/netfilter/ip_nat_core.c	1.20    -> 1.21   
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 03/09/28	kaber@trash.net	1.1135
# [NETFILTER]: Fix expectation eviction order
# --------------------------------------------
#
diff -Nru a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
--- a/net/ipv4/netfilter/ip_conntrack_core.c	Sun Sep 28 20:01:46 2003
+++ b/net/ipv4/netfilter/ip_conntrack_core.c	Sun Sep 28 20:01:46 2003
@@ -972,7 +972,6 @@
 		}
 	} else if (related_to->helper->max_expected && 
 		   related_to->expecting >= related_to->helper->max_expected) {
-		struct list_head *cur_item;
 		/* old == NULL */
 		if (!(related_to->helper->flags & 
 		      IP_CT_HELPER_F_REUSE_EXPECT)) {
@@ -997,21 +996,14 @@
 		       NIPQUAD(related_to->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip));
  
 		/* choose the the oldest expectation to evict */
-		list_for_each(cur_item, &related_to->sibling_list) { 
-			struct ip_conntrack_expect *cur;
-
-			cur = list_entry(cur_item, 
-					 struct ip_conntrack_expect,
-					 expected_list);
-			if (cur->sibling == NULL) {
-				old = cur;
+		list_for_each_entry(old, &related_to->sibling_list, 
+		                                      expected_list)
+			if (old->sibling == NULL)
 				break;
-			}
-		}
 
-		/* (!old) cannot happen, since related_to->expecting is the
-		 * number of unconfirmed expects */
-		IP_NF_ASSERT(old);
+		/* We cannot fail since related_to->expecting is the number
+		 * of unconfirmed expectations */
+		IP_NF_ASSERT(old && old->sibling == NULL);
 
 		/* newnat14 does not reuse the real allocated memory
 		 * structures but rather unexpects the old and
@@ -1043,7 +1035,7 @@
 	atomic_set(&new->use, 1);
 	
 	/* add to expected list for this connection */	
-	list_add(&new->expected_list, &related_to->sibling_list);
+	list_add_tail(&new->expected_list, &related_to->sibling_list);
 	/* add to global list of expectations */
 	list_prepend(&ip_conntrack_expect_list, &new->list);
 	/* add and start timer if required */
diff -Nru a/net/ipv4/netfilter/ip_nat_core.c b/net/ipv4/netfilter/ip_nat_core.c
--- a/net/ipv4/netfilter/ip_nat_core.c	Sun Sep 28 20:01:46 2003
+++ b/net/ipv4/netfilter/ip_nat_core.c	Sun Sep 28 20:01:46 2003
@@ -810,7 +810,7 @@
 
 		/* Have to grab read lock before sibling_list traversal */
 		READ_LOCK(&ip_conntrack_lock);
-		list_for_each(cur_item, &ct->sibling_list) { 
+		list_for_each_prev(cur_item, &ct->sibling_list) { 
 			exp = list_entry(cur_item, struct ip_conntrack_expect, 
 					 expected_list);
 					 

--------------070208040101020907050407
Content-Type: text/plain;
 name="2.6-expect-evict-order.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="2.6-expect-evict-order.diff"

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.1354  -> 1.1355 
#	net/ipv4/netfilter/ip_conntrack_core.c	1.37    -> 1.38   
#	net/ipv4/netfilter/ip_nat_core.c	1.32    -> 1.33   
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 03/09/28	kaber@trash.net	1.1355
# [NETFILTER]: Fix expectation eviction order
# --------------------------------------------
#
diff -Nru a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
--- a/net/ipv4/netfilter/ip_conntrack_core.c	Sun Sep 28 20:17:48 2003
+++ b/net/ipv4/netfilter/ip_conntrack_core.c	Sun Sep 28 20:17:48 2003
@@ -950,7 +950,6 @@
 		}
 	} else if (related_to->helper->max_expected && 
 		   related_to->expecting >= related_to->helper->max_expected) {
-		struct list_head *cur_item;
 		/* old == NULL */
 		if (!(related_to->helper->flags & 
 		      IP_CT_HELPER_F_REUSE_EXPECT)) {
@@ -975,21 +974,14 @@
 		       NIPQUAD(related_to->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip));
  
 		/* choose the the oldest expectation to evict */
-		list_for_each(cur_item, &related_to->sibling_list) { 
-			struct ip_conntrack_expect *cur;
-
-			cur = list_entry(cur_item, 
-					 struct ip_conntrack_expect,
-					 expected_list);
-			if (cur->sibling == NULL) {
-				old = cur;
+		list_for_each_entry(old, &related_to->sibling_list, 
+		                                      expected_list)
+			if (old->sibling == NULL)
 				break;
-			}
-		}
 
-		/* (!old) cannot happen, since related_to->expecting is the
-		 * number of unconfirmed expects */
-		IP_NF_ASSERT(old);
+		/* We cannot fail since related_to->expecting is the number
+		 * of unconfirmed expectations */
+		IP_NF_ASSERT(old && old->sibling == NULL);
 
 		/* newnat14 does not reuse the real allocated memory
 		 * structures but rather unexpects the old and
@@ -1021,7 +1013,7 @@
 	atomic_set(&new->use, 1);
 	
 	/* add to expected list for this connection */	
-	list_add(&new->expected_list, &related_to->sibling_list);
+	list_add_tail(&new->expected_list, &related_to->sibling_list);
 	/* add to global list of expectations */
 	list_prepend(&ip_conntrack_expect_list, &new->list);
 	/* add and start timer if required */
diff -Nru a/net/ipv4/netfilter/ip_nat_core.c b/net/ipv4/netfilter/ip_nat_core.c
--- a/net/ipv4/netfilter/ip_nat_core.c	Sun Sep 28 20:17:48 2003
+++ b/net/ipv4/netfilter/ip_nat_core.c	Sun Sep 28 20:17:48 2003
@@ -804,7 +804,7 @@
 
 		/* Have to grab read lock before sibling_list traversal */
 		READ_LOCK(&ip_conntrack_lock);
-		list_for_each(cur_item, &ct->sibling_list) { 
+		list_for_each_prev(cur_item, &ct->sibling_list) { 
 			exp = list_entry(cur_item, struct ip_conntrack_expect, 
 					 expected_list);
 					 

--------------070208040101020907050407--
