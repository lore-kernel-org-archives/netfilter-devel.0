From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] ipt_hashlimit.c: expire's type overflow when showing
 tuples at bad moment.
Date: Wed, 02 Feb 2005 03:11:23 +0100
Message-ID: <420036CB.9050804@trash.net>
References: <41F2FE92.6020603@cookinglinux.org>	<20050201132915.GJ6878@sunbeam.de.gnumonks.org>	<41FF877D.4080309@trash.net>	<20050201135423.GS6878@sunbeam.de.gnumonks.org>	<41FF9024.3070101@trash.net>	<6732.142.169.215.10.1107269629.squirrel@142.169.215.10>
	<41FFC770.2090401@trash.net> <41FFF909.9050509@cookinglinux.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000703030603050706000901"
Cc: netfilter-devel@lists.netfilter.org
To: Samuel Jean <sj-netfilter@cookinglinux.org>
In-Reply-To: <41FFF909.9050509@cookinglinux.org>
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
--------------000703030603050706000901
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Samuel Jean wrote:

> # cat /proc/net/ipt_hashlimit/moo
> 4294967 x.239.59.104:0->0.0.0.0:0 1600 1600 320
> 4294967 x.162.158.131:0->0.0.0.0:0 1600 1600 320

Apparently we saw two different problems. The problem I saw on my
64 bit system was caused by my false assumption that gcc would
promote arguments to functions declared with attribute(format(printf))
to the types specified in the format string. It does not, so -1
was passed as signed int, but interpreted as an signed long.
The reason for the problem you are seeing is that the result of
an arithmetic operation where both operands have equal types has
the same type as the operands. This means the subtraction of
two unsigned longs yields an unsigned long. The division by HZ
then makes it small enough so it looses the sign bit.

This patch should fix the problem.

Regards
Patrick


--------------000703030603050706000901
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2005/02/02 02:59:11+01:00 kaber@coreworks.de 
#   [NETFILTER]: Use correct types in seq_printf calls
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ipt_hashlimit.c
#   2005/02/02 02:59:01+01:00 kaber@coreworks.de +1 -1
#   [NETFILTER]: Use correct types in seq_printf calls
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_conntrack_standalone.c
#   2005/02/02 02:59:01+01:00 kaber@coreworks.de +6 -5
#   [NETFILTER]: Use correct types in seq_printf calls
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv4/netfilter/ip_conntrack_standalone.c b/net/ipv4/netfilter/ip_conntrack_standalone.c
--- a/net/ipv4/netfilter/ip_conntrack_standalone.c	2005-02-02 03:03:08 +01:00
+++ b/net/ipv4/netfilter/ip_conntrack_standalone.c	2005-02-02 03:03:08 +01:00
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
--- a/net/ipv4/netfilter/ipt_hashlimit.c	2005-02-02 03:03:08 +01:00
+++ b/net/ipv4/netfilter/ipt_hashlimit.c	2005-02-02 03:03:08 +01:00
@@ -609,7 +609,7 @@
 	rateinfo_recalc(ent, jiffies);
 
 	return seq_printf(s, "%ld %u.%u.%u.%u:%u->%u.%u.%u.%u:%u %u %u %u\n",
-			(ent->expires - jiffies)/HZ,
+			(long)(ent->expires - jiffies)/HZ,
 			NIPQUAD(ent->dst.src_ip), ntohs(ent->dst.src_port),
 			NIPQUAD(ent->dst.dst_ip), ntohs(ent->dst.dst_port),
 			ent->rateinfo.credit, ent->rateinfo.credit_cap,

--------------000703030603050706000901--
