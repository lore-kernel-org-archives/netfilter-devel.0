From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: ipset: pernet ops must be unregistered last
Date: Tue, 26 Sep 2017 00:44:13 +0200
Message-ID: <20170925224413.24412-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:55980 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934254AbdIYWoF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Sep 2017 18:44:05 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Removing the ipset module leaves a small window where one cpu performs
module removal while another runs a command like 'ipset flush'.

ipset uses net_generic(), unregistering the pernet ops frees this
storage area.

Fix it by first removing the user-visible api handlers and the pernet
ops last.

Fixes: 1785e8f473082 ("netfiler: ipset: Add net namespace for ipset")
Reported-by: Li Shuang <shuali@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/ipset/ip_set_core.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index e495b5e484b1..5ec7740c2088 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -2072,25 +2072,27 @@ static struct pernet_operations ip_set_net_ops = {
 static int __init
 ip_set_init(void)
 {
-	int ret = nfnetlink_subsys_register(&ip_set_netlink_subsys);
+	int ret = register_pernet_subsys(&ip_set_net_ops);
+	if (ret) {
+		pr_err("ip_set: cannot register pernet_subsys.\n");
+		return ret;
+	}
 
+	ret = nfnetlink_subsys_register(&ip_set_netlink_subsys);
 	if (ret != 0) {
 		pr_err("ip_set: cannot register with nfnetlink.\n");
+		unregister_pernet_subsys(&ip_set_net_ops);
 		return ret;
 	}
+
 	ret = nf_register_sockopt(&so_set);
 	if (ret != 0) {
 		pr_err("SO_SET registry failed: %d\n", ret);
 		nfnetlink_subsys_unregister(&ip_set_netlink_subsys);
+		unregister_pernet_subsys(&ip_set_net_ops);
 		return ret;
 	}
-	ret = register_pernet_subsys(&ip_set_net_ops);
-	if (ret) {
-		pr_err("ip_set: cannot register pernet_subsys.\n");
-		nf_unregister_sockopt(&so_set);
-		nfnetlink_subsys_unregister(&ip_set_netlink_subsys);
-		return ret;
-	}
+
 	pr_info("ip_set: protocol %u\n", IPSET_PROTOCOL);
 	return 0;
 }
@@ -2098,9 +2100,10 @@ ip_set_init(void)
 static void __exit
 ip_set_fini(void)
 {
-	unregister_pernet_subsys(&ip_set_net_ops);
-	nf_unregister_sockopt(&so_set);
 	nfnetlink_subsys_unregister(&ip_set_netlink_subsys);
+	nf_unregister_sockopt(&so_set);
+
+	unregister_pernet_subsys(&ip_set_net_ops);
 	pr_debug("these are the famous last words\n");
 }
 
-- 
2.13.5

