From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH] netfilter: seqadj: print the host byte order ack seq
Date: Thu, 25 Dec 2014 17:47:09 +0800
Message-ID: <1419500829-9523-1-git-send-email-gaofeng@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Gao feng <gaofeng@cn.fujitsu.com>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:12596 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751637AbaLYJrU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Dec 2014 04:47:20 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sBP9kn1p019146
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Dec 2014 17:46:49 +0800
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

new_start_seq and new_end_seq are network byte order,
print the host byte order in debug message.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 net/netfilter/nf_conntrack_seqadj.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_seqadj.c b/net/netfilter/nf_conntrack_seqadj.c
index f6e2ae9..6e278e4 100644
--- a/net/netfilter/nf_conntrack_seqadj.c
+++ b/net/netfilter/nf_conntrack_seqadj.c
@@ -99,8 +99,8 @@ static void nf_ct_sack_block_adjust(struct sk_buff *skb,
 				      seq->offset_before);
 
 		pr_debug("sack_adjust: start_seq: %d->%d, end_seq: %d->%d\n",
-			 ntohl(sack->start_seq), new_start_seq,
-			 ntohl(sack->end_seq), new_end_seq);
+			 ntohl(sack->start_seq), ntohl(new_start_seq),
+			 ntohl(sack->end_seq), ntohl(new_end_seq));
 
 		inet_proto_csum_replace4(&tcph->check, skb,
 					 sack->start_seq, new_start_seq, 0);
-- 
2.1.0

