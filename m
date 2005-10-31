From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH] Fix module refcount dropping too far in 2.6.14
Date: Mon, 31 Oct 2005 18:07:22 +1100
Message-ID: <1130742442.20697.3.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>
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

(Trivial, not compiled). The unknown protocol is used as a fallback when
a protocol isn't known.  Hence we cannot handle it failing, so don't set
".me".  It's OK, since we only grab a reference from within the same
module (iptable_nat.ko), so we never take the module refcount from 0 to
1.

Also, remove the "protocol is NULL" test: it's never NULL.
Signed-off-by: Rusty Rusty <rusty@rustcorp.com.au>

diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal linux-2.6.14/net/ipv4/netfilter/ip_nat_core.c working-2.6.14-proto-unknown-fix/net/ipv4/netfilter/ip_nat_core.c
--- linux-2.6.14/net/ipv4/netfilter/ip_nat_core.c	2005-10-31 12:21:25.000000000 +1100
+++ working-2.6.14-proto-unknown-fix/net/ipv4/netfilter/ip_nat_core.c	2005-10-31 17:59:39.000000000 +1100
@@ -66,10 +66,8 @@ ip_nat_proto_find_get(u_int8_t protonum)
 	 * removed until we've grabbed the reference */
 	preempt_disable();
 	p = __ip_nat_proto_find(protonum);
-	if (p) {
-		if (!try_module_get(p->me))
-			p = &ip_nat_unknown_protocol;
-	}
+	if (!try_module_get(p->me))
+		p = &ip_nat_unknown_protocol;
 	preempt_enable();
 
 	return p;
diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal linux-2.6.14/net/ipv4/netfilter/ip_nat_proto_unknown.c working-2.6.14-proto-unknown-fix/net/ipv4/netfilter/ip_nat_proto_unknown.c
--- linux-2.6.14/net/ipv4/netfilter/ip_nat_proto_unknown.c	2005-10-31 12:21:25.000000000 +1100
+++ working-2.6.14-proto-unknown-fix/net/ipv4/netfilter/ip_nat_proto_unknown.c	2005-10-31 18:01:12.000000000 +1100
@@ -62,7 +62,7 @@ unknown_print_range(char *buffer, const 
 
 struct ip_nat_protocol ip_nat_unknown_protocol = {
 	.name			= "unknown",
-	.me			= THIS_MODULE,
+	/* .me isn't set: getting a ref to this cannot fail. */
 	.manip_pkt		= unknown_manip_pkt,
 	.in_range		= unknown_in_range,
 	.unique_tuple		= unknown_unique_tuple,

-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
