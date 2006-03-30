From: "Darren Jenkins\\" <darrenrjenkins@gmail.com>
Subject: [KJ] fix kbuild warning in iptable_nat.o
Date: Thu, 30 Mar 2006 22:57:55 +1100
Message-ID: <1143719875.8469.14.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4959871642504261=="
Cc: kernel Janitors <kernel-janitors@lists.osdl.org>
Return-path: <kernel-janitors-bounces@lists.osdl.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.osdl.org/mailman/listinfo/kernel-janitors>,
	<mailto:kernel-janitors-request@lists.osdl.org?subject=unsubscribe>
List-Archive: <http://lists.osdl.org/pipermail/kernel-janitors>
List-Post: <mailto:kernel-janitors@lists.osdl.org>
List-Help: <mailto:kernel-janitors-request@lists.osdl.org?subject=help>
List-Subscribe: <https://lists.osdl.org/mailman/listinfo/kernel-janitors>,
	<mailto:kernel-janitors-request@lists.osdl.org?subject=subscribe>
Sender: kernel-janitors-bounces@lists.osdl.org
Errors-To: kernel-janitors-bounces@lists.osdl.org
List-Id: netfilter-devel.vger.kernel.org

--===============4959871642504261==
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

G'day list

There are a couple of Kbuild warnings in net/ipv4/netfilter/ that would
be nice to get rid of.

WARNING: net/ipv4/netfilter/ip_conntrack.o - Section mismatch: reference
to .init.text:ip_conntrack_init from .text between 'init_or_cleanup' (at
offset 0x7ea) and '__hash_conntrack'
WARNING: net/ipv4/netfilter/iptable_nat.o - Section mismatch: reference
to .init.text:ip_nat_rule_init from .text between 'init_or_cleanup' (at
offset 0x455) and 'nat_decode_session'

I have a patch for the 'iptable_nat.o' warning below, and I was just
wanting to check in and see if any of you netfilter guys had a problem
with this patch, or with me doing a similar patch for the
'ip_canntrack.o' warning.


Any input would be welcome, thanks in advance :). 

Darren J


PS You will have to CC: me as I am not on the netfilter list




Signed-off-by: Darren Jenkins <darrenrjenkins@gmail.com>


--- linux-2.6.16-git13/net/ipv4/netfilter/ip_nat_standalone.c.orig	2006-03-28 21:38:33.000000000 +1100
+++ linux-2.6.16-git13/net/ipv4/netfilter/ip_nat_standalone.c	2006-03-30 22:05:20.000000000 +1100
@@ -354,14 +354,46 @@ static struct nf_hook_ops ip_nat_adjust_
 };
 
 
-static int init_or_cleanup(int init)
+/*
+**	Note: This is used to clean up on unload
+**	but is also used in the init() error path
+**	to relinquish resources before exiting
+*/
+static void cleanup(int clean_level)
+{
+
+	switch (clean_level) {
+	
+	case 0:
+		nf_unregister_hook(&ip_nat_local_in_ops);
+	case 1:
+		nf_unregister_hook(&ip_nat_local_out_ops);
+	case 2:
+		nf_unregister_hook(&ip_nat_adjust_out_ops);
+	case 3:
+		nf_unregister_hook(&ip_nat_adjust_in_ops);
+	case 4:
+		nf_unregister_hook(&ip_nat_out_ops);
+	case 5:
+		nf_unregister_hook(&ip_nat_in_ops);
+	case 6:
+		ip_nat_rule_cleanup();
+	case 7:
+#ifdef CONFIG_XFRM
+		ip_nat_decode_session = NULL;
+		synchronize_net();
+#endif
+	break;
+	}
+}
+
+
+static int __init init(void)
 {
 	int ret = 0;
 
 	need_conntrack();
 
-	if (!init) goto cleanup;
-
 #ifdef CONFIG_XFRM
 	BUG_ON(ip_nat_decode_session != NULL);
 	ip_nat_decode_session = nat_decode_session;
@@ -369,70 +401,50 @@ static int init_or_cleanup(int init)
 	ret = ip_nat_rule_init();
 	if (ret < 0) {
 		printk("ip_nat_init: can't setup rules.\n");
-		goto cleanup_decode_session;
+		cleanup(7);
+		return ret;
 	}
 	ret = nf_register_hook(&ip_nat_in_ops);
 	if (ret < 0) {
 		printk("ip_nat_init: can't register in hook.\n");
-		goto cleanup_rule_init;
+		cleanup(6);
+		return ret;
 	}
 	ret = nf_register_hook(&ip_nat_out_ops);
 	if (ret < 0) {
 		printk("ip_nat_init: can't register out hook.\n");
-		goto cleanup_inops;
+		cleanup(5);
+		return ret;
 	}
 	ret = nf_register_hook(&ip_nat_adjust_in_ops);
 	if (ret < 0) {
 		printk("ip_nat_init: can't register adjust in hook.\n");
-		goto cleanup_outops;
+		cleanup(4);
+		return ret;
 	}
 	ret = nf_register_hook(&ip_nat_adjust_out_ops);
 	if (ret < 0) {
 		printk("ip_nat_init: can't register adjust out hook.\n");
-		goto cleanup_adjustin_ops;
+		cleanup(3);
+		return ret;
 	}
 	ret = nf_register_hook(&ip_nat_local_out_ops);
 	if (ret < 0) {
 		printk("ip_nat_init: can't register local out hook.\n");
-		goto cleanup_adjustout_ops;
+		cleanup(2);
+		return ret;
 	}
 	ret = nf_register_hook(&ip_nat_local_in_ops);
 	if (ret < 0) {
 		printk("ip_nat_init: can't register local in hook.\n");
-		goto cleanup_localoutops;
+		cleanup(1);
 	}
 	return ret;
-
- cleanup:
-	nf_unregister_hook(&ip_nat_local_in_ops);
- cleanup_localoutops:
-	nf_unregister_hook(&ip_nat_local_out_ops);
- cleanup_adjustout_ops:
-	nf_unregister_hook(&ip_nat_adjust_out_ops);
- cleanup_adjustin_ops:
-	nf_unregister_hook(&ip_nat_adjust_in_ops);
- cleanup_outops:
-	nf_unregister_hook(&ip_nat_out_ops);
- cleanup_inops:
-	nf_unregister_hook(&ip_nat_in_ops);
- cleanup_rule_init:
-	ip_nat_rule_cleanup();
- cleanup_decode_session:
-#ifdef CONFIG_XFRM
-	ip_nat_decode_session = NULL;
-	synchronize_net();
-#endif
-	return ret;
-}
-
-static int __init init(void)
-{
-	return init_or_cleanup(1);
 }
 
 static void __exit fini(void)
 {
-	init_or_cleanup(0);
+	cleanup(0);
 }
 
 module_init(init);




--===============4959871642504261==
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

_______________________________________________
Kernel-janitors mailing list
Kernel-janitors@lists.osdl.org
https://lists.osdl.org/mailman/listinfo/kernel-janitors

--===============4959871642504261==--
