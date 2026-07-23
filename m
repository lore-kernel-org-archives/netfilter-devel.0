Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39C532F7EF2;
	Thu, 23 Jul 2026 16:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784824796; cv=none; b=OUFUFmGmPsoH94GWD9x1rKTLKrol05RTAVwuckwLQpvAT1+UffPPvjgqSfZNbNaADBLWUSriZbNg1w0e4mhokaewkNlpLeUAV6Yt6RQuqbrP3TuNNzHVahUB7kHdg0W4PDHIdLe+K+TNPMPw6TZpGMzUc4lwX4AQ/rwCp1CrNqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784824796; c=relaxed/simple;
	bh=aInLqgarjvsJGUH/TmqL+5Pq1RNPab7vCs908PPwzXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uJ8/EK3LdjjoXuR5vItQiW3WvJtsT33VMhzsLH7ac16D32+p2El/SM/i9MAauY/3sSMb6mnJdCqq5X/XH9KcIHD55ji8V8dOSE/jdSjSC0h29m71oRaX0jIlgKtrA06t6tfLktqLCTHDiYQwx4AMWeRGpwcrJRr3WUZ5FQB9TXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ktAueeIY; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ktAueeIY"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 3B16D601CC;
	Thu, 23 Jul 2026 18:39:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1784824785;
	bh=rD1lrLqLrERUcFn+n2sSYrVumHTXPgzIe00JRP88Pt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ktAueeIYFFw+Vr12ljuOX6/ZGqWoJqRen2x1EYmMkl6qSKvAXv2saOESir41fvnbq
	 5CyXjjAVnTFnv+Ghb19+C6yaNHfRFBMPaYP6Spame8U45LJ9155ZYoeL3aWvAo7a0n
	 93PJ2J8QIPBNdfdRJRPiBYyP3J+/caKLSUS8K9qeJBeMZzd+ZOrj/uxcyMLLJq/wjP
	 mzzq4IN924UuvgxdBXmZ7879Bb0nn2KMZJymnKcJ+4xD/Vcg2xQ9Nr+PP9V6jp8jsG
	 BXQBCCbTfx6OIqfG0YqkNoGS26vI6fjelqmCg+TJ9XjFZMhPNvS2KcTkyrJsiH19Tg
	 /Vu4K2VegyMNA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 13/13] netfilter: nft_payload: fix mask build for partial field offload
Date: Thu, 23 Jul 2026 18:39:10 +0200
Message-ID: <20260723163910.274695-14-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260723163910.274695-1-pablo@netfilter.org>
References: <20260723163910.274695-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Xiang Mei (Microsoft)" <xmei5@asu.edu>

nft_payload_offload_mask() builds the offload match mask for a payload
expression that covers only part of a header field.  For a partial IPv6
address match (field_len = 16, priv_len = 1) that shift is 1 << 120, which
is undefined on the 32-bit int operand.  It also trims only one word, so
the remaining words stay 0xffffffff (and when priv_len is a multiple of 4
the trim is skipped entirely), leaving the mask covering more bytes than
the rule matches.

  UBSAN: shift-out-of-bounds in net/netfilter/nft_payload.c:278:20
  shift exponent 120 is too large for 32-bit type 'int'
  ...

The match is byte-granular and struct nft_data is zero-initialised, so the
correct mask is simply the first priv_len bytes set to 0xff. Set those
bytes directly and drop the word/shift trimming; this removes the undefined
shift and no longer over-masks the trailing bytes.

Fixes: a5d45bc0dc50 ("netfilter: nftables_offload: build mask based from the matching bytes")
Reported-by: AutonomousCodeSecurity@microsoft.com
Signed-off-by: Xiang Mei (Microsoft) <xmei5@asu.edu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_payload.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 391539a1ceaa..8a4472fd77d9 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -259,9 +259,7 @@ static int nft_payload_dump(struct sk_buff *skb,
 static bool nft_payload_offload_mask(struct nft_offload_reg *reg,
 				     u32 priv_len, u32 field_len)
 {
-	unsigned int remainder, delta, k;
 	struct nft_data mask = {};
-	__be32 remainder_mask;
 
 	if (priv_len == field_len) {
 		memset(&reg->mask, 0xff, priv_len);
@@ -270,15 +268,7 @@ static bool nft_payload_offload_mask(struct nft_offload_reg *reg,
 		return false;
 	}
 
-	memset(&mask, 0xff, field_len);
-	remainder = priv_len % sizeof(u32);
-	if (remainder) {
-		k = priv_len / sizeof(u32);
-		delta = field_len - priv_len;
-		remainder_mask = htonl(~((1 << (delta * BITS_PER_BYTE)) - 1));
-		mask.data[k] = (__force u32)remainder_mask;
-	}
-
+	memset(&mask, 0xff, priv_len);
 	memcpy(&reg->mask, &mask, field_len);
 
 	return true;
-- 
2.47.3

