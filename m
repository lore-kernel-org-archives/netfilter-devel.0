From: Alexey Dobriyan <adobriyan@parallels.com>
Subject: [PATCH] netfilter: netnsize ip6table_security
Date: Tue, 10 Jun 2008 20:48:34 +0400
Message-ID: <200806102048.34447.adobriyan@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, James Morris <jmorris@namei.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:29956 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751669AbYFJQsx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Jun 2008 12:48:53 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Alexey Dobriyan <adobriyan@parallels.com>
---

 not sure why this code in IPv4 version but not in IPv6

 net/ipv6/netfilter/ip6table_security.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

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
