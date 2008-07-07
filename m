From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 01/13: use correct namespace in ip6table_security
Date: Mon,  7 Jul 2008 14:05:16 +0200 (MEST)
Message-ID: <20080707120515.4975.81471.sendpatchset@localhost.localdomain>
References: <20080707120514.4975.88670.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58366 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451AbYGGMFR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Jul 2008 08:05:17 -0400
In-Reply-To: <20080707120514.4975.88670.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

netfilter: use correct namespace in ip6table_security

Signed-off-by: Alexey Dobriyan <adobriyan@parallels.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 1efb97e64956296424507f66dd8af9861f98ad89
tree 4ccfa87e7cea14fc1353b6c8f35ecf4d75527494
parent 4b5a698ef423eebc37cfacc6d3376d6dffd5bf83
author Alexey Dobriyan <adobriyan@parallels.com> Mon, 07 Jul 2008 13:00:15 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 07 Jul 2008 13:00:15 +0200

 net/ipv6/netfilter/ip6table_security.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/netfilter/ip6table_security.c b/net/ipv6/netfilter/ip6table_security.c
index 063a3d9..a07abee 100644
--- a/net/ipv6/netfilter/ip6table_security.c
+++ b/net/ipv6/netfilter/ip6table_security.c
@@ -72,7 +72,7 @@ ip6t_local_in_hook(unsigned int hook,
 		   int (*okfn)(struct sk_buff *))
 {
 	return ip6t_do_table(skb, hook, in, out,
-			     init_net.ipv6.ip6table_security);
+			     nf_local_in_net(in, out)->ipv6.ip6table_security);
 }
 
 static unsigned int
@@ -83,7 +83,7 @@ ip6t_forward_hook(unsigned int hook,
 		  int (*okfn)(struct sk_buff *))
 {
 	return ip6t_do_table(skb, hook, in, out,
-			     init_net.ipv6.ip6table_security);
+			     nf_forward_net(in, out)->ipv6.ip6table_security);
 }
 
 static unsigned int
@@ -95,7 +95,7 @@ ip6t_local_out_hook(unsigned int hook,
 {
 	/* TBD: handle short packets via raw socket */
 	return ip6t_do_table(skb, hook, in, out,
-			     init_net.ipv6.ip6table_security);
+			     nf_local_out_net(in, out)->ipv6.ip6table_security);
 }
 
 static struct nf_hook_ops ip6t_ops[] __read_mostly = {
