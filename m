From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nftables PATCH v2] payload: Relax assert in function payload_expr_pctx_update
Date: Wed, 28 May 2014 11:47:34 +0200
Message-ID: <1401270454-11669-1-git-send-email-alvaroneay@gmail.com>
References: <1401203097-26180-1-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:36066 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbaE1JsS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 May 2014 05:48:18 -0400
Received: by mail-wg0-f49.google.com with SMTP id m15so10970996wgh.32
        for <netfilter-devel@vger.kernel.org>; Wed, 28 May 2014 02:48:17 -0700 (PDT)
Received: from localhost.localdomain (186.169.216.87.static.jazztel.es. [87.216.169.186])
        by mx.google.com with ESMTPSA id q2sm15487867wix.5.2014.05.28.02.48.16
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 May 2014 02:48:16 -0700 (PDT)
In-Reply-To: <1401203097-26180-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

If we add this rule:

sudo nft add rule ip test input ip protocol !=3D icmp

and we try to list the rules in the table test, nftables
show this error:

nft: src/payload.c:76: payload_expr_pctx_update: Assertion `expr->op
=3D=3D OP_EQ' failed.

This patch relaxes this assert adding another clause like
the expr operation can be non equal, not only equal.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
[changes in v2]
* I have rewritten the title and the description of this patch

 src/payload.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/payload.c b/src/payload.c
index a1785a5..b9ad6f7 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -73,7 +73,7 @@ static void payload_expr_pctx_update(struct proto_ctx=
 *ctx,
 	if (!(left->flags & EXPR_F_PROTOCOL))
 		return;
=20
-	assert(expr->op =3D=3D OP_EQ);
+	assert(expr->op =3D=3D OP_EQ || expr->op =3D=3D OP_NEQ);
 	base =3D ctx->protocol[left->payload.base].desc;
 	desc =3D proto_find_upper(base, mpz_get_uint32(right->value));
=20
--=20
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
