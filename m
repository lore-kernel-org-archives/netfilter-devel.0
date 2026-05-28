Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23D583438A1
	for <netfilter-devel@vger.kernel.org>; Thu, 28 May 2026 05:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779946987; cv=none; b=nzYAKDrwVuYGJ3qVX2rA1ijvddkq6DSOFHhU/y66yJjPTKs8ZN2Rz2C198yBD6BJKzoQqhJaOTfFJQqNFv1YlxGgIvUlgdj0P+6FONo/hQopneT0uunfV9qkH6nHW8/sEHofzERwzrGwKTh8n5ZFzfaO0lWvqGwzXleyQ/uxjxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779946987; c=relaxed/simple;
	bh=+7Zrv23R967gMJt2J0q2jxd2Djc43za0SoKaK9nGcPI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XfzbvsAVkHDXxUebniviV4dSKV4N7cBC68xC2K1ws3deWQgUjah5DpHyvwwq6+RQYWjSQHGYisjF7Sx5Yn3DjgKq65/B+3XCb0Z/YzkXfNZqGBrktu7yAxt/G781QTmpBhdhC9ptudfPuUbjVjtJaQ8T1fEoVZ+iJZUdcAxbkYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 73B32604A0; Thu, 28 May 2026 07:43:04 +0200 (CEST)
Date: Thu, 28 May 2026 07:43:04 +0200
From: Florian Westphal <fw@strlen.de>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nft_ct: fix OOB in NFT_CT_SRC/DST eval
Message-ID: <ahfV6K6KrG0akLUZ@strlen.de>
References: <20260528042620.263828-1-jiayuan.chen@linux.dev>
 <ahfQGCNs8hl6FlHL@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahfQGCNs8hl6FlHL@strlen.de>

Florian Westphal <fw@strlen.de> wrote:
> > which makes nf_ct_l3num(ct) be 0
> 
> How?

Wild guess:

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -78,7 +78,7 @@ static void nft_ct_get_eval(const struct nft_expr *expr,
 		break;
 	}
 
-	if (ct == NULL)
+	if (!ct || nf_ct_is_template(ct))
 		goto err;
 
 	switch (priv->key) {
diff --git a/net/netfilter/nft_ct_fast.c b/net/netfilter/nft_ct_fast.c
--- a/net/netfilter/nft_ct_fast.c
+++ b/net/netfilter/nft_ct_fast.c
@@ -30,7 +30,7 @@ void nft_ct_get_fast_eval(const struct nft_expr *expr,
 		break;
 	}
 
-	if (!ct) {
+	if (!ct || nf_ct_is_template(ct)) {
 		regs->verdict.code = NFT_BREAK;
 		return;
 	}


.... might also make sense to invert
nf_ct_l3num(ct) == NFPROTO_IPV4 ? 4 : 16), i.e.:
nf_ct_l3num(ct) == NFPROTO_IPV6 ? 16 : 4);
