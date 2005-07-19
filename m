From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH] Fix conntrack expectation double-free
Date: Wed, 20 Jul 2005 05:28:11 +1000
Message-ID: <1121801291.30271.160.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
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

Harald, this should probably go into 2.6.13.  We were going to refcnt
for ct_sync anyway, and this fixes real bugs.

Rusty.


Name: ip_conntrack_expect_related Must Not Free Expectation
Status: Tested under nfsim and valgrind
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

If a connection tracking helper tells us to expect a connection, and
we're already expecting that connection, we simply free the one they
gave us and return success.

The problem is that NAT helpers (eg. FTP) have to allocate the
expectation first (to see what port is available) then rewrite the
packet.  If that rewrite fails, they try to remove the expectation,
but it was freed in ip_conntrack_expect_related.

This is one example of a larger problem: having registered the
expectation, the pointer is no longer ours to use.  Reference counting
is needed for ctnetlink anyway, so introduce it now.

To have a single "put" path, we need to grab the reference to the
connection on creation, rather than open-coding it in the caller.

Index: linux-2.6.13-rc3-git1-Netfilter/include/linux/netfilter_ipv4/ip_conntrack.h
===================================================================
--- linux-2.6.13-rc3-git1-Netfilter.orig/include/linux/netfilter_ipv4/ip_conntrack.h	2005-05-25 13:49:14.000000000 +1000
+++ linux-2.6.13-rc3-git1-Netfilter/include/linux/netfilter_ipv4/ip_conntrack.h	2005-07-20 00:44:14.000000000 +1000
@@ -197,6 +197,9 @@
 	/* Timer function; deletes the expectation. */
 	struct timer_list timeout;
 
+	/* Usage count. */
+	atomic_t use;
+
 #ifdef CONFIG_IP_NF_NAT_NEEDED
 	/* This is the original per-proto part, used to map the
 	 * expected connection the way the recipient expects. */
Index: linux-2.6.13-rc3-git1-Netfilter/include/linux/netfilter_ipv4/ip_conntrack_helper.h
===================================================================
--- linux-2.6.13-rc3-git1-Netfilter.orig/include/linux/netfilter_ipv4/ip_conntrack_helper.h	2005-05-25 13:49:14.000000000 +1000
+++ linux-2.6.13-rc3-git1-Netfilter/include/linux/netfilter_ipv4/ip_conntrack_helper.h	2005-07-20 03:33:41.000000000 +1000
@@ -30,9 +30,10 @@
 extern void ip_conntrack_helper_unregister(struct ip_conntrack_helper *);
 
 /* Allocate space for an expectation: this is mandatory before calling 
-   ip_conntrack_expect_related. */
-extern struct ip_conntrack_expect *ip_conntrack_expect_alloc(void);
-extern void ip_conntrack_expect_free(struct ip_conntrack_expect *exp);
+   ip_conntrack_expect_related.  You will have to call put afterwards. */
+extern struct ip_conntrack_expect *
+ip_conntrack_expect_alloc(struct ip_conntrack *master);
+extern void ip_conntrack_expect_put(struct ip_conntrack_expect *exp);
 
 /* Add an expected connection: can have more than one per connection */
 extern int ip_conntrack_expect_related(struct ip_conntrack_expect *exp);
Index: linux-2.6.13-rc3-git1-Netfilter/net/ipv4/netfilter/ip_conntrack_amanda.c
===================================================================
--- linux-2.6.13-rc3-git1-Netfilter.orig/net/ipv4/netfilter/ip_conntrack_amanda.c	2005-07-15 04:42:15.000000000 +1000
+++ linux-2.6.13-rc3-git1-Netfilter/net/ipv4/netfilter/ip_conntrack_amanda.c	2005-07-20 03:44:54.000000000 +1000
@@ -101,14 +101,13 @@
 		if (port == 0 || len > 5)
 			break;
 
-		exp = ip_conntrack_expect_alloc();
+		exp = ip_conntrack_expect_alloc(ct);
 		if (exp == NULL) {
 			ret = NF_DROP;
 			goto out;
 		}
 
 		exp->expectfn = NULL;
