From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 2/18]
	/home/rusty/devel/kernel/quilt/linux-2.6.10-bk7-Netfilter: When
	ipt_ECN needs TCP, check it is not inverted
Date: Wed, 05 Jan 2005 14:29:45 +1100
Message-ID: <1104895785.20582.43.camel@localhost.localdomain>
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

Name: When ipt_ECN needs TCP, check it is not inverted
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Status: Tested under nfsim

Writing the nfsim testcase for the ECN target revealed a hole in the
rule checking: when checking whether the rule specified TCP, you need
to check it isn't inverted.

Index: linux-2.6.10-bk6-Netfilter/net/ipv4/netfilter/ipt_ECN.c
===================================================================
--- linux-2.6.10-bk6-Netfilter.orig/net/ipv4/netfilter/ipt_ECN.c	2005-01-04 20:49:24.000000000 +1100
+++ linux-2.6.10-bk6-Netfilter/net/ipv4/netfilter/ipt_ECN.c	2005-01-04 21:24:00.812679904 +1100
@@ -148,7 +148,7 @@
 	}
 
 	if ((einfo->operation & (IPT_ECN_OP_SET_ECE|IPT_ECN_OP_SET_CWR))
-	    && e->ip.proto != IPPROTO_TCP) {
+	    && (e->ip.proto != IPPROTO_TCP || (e->ip.invflags & IPT_INV_PROTO))) {
 		printk(KERN_WARNING "ECN: cannot use TCP operations on a "
 		       "non-tcp rule\n");
 		return 0;
