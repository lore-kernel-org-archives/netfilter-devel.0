From: Max Kellermann <max@duempel.org>
Subject: [PATCH] ipt_TARPIT for Linux 2.6.21
Date: Fri, 27 Apr 2007 10:23:43 +0200
Message-ID: <20070427082343.GA26645@roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
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

Adapt ipt_TARPIT for Linux 2.6.21.

Signed-off-by: Max Kellermann <max@duempel.org>

diff --git a/net/ipv4/netfilter/ipt_TARPIT.c b/net/ipv4/netfilter/ipt_TARPIT.c
index 3a2bd64..f0e252d 100644
--- a/net/ipv4/netfilter/ipt_TARPIT.c
+++ b/net/ipv4/netfilter/ipt_TARPIT.c
@@ -100,7 +100,7 @@ static void tarpit_tcp(struct sk_buff *oskb,struct rtable *ort,int local)
 		return;
 
 	/* Check checksum. */
-	if (tcp_v4_check(otcph, otcplen, oskb->nh.iph->saddr,
+	if (tcp_v4_check(otcplen, oskb->nh.iph->saddr,
 			 oskb->nh.iph->daddr,
 			 csum_partial((char *)otcph, otcplen, 0)) != 0)
 		return;
@@ -158,7 +158,7 @@ static void tarpit_tcp(struct sk_buff *oskb,struct rtable *ort,int local)
 
 	/* Adjust TCP checksum */
 	ntcph->check = 0;
-	ntcph->check = tcp_v4_check(ntcph, sizeof(struct tcphdr),
+	ntcph->check = tcp_v4_check(sizeof(struct tcphdr),
 				   nskb->nh.iph->saddr,
 				   nskb->nh.iph->daddr,
 				   csum_partial((char *)ntcph,
@@ -269,8 +269,9 @@ static int check(const char *tablename,
 	return 1;
 }
 
-static struct ipt_target ipt_tarpit_reg = {
+static struct xt_target ipt_tarpit_reg = {
 	.name = "TARPIT",
+	.family = AF_INET,
 	.target = tarpit,
 	.checkentry = check,
 	.me = THIS_MODULE
@@ -278,12 +279,12 @@ static struct ipt_target ipt_tarpit_reg = {
 
 static int __init init(void)
 {
-	return ipt_register_target(&ipt_tarpit_reg);
+	return xt_register_target(&ipt_tarpit_reg);
 }
 
 static void __exit fini(void)
 {
-	ipt_unregister_target(&ipt_tarpit_reg);
+	xt_unregister_target(&ipt_tarpit_reg);
 }
 
 module_init(init);
