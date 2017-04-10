From: gfree.wind@foxmail.com
Subject: [PATCH nf 1/1] netfilter: seqadj: Fix possible non-linear data access for TCP header
Date: Mon, 10 Apr 2017 18:36:03 +0800
Message-ID: <1491820563-98023-1-git-send-email-gfree.wind@foxmail.com>
Cc: Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbgbr2.qq.com ([54.207.22.56]:36791 "EHLO smtpbgbr2.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753017AbdDJKgT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Apr 2017 06:36:19 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

The current call path of nf_ct_tcp_seqadj_set is the following.

nfqnl_recv_verdict->ctnetlink_glue_hook->ctnetlink_glue_seqadj
->nf_ct_tcp_seqadj_set.

It couldn't make sure the TCP header is in the linear data part.
So use the skb_header_pointer instead of the current codes.

BTW, the nf_ct_tcp_seqadj_set is one external function of netfilter
which works in the network layer, it should not assume the transport
header is in the linear data.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 net/netfilter/nf_conntrack_seqadj.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_seqadj.c b/net/netfilter/nf_conntrack_seqadj.c
index ef7063e..80394ab 100644
--- a/net/netfilter/nf_conntrack_seqadj.c
+++ b/net/netfilter/nf_conntrack_seqadj.c
@@ -61,11 +61,14 @@ void nf_ct_tcp_seqadj_set(struct sk_buff *skb,
 			  s32 off)
 {
 	const struct tcphdr *th;
+	struct tcphdr tcph;
 
 	if (nf_ct_protonum(ct) != IPPROTO_TCP)
 		return;
 
-	th = (struct tcphdr *)(skb_network_header(skb) + ip_hdrlen(skb));
+	th = skb_header_pointer(skb, ip_hdrlen(skb), sizeof(tcph), &tcph);
+	if (!th)
+		return;
 	nf_ct_seqadj_set(ct, ctinfo, th->seq, off);
 }
 EXPORT_SYMBOL_GPL(nf_ct_tcp_seqadj_set);
-- 
1.9.1




