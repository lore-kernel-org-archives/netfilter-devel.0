From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [netfilter-core] recent in_range fix uncovered another bug?
Date: Thu, 11 Sep 2003 15:45:53 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030911061644.B23BC2C0A7@lists.samba.org>
References: <20030910110555.GA30240@mt.lv>
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Karlis Peisenieks <karlis@mt.lv>
In-reply-to: Your message of "Wed, 10 Sep 2003 14:05:55 +0300."
             <20030910110555.GA30240@mt.lv>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

In message <20030910110555.GA30240@mt.lv> you write:
> Hello!
> 
> I came across "lockup" in conntrack code using 2.4 kernel with bridge 
> netfilter (which is standart in 2.6 kernel) patch applied. Lockup can be 
> reproduced by pinging some host over bridge interface if the host is 
> unreachable in the beginning (e.g. ARP does not resolve) and then 
> becomes reachable (ARP resolves).

Hmm, I've had a patch around for this code for a while now.  The code
is simply wrong.  Does this work for you?

Thanks for your report!
Rusty.
--
  Anyone who quotes me in their sig is an idiot. -- Rusty Russell.

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
