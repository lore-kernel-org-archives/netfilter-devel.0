From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 7/18] Netfilter:  Warn when old code would have done extra
	mangling
Date: Wed, 05 Jan 2005 14:32:55 +1100
Message-ID: <1104895975.20582.68.camel@localhost.localdomain>
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

Name: Warn when old code would have done extra mangling
Status: Tested under nfsim
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Now we no longer do extra mangling, warn in that case.

Index: linux-2.6.10-rc3-bk6-Netfilter/net/ipv4/netfilter/ip_nat_core.c
===================================================================
--- linux-2.6.10-rc3-bk6-Netfilter.orig/net/ipv4/netfilter/ip_nat_core.c	2004-12-13 12:03:18.636116760 +1100
+++ linux-2.6.10-rc3-bk6-Netfilter/net/ipv4/netfilter/ip_nat_core.c	2004-12-13 12:03:19.125042432 +1100
@@ -118,6 +118,25 @@
 	return ip_conntrack_tuple_taken(&reply, ignored_conntrack);
 }
 
+/* Before 2.6.11 we did implicit source NAT if required. Warn about change. */
+static void warn_if_extra_mangle(u32 dstip, u32 srcip)
+{
+	static int warned = 0;
+	struct flowi fl = { .nl_u = { .ip4_u = { .daddr = dstip } } };
+	struct rtable *rt;
+
+	if (ip_route_output_key(&rt, &fl) != 0)
+		return;
+
+	if (rt->rt_src != srcip && !warned) {
+		printk("NAT: no longer support implicit source local NAT\n");
+		printk("NAT: packet src %u.%u.%u.%u -> dst %u.%u.%u.%u\n",
+		       NIPQUAD(srcip), NIPQUAD(dstip));
+		warned = 1;
+	}
+	ip_rt_put(rt);
+}
+
 /* If we source map this tuple so reply looks like reply_tuple, will
  * that meet the constraints of range. */
 static int
@@ -310,6 +329,9 @@
 	*tuple = *orig_tuple;
 	find_best_ips_proto(tuple, range, conntrack, hooknum);
 
+	if (hooknum == NF_IP_LOCAL_OUT && tuple->dst.ip != orig_tuple->dst.ip)
+		warn_if_extra_mangle(tuple->src.ip, tuple->dst.ip);
+
 	/* 3) The per-protocol part of the manip is made to map into
 	   the range to make a unique tuple. */
 
