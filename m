From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 10/12]: Fix two broken assertions
Date: Tue, 21 Sep 2004 05:23:18 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <414F9EA6.7020302@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090104050200040607000509"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@redhat.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------090104050200040607000509
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

ChangeSet@1.1935.1.10, 2004-09-20 11:52:16+02:00, kaber@coreworks.de
  [NETFILTER]: Fix two broken assertions
 
  Signed-off-by: Patrick McHardy <kaber@trash.net>



--------------090104050200040607000509
Content-Type: text/x-patch;
 name="10.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="10.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/09/20 11:52:16+02:00 kaber@coreworks.de 
#   [NETFILTER]: Fix two broken assertions
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_nat_core.c
#   2004/09/20 11:51:56+02:00 kaber@coreworks.de +2 -6
#   [NETFILTER]: Fix two broken assertions
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_conntrack_core.c
#   2004/09/20 11:51:56+02:00 kaber@coreworks.de +1 -1
#   [NETFILTER]: Fix two broken assertions
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
--- a/net/ipv4/netfilter/ip_conntrack_core.c	2004-09-20 11:59:17 +02:00
+++ b/net/ipv4/netfilter/ip_conntrack_core.c	2004-09-20 11:59:17 +02:00
@@ -590,7 +590,7 @@
 		DEBUGP("conntrack: expectation arrives ct=%p exp=%p\n",
 			conntrack, expected);
 		/* Welcome, Mr. Bond.  We've been expecting you... */
-		IP_NF_ASSERT(master_ct(conntrack));
+		IP_NF_ASSERT(expected->expectant);
 		__set_bit(IPS_EXPECTED_BIT, &conntrack->status);
 		conntrack->master = expected;
 		expected->sibling = conntrack;
diff -Nru a/net/ipv4/netfilter/ip_nat_core.c b/net/ipv4/netfilter/ip_nat_core.c
--- a/net/ipv4/netfilter/ip_nat_core.c	2004-09-20 11:59:17 +02:00
+++ b/net/ipv4/netfilter/ip_nat_core.c	2004-09-20 11:59:17 +02:00
@@ -852,12 +852,8 @@
 	}
 
 	/* Must be RELATED */
-	IP_NF_ASSERT((*pskb)->nfct
-		     - ((struct ip_conntrack *)(*pskb)->nfct->master)->infos
-		     == IP_CT_RELATED
-		     || (*pskb)->nfct
-		     - ((struct ip_conntrack *)(*pskb)->nfct->master)->infos
-		     == IP_CT_RELATED+IP_CT_IS_REPLY);
+	IP_NF_ASSERT((*pskb)->nfctinfo == IP_CT_RELATED ||
+		     (*pskb)->nfctinfo == IP_CT_RELATED+IP_CT_IS_REPLY);
 
 	/* Redirects on non-null nats must be dropped, else they'll
            start talking to each other without our translation, and be

--------------090104050200040607000509--