-		exp->master = ct;
 
 		exp->tuple.src.ip = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip;
 		exp->tuple.src.u.tcp.port = 0;
@@ -126,10 +125,9 @@
 			ret = ip_nat_amanda_hook(pskb, ctinfo,
 						 tmp - amanda_buffer,
 						 len, exp);
-		else if (ip_conntrack_expect_related(exp) != 0) {
-			ip_conntrack_expect_free(exp);
+		else if (ip_conntrack_expect_related(exp) != 0)
 			ret = NF_DROP;
-		}
+		ip_conntrack_expect_put(exp);
 	}
 
 out:
Index: linux-2.6.13-rc3-git1-Netfilter/net/ipv4/netfilter/ip_conntrack_core.c
===================================================================
--- linux-2.6.13-rc3-git1-Netfilter.orig/net/ipv4/netfilter/ip_conntrack_core.c	2005-07-15 04:42:15.000000000 +1000
+++ linux-2.6.13-rc3-git1-Netfilter/net/ipv4/netfilter/ip_conntrack_core.c	2005-07-20 04:42:27.000000000 +1000
@@ -137,19 +137,12 @@
 
 
 /* ip_conntrack_expect helper functions */
-static void destroy_expect(struct ip_conntrack_expect *exp)
-{
-	ip_conntrack_put(exp->master);
-	IP_NF_ASSERT(!timer_pending(&exp->timeout));
-	kmem_cache_free(ip_conntrack_expect_cachep, exp);
-	CONNTRACK_STAT_INC(expect_delete);
-}
-
 static void unlink_expect(struct ip_conntrack_expect *exp)
 {
 	ASSERT_WRITE_LOCK(&ip_conntrack_lock);
+	IP_NF_ASSERT(!timer_pending(&exp->timeout));
 	list_del(&exp->list);
-	/* Logically in destroy_expect, but we hold the lock here. */
+	CONNTRACK_STAT_INC(expect_delete);
 	exp->master->expecting--;
 }
 
@@ -160,7 +153,7 @@
 	write_lock_bh(&ip_conntrack_lock);
 	unlink_expect(exp);
 	write_unlock_bh(&ip_conntrack_lock);
