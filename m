From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf-next:master 10/20]
 net/netfilter/nf_conntrack_standalone.c:566:2: error:
 'nf_ct_netfilter_header' undeclared
Date: Wed, 23 Jan 2013 15:15:22 +0100
Message-ID: <20130123141522.GA17264@1984>
References: <50ffea92.W3YbcwYaFKlgs8cR%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="2oS5YaxWCcQjTEyO"
Cc: Gao feng <gaofeng@cn.fujitsu.com>, netfilter-devel@vger.kernel.org
To: kbuild test robot <fengguang.wu@intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38252 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755710Ab3AWOP1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jan 2013 09:15:27 -0500
Content-Disposition: inline
In-Reply-To: <50ffea92.W3YbcwYaFKlgs8cR%fengguang.wu@intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 23, 2013 at 09:50:10PM +0800, kbuild test robot wrote:
> tree:   git://150.214.188.80/nf-next master
> head:   c296bb4d5d417d466c9bcc8afef68a3db5449a64
> commit: f94161c1bbdf7af11729cf106b4452f2432448e0 [10/20] netfilter: nf_conntrack: move initialization out of pernet operations
> config: x86_64-randconfig-x974 (attached as .config)
> 
> All error/warnings:
> 
>    net/netfilter/nf_conntrack_standalone.c: In function 'nf_conntrack_standalone_init':
> >> net/netfilter/nf_conntrack_standalone.c:566:2: error: 'nf_ct_netfilter_header' undeclared (first use in this function)
>    net/netfilter/nf_conntrack_standalone.c:566:2: note: each undeclared identifier is reported only once for each function it appears in
> >> net/netfilter/nf_conntrack_standalone.c:567:41: error: 'nf_ct_netfilter_table' undeclared (first use in this function)
>    net/netfilter/nf_conntrack_standalone.c: In function 'nf_conntrack_standalone_fini':
>    net/netfilter/nf_conntrack_standalone.c:591:30: error: 'nf_ct_netfilter_header' undeclared (first use in this function)

Patch attached to fix this. Thanks kbuild test robot.

--2oS5YaxWCcQjTEyO
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-netfilter-nf_conntrack-fix-compilation-if-sysctl-are.patch"

>From 5f9f946b39bff31bc9a4a8be18cef3354d3382ae Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Wed, 23 Jan 2013 15:12:25 +0100
Subject: [PATCH] netfilter: nf_conntrack: fix compilation if sysctl are
 disabled

In (f94161c netfilter: nf_conntrack: move initialization out of pernet
operations), some ifdefs were missing for sysctl dependent code.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_standalone.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 725bf04..7936bf7 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -563,10 +563,14 @@ static int __init nf_conntrack_standalone_init(void)
 	if (ret < 0)
 		goto out_start;
 
+#ifdef CONFIG_SYSCTL
 	nf_ct_netfilter_header =
 		register_net_sysctl(&init_net, "net", nf_ct_netfilter_table);
-	if (!nf_ct_netfilter_header)
+	if (!nf_ct_netfilter_header) {
+		pr_err("nf_conntrack: can't register to sysctl.\n");
 		goto out_sysctl;
+	}
+#endif
 
 	ret = register_pernet_subsys(&nf_conntrack_net_ops);
 	if (ret < 0)
@@ -576,9 +580,10 @@ static int __init nf_conntrack_standalone_init(void)
 	return 0;
 
 out_pernet:
+#ifdef CONFIG_SYSCTL
 	unregister_net_sysctl_table(nf_ct_netfilter_header);
 out_sysctl:
-	pr_err("nf_conntrack: can't register to sysctl.\n");
+#endif
 	nf_conntrack_cleanup_end();
 out_start:
 	return ret;
@@ -588,7 +593,9 @@ static void __exit nf_conntrack_standalone_fini(void)
 {
 	nf_conntrack_cleanup_start();
 	unregister_pernet_subsys(&nf_conntrack_net_ops);
+#ifdef CONFIG_SYSCTL
 	unregister_net_sysctl_table(nf_ct_netfilter_header);
+#endif
 	nf_conntrack_cleanup_end();
 }
 
-- 
1.7.10.4


--2oS5YaxWCcQjTEyO--
