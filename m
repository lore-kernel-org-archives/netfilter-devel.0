From: gfree.wind@foxmail.com
Subject: [PATCH nf v4 1/1] netfilter: snmp: Fix one possible panic when snmp_trap_helper fail to register
Date: Sat, 25 Mar 2017 10:24:06 +0800
Message-ID: <1490408646-26051-1-git-send-email-gfree.wind@foxmail.com>
Cc: Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        gfree.wind@foxmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbgau1.qq.com ([54.206.16.166]:57655 "EHLO smtpbgau1.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934005AbdCYCY0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Mar 2017 22:24:26 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

In the commit 93557f53e1fb ("netfilter: nf_conntrack: nf_conntrack snmp
helper"), the snmp_helper is replaced by nf_nat_snmp_hook. So the
snmp_helper is never registered. But it still tries to unregister the
snmp_helper, it could cause the panic.

Now remove the useless snmp_helper and the unregister call in the
error handler.

Fixes: 93557f53e1fb ("netfilter: nf_conntrack: nf_conntrack snmp helper")
Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 v4: Simplify the codes, per Pablo
 v3: Remove the angle brackets in description, per Sergei
 v2: Add the SHA1 ID in the description, per Sergei
 v1: Initial version

 net/ipv4/netfilter/nf_nat_snmp_basic.c | 17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_snmp_basic.c b/net/ipv4/netfilter/nf_nat_snmp_basic.c
index c9b52c3..36d16e5 100644
--- a/net/ipv4/netfilter/nf_nat_snmp_basic.c
+++ b/net/ipv4/netfilter/nf_nat_snmp_basic.c
@@ -1260,16 +1260,6 @@ static int help(struct sk_buff *skb, unsigned int protoff,
 	.timeout	= 180,
 };
 
-static struct nf_conntrack_helper snmp_helper __read_mostly = {
-	.me			= THIS_MODULE,
-	.help			= help,
-	.expect_policy		= &snmp_exp_policy,
-	.name			= "snmp",
-	.tuple.src.l3num	= AF_INET,
-	.tuple.src.u.udp.port	= cpu_to_be16(SNMP_PORT),
-	.tuple.dst.protonum	= IPPROTO_UDP,
-};
-
 static struct nf_conntrack_helper snmp_trap_helper __read_mostly = {
 	.me			= THIS_MODULE,
 	.help			= help,
@@ -1293,12 +1283,7 @@ static int __init nf_nat_snmp_basic_init(void)
 	BUG_ON(nf_nat_snmp_hook != NULL);
 	RCU_INIT_POINTER(nf_nat_snmp_hook, help);
 
-	ret = nf_conntrack_helper_register(&snmp_trap_helper);
-	if (ret < 0) {
-		nf_conntrack_helper_unregister(&snmp_helper);
-		return ret;
-	}
-	return ret;
+	return nf_conntrack_helper_register(&snmp_trap_helper);
 }
 
 static void __exit nf_nat_snmp_basic_fini(void)
-- 
1.9.1




