Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4549C43C7BC;
	Wed, 22 Jul 2026 21:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784754891; cv=none; b=Zoj+E0TojBIWt49fv8fGwp2N05aWKllzGp/gU/jR9P9I1QRoczzevXLkG7sFk7aLPEuWXc2irj3Z+M3oobDaa9/zA2DnVGQ6cVBlJgCvwTaD4FmSENSIOe4uzDCw0zIO2QrtJjmeODPanPd0b1FqWfNfVFFi6bS/vN65bU1JH2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784754891; c=relaxed/simple;
	bh=aInLqgarjvsJGUH/TmqL+5Pq1RNPab7vCs908PPwzXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N4pyPtEkKznHj5Azm7TKib7z7aFxeWhpTuURW8uvaf1pyUAh1AteYt+ECIlWzjrrZiXTZRlSoIAHbz//+R3iv5cfX0jgCQEh20OAVcJdVuAg7NWS9CC+cOiyLkJtFTYLeo3gN8ddoRcXuL5Wh5ou3zKvLa5+0bGh02aPNGBlmHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=AjbmvWae; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="AjbmvWae"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id BE08B6019E;
	Wed, 22 Jul 2026 23:14:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1784754886;
	bh=rD1lrLqLrERUcFn+n2sSYrVumHTXPgzIe00JRP88Pt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AjbmvWaebqJWPCR5B5udnbmnXEv/nFQHF3aH4EdUlxe1XTcHY3ekxrNeLE3BWr8xo
	 xe8FAz2sUXmZKvQ+9lN5cyfiE00hYgVdxVsr1r2xisB6O9rjiBnmxTNNFufgf4doSS
	 GnH2Uf1csIS1vaGTJ7+nrYeFdZfsCFGa33daOUUXwKfu2NS0gB0zo8FAeo1t/G6J43
	 NsqeDIwZoCZcF3SRLSFaf0pV6RpMV2K4NgGBczw0mcPEMYgn0K8gVVDXJd86Bl7ENp
	 6O/pfNPFDe4/xeElRVnjJWeJUCzKLeA13vA7TqKa4T1hHhyVL9FvMS/cs3WwB40PEm
	 eFzHw97gkrEuA==
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
Date: Wed, 22 Jul 2026 23:14:20 +0200
Message-ID: <20260722211420.153933-14-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260722211420.153933-1-pablo@netfilter.org>
References: <20260722211420.153933-1-pablo@netfilter.org>
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

