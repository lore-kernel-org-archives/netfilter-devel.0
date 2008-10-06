From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] TPROXY cleanups
Date: Mon, 6 Oct 2008 16:19:44 +0400
Message-ID: <20081006121943.GA13547@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: hidden@sch.bme.hu, netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:48859 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842AbYJFMR1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Oct 2008 08:17:27 -0400
Received: by fg-out-1718.google.com with SMTP id 19so1917216fgg.17
        for <netfilter-devel@vger.kernel.org>; Mon, 06 Oct 2008 05:17:25 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

* drop version.h -- unneeded and file will be needlessly rebuilt.
* make tproxy_core unloadable
* use "in" device outright, -- target and match are only in PRE_ROUTING,
  so should avoid dereference.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 net/netfilter/nf_tproxy_core.c |    5 ++++-
 net/netfilter/xt_TPROXY.c      |    2 +-
 net/netfilter/xt_socket.c      |    2 +-
 3 files changed, 6 insertions(+), 3 deletions(-)

--- a/net/netfilter/nf_tproxy_core.c
+++ b/net/netfilter/nf_tproxy_core.c
@@ -10,7 +10,6 @@
  *
  */
 
-#include <linux/version.h>
 #include <linux/module.h>
 
 #include <linux/net.h>
@@ -89,7 +88,11 @@ static int __init nf_tproxy_init(void)
 	return 0;
 }
 
+static void __exit nf_tproxy_exit(void)
+{
+}
 module_init(nf_tproxy_init);
+module_exit(nf_tproxy_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Krisztian Kovacs");
--- a/net/netfilter/xt_TPROXY.c
+++ b/net/netfilter/xt_TPROXY.c
@@ -41,7 +41,7 @@ tproxy_tg(struct sk_buff *skb,
 	if (hp == NULL)
 		return NF_DROP;
 
-	sk = nf_tproxy_get_sock_v4(dev_net(skb->dev), iph->protocol,
+	sk = nf_tproxy_get_sock_v4(dev_net(in), iph->protocol,
 				   iph->saddr, tgi->laddr ? tgi->laddr : iph->daddr,
 				   hp->source, tgi->lport ? tgi->lport : hp->dest,
 				   in, true);
--- a/net/netfilter/xt_socket.c
+++ b/net/netfilter/xt_socket.c
@@ -145,7 +145,7 @@ socket_mt(const struct sk_buff *skb,
 	}
 #endif
 
-	sk = nf_tproxy_get_sock_v4(dev_net(skb->dev), protocol,
+	sk = nf_tproxy_get_sock_v4(dev_net(in), protocol,
 				   saddr, daddr, sport, dport, in, false);
 	if (sk != NULL) {
 		bool wildcard = (inet_sk(sk)->rcv_saddr == 0);
