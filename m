From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 2/8]: Use correct types in seq_printf calls
Date: Fri, 04 Mar 2005 13:00:29 +0100
Message-ID: <42284DDD.5070900@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
 name="02.diff"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline;
 filename="02.diff"
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

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2005/03/03 23:15:03+01:00 kaber@coreworks.de 
#   [NETFILTER]: Use correct types in seq_printf calls
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ipt_hashlimit.c
#   2005/03/03 23:14:53+01:00 kaber@coreworks.de +1 -1
#   [NETFILTER]: Use correct types in seq_printf calls
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_conntrack_standalone.c
#   2005/03/03 23:14:53+01:00 kaber@coreworks.de +6 -5
#   [NETFILTER]: Use correct types in seq_printf calls
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv4/netfilter/ip_conntrack_standalone.c b/net/ipv4/netfilter/ip_conntrack_standalone.c
--- a/net/ipv4/netfilter/ip_conntrack_standalone.c	2005-03-03 23:35:36 +01:00
+++ b/net/ipv4/netfilter/ip_conntrack_standalone.c	2005-03-03 23:35:36 +01:00
@@ -115,11 +115,12 @@
 			       .tuple.dst.protonum);
 	IP_NF_ASSERT(proto);
 
-	if (seq_printf(s, "%-8s %u %lu ",
+	if (seq_printf(s, "%-8s %u %ld ",
 		      proto->name,
 		      conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum,
 		      timer_pending(&conntrack->timeout)
-		      ? (conntrack->timeout.expires - jiffies)/HZ : 0) != 0)
+		      ? (long)(conntrack->timeout.expires - jiffies)/HZ
+		      : 0) != 0)
 		return 1;
 
 	if (proto->print_conntrack(s, conntrack))
@@ -148,7 +149,7 @@
 			return 1;
 
 #if defined(CONFIG_IP_NF_CONNTRACK_MARK)
-	if (seq_printf(s, "mark=%ld ", conntrack->mark))
+	if (seq_printf(s, "mark=%lu ", conntrack->mark))
 		return 1;
 #endif
 
@@ -235,8 +236,8 @@
 	struct ip_conntrack_expect *expect = v;
 
 	if (expect->timeout.function)
-		seq_printf(s, "%lu ", timer_pending(&expect->timeout)
-			   ? (expect->timeout.expires - jiffies)/HZ : 0);
+		seq_printf(s, "%ld ", timer_pending(&expect->timeout)
+			   ? (long)(expect->timeout.expires - jiffies)/HZ : 0);
 	else
 		seq_printf(s, "- ");
 
diff -Nru a/net/ipv4/netfilter/ipt_hashlimit.c b/net/ipv4/netfilter/ipt_hashlimit.c
--- a/net/ipv4/netfilter/ipt_hashlimit.c	2005-03-03 23:35:36 +01:00
+++ b/net/ipv4/netfilter/ipt_hashlimit.c	2005-03-03 23:35:36 +01:00
@@ -619,7 +619,7 @@
 	rateinfo_recalc(ent, jiffies);
 
 	return seq_printf(s, "%ld %u.%u.%u.%u:%u->%u.%u.%u.%u:%u %u %u %u\n",
-			(ent->expires - jiffies)/HZ,
+			(long)(ent->expires - jiffies)/HZ,
 			NIPQUAD(ent->dst.src_ip), ntohs(ent->dst.src_port),
 			NIPQUAD(ent->dst.dst_ip), ntohs(ent->dst.dst_port),
 			ent->rateinfo.credit, ent->rateinfo.credit_cap,
