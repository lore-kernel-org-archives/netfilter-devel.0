From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH -stable-3.12] netfilter: fix wrong byte order in nf_ct_seqadj_set internal information
Date: Fri, 13 Dec 2013 19:28:23 +0100
Message-ID: <1386959303-24665-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, stable@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50143 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753289Ab3LMS2e (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Dec 2013 13:28:34 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Phil Oester <kernel@linuxace.com>

[ mainstream commit 23dfe136e2bf8d9ea1095704c535368a9bc721da ]

In commit 41d73ec053d2, sequence number adjustments were moved to a
separate file. Unfortunately, the sequence numbers that are stored
in the nf_ct_seqadj structure are expressed in host byte order. The
necessary ntohl call was removed when the call to adjust_tcp_sequence
was collapsed into nf_ct_seqadj_set. This broke the FTP NAT helper.
Fix it by adding back the byte order conversions.

Reported-by: Dawid Stawiarski <dawid.stawiarski@netart.pl>
Signed-off-by: Phil Oester <kernel@linuxace.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_seqadj.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_seqadj.c b/net/netfilter/nf_conntrack_seqadj.c
index 5f9bfd0..17c1bcb 100644
--- a/net/netfilter/nf_conntrack_seqadj.c
+++ b/net/netfilter/nf_conntrack_seqadj.c
@@ -41,8 +41,8 @@ int nf_ct_seqadj_set(struct nf_conn *ct, enum ip_conntrack_info ctinfo,
 	spin_lock_bh(&ct->lock);
 	this_way = &seqadj->seq[dir];
 	if (this_way->offset_before == this_way->offset_after ||
-	    before(this_way->correction_pos, seq)) {
-		this_way->correction_pos = seq;
+	    before(this_way->correction_pos, ntohl(seq))) {
+		this_way->correction_pos = ntohl(seq);
 		this_way->offset_before	 = this_way->offset_after;
 		this_way->offset_after	+= off;
 	}
-- 
1.7.10.4

