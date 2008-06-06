From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 06/11: nf_conntrack_extend: use krealloc() in nf_conntrack_extend.c V2
Date: Fri,  6 Jun 2008 17:17:54 +0200 (MEST)
Message-ID: <20080606151752.25286.35255.sendpatchset@localhost.localdomain>
References: <20080606151737.25286.54547.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48146 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758045AbYFFPR4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Jun 2008 11:17:56 -0400
In-Reply-To: <20080606151737.25286.54547.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

netfilter: nf_conntrack_extend: use krealloc() in nf_conntrack_extend.c V2

The ksize() API is going away because it is being abused and it doesn't even
work consistenly across different allocators. Therefore, convert
net/netfilter/nf_conntrack_extend.c to use krealloc().

Cc: <netfilter-devel@vger.kernel.org>
Cc: <netdev@vger.kernel.org>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit c6bf7199df1514a3f82c2c6a3d925c5966798141
tree 64365998231e0ae71aa95ff478bd185ea22af3d5
parent 90faf09757063e4e45aba7124977ef5b82cd5223
author Pekka Enberg <penberg@cs.helsinki.fi> Fri, 06 Jun 2008 17:11:04 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 06 Jun 2008 17:11:04 +0200

 net/netfilter/nf_conntrack_extend.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_conntrack_extend.c b/net/netfilter/nf_conntrack_extend.c
index bcc19fa..ba1c491 100644
--- a/net/netfilter/nf_conntrack_extend.c
+++ b/net/netfilter/nf_conntrack_extend.c
@@ -88,13 +88,11 @@ void *__nf_ct_ext_add(struct nf_conn *ct, enum nf_ct_ext_id id, gfp_t gfp)
 	newlen = newoff + t->len;
 	rcu_read_unlock();
 
-	if (newlen >= ksize(ct->ext)) {
-		new = kmalloc(newlen, gfp);
-		if (!new)
-			return NULL;
-
-		memcpy(new, ct->ext, ct->ext->len);
+	new = krealloc(ct->ext, newlen, gfp);
+	if (!new)
+		return NULL;
 
+	if (new != ct->ext) {
 		for (i = 0; i < NF_CT_EXT_NUM; i++) {
 			if (!nf_ct_ext_exist(ct, i))
 				continue;
