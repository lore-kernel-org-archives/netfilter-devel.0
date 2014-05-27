From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nftables PATCH] payload: moderate the expr operation checking
Date: Tue, 27 May 2014 17:04:57 +0200
Message-ID: <1401203097-26180-1-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:44969 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590AbaE0PFn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 May 2014 11:05:43 -0400
Received: by mail-wi0-f173.google.com with SMTP id bs8so1897833wib.0
        for <netfilter-devel@vger.kernel.org>; Tue, 27 May 2014 08:05:40 -0700 (PDT)
Received: from localhost.localdomain (186.169.216.87.static.jazztel.es. [87.216.169.186])
        by mx.google.com with ESMTPSA id rw4sm35643239wjb.44.2014.05.27.08.05.38
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 May 2014 08:05:39 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

When we add this rule:

sudo nft add rule ip test input ip protocol !=3D icmp

If we try to list the rules in the table test, nftables
show this error:

nft: src/payload.c:76: payload_expr_pctx_update: Assertion `expr->op
=3D=3D OP_EQ' failed.

This patch moderates the checking by adding another clause like
the expr operation can be non equal, not always equal.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
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
