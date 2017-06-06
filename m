From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH] src: Remove expire information from list stateless ruleset.
Date: Tue, 6 Jun 2017 11:55:40 +0530
Message-ID: <59364aea.86c6620a.a5511.685a@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:34728 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750953AbdFFGZx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Jun 2017 02:25:53 -0400
Received: by mail-pf0-f193.google.com with SMTP id w69so23360206pfk.1
        for <netfilter-devel@vger.kernel.org>; Mon, 05 Jun 2017 23:25:52 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

As expires is stateful information. This patch removes expire
information from list stateless ruleset. With nft -s option, the
ruleset will be as following.

table ip firewall {
        set host {
                type ipv4_addr
                flags timeout
                elements = { 10.0.0.2 timeout 10m }
        }
}

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 src/expression.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/expression.c b/src/expression.c
index 55dd391..4fef830 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -962,7 +962,7 @@ static void set_elem_expr_print(const struct expr *expr)
 		printf(" timeout ");
 		time_print(expr->timeout / 1000);
 	}
-	if (expr->expiration) {
+	if (!stateless_output && expr->expiration) {
 		printf(" expires ");
 		time_print(expr->expiration / 1000);
 	}
-- 
2.9.4

