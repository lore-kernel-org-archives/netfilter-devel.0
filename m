From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nft PATCH 1/4 v2] payload: generate dependency in the appropriate byteorder
Date: Fri, 26 Sep 2014 18:50:52 +0200
Message-ID: <1411750255-7663-1-git-send-email-alvaroneay@gmail.com>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:34050 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872AbaIZQun (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Sep 2014 12:50:43 -0400
Received: by mail-wi0-f179.google.com with SMTP id d1so12010408wiv.12
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Sep 2014 09:50:42 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If we add a dependency, the constant expression on the right
hand side must be represented in the appropriate order.

Example without this patch:

  nft add rule bridge filter input reject with icmp-host-unreach --debug netlink

  [ payload load 2b @ link header + 12 => reg 1 ]
  [ cmp eq reg 1 0x00000800 ]
  [ reject type 0 code 1 ]

When we create the payload expression we have the right value in host endian but
this has to be in big endian.

With this patch, if we add the same rule:

  nft add rule bridge filter input reject with icmp-host-unreach --debug netlink

  [ payload load 2b @ link header + 12 => reg 1 ]
  [ cmp eq reg 1 0x00000008 ]
  [ reject type 0 code 1 ]

The new dependency is converted to big endian.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
[Changes in v2]
* Added a example with the problem and the fix in the description

 src/payload.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/src/payload.c b/src/payload.c
index 1eee4e0..a3bbe51 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -216,8 +216,7 @@ int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
 		left = payload_expr_alloc(&expr->location, desc, desc->protocol_key);
 
 	right = constant_expr_alloc(&expr->location, tmpl->dtype,
-				    BYTEORDER_HOST_ENDIAN,
-				    tmpl->len,
+				    tmpl->dtype->byteorder, tmpl->len,
 				    constant_data_ptr(protocol, tmpl->len));
 
 	dep = relational_expr_alloc(&expr->location, OP_EQ, left, right);
-- 
1.7.10.4

