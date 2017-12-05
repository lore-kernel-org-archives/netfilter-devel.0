From: Lin Zhang <xiaolou4617@gmail.com>
Subject: [PATCH] net: netfilter: fix coding style
Date: Tue,  5 Dec 2017 15:34:09 +0800
Message-ID: <1512459249-857-1-git-send-email-xiaolou4617@gmail.com>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Lin Zhang <xiaolou4617@gmail.com>
To: pablo@netfilter.org, kadlec@blackhole.kfki.hu, fw@strlen.de,
        davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:42240 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751255AbdLEHet (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 Dec 2017 02:34:49 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I think use variable 'min' instead of number '1024' is better.

Signed-off-by: Lin Zhang <xiaolou4617@gmail.com>
---
 net/netfilter/nf_nat_proto_common.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nf_nat_proto_common.c b/net/netfilter/nf_nat_proto_common.c
index fbce552..e87e683 100644
--- a/net/netfilter/nf_nat_proto_common.c
+++ b/net/netfilter/nf_nat_proto_common.c
@@ -67,7 +67,7 @@ void nf_nat_l4proto_unique_tuple(const struct nf_nat_l3proto *l3proto,
 			}
 		} else {
 			min = 1024;
-			range_size = 65535 - 1024 + 1;
+			range_size = 65535 - min + 1;
 		}
 	} else {
 		min = ntohs(range->min_proto.all);
-- 
1.7.1

