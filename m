From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH iptables] libxt_sctp: fix array out of range in print_chunk
Date: Fri, 10 Nov 2017 11:49:05 +0100
Message-ID: <20171110104905.9205-1-nicolas.dichtel@6wind.com>
Cc: netfilter-devel@vger.kernel.org,
        huaibin Wang <huaibin.wang@6wind.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from host.76.145.23.62.rev.coltfrance.com ([62.23.145.76]:54646 "EHLO
        proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752405AbdKJK4A (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Nov 2017 05:56:00 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: huaibin Wang <huaibin.wang@6wind.com>

For chunk type ASCONF, ASCONF_ACK and FORWARD_TSN, sctp_chunk_names[].chunk_type
is not equal to the corresponding index in sctp_chunk_names[]. Using this field
leads to a segmentation fault (index out of range).

Example
$ iptables -A INPUT -p sctp --chunk-type all ASCONF,ASCONF_ACK,FORWARD_TSN -j ACCEPT
$ iptables -L
Chain INPUT (policy ACCEPT)
target     prot opt source               destination
Segmentation fault

Signed-off-by: huaibin Wang <huaibin.wang@6wind.com>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 extensions/libxt_sctp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/libxt_sctp.c b/extensions/libxt_sctp.c
index df1936be8b83..140de2653b1e 100644
--- a/extensions/libxt_sctp.c
+++ b/extensions/libxt_sctp.c
@@ -370,7 +370,7 @@ print_chunk(uint32_t chunknum, int numeric)
 
 		for (i = 0; i < ARRAY_SIZE(sctp_chunk_names); ++i)
 			if (sctp_chunk_names[i].chunk_type == chunknum)
-				printf("%s", sctp_chunk_names[chunknum].name);
+				printf("%s", sctp_chunk_names[i].name);
 	}
 }
 
-- 
2.13.2

