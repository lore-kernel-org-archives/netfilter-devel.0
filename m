From: Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH net-next] netfilter: remove dead code
Date: Mon, 30 Dec 2013 17:16:08 -0800
Message-ID: <20131230171608.211bac4f@nehalam.linuxnetplumber.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:36799 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932365Ab3LaBQO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Dec 2013 20:16:14 -0500
Received: by mail-pb0-f50.google.com with SMTP id rr13so12135585pbb.37
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Dec 2013 17:16:14 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following code is not used in current upstream code.
Some of this seems to be old hooks, other might be used by some
out of tree module (which I don't care about breaking), and
the need_ipv4_conntrack was used by old NAT code but no longer
called.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
  

--- a/net/netfilter/nf_conntrack_core.c	2013-12-30 15:37:28.704768854 -0800
+++ b/net/netfilter/nf_conntrack_core.c	2013-12-30 17:03:14.891304019 -0800
@@ -60,12 +60,6 @@ int (*nfnetlink_parse_nat_setup_hook)(st
 				      const struct nlattr *attr) __read_mostly;
 EXPORT_SYMBOL_GPL(nfnetlink_parse_nat_setup_hook);
 
-int (*nf_nat_seq_adjust_hook)(struct sk_buff *skb,
-			      struct nf_conn *ct,
-			      enum ip_conntrack_info ctinfo,
-			      unsigned int protoff);
-EXPORT_SYMBOL_GPL(nf_nat_seq_adjust_hook);
-
 DEFINE_SPINLOCK(nf_conntrack_lock);
 EXPORT_SYMBOL_GPL(nf_conntrack_lock);
 
@@ -361,15 +355,6 @@ begin:
 	return NULL;
 }
 
-struct nf_conntrack_tuple_hash *
-__nf_conntrack_find(struct net *net, u16 zone,
-		    const struct nf_conntrack_tuple *tuple)
-{
-	return ____nf_conntrack_find(net, zone, tuple,
-				     hash_conntrack_raw(tuple, zone));
-}
-EXPORT_SYMBOL_GPL(__nf_conntrack_find);
-
 /* Find a connection corresponding to a tuple. */
 static struct nf_conntrack_tuple_hash *
 __nf_conntrack_find_get(struct net *net, u16 zone,
--- a/include/net/netfilter/nf_conntrack_l3proto.h	2013-12-30 17:02:46.135751699 -0800
+++ b/include/net/netfilter/nf_conntrack_l3proto.h	2013-12-30 17:03:14.891304019 -0800
@@ -87,7 +87,6 @@ int nf_ct_l3proto_register(struct nf_con
 void nf_ct_l3proto_unregister(struct nf_conntrack_l3proto *proto);
 
 struct nf_conntrack_l3proto *nf_ct_l3proto_find_get(u_int16_t l3proto);
-void nf_ct_l3proto_put(struct nf_conntrack_l3proto *p);
 
 /* Existing built-in protocols */
 extern struct nf_conntrack_l3proto nf_conntrack_l3proto_generic;
--- a/net/netfilter/nf_conntrack_proto.c	2013-12-30 17:02:46.135751699 -0800
+++ b/net/netfilter/nf_conntrack_proto.c	2013-12-30 17:03:14.891304019 -0800
@@ -92,12 +92,6 @@ nf_ct_l3proto_find_get(u_int16_t l3proto
 }
 EXPORT_SYMBOL_GPL(nf_ct_l3proto_find_get);
 
-void nf_ct_l3proto_put(struct nf_conntrack_l3proto *p)
-{
-	module_put(p->me);
-}
-EXPORT_SYMBOL_GPL(nf_ct_l3proto_put);
-
 int
 nf_ct_l3proto_try_module_get(unsigned short l3proto)
 {
--- a/include/net/netfilter/ipv4/nf_conntrack_ipv4.h	2013-12-30 15:37:28.704768854 -0800
+++ b/include/net/netfilter/ipv4/nf_conntrack_ipv4.h	2013-12-30 17:05:52.272854228 -0800
@@ -19,6 +19,4 @@ extern struct nf_conntrack_l4proto nf_co
 int nf_conntrack_ipv4_compat_init(void);
 void nf_conntrack_ipv4_compat_fini(void);
 
-void need_ipv4_conntrack(void);
-
 #endif /*_NF_CONNTRACK_IPV4_H*/
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c	2013-12-30 15:37:28.704768854 -0800
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c	2013-12-30 17:07:29.067347857 -0800
@@ -548,9 +548,3 @@ static void __exit nf_conntrack_l3proto_
 
 module_init(nf_conntrack_l3proto_ipv4_init);
 module_exit(nf_conntrack_l3proto_ipv4_fini);
-
-void need_ipv4_conntrack(void)
-{
-	return;
-}
-EXPORT_SYMBOL_GPL(need_ipv4_conntrack);
