From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] selinux: use nf_register_hooks()
Date: Mon, 21 Jul 2008 20:25:03 +0400
Message-ID: <20080721162503.GB13264@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, sds@tycho.nsa.gov,
	jmorris@namei.org, eparis@parisplace.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:4970 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbYGUQ0v (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jul 2008 12:26:51 -0400
Received: by ug-out-1314.google.com with SMTP id h2so272935ugf.16
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Jul 2008 09:26:50 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 security/selinux/hooks.c |   27 ++++++++-------------------
 1 file changed, 8 insertions(+), 19 deletions(-)

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
-- 
1.5.4.5


