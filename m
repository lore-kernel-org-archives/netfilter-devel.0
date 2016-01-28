From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH] src: netlink_linearize: Fix bug for redirect target
Date: Fri, 29 Jan 2016 01:05:37 +0530
Message-ID: <20160128193537.GA23701@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:32836 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479AbcA1Tfp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Jan 2016 14:35:45 -0500
Received: by mail-pa0-f48.google.com with SMTP id cy9so27874014pac.0
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Jan 2016 11:35:45 -0800 (PST)
Received: from gmail.com ([106.209.40.35])
        by smtp.gmail.com with ESMTPSA id l9sm18267001pfb.29.2016.01.28.11.35.42
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Thu, 28 Jan 2016 11:35:43 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Before this patch,
$ sudo nft --debug=netlink add rule ip nat post ip protocol tcp redirect to 100-200
ip nat post
  [ payload load 1b @ network header + 9 => reg 1 ]
  [ cmp eq reg 1 0x00000006 ]
  [ immediate reg 1 0x00006400 ]
  [ immediate reg 2 0x0000c800 ]
  [ redir proto_min reg 1 proto_max reg 5 ]

<cmdline>:1:1-56: Error: Could not process rule: Invalid argument
add rule ip nat post ip protocol tcp redirect to 100-200
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

After this patch,
$ sudo nft --debug=netlink add rule ip nat post ip protocol tcp redirect to 100-200
ip nat post
  [ payload load 1b @ network header + 9 => reg 1 ]
  [ cmp eq reg 1 0x00000006 ]
  [ immediate reg 1 0x00006400 ]
  [ immediate reg 2 0x0000c800 ]
  [ redir proto_min reg 1 proto_max reg 2 ]

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 src/netlink_linearize.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 7c6ef16..dfe8dca 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -861,17 +861,17 @@ static void netlink_gen_redir_stmt(struct netlink_linearize_ctx *ctx,
 					 pmin_reg);
 			netlink_gen_expr(ctx, stmt->redir.proto->right,
 					 pmax_reg);
-			nftnl_expr_set_u32(nle,
-					      NFTNL_EXPR_REDIR_REG_PROTO_MIN,
-					      pmin_reg);
-			nftnl_expr_set_u32(nle,
-					      NFTNL_EXPR_REDIR_REG_PROTO_MAX,
-					      pmax_reg);
+			netlink_put_register(nle,
+					     NFTNL_EXPR_REDIR_REG_PROTO_MIN,
+					     pmin_reg);
+			netlink_put_register(nle,
+					     NFTNL_EXPR_REDIR_REG_PROTO_MAX,
+					     pmax_reg);
 		} else {
 			netlink_gen_expr(ctx, stmt->redir.proto, pmin_reg);
-			nftnl_expr_set_u32(nle,
-					      NFTNL_EXPR_REDIR_REG_PROTO_MIN,
-					      pmin_reg);
+			netlink_put_register(nle,
+					     NFTNL_EXPR_REDIR_REG_PROTO_MIN,
+					     pmin_reg);
 		}
 	}
 
-- 
1.9.1