-	destroy_expect(exp);
+	ip_conntrack_expect_put(exp);
 }
 
 /* If an expectation for this connection is found, it gets delete from
@@ -198,7 +191,7 @@
 	list_for_each_entry_safe(i, tmp, &ip_conntrack_expect_list, list) {
 		if (i->master == ct && del_timer(&i->timeout)) {
 			unlink_expect(i);
-			destroy_expect(i);
+			ip_conntrack_expect_put(i);
 		}
 	}
 }
@@ -537,7 +530,7 @@
 	if (exp) {
 		if (exp->expectfn)
 			exp->expectfn(conntrack, exp);
-		destroy_expect(exp);
+		ip_conntrack_expect_put(exp);
 	}
 
 	return &conntrack->tuplehash[IP_CT_DIR_ORIGINAL];
@@ -729,14 +722,14 @@
 		if (expect_matches(i, exp) && del_timer(&i->timeout)) {
 			unlink_expect(i);
 			write_unlock_bh(&ip_conntrack_lock);
-			destroy_expect(i);
+			ip_conntrack_expect_put(i);
 			return;
 		}
 	}
 	write_unlock_bh(&ip_conntrack_lock);
 }
 
-struct ip_conntrack_expect *ip_conntrack_expect_alloc(void)
+struct ip_conntrack_expect *ip_conntrack_expect_alloc(struct ip_conntrack *me)
 {
 	struct ip_conntrack_expect *new;
 
@@ -745,18 +738,23 @@
 		DEBUGP("expect_related: OOM allocating expect\n");
 		return NULL;
 	}
-	new->master = NULL;
+	new->master = me;
+	atomic_inc(&new->master->ct_general.use);
+	atomic_set(&new->use, 1);
 	return new;
 }
 
-void ip_conntrack_expect_free(struct ip_conntrack_expect *expect)
+void ip_conntrack_expect_put(struct ip_conntrack_expect *exp)
 {
-	kmem_cache_free(ip_conntrack_expect_cachep, expect);
+	if (atomic_dec_and_test(&exp->use)) {
+		ip_conntrack_put(exp->master);
+		kmem_cache_free(ip_conntrack_expect_cachep, exp);
+	}
 }
 
 static void ip_conntrack_expect_insert(struct ip_conntrack_expect *exp)
 {
-	atomic_inc(&exp->master->ct_general.use);
+	atomic_inc(&exp->use);
 	exp->master->expecting++;
 	list_add(&exp->list, &ip_conntrack_expect_list);
 
@@ -778,7 +776,7 @@
 		if (i->master == master) {
 			if (del_timer(&i->timeout)) {
 				unlink_expect(i);
-				destroy_expect(i);
+				ip_conntrack_expect_put(i);
 			}
 			break;
 		}
@@ -810,8 +808,6 @@
 			/* Refresh timer: if it's dying, ignore.. */
 			if (refresh_timer(i)) {
 				ret = 0;
-				/* We don't need the one they've given us. */
-				ip_conntrack_expect_free(expect);
 				goto out;
 			}
 		} else if (expect_clash(i, expect)) {
@@ -881,7 +877,7 @@
 	list_for_each_entry_safe(exp, tmp, &ip_conntrack_expect_list, list) {
 		if (exp->master->helper == me && del_timer(&exp->timeout)) {
 			unlink_expect(exp);
-			destroy_expect(exp);
+			ip_conntrack_expect_put(exp);
 		}
 	}
 	/* Get rid of expecteds, set helpers to NULL. */
Index: linux-2.6.13-rc3-git1-Netfilter/net/ipv4/netfilter/ip_conntrack_ftp.c
===================================================================
--- linux-2.6.13-rc3-git1-Netfilter.orig/net/ipv4/netfilter/ip_conntrack_ftp.c	2005-07-15 04:42:15.000000000 +1000
+++ linux-2.6.13-rc3-git1-Netfilter/net/ipv4/netfilter/ip_conntrack_ftp.c	2005-07-20 03:51:55.000000000 +1000
@@ -376,7 +376,7 @@
 	       fb_ptr + matchoff, matchlen, ntohl(th->seq) + matchoff);
 			 
 	/* Allocate expectation which will be inserted */
-	exp = ip_conntrack_expect_alloc();
+	exp = ip_conntrack_expect_alloc(ct);
 	if (exp == NULL) {
 		ret = NF_DROP;
 		goto out;
@@ -403,8 +403,7 @@
 		   networks, or the packet filter itself). */
 		if (!loose) {
 			ret = NF_ACCEPT;
-			ip_conntrack_expect_free(exp);
-			goto out_update_nl;
+			goto out_put_expect;
 		}
 		exp->tuple.dst.ip = htonl((array[0] << 24) | (array[1] << 16)
 					 | (array[2] << 8) | array[3]);
@@ -419,7 +418,6 @@
 		  { 0xFFFFFFFF, { .tcp = { 0xFFFF } }, 0xFF }});
 
 	exp->expectfn = NULL;
-	exp->master = ct;
 
 	/* Now, NAT might want to mangle the packet, and register the
 	 * (possibly changed) expectation itself. */
@@ -428,13 +426,15 @@
 				      matchoff, matchlen, exp, &seq);
 	else {
 		/* Can't expect this?  Best to drop packet now. */
-		if (ip_conntrack_expect_related(exp) != 0) {
-			ip_conntrack_expect_free(exp);
+		if (ip_conntrack_expect_related(exp) != 0)
 			ret = NF_DROP;
-		} else
+		else
 			ret = NF_ACCEPT;
 	}
 
+out_put_expect:
+	ip_conntrack_expect_put(exp);
+
 out_update_nl:
 	/* Now if this ends in \n, update ftp info.  Seq may have been
 	 * adjusted by NAT code. */
