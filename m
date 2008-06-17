From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 03/03: nf_conntrack_h323: fix module unload crash
Date: Tue, 17 Jun 2008 16:03:55 +0200 (MEST)
Message-ID: <20080617140355.1355.10215.sendpatchset@localhost.localdomain>
References: <20080617140351.1355.59710.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:65218 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757866AbYFQOD5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Jun 2008 10:03:57 -0400
In-Reply-To: <20080617140351.1355.59710.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

netfilter: nf_conntrack_h323: fix module unload crash

The H.245 helper is not registered/unregistered, but assigned to
connections manually from the Q.931 helper. This means on unload
existing expectations and connections using the helper are not
cleaned up, leading to the following oops on module unload:

CPU 0 Unable to handle kernel paging request at virtual address c00a6828, epc == 802224dc, ra == 801d4e7c
Oops[#1]:
Cpu 0
$ 0   : 00000000 00000000 00000004 c00a67f0
$ 4   : 802a5ad0 81657e00 00000000 00000000
$ 8   : 00000008 801461c8 00000000 80570050
$12   : 819b0280 819b04b0 00000006 00000000
$16   : 802a5a60 80000000 80b46000 80321010
$20   : 00000000 00000004 802a5ad0 00000001
$24   : 00000000 802257a8
$28   : 802a4000 802a59e8 00000004 801d4e7c
Hi    : 0000000b
Lo    : 00506320
epc   : 802224dc ip_conntrack_help+0x38/0x74     Tainted: P
ra    : 801d4e7c nf_iterate+0xbc/0x130
Status: 1000f403    KERNEL EXL IE
Cause : 00800008
BadVA : c00a6828
PrId  : 00019374
Modules linked in: ip_nat_pptp ip_conntrack_pptp ath_pktlog wlan_acl wlan_wep wlan_tkip wlan_ccmp wlan_xauth ath_pci ath_dev ath_dfs ath_rate_atheros wlan ath_hal ip_nat_tftp ip_conntrack_tftp ip_nat_ftp ip_conntrack_ftp pppoe ppp_async ppp_deflate ppp_mppe pppox ppp_generic slhc
Process swapper (pid: 0, threadinfo=802a4000, task=802a6000)
Stack : 801e7d98 00000004 802a5a60 80000000 801d4e7c 801d4e7c 802a5ad0 00000004
        00000000 00000000 801e7d98 00000000 00000004 802a5ad0 00000000 00000010
        801e7d98 80b46000 802a5a60 80320000 80000000 801d4f8c 802a5b00 00000002
        80063834 00000000 80b46000 802a5a60 801e7d98 80000000 802ba854 00000000
        81a02180 80b7e260 81a021b0 819b0000 819b0000 80570056 00000000 00000001
        ...
Call Trace:
 [<801e7d98>] ip_finish_output+0x0/0x23c
 [<801d4e7c>] nf_iterate+0xbc/0x130
 [<801d4e7c>] nf_iterate+0xbc/0x130
 [<801e7d98>] ip_finish_output+0x0/0x23c
 [<801e7d98>] ip_finish_output+0x0/0x23c
 [<801d4f8c>] nf_hook_slow+0x9c/0x1a4

One way to fix this would be to split helper cleanup from the unregistration
function and invoke it for the H.245 helper, but since ctnetlink needs to be
able to find the helper for synchonization purposes, a better fix is to
register it normally and make sure its not assigned to connections during
helper lookup. The missing l3num initialization is enough for this, this
patch changes it to use AF_UNSPEC to make it more explicit though.

Reported-by: liannan <liannan@twsz.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 7a514d9c7e4b0d77393eb4bef00580d7ab837906
tree c7f5b120e0c18749da34e9c58d9118ea0e946015
parent bed6cb858aec9a01eefee7fe4d3bfb7581da4863
author Patrick McHardy <kaber@trash.net> Tue, 17 Jun 2008 15:36:39 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 17 Jun 2008 15:36:39 +0200

 net/netfilter/nf_conntrack_h323_main.c |   21 ++++++++++++++-------
 1 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index 99e385d..2f83c15 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -619,6 +619,7 @@ static const struct nf_conntrack_expect_policy h245_exp_policy = {
 static struct nf_conntrack_helper nf_conntrack_helper_h245 __read_mostly = {
 	.name			= "H.245",
 	.me			= THIS_MODULE,
+	.tuple.src.l3num	= AF_UNSPEC,
 	.tuple.dst.protonum	= IPPROTO_UDP,
 	.help			= h245_help,
 	.expect_policy		= &h245_exp_policy,
@@ -1765,6 +1766,7 @@ static void __exit nf_conntrack_h323_fini(void)
 	nf_conntrack_helper_unregister(&nf_conntrack_helper_ras[0]);
 	nf_conntrack_helper_unregister(&nf_conntrack_helper_q931[1]);
 	nf_conntrack_helper_unregister(&nf_conntrack_helper_q931[0]);
+	nf_conntrack_helper_unregister(&nf_conntrack_helper_h245);
 	kfree(h323_buffer);
 	pr_debug("nf_ct_h323: fini\n");
 }
@@ -1777,27 +1779,32 @@ static int __init nf_conntrack_h323_init(void)
 	h323_buffer = kmalloc(65536, GFP_KERNEL);
 	if (!h323_buffer)
 		return -ENOMEM;
-	ret = nf_conntrack_helper_register(&nf_conntrack_helper_q931[0]);
+	ret = nf_conntrack_helper_register(&nf_conntrack_helper_h245);
 	if (ret < 0)
 		goto err1;
-	ret = nf_conntrack_helper_register(&nf_conntrack_helper_q931[1]);
+	ret = nf_conntrack_helper_register(&nf_conntrack_helper_q931[0]);
 	if (ret < 0)
 		goto err2;
-	ret = nf_conntrack_helper_register(&nf_conntrack_helper_ras[0]);
+	ret = nf_conntrack_helper_register(&nf_conntrack_helper_q931[1]);
 	if (ret < 0)
 		goto err3;
-	ret = nf_conntrack_helper_register(&nf_conntrack_helper_ras[1]);
+	ret = nf_conntrack_helper_register(&nf_conntrack_helper_ras[0]);
 	if (ret < 0)
 		goto err4;
+	ret = nf_conntrack_helper_register(&nf_conntrack_helper_ras[1]);
+	if (ret < 0)
+		goto err5;
 	pr_debug("nf_ct_h323: init success\n");
 	return 0;
 
-err4:
+err5:
 	nf_conntrack_helper_unregister(&nf_conntrack_helper_ras[0]);
-err3:
+err4:
 	nf_conntrack_helper_unregister(&nf_conntrack_helper_q931[1]);
-err2:
+err3:
 	nf_conntrack_helper_unregister(&nf_conntrack_helper_q931[0]);
+err2:
+	nf_conntrack_helper_unregister(&nf_conntrack_helper_h245);
 err1:
 	kfree(h323_buffer);
 	return ret;
