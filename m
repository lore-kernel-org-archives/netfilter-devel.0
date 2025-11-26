Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78375346795;
	Wed, 26 Nov 2025 20:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764190600; cv=none; b=i4INchFekmsl4cD9wfQujpi2AT+bk2FdYqhsnibcTrZ5At4hy6viEXM9TwIy+yVyEAQw5vnuU16vZYKvJoLc2+5USbtYFCEaw7nmnuboCJZf1Whk3+0PT2q02S5hUngIO7RuJYveaDbh2EdPz51G1jIPui0upEExjqlBn91Z6pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764190600; c=relaxed/simple;
	bh=mHVKL7B/Pck2eEHywj3NZ8XFvqieAfffjQY/J+4IKTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WJNAeQJ0AbelXpRvRntbkp2KXcwq8gUd0VvuY8fRsgIfzCwDFg3UHqv28CtajAcLOypZmu14u/Ab3LA/0qPxDodCcKitp+ChkfHMqZcs02knPIHixTdiU2JfeYdJBoLET2pXKtxN4fmwzCWAleOUfS6GXMvLuL3BI6pEhrU793c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=OtgKVBvv; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="OtgKVBvv"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 7AD4660276;
	Wed, 26 Nov 2025 21:56:36 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1764190596;
	bh=1ho8PDs+OBgoNdLqkpyzC6a6MIOXx3i+Lj4/KrNlo/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OtgKVBvvKWPyRbed2wIqs2fjGIMV5XUkZbCTn1AmB8VVSb7Rj87EqU35QjMdd71j9
	 /fJran2nSFFPVyqdtAlPox9iRNvqv/3QANdn4beMHyEqenYRtglBhMigm211OoXB5y
	 yozazuBsLdz0fi3WwdOPqzjzltUxtA462YAW0jBcw7lkF2SsTZbKKxIpQVQ4YDM1jr
	 pxU1YTq41dhBvL/PEQMOFICeKbxhjVm0F9CeEjutHoO12w9etl5j3zHwoNf+YW70Ze
	 xvvDZDI8x+i0tJztJT3Sl+DRTuRBaGMBBJEq634Wap72iclcdrRPJV14z9ssom+jXz
	 9xv93UrKWxWiA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 13/16] netfilter: nft_connlimit: add support to object update operation
Date: Wed, 26 Nov 2025 20:56:08 +0000
Message-ID: <20251126205611.1284486-14-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251126205611.1284486-1-pablo@netfilter.org>
References: <20251126205611.1284486-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fernando Fernandez Mancera <fmancera@suse.de>

This is useful to update the limit or flags without clearing the
connections tracked. Use READ_ONCE() on packetpath as it can be modified
on controlplane.

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_connlimit.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_connlimit.c b/net/netfilter/nft_connlimit.c
index 714a59485935..4a7aef1674bc 100644
--- a/net/netfilter/nft_connlimit.c
+++ b/net/netfilter/nft_connlimit.c
@@ -44,7 +44,7 @@ static inline void nft_connlimit_do_eval(struct nft_connlimit *priv,
 
 	count = READ_ONCE(priv->list->count);
 
-	if ((count > priv->limit) ^ priv->invert) {
+	if ((count > READ_ONCE(priv->limit)) ^ READ_ONCE(priv->invert)) {
 		regs->verdict.code = NFT_BREAK;
 		return;
 	}
@@ -131,6 +131,16 @@ static int nft_connlimit_obj_init(const struct nft_ctx *ctx,
 	return nft_connlimit_do_init(ctx, tb, priv);
 }
 
+static void nft_connlimit_obj_update(struct nft_object *obj,
+				     struct nft_object *newobj)
+{
+	struct nft_connlimit *newpriv = nft_obj_data(newobj);
+	struct nft_connlimit *priv = nft_obj_data(obj);
+
+	priv->limit = newpriv->limit;
+	priv->invert = newpriv->invert;
+}
+
 static void nft_connlimit_obj_destroy(const struct nft_ctx *ctx,
 				      struct nft_object *obj)
 {
@@ -160,6 +170,7 @@ static const struct nft_object_ops nft_connlimit_obj_ops = {
 	.init		= nft_connlimit_obj_init,
 	.destroy	= nft_connlimit_obj_destroy,
 	.dump		= nft_connlimit_obj_dump,
+	.update		= nft_connlimit_obj_update,
 };
 
 static struct nft_object_type nft_connlimit_obj_type __read_mostly = {
-- 
2.47.3

