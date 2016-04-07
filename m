From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH nft] src: evaluate: Show error for fanout without balance
Date: Thu, 7 Apr 2016 15:06:40 +0530
Message-ID: <20160407093640.GA5034@shivani>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:33036 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755206AbcDGJhS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Apr 2016 05:37:18 -0400
Received: by mail-pf0-f193.google.com with SMTP id e190so6719155pfe.0
        for <netfilter-devel@vger.kernel.org>; Thu, 07 Apr 2016 02:37:18 -0700 (PDT)
Received: from shivani ([116.202.34.78])
        by smtp.gmail.com with ESMTPSA id zu10sm10725157pab.31.2016.04.07.02.37.15
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Thu, 07 Apr 2016 02:37:16 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The idea of fanout option is to improve the performance by indexing CPU
ID to map packets to the queues. This is used for load balancing.
Fanout option is not required when there is a single queue specified.

According to iptables, queue balance should be specified in order to use
fanout, following that, throw an error in nftables if the range of
queues for load balancing is not specified with the fanout option.

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 src/evaluate.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index 473f014..f3fe13d 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2000,6 +2000,11 @@ static int stmt_evaluate_queue(struct eval_ctx *ctx, struct stmt *stmt)
 		if (!expr_is_constant(stmt->queue.queue))
 			return expr_error(ctx->msgs, stmt->queue.queue,
 					  "queue number is not constant");
+		if (stmt->queue.queue->ops->type != EXPR_RANGE &&
+		    (stmt->queue.flags & NFT_QUEUE_FLAG_CPU_FANOUT))
+			return expr_error(ctx->msgs, stmt->queue.queue,
+					  "fanout requires queue num range"
+					  " to be specified");
 	}
 	return 0;
 }
-- 
1.9.1

