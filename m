From: Alvaro Neira <alvaroneay@gmail.com>
Subject: [libnftables PATCH] chain: json: fix family and table error
Date: Thu, 18 Jul 2013 13:36:01 +0200
Message-ID: <20130718113601.7544.7115.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:42038 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703Ab3GRLgZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Jul 2013 07:36:25 -0400
Received: by mail-wi0-f182.google.com with SMTP id m6so3054085wiv.15
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Jul 2013 04:36:24 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

In (74ccff7 chain: json: use string to identify policy), the json suppo=
rt for chain was unintentionally
swapping the table name and the family.


Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 0 files changed

diff --git a/src/chain.c b/src/chain.c
index 0a0e688..3c73511 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -746,8 +746,8 @@ static int nft_chain_snprintf_json(char *buf, size_=
t size, struct nft_chain *c)
 				"\"table\": \"%s\","
 				"\"use\": %d",
 			c->name, c->handle, c->bytes, c->packets,
-			NFT_CHAIN_JSON_VERSION, c->table,
-			nft_family2str(c->family), c->use);
+			NFT_CHAIN_JSON_VERSION, nft_family2str(c->family),
+			c->table, c->use);
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
=20
 	if (c->flags & (1 << NFT_CHAIN_ATTR_HOOKNUM)) {

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
