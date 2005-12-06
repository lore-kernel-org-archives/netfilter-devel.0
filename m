From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [RESEND 2] [2/2] OSF: netlink related changes.
Date: Tue, 6 Dec 2005 16:52:10 +0300
Message-ID: <20051206135209.GB27686@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harald Welte <laforge@netfilter.org>, PatriK McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hello, developers.
Due to new interface and changed API in netlink area
several patch-o-matic modules can not be compiled.
Passive OS fingerprinting OSF modules is one of them. 
Consider for inclusion.
Thank you.

Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

--- trunk/patch-o-matic-ng/patchlets/osf/linux-2.6/net/ipv4/netfilter/ipt_osf.c      2005-11-05 12:35:02.000000000 -0500
+++ trunk/patch-o-matic-ng/patchlets/osf/linux-2.6/net/ipv4/netfilter/ipt_osf.c       2005-11-05 12:43:54.000000000 -0500
@@ -30,6 +30,7 @@

 #include <linux/config.h>
 #include <linux/kernel.h>
+#include <linux/version.h>
 #include <linux/types.h>
 #include <linux/string.h>
 #include <linux/smp.h>
@@ -155,7 +156,11 @@
 	memcpy(&data->ip, sk->nh.iph, sizeof(struct iphdr));
 	memcpy(&data->tcp, (struct tcphdr *)((u_int32_t *)sk->nh.iph + sk->nh.iph->ihl), sizeof(struct tcphdr));

+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,14)
 	NETLINK_CB(skb).dst_groups = ipt_osf_groups;
+#else
+	NETLINK_CB(skb).dst_group = ipt_osf_groups;
+#endif
 	netlink_broadcast(nts, skb, 0, ipt_osf_groups, GFP_ATOMIC);

 nlmsg_failure:
@@ -821,7 +826,11 @@
 	p->write_proc->osf_proc_write;
 	p->read_proc->osf_proc_read;

+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,14)
 	nts->netlink_kernel_create(NETLINK_NFLOG, NULL);
+#else
+	nts->netlink_kernel_create(NETLINK_NFLOG, 1, NULL, THIS_MODULE);
+#endif
 	if (!nts) {
 		log("netlink_kernel_create() failed\n");
 	}


-- 
	Evgeniy Polyakov
