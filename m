From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 1/4]: Fix SNAT/DNAT target size checks
Date: Tue, 25 Jan 2005 05:48:07 +0100
Message-ID: <41F5CF87.50208@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050805090204000704020602"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
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
--------------050805090204000704020602
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit



--------------050805090204000704020602
Content-Type: text/x-patch;
 name="01.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2005/01/25 03:56:48+01:00 gandalf@wlug.westbo.se 
#   [NETFILTER]: Fix SNAT/DNAT target size checks
#   
#   This patch fixes two size checks in the checkentry() for SNAT and DNAT
#   targets. The patch to remove support for multiple ranges forgot to use
#   IPT_ALIGN(). This isn't a problem on x86 but other archs like parisc
#   are affected and thus can't add any SNAT/DNAT rules.
#   
#   Signed-off-by: Martin Josefsson <gandalf@wlug.westbo.se>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_nat_rule.c
#   2005/01/25 03:56:39+01:00 gandalf@wlug.westbo.se +2 -2
#   [NETFILTER]: Fix SNAT/DNAT target size checks
#   
#   This patch fixes two size checks in the checkentry() for SNAT and DNAT
#   targets. The patch to remove support for multiple ranges forgot to use
#   IPT_ALIGN(). This isn't a problem on x86 but other archs like parisc
#   are affected and thus can't add any SNAT/DNAT rules.
#   
#   Signed-off-by: Martin Josefsson <gandalf@wlug.westbo.se>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv4/netfilter/ip_nat_rule.c b/net/ipv4/netfilter/ip_nat_rule.c
--- a/net/ipv4/netfilter/ip_nat_rule.c	2005-01-25 04:37:00 +01:00
+++ b/net/ipv4/netfilter/ip_nat_rule.c	2005-01-25 04:37:00 +01:00
@@ -181,7 +181,7 @@
 		return 0;
 	}
 
-	if (targinfosize != sizeof(struct ip_nat_multi_range_compat)) {
+	if (targinfosize != IPT_ALIGN(sizeof(struct ip_nat_multi_range_compat))) {
 		DEBUGP("SNAT: Target size %u wrong for %u ranges\n",
 		       targinfosize, mr->rangesize);
 		return 0;
@@ -214,7 +214,7 @@
 		return 0;
 	}
 
-	if (targinfosize != sizeof(struct ip_nat_multi_range_compat)) {
+	if (targinfosize != IPT_ALIGN(sizeof(struct ip_nat_multi_range_compat))) {
 		DEBUGP("DNAT: Target size %u wrong for %u ranges\n",
 		       targinfosize, mr->rangesize);
 		return 0;

--------------050805090204000704020602--
