From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH v2] netfilter: seqadj: print the host byte order ack seq
Date: Mon, 29 Dec 2014 16:22:11 +0800
Message-ID: <1419841331-21299-1-git-send-email-gaofeng@cn.fujitsu.com>
References: <1419500829-9523-1-git-send-email-gaofeng@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Gao feng <gaofeng@cn.fujitsu.com>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:40801 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751596AbaL2IWM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 29 Dec 2014 03:22:12 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sBT8LfvP030593
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Dec 2014 16:21:41 +0800
In-Reply-To: <1419500829-9523-1-git-send-email-gaofeng@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

new_start_seq and new_end_seq are network byte order,
print the host byte order in debug message and print
seq number as the type of unsigned int.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 net/netfilter/nf_conntrack_seqadj.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_seqadj.c b/net/netfilter/nf_conntrack_seqadj.c
index f6e2ae9..ce3e840c8 100644
--- a/net/netfilter/nf_conntrack_seqadj.c
+++ b/net/netfilter/nf_conntrack_seqadj.c
@@ -98,9 +98,9 @@ static void nf_ct_sack_block_adjust(struct sk_buff *skb,
 			new_end_seq = htonl(ntohl(sack->end_seq) -
 				      seq->offset_before);
 
-		pr_debug("sack_adjust: start_seq: %d->%d, end_seq: %d->%d\n",
-			 ntohl(sack->start_seq), new_start_seq,
-			 ntohl(sack->end_seq), new_end_seq);
+		pr_debug("sack_adjust: start_seq: %u->%u, end_seq: %u->%u\n",
+			 ntohl(sack->start_seq), ntohl(new_start_seq),
+			 ntohl(sack->end_seq), ntohl(new_end_seq));
 
 		inet_proto_csum_replace4(&tcph->check, skb,
 					 sack->start_seq, new_start_seq, 0);
-- 
2.1.0

