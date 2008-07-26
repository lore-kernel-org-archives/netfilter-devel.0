From: Patrick McHardy <kaber@trash.net>
Subject: selinux 02/06: use nf_register_hooks()
Date: Sun, 27 Jul 2008 01:37:09 +0200 (MEST)
Message-ID: <20080726233708.15283.61416.sendpatchset@localhost.localdomain>
References: <20080726233705.15283.38364.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43532 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756012AbYGZXhK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 26 Jul 2008 19:37:10 -0400
In-Reply-To: <20080726233705.15283.38364.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

selinux: use nf_register_hooks()

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Acked-by: James Morris <jmorris@namei.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 0b2ece9450ccf5ab814cc8d3520f6977db184e28
tree 3d55f92f34e54fb29885979946c1cc9350e09620
parent 1560ab44b64937c854fedbfedc80a7f2ae491436
author Alexey Dobriyan <adobriyan@gmail.com> Sun, 27 Jul 2008 00:40:02 +0200
committer Patrick McHardy <kaber@trash.net> Sun, 27 Jul 2008 00:40:02 +0200

 security/selinux/hooks.c |   27 ++++++++-------------------
 1 files changed, 8 insertions(+), 19 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 63f131f..df0515d 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -5670,27 +5670,20 @@ static struct nf_hook_ops selinux_ipv6_ops[] = {
 static int __init selinux_nf_ip_init(void)
 {
 	int err = 0;
-	u32 iter;
 
 	if (!selinux_enabled)
 		goto out;
 
 	printk(KERN_DEBUG "SELinux:  Registering netfilter hooks\n");
 
-	for (iter = 0; iter < ARRAY_SIZE(selinux_ipv4_ops); iter++) {
-		err = nf_register_hook(&selinux_ipv4_ops[iter]);
-		if (err)
-			panic("SELinux: nf_register_hook for IPv4: error %d\n",
-			      err);
-	}
+	err = nf_register_hooks(selinux_ipv4_ops, ARRAY_SIZE(selinux_ipv4_ops));
+	if (err)
+		panic("SELinux: nf_register_hooks for IPv4: error %d\n", err);
 
 #if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
-	for (iter = 0; iter < ARRAY_SIZE(selinux_ipv6_ops); iter++) {
-		err = nf_register_hook(&selinux_ipv6_ops[iter]);
-		if (err)
-			panic("SELinux: nf_register_hook for IPv6: error %d\n",
-			      err);
-	}
+	err = nf_register_hooks(selinux_ipv6_ops, ARRAY_SIZE(selinux_ipv6_ops));
+	if (err)
+		panic("SELinux: nf_register_hooks for IPv6: error %d\n", err);
 #endif	/* IPV6 */
 
 out:
@@ -5702,15 +5695,11 @@ __initcall(selinux_nf_ip_init);
 #ifdef CONFIG_SECURITY_SELINUX_DISABLE
 static void selinux_nf_ip_exit(void)
 {
-	u32 iter;
-
 	printk(KERN_DEBUG "SELinux:  Unregistering netfilter hooks\n");
 
-	for (iter = 0; iter < ARRAY_SIZE(selinux_ipv4_ops); iter++)
-		nf_unregister_hook(&selinux_ipv4_ops[iter]);
+	nf_unregister_hooks(selinux_ipv4_ops, ARRAY_SIZE(selinux_ipv4_ops));
 #if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
-	for (iter = 0; iter < ARRAY_SIZE(selinux_ipv6_ops); iter++)
-		nf_unregister_hook(&selinux_ipv6_ops[iter]);
+	nf_unregister_hooks(selinux_ipv6_ops, ARRAY_SIZE(selinux_ipv6_ops));
 #endif	/* IPV6 */
 }
 #endif
