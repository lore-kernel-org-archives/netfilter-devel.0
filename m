From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH][RFC] Race in ip_conntrack_alter_reply
Date: Sun, 16 May 2004 14:06:16 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040516210616.GA20291@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I am still experiencing near daily deadlocks on a few heavily used
firewalls here (on all kernels from ~2.4.2x - 2.6.6).

In searching for a solution, I noticed that back in September 2003,
Rusty Russell pointed out the possibility of a race in ip_conntrack_alter_reply
and offered the below patch.

The relevant threads are:

http://lists.netfilter.org/pipermail/netfilter-devel/2003-September/012368.html
http://lists.netfilter.org/pipermail/netfilter-devel/2003-September/012388.html

And the patch is included below.

It has not yet been included in 2.6 -- should it be??

Phil Oester


Name: ip_conntrack_alter_reply thinko fix
Author: Rusty Russell
Status: Trivial

D: ip_conntrack_alter_reply checks that the reply isn't already taken,
D: but there's little point, since there's *still* a race after it is
D: called (which we handle at confirm time anyway).

diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .18239-linux-2.6.0-test5-bk1/include/linux/netfilter_ipv4/ip_conntrack.h .18239-linux-2.6.0-test5-bk1.updated/include/linux/netfilter_ipv4/ip_conntrack.h
--- .18239-linux-2.6.0-test5-bk1/include/linux/netfilter_ipv4/ip_conntrack.h	2003-05-27 15:02:21.000000000 +1000
+++ .18239-linux-2.6.0-test5-bk1.updated/include/linux/netfilter_ipv4/ip_conntrack.h	2003-09-11 15:38:49.000000000 +1000
@@ -211,9 +211,8 @@ struct ip_conntrack
 /* get master conntrack via master expectation */
 #define master_ct(conntr) (conntr->master ? conntr->master->expectant : NULL)
 
-/* Alter reply tuple (maybe alter helper).  If it's already taken,
-   return 0 and don't do alteration. */
-extern int
+/* Alter reply tuple (maybe alter helper). */
+extern void
 ip_conntrack_alter_reply(struct ip_conntrack *conntrack,
 			 const struct ip_conntrack_tuple *newreply);
 
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .18239-linux-2.6.0-test5-bk1/net/ipv4/netfilter/ip_conntrack_core.c .18239-linux-2.6.0-test5-bk1.updated/net/ipv4/netfilter/ip_conntrack_core.c
--- .18239-linux-2.6.0-test5-bk1/net/ipv4/netfilter/ip_conntrack_core.c	2003-09-09 10:35:07.000000000 +1000
+++ .18239-linux-2.6.0-test5-bk1.updated/net/ipv4/netfilter/ip_conntrack_core.c	2003-09-11 15:39:14.000000000 +1000
@@ -1081,16 +1081,12 @@ int ip_conntrack_change_expect(struct ip
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
 
@@ -1103,8 +1099,6 @@ int ip_conntrack_alter_reply(struct ip_c
 					      struct ip_conntrack_helper *,
 					      newreply);
 	WRITE_UNLOCK(&ip_conntrack_lock);
-
-	return 1;
 }
 
 int ip_conntrack_helper_register(struct ip_conntrack_helper *me)
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .18239-linux-2.6.0-test5-bk1/net/ipv4/netfilter/ip_nat_core.c .18239-linux-2.6.0-test5-bk1.updated/net/ipv4/netfilter/ip_nat_core.c
--- .18239-linux-2.6.0-test5-bk1/net/ipv4/netfilter/ip_nat_core.c	2003-09-09 10:35:07.000000000 +1000
+++ .18239-linux-2.6.0-test5-bk1.updated/net/ipv4/netfilter/ip_nat_core.c	2003-09-11 15:38:49.000000000 +1000
@@ -557,38 +557,25 @@ ip_nat_setup_info(struct ip_conntrack *c
 	}
 #endif
 
-	do {
-		if (!get_unique_tuple(&new_tuple, &orig_tp, mr, conntrack,
-				      hooknum)) {
-			DEBUGP("ip_nat_setup_info: Can't get unique for %p.\n",
-			       conntrack);
-			return NF_DROP;
-		}
-
-#if 0
-		DEBUGP("Hook %u (%s) %p\n", hooknum,
-		       HOOK2MANIP(hooknum)==IP_NAT_MANIP_SRC ? "SRC" : "DST",
+	if (!get_unique_tuple(&new_tuple, &orig_tp, mr, conntrack, hooknum)) {
+		DEBUGP("ip_nat_setup_info: Can't get unique for %p.\n",
 		       conntrack);
-		DEBUGP("Original: ");
-		DUMP_TUPLE(&orig_tp);
-		DEBUGP("New: ");
-		DUMP_TUPLE(&new_tuple);
-#endif
+		return NF_DROP;
+	}
 
-		/* We now have two tuples (SRCIP/SRCPT/DSTIP/DSTPT):
-		   the original (A/B/C/D') and the mangled one (E/F/G/H').
+	/* We now have two tuples (SRCIP/SRCPT/DSTIP/DSTPT):
+	   the original (A/B/C/D') and the mangled one (E/F/G/H').
 
-		   We're only allowed to work with the SRC per-proto
-		   part, so we create inverses of both to start, then
-		   derive the other fields we need.  */
+	   We're only allowed to work with the SRC per-proto
+	   part, so we create inverses of both to start, then
+	   derive the other fields we need.  */
 
-		/* Reply connection: simply invert the new tuple
-                   (G/H/E/F') */
-		invert_tuplepr(&reply, &new_tuple);
+	/* Reply connection: simply invert the new tuple
+	   (G/H/E/F') */
+	invert_tuplepr(&reply, &new_tuple);
 
-		/* Alter conntrack table so it recognizes replies.
-                   If fail this race (reply tuple now used), repeat. */
-	} while (!ip_conntrack_alter_reply(conntrack, &reply));
+	/* Alter conntrack table so it recognizes replies. */
+	ip_conntrack_alter_reply(conntrack, &reply);
 
 	/* FIXME: We can simply used existing conntrack reply tuple
            here --RR */