Index: linux-2.6.13-rc3-git1-Netfilter/net/ipv4/netfilter/ip_conntrack_irc.c
===================================================================
--- linux-2.6.13-rc3-git1-Netfilter.orig/net/ipv4/netfilter/ip_conntrack_irc.c	2005-07-15 04:42:15.000000000 +1000
+++ linux-2.6.13-rc3-git1-Netfilter/net/ipv4/netfilter/ip_conntrack_irc.c	2005-07-20 03:45:33.000000000 +1000
@@ -197,7 +197,7 @@
 				continue;
 			}
 
-			exp = ip_conntrack_expect_alloc();
+			exp = ip_conntrack_expect_alloc(ct);
 			if (exp == NULL) {
 				ret = NF_DROP;
 				goto out;
@@ -221,16 +221,14 @@
 				{ { 0, { 0 } },
 				  { 0xFFFFFFFF, { .tcp = { 0xFFFF } }, 0xFF }});
 			exp->expectfn = NULL;
-			exp->master = ct;
 			if (ip_nat_irc_hook)
 				ret = ip_nat_irc_hook(pskb, ctinfo, 
 						      addr_beg_p - ib_ptr,
 						      addr_end_p - addr_beg_p,
 						      exp);
-			else if (ip_conntrack_expect_related(exp) != 0) {
-				ip_conntrack_expect_free(exp);
+			else if (ip_conntrack_expect_related(exp) != 0)
 				ret = NF_DROP;
-			}
+			ip_conntrack_expect_put(exp);
 			goto out;
 		} /* for .. NUM_DCCPROTO */
 	} /* while data < ... */
Index: linux-2.6.13-rc3-git1-Netfilter/net/ipv4/netfilter/ip_conntrack_standalone.c
===================================================================
--- linux-2.6.13-rc3-git1-Netfilter.orig/net/ipv4/netfilter/ip_conntrack_standalone.c	2005-07-15 04:42:15.000000000 +1000
+++ linux-2.6.13-rc3-git1-Netfilter/net/ipv4/netfilter/ip_conntrack_standalone.c	2005-07-20 01:41:13.000000000 +1000
@@ -985,7 +985,7 @@
 EXPORT_SYMBOL(ip_ct_protos);
 EXPORT_SYMBOL(ip_ct_find_proto);
 EXPORT_SYMBOL(ip_conntrack_expect_alloc);
-EXPORT_SYMBOL(ip_conntrack_expect_free);
+EXPORT_SYMBOL(ip_conntrack_expect_put);
 EXPORT_SYMBOL(ip_conntrack_expect_related);
 EXPORT_SYMBOL(ip_conntrack_unexpect_related);
 EXPORT_SYMBOL(ip_conntrack_tuple_taken);
Index: linux-2.6.13-rc3-git1-Netfilter/net/ipv4/netfilter/ip_conntrack_tftp.c
===================================================================
--- linux-2.6.13-rc3-git1-Netfilter.orig/net/ipv4/netfilter/ip_conntrack_tftp.c	2005-05-25 13:49:18.000000000 +1000
+++ linux-2.6.13-rc3-git1-Netfilter/net/ipv4/netfilter/ip_conntrack_tftp.c	2005-07-20 03:45:46.000000000 +1000
@@ -65,7 +65,7 @@
 		DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
 		DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
 
-		exp = ip_conntrack_expect_alloc();
+		exp = ip_conntrack_expect_alloc(ct);
 		if (exp == NULL)
 			return NF_DROP;
 
@@ -75,17 +75,15 @@
 		exp->mask.dst.u.udp.port = 0xffff;
 		exp->mask.dst.protonum = 0xff;
 		exp->expectfn = NULL;
-		exp->master = ct;
 
 		DEBUGP("expect: ");
 		DUMP_TUPLE(&exp->tuple);
 		DUMP_TUPLE(&exp->mask);
 		if (ip_nat_tftp_hook)
 			ret = ip_nat_tftp_hook(pskb, ctinfo, exp);
