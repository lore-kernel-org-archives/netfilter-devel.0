Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5660B21A42F
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Apr 2025 11:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743593678; cv=none; b=QKrvio6a3Xb2iHRpN1CYoElYrZoPqRnzCWkMKy4rktx3/vDvh70RKB+AHsdwnSxb7gIe2DSoNErHyHoZBJCV9vqFqUtvCozL5CvbQGRGthEFpIJfdtDaLwg0CBBbSvW3AyxQuXSMaUqLcaUQNEgVUruhRV0eSDj7x8KarppQ9iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743593678; c=relaxed/simple;
	bh=/oMv/6uGASWehZYXpNh+BHvAc/0VZQ5Dx4nnzKrdYIE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=uwNbwo3ojsHI78kuYjGvEa01HXXyLpMELXYNFPHzivdyjIJIiroiFOE/+3DTf9ttK2Na116V+VT8/nUxVIQ72TIJLp9KNzWBQKdCB8LqrWouZW14bXJkIZmFwMRoD5BlKf7DoHf/aGDoI0wDzbviYmrQCvFRGvJnKeG4ql+LLa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=PBU8SJ+w; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=J1f9iTGC; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="PBU8SJ+w";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="J1f9iTGC"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 12BDD605B2; Wed,  2 Apr 2025 13:34:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743593672;
	bh=BtYEGUMatC3h0sQF0cGnn0rdM1R9r9hRrSJ+7QJ30y8=;
	h=From:To:Cc:Subject:Date:From;
	b=PBU8SJ+w5SmAA11EFQ5C57SRO8nDsbb7wzel1VVO/3PMjDkkfM8K6WexT7lL2KRYB
	 XtT0GWcWxIIVvJN28USUQHudd80vbJqpzt/dMIqYolF8i6G2y/hL/oY1AhTw0eZnwx
	 /l0M0IvmQzO1u874SUo22oEzkhKG1D34ioesN2w/fdnemlh+M2XMUIUahrkh6eErEm
	 UKIzXaHniIM8b5gQSl/piChNgUiAK1V7gWiez8io5CHv/gOr92JpDN30Whs6/Trwqb
	 IAp/PsB6FDQ5eDMk1ApenZoKxfNKQF8u3n/pvRTPrDaA2oknUepvva4pCRnnTF0HtD
	 waHnVSdZe7RAQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 5DCBA603A6;
	Wed,  2 Apr 2025 13:34:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743593671;
	bh=BtYEGUMatC3h0sQF0cGnn0rdM1R9r9hRrSJ+7QJ30y8=;
	h=From:To:Cc:Subject:Date:From;
	b=J1f9iTGCYC8eOhawvqreeWO8GY1qvzDV3ddUh/XZ/OvaeT1t3h2zuikoo7rlII+JF
	 fXFaHEv4nxbw+5GeGDzz5tRa72aUpzmfj6isNQ59k0dDw2+KNTsKHaV++pRbSSDzxq
	 PhdMek9tV514krBoesl/N9C5M2Q/W/lbeMSwZVvUU5AoMihA6fBSHUSHz+XtzNPlXw
	 3tRSYm1YlADUdKlde0X1qux2De6FgJl3BIHoD6KpxyDED8m0s7XPQgGMK8yazddcKI
	 1zO92MJfHRuCJToDWt5RMrhFHraDv2ZNoJCi0yepB2uCEqHlQrT7dhLuTz9uHclpzH
	 Q0o0O9LGlSPRQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf,v2] netfilter: nf_tables: don't unregister hook when table is dormant
Date: Wed,  2 Apr 2025 13:34:27 +0200
Message-Id: <20250402113427.53530-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

When nf_tables_updchain encounters an error, hook registration needs to
be rolled back.

This should only be done if the hook has been registered, which won't
happen when the table is flagged as dormant (inactive).

Just move the assignment into the registration block.

Reported-by: syzbot+53ed3a6440173ddbf499@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=53ed3a6440173ddbf499
Fixes: b9703ed44ffb ("netfilter: nf_tables: support for adding new devices to an existing netdev chain")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: toggle unregister flag only for netdev basechain.

 net/netfilter/nf_tables_api.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c2df81b7e950..a133e1c175ce 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2839,11 +2839,11 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 			err = nft_netdev_register_hooks(ctx->net, &hook.list);
 			if (err < 0)
 				goto err_hooks;
+
+			unregister = true;
 		}
 	}
 
-	unregister = true;
-
 	if (nla[NFTA_CHAIN_COUNTERS]) {
 		if (!nft_is_base_chain(chain)) {
 			err = -EOPNOTSUPP;
-- 
2.30.2

