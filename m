From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 4/18] Netfilter:  ip_conntrack_alter_reply doesn't need to
	loop
Date: Wed, 05 Jan 2005 14:31:58 +1100
Message-ID: <1104895918.20582.63.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Linus Torvalds <torvalds@osdl.org>
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

Index: linux-2.6.10-bk6-Netfilter/net/ipv4/netfilter/ip_nat_core.c
===================================================================
--- linux-2.6.10-bk6-Netfilter.orig/net/ipv4/netfilter/ip_nat_core.c	2005-01-04 22:11:47.519874168 +1100
+++ linux-2.6.10-bk6-Netfilter/net/ipv4/netfilter/ip_nat_core.c	2005-01-04 22:11:53.612947880 +1100
@@ -467,38 +467,25 @@
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
+
+	   We're only allowed to work with the SRC per-proto
+	   part, so we create inverses of both to start, then
+	   derive the other fields we need.  */
 
-		/* We now have two tuples (SRCIP/SRCPT/DSTIP/DSTPT):
-		   the original (A/B/C/D') and the mangled one (E/F/G/H').
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
Index: linux-2.6.10-bk6-Netfilter/include/linux/netfilter_ipv4/ip_conntrack.h
===================================================================
--- linux-2.6.10-bk6-Netfilter.orig/include/linux/netfilter_ipv4/ip_conntrack.h	2005-01-04 21:30:37.023446712 +1100
+++ linux-2.6.10-bk6-Netfilter/include/linux/netfilter_ipv4/ip_conntrack.h	2005-01-04 22:11:53.613947728 +1100
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
 
Index: linux-2.6.10-bk6-Netfilter/net/ipv4/netfilter/ip_conntrack_core.c
===================================================================
--- linux-2.6.10-bk6-Netfilter.orig/net/ipv4/netfilter/ip_conntrack_core.c	2005-01-04 21:30:37.023446712 +1100
+++ linux-2.6.10-bk6-Netfilter/net/ipv4/netfilter/ip_conntrack_core.c	2005-01-04 22:11:53.614947576 +1100
@@ -1035,16 +1035,12 @@
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
 
@@ -1055,8 +1051,6 @@
 	if (!conntrack->master && list_empty(&conntrack->sibling_list))
 		conntrack->helper = ip_ct_find_helper(newreply);
 	WRITE_UNLOCK(&ip_conntrack_lock);
-
-	return 1;
 }
 
 int ip_conntrack_helper_register(struct ip_conntrack_helper *me)
