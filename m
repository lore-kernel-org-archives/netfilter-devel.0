From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 28/69]: more sparse fixes
Date: Wed, 30 Jan 2008 21:17:37 +0100 (MET)
Message-ID: <20080130201735.29874.22059.sendpatchset@localhost.localdomain>
References: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60716 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764076AbYA3URj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:17:39 -0500
In-Reply-To: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: more sparse fixes

Some lock annotations, and make initializers static.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit cba4c67b58eee186ca8ff3e4588a01406d96a886
tree ed40d2d70fccb6aa1cb3c520ffc39b5a517b0018
parent a56984be5dde4c3ab631f9c66e15c1fa7a12f17e
author Stephen Hemminger <shemminger@vyatta.com> Tue, 29 Jan 2008 16:22:06 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 30 Jan 2008 15:04:19 +0100

 net/ipv4/netfilter/nf_nat_proto_gre.c |    4 ++--
 net/netfilter/xt_hashlimit.c          |    2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_proto_gre.c b/net/ipv4/netfilter/nf_nat_proto_gre.c
index 9fa272e..c9dbd55 100644
--- a/net/ipv4/netfilter/nf_nat_proto_gre.c
+++ b/net/ipv4/netfilter/nf_nat_proto_gre.c
@@ -148,12 +148,12 @@ static const struct nf_nat_protocol gre = {
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
diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index d479ca9..b224b8f 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -624,6 +624,7 @@ static struct xt_match hashlimit_mt_reg[] __read_mostly = {
 
 /* PROC stuff */
 static void *dl_seq_start(struct seq_file *s, loff_t *pos)
+	__acquires(htable->lock)
 {
 	struct proc_dir_entry *pde = s->private;
 	struct xt_hashlimit_htable *htable = pde->data;
@@ -656,6 +657,7 @@ static void *dl_seq_next(struct seq_file *s, void *v, loff_t *pos)
 }
 
 static void dl_seq_stop(struct seq_file *s, void *v)
+	__releases(htable->lock)
 {
 	struct proc_dir_entry *pde = s->private;
 	struct xt_hashlimit_htable *htable = pde->data;
