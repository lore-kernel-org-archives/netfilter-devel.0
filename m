From: Stephen Hemminger <shemminger@vyatta.com>
Subject: [PATCH 7/8] netfilter: more spase fixes
Date: Thu, 24 Jan 2008 10:15:43 -0800
Message-ID: <20080124181628.468442092@vyatta.com>
References: <20080124181536.446214111@vyatta.com>
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.vyatta.com ([216.93.170.194]:48247 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753886AbYAXSYV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jan 2008 13:24:21 -0500
Content-Disposition: inline; filename=nf-yms.patch
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Some lock annotations, and make initializers static.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>


--- a/net/netfilter/xt_hashlimit.c	2008-01-24 10:10:46.000000000 -0800
+++ b/net/netfilter/xt_hashlimit.c	2008-01-24 10:12:30.000000000 -0800
@@ -624,6 +624,7 @@ static struct xt_match hashlimit_mt_reg[
 
 /* PROC stuff */
 static void *dl_seq_start(struct seq_file *s, loff_t *pos)
+	__acquires(htable->lock)
 {
 	struct proc_dir_entry *pde = s->private;
 	struct xt_hashlimit_htable *htable = pde->data;
@@ -656,6 +657,7 @@ static void *dl_seq_next(struct seq_file
 }
 
 static void dl_seq_stop(struct seq_file *s, void *v)
+	__releases(htable->lock)
 {
 	struct proc_dir_entry *pde = s->private;
 	struct xt_hashlimit_htable *htable = pde->data;
--- a/net/ipv4/netfilter/nf_nat_proto_gre.c	2008-01-24 10:10:46.000000000 -0800
+++ b/net/ipv4/netfilter/nf_nat_proto_gre.c	2008-01-24 10:12:30.000000000 -0800
@@ -148,12 +148,12 @@ static const struct nf_nat_protocol gre 
 #endif
 };
 
-int __init nf_nat_proto_gre_init(void)
+static int __init nf_nat_proto_gre_init(void)
 {
 	return nf_nat_protocol_register(&gre);
 }
 
-void __exit nf_nat_proto_gre_fini(void)
+static void __exit nf_nat_proto_gre_fini(void)
 {
 	nf_nat_protocol_unregister(&gre);
 }

-- 
Stephen Hemminger <stephen.hemminger@vyatta.com>

