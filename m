From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH nft v2] src: evaluate: Show error for fanout without balance
Date: Thu, 7 Apr 2016 22:58:54 +0530
Message-ID: <20160407172854.GA3233@shivani>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:36566 "EHLO
	mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756660AbcDGR3b (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Apr 2016 13:29:31 -0400
Received: by mail-pf0-f182.google.com with SMTP id e128so59473111pfe.3
        for <netfilter-devel@vger.kernel.org>; Thu, 07 Apr 2016 10:29:31 -0700 (PDT)
Received: from shivani ([116.202.34.236])
        by smtp.gmail.com with ESMTPSA id m10sm13530869pfi.32.2016.04.07.10.29.29
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Thu, 07 Apr 2016 10:29:30 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The idea of fanout option is to improve the performance by indexing CPU
ID to map packets to the queues. This is used for load balancing.
Fanout option is not required when there is a single queue specified.

According to iptables, queue balance should be specified in order to use
fanout. Following that, throw an error in nftables if the range of
queues for load balancing is not specified with the fanout option.

After this patch,

$ sudo nft add rule ip filter forward counter queue num 0 fanout
<cmdline>:1:46-46: Error: fanout requires queue num range to be specified
add rule ip filter forward counter queue num 0 fanout
                                             ^

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
Changes in v2:
	Update the description with error that is going to show up

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