-		else if (ip_conntrack_expect_related(exp) != 0) {
-			ip_conntrack_expect_free(exp);
+		else if (ip_conntrack_expect_related(exp) != 0)
 			ret = NF_DROP;
-		}
+		ip_conntrack_expect_put(exp);
 		break;
 	case TFTP_OPCODE_DATA:
 	case TFTP_OPCODE_ACK:
Index: linux-2.6.13-rc3-git1-Netfilter/net/ipv4/netfilter/ip_nat_amanda.c
===================================================================
--- linux-2.6.13-rc3-git1-Netfilter.orig/net/ipv4/netfilter/ip_nat_amanda.c	2005-05-25 13:49:18.000000000 +1000
+++ linux-2.6.13-rc3-git1-Netfilter/net/ipv4/netfilter/ip_nat_amanda.c	2005-07-20 01:41:39.000000000 +1000
@@ -56,10 +56,8 @@
 			break;
 	}
 
-	if (port == 0) {
-		ip_conntrack_expect_free(exp);
+	if (port == 0)
 		return NF_DROP;
-	}
 
 	sprintf(buffer, "%u", port);
 	ret = ip_nat_mangle_udp_packet(pskb, exp->master, ctinfo,
Index: linux-2.6.13-rc3-git1-Netfilter/net/ipv4/netfilter/ip_nat_ftp.c
===================================================================
--- linux-2.6.13-rc3-git1-Netfilter.orig/net/ipv4/netfilter/ip_nat_ftp.c	2005-07-15 04:39:56.000000000 +1000
+++ linux-2.6.13-rc3-git1-Netfilter/net/ipv4/netfilter/ip_nat_ftp.c	2005-07-20 01:41:49.000000000 +1000
@@ -143,10 +143,8 @@
 			break;
 	}
 
-	if (port == 0) {
-		ip_conntrack_expect_free(exp);
+	if (port == 0)
 		return NF_DROP;
-	}
 
 	if (!mangle[type](pskb, newip, port, matchoff, matchlen, ct, ctinfo,
 			  seq)) {
Index: linux-2.6.13-rc3-git1-Netfilter/net/ipv4/netfilter/ip_nat_irc.c
===================================================================
--- linux-2.6.13-rc3-git1-Netfilter.orig/net/ipv4/netfilter/ip_nat_irc.c	2005-07-15 04:39:56.000000000 +1000
+++ linux-2.6.13-rc3-git1-Netfilter/net/ipv4/netfilter/ip_nat_irc.c	2005-07-20 01:42:00.000000000 +1000
@@ -65,10 +65,8 @@
 			break;
 	}
 
-	if (port == 0) {
-		ip_conntrack_expect_free(exp);
+	if (port == 0)
 		return NF_DROP;
-	}
 
 	/*      strlen("\1DCC CHAT chat AAAAAAAA P\1\n")=27
 	 *      strlen("\1DCC SCHAT chat AAAAAAAA P\1\n")=28
Index: linux-2.6.13-rc3-git1-Netfilter/net/ipv4/netfilter/ip_nat_tftp.c
===================================================================
--- linux-2.6.13-rc3-git1-Netfilter.orig/net/ipv4/netfilter/ip_nat_tftp.c	2005-05-25 13:49:18.000000000 +1000
+++ linux-2.6.13-rc3-git1-Netfilter/net/ipv4/netfilter/ip_nat_tftp.c	2005-07-20 01:42:07.000000000 +1000
@@ -45,10 +45,8 @@
 	exp->saved_proto.udp.port = exp->tuple.dst.u.tcp.port;
 	exp->dir = IP_CT_DIR_REPLY;
 	exp->expectfn = ip_nat_follow_master;
-	if (ip_conntrack_expect_related(exp) != 0) {
-		ip_conntrack_expect_free(exp);
+	if (ip_conntrack_expect_related(exp) != 0)
 		return NF_DROP;
-	}
 	return NF_ACCEPT;
 }
 


-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
