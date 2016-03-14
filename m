From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v3 2/3] netfilter: labels: don't emit ct event if labels are unchanged
Date: Mon, 14 Mar 2016 14:46:33 +0100
Message-ID: <1457963194-19132-3-git-send-email-fw@strlen.de>
References: <1457963194-19132-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:52683 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932123AbcCNNqR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Mar 2016 09:46:17 -0400
In-Reply-To: <1457963194-19132-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

make the replace function only send a ctnetlink event if the contents
of the new set is different.

Otherwise 'ct label set ct label | bar'

will cause netlink event storm since we "replace" labels for each packet.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 No changes since last version.

 net/netfilter/nf_conntrack_labels.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_conntrack_labels.c b/net/netfilter/nf_conntrack_labels.c
index 3a30900..bd7f26b 100644
--- a/net/netfilter/nf_conntrack_labels.c
+++ b/net/netfilter/nf_conntrack_labels.c
@@ -33,14 +33,18 @@ int nf_connlabel_set(struct nf_conn *ct, u16 bit)
 }
 EXPORT_SYMBOL_GPL(nf_connlabel_set);
 
-static void replace_u32(u32 *address, u32 mask, u32 new)
+static int replace_u32(u32 *address, u32 mask, u32 new)
 {
 	u32 old, tmp;
 
 	do {
 		old = *address;
 		tmp = (old & mask) ^ new;
+		if (old == tmp)
+			return 0;
 	} while (cmpxchg(address, old, tmp) != old);
+
+	return 1;
 }
 
 int nf_connlabels_replace(struct nf_conn *ct,
@@ -49,6 +53,7 @@ int nf_connlabels_replace(struct nf_conn *ct,
 {
 	struct nf_conn_labels *labels;
 	unsigned int size, i;
+	int changed = 0;
 	u32 *dst;
 
 	labels = nf_ct_labels_find(ct);
@@ -60,16 +65,15 @@ int nf_connlabels_replace(struct nf_conn *ct,
 		words32 = size / sizeof(u32);
 
 	dst = (u32 *) labels->bits;
-	if (words32) {
-		for (i = 0; i < words32; i++)
-			replace_u32(&dst[i], mask ? ~mask[i] : 0, data[i]);
-	}
+	for (i = 0; i < words32; i++)
+		changed |= replace_u32(&dst[i], mask ? ~mask[i] : 0, data[i]);
 
 	size /= sizeof(u32);
 	for (i = words32; i < size; i++) /* pad */
 		replace_u32(&dst[i], 0, 0);
 
-	nf_conntrack_event_cache(IPCT_LABEL, ct);
+	if (changed)
+		nf_conntrack_event_cache(IPCT_LABEL, ct);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(nf_connlabels_replace);
-- 
2.4.10

