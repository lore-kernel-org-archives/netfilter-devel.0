From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: [PATCH 3/7] ipt_TARPIT compile fix for 2.6.21
Date: Sat, 7 Apr 2007 20:49:48 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0704072049350.22181__47321.7249419124$1177662778$gmane$org@yvahk01.tjqt.qr>
References: <8d158e1f0704070955x2bb50060ueb8d2c0b91acba00@mail.gmail.com>
	<Pine.LNX.4.61.0704072045320.22181@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: Netfilter Mailing List <netfilter@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0704072045320.22181@yvahk01.tjqt.qr>
ReSent-Message-ID: <Pine.LNX.4.61.0704271032051.506@yvahk01.tjqt.qr>
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


Fixes compilation of ipt_TARPIT.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

Index: linux-2.6.21-rc5/net/ipv4/netfilter/ipt_TARPIT.c
===================================================================
--- linux-2.6.21-rc5.orig/net/ipv4/netfilter/ipt_TARPIT.c
+++ linux-2.6.21-rc5/net/ipv4/netfilter/ipt_TARPIT.c
@@ -100,7 +100,7 @@ static void tarpit_tcp(struct sk_buff *o
 		return;
 
 	/* Check checksum. */
-	if (tcp_v4_check(otcph, otcplen, oskb->nh.iph->saddr,
+	if (tcp_v4_check(otcplen, oskb->nh.iph->saddr,
 			 oskb->nh.iph->daddr,
 			 csum_partial((char *)otcph, otcplen, 0)) != 0)
 		return;
@@ -158,7 +158,7 @@ static void tarpit_tcp(struct sk_buff *o
 
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
@@ -278,12 +279,12 @@ static struct ipt_target ipt_tarpit_reg 
 
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
