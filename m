From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 2/5]  ip_conntrack_alter_reply doesn't need to loop
Date: Thu, 18 Nov 2004 16:42:08 +1100
Message-ID: <1100756528.5865.50.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
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

Name: ip_conntrack_alter_reply doesn't need to loop
Author: Rusty Russell
Status: Booted on 2.6.0-test5-bk1

ip_conntrack_alter_reply checks that the reply isn't already taken,
but there's little point, since there's *still* a race after it is
called (which we handle at confirm time anyway).

Index: linux-2.6.10-rc2-bk1-Netfilter/net/ipv4/netfilter/ip_nat_core.c
===================================================================
--- linux-2.6.10-rc2-bk1-Netfilter.orig/net/ipv4/netfilter/ip_nat_core.c	2004-11-18 15:17:07.283148416 +1100
+++ linux-2.6.10-rc2-bk1-Netfilter/net/ipv4/netfilter/ip_nat_core.c	2004-11-18 15:20:38.391055136 +1100
@@ -475,38 +475,25 @@
 	}
 #endif
 
-	do {
-		if (!get_unique_tuple(&new_tuple, &orig_tp, range, conntrack,
-				      hooknum)) {
-			DEBUGP("ip_nat_setup_info: Can't get unique for %p.\n",
-			       conntrack);
-			return NF_DROP;
-		}
-
-#if 0
-		DEBUGP("Hook %u (%s) %p\n", hooknum,
-		       HOOK2MANIP(hooknum)==IP_NAT_MANIP_SRC ? "SRC" : "DST",
+	if (!get_unique_tuple(&new_tuple, &orig_tp, range,conntrack,hooknum)) {
+		DEBUGP("ip_nat_setup_info: Can't get unique for %p.\n",
 		       conntrack);
-		DEBUGP("Original: ");
-		DUMP_TUPLE(&orig_tp);
-		DEBUGP("New: ");
-		DUMP_TUPLE(&new_tuple);
-#endif
+		return NF_DROP;
+	}
+
+	/* We now have two tuples (SRCIP/SRCPT/DSTIP/DSTPT):
+	   the original (A/B/C/D') and the mangled one (E/F/G/H').
 
-		/* We now have two tuples (SRCIP/SRCPT/DSTIP/DSTPT):
-		   the original (A/B/C/D') and the mangled one (E/F/G/H').
+	   We're only allowed to work with the SRC per-proto
+	   part, so we create inverses of both to start, then
+	   derive the other fields we need.  */
+
+	/* Reply connection: simply invert the new tuple
+	   (G/H/E/F') */
+	invert_tuplepr(&reply, &new_tuple);
 
-		   We're only allowed to work with the SRC per-proto
-		   part, so we create inverses of both to start, then
-		   derive the other fields we need.  */
-
-		/* Reply connection: simply invert the new tuple
-                   (G/H/E/F') */
-		invert_tuplepr(&reply, &new_tuple);
-
-		/* Alter conntrack table so it recognizes replies.
-                   If fail this race (reply tuple now used), repeat. */
-	} while (!ip_conntrack_alter_reply(conntrack, &reply));
+	/* Alter conntrack table so will recognize replies. */
+	ip_conntrack_alter_reply(conntrack, &reply);
 
 	/* FIXME: We can simply used existing conntrack reply tuple
            here --RR */
Index: linux-2.6.10-rc2-bk1-Netfilter/include/linux/netfilter_ipv4/ip_conntrack.h
===================================================================
--- linux-2.6.10-rc2-bk1-Netfilter.orig/include/linux/netfilter_ipv4/ip_conntrack.h	2004-11-16 15:30:07.000000000 +1100
+++ linux-2.6.10-rc2-bk1-Netfilter/include/linux/netfilter_ipv4/ip_conntrack.h	2004-11-18 15:17:49.631710456 +1100
@@ -224,9 +224,8 @@
 /* get master conntrack via master expectation */
 #define master_ct(conntr) (conntr->master ? conntr->master->expectant : NULL)
 
-/* Alter reply tuple (maybe alter helper).  If it's already taken,
-   return 0 and don't do alteration. */
-extern int
+/* Alter reply tuple (maybe alter helper). */
+extern void
 ip_conntrack_alter_reply(struct ip_conntrack *conntrack,
 			 const struct ip_conntrack_tuple *newreply);
 
Index: linux-2.6.10-rc2-bk1-Netfilter/net/ipv4/netfilter/ip_conntrack_core.c
===================================================================
--- linux-2.6.10-rc2-bk1-Netfilter.orig/net/ipv4/netfilter/ip_conntrack_core.c	2004-11-16 15:30:12.000000000 +1100
+++ linux-2.6.10-rc2-bk1-Netfilter/net/ipv4/netfilter/ip_conntrack_core.c	2004-11-18 15:17:49.632710304 +1100
@@ -1013,16 +1013,12 @@
 	return ret;
 }
 
-/* Alter reply tuple (maybe alter helper).  If it's already taken,
-   return 0 and don't do alteration. */
-int ip_conntrack_alter_reply(struct ip_conntrack *conntrack,
-			     const struct ip_conntrack_tuple *newreply)
+/* Alter reply tuple (maybe alter helper).  This is for NAT, and is
+   implicitly racy: see __ip_conntrack_confirm */
+void ip_conntrack_alter_reply(struct ip_conntrack *conntrack,
+			      const struct ip_conntrack_tuple *newreply)
 {
 	WRITE_LOCK(&ip_conntrack_lock);
-	if (__ip_conntrack_find(newreply, conntrack)) {
-		WRITE_UNLOCK(&ip_conntrack_lock);
-		return 0;
-	}
 	/* Should be unconfirmed, so not in hash table yet */
 	IP_NF_ASSERT(!is_confirmed(conntrack));
 
@@ -1033,8 +1029,6 @@
 	if (!conntrack->master && list_empty(&conntrack->sibling_list))
 		conntrack->helper = ip_ct_find_helper(newreply);
 	WRITE_UNLOCK(&ip_conntrack_lock);
-
-	return 1;
 }
 
 int ip_conntrack_helper_register(struct ip_conntrack_helper *me)

-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
