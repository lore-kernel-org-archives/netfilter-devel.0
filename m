Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D7621A38E0;
	Wed, 28 Aug 2024 20:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724877031; cv=none; b=EmnnpiBAqeECOsENrIOyvyfRCBIxozJu+XfCBePrEFGc5+ualMYrcld7IubGmGfhjXezNGKecKwRJgrgWuS9SZbgHCWF84PsIk6Bg3ZS2ygfOhJ3FOsomDBWisbYPTAXncIhYyjOHL2DHx1N8PqpGZzVsXFBs7mHIvrO0kvV8LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724877031; c=relaxed/simple;
	bh=EuS2yeccKBeQRCJh/1X75khYwRW1PEfRRJNQBXVsk7w=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=iNJNCh/vj8WHGaF/p/YWN8F2Iv/4wMxJ6FELRUtpI2cySrRchg7VlygAH81O1VnezO42jCAtEGxIXfi/T5sxKTppOm8aBnH88ogA9Gs5w/Uq4qt2JomL2qZ7m8+DqvgWubtn0Jq1R8Ghf3MRIw8XrCymq95pX8bq2NWe4B/r9cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pt9aBFwI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pt9aBFwI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05AFDC4CEC0;
	Wed, 28 Aug 2024 20:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724877030;
	bh=EuS2yeccKBeQRCJh/1X75khYwRW1PEfRRJNQBXVsk7w=;
	h=From:Date:Subject:To:Cc:From;
	b=pt9aBFwI7W+WHHXX61rLa7rZYzI5dqVJ4YNjTfYGlPb3x3eZj21mAIX40knpjsytH
	 Iu8ukrP7MuWdVIiDGGrHTUTPGFqB4H0QSu893yWwbVMcPFhRmFdQyozI1EcUbFcvZY
	 HISWGig4lNs/91+3Uoe8Z5hTVgSsZG7ogu9ya8hZBFibM+hjT5pqieDPThfF1+8ax+
	 r54uzuzDJ4ZUFufm7vQeCSNXn7uNVpyejAeeq5MYcvuYHIv3+swfidBb3RrmVQxUnR
	 1Za9EEdryxMf2TEABjR8DaR6D0ifREn/56iDRsZ90FQuI2l2eoXMXdX27HNO+6b0oP
	 Wkt72k2+LOAAw==
From: Simon Horman <horms@kernel.org>
Date: Wed, 28 Aug 2024 21:30:16 +0100
Subject: [PATCH] netfilter: nf_tables: Correct spelling in nf_tables.h
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240828-netfilter-spell-v1-1-e4e806f2daef@kernel.org>
X-B4-Tracking: v=1; b=H4sIANeIz2YC/x3MTQqAIBBA4avErBPMfrSuEi1inGpALFQikO6et
 PwW72WIFJgiTFWGQDdHPn1BU1eAx+p3EmyLQUnVSaOM8JQ2domCiBc5J4axRysRW60RSnUF2vj
 5j/Pyvh8dZ2nhYQAAAA==
To: Pablo Neira Ayuso <pablo@netfilter.org>, 
 Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, netfilter-devel@vger.kernel.org, 
 coreteam@netfilter.org, netdev@vger.kernel.org
X-Mailer: b4 0.14.0

Correct spelling in nf_tables.h.
As reported by codespell.

Signed-off-by: Simon Horman <horms@kernel.org>
---
 include/net/netfilter/nf_tables.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 1cc33d946d41..3025d0ccef6d 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -687,7 +687,7 @@ void nf_tables_destroy_set(const struct nft_ctx *ctx, struct nft_set *set);
  *	@NFT_SET_EXT_TIMEOUT: element timeout
  *	@NFT_SET_EXT_EXPIRATION: element expiration time
  *	@NFT_SET_EXT_USERDATA: user data associated with the element
- *	@NFT_SET_EXT_EXPRESSIONS: expressions assiciated with the element
+ *	@NFT_SET_EXT_EXPRESSIONS: expressions associated with the element
  *	@NFT_SET_EXT_OBJREF: stateful object reference associated with element
  *	@NFT_SET_EXT_NUM: number of extension types
  */

