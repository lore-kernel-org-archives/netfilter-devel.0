Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E10603AD52E
	for <netfilter-devel@vger.kernel.org>; Thu, 28 May 2026 09:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779960697; cv=none; b=bv6BF3fIborWTMcq0/3nGeJzoAZ9diGVDWR8XlE4HqzuO+iicYEcpIhyNPkZ9PBVj9J2KOOQ6HJ6zyuOQFEEguFqjK/DWUyZAxZWyDLpFPaQyhOgCOaFpIhWuL1+6tvltlg0Y5cFHbsQH5AHP16fvjzjMTs/9+DHhIMnPOp8UfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779960697; c=relaxed/simple;
	bh=Gf5GP3EL6NlcRmczAppCoL4pCDBDT4GMhuVAsj7QmKQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZJBrKrvtFm45FaJSQfjJrDA2ZBQjZua/bYqXADSqr+in2JB3zZRaupB+jDWGiBudUZRMSrz0drmhY7UWW0TxK5mFSDGOW1PGvQ21zSWekaZ3cZSbpgp/wHAa/VbKFjm6R8xl2XRJTFsy6t61x6/j9IkIiH0O23N7sI3y2VjlJKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 7170860232; Thu, 28 May 2026 11:31:32 +0200 (CEST)
Date: Thu, 28 May 2026 11:31:32 +0200
From: Florian Westphal <fw@strlen.de>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nft_ct: fix OOB in NFT_CT_SRC/DST eval
Message-ID: <ahgLdDKloq01r7lK@strlen.de>
References: <20260528042620.263828-1-jiayuan.chen@linux.dev>
 <ahfQGCNs8hl6FlHL@strlen.de>
 <ahfV6K6KrG0akLUZ@strlen.de>
 <88abc4d7-8316-4c9e-aca0-351fe0ecb2b0@linux.dev>
 <ahfqfM6xQKZr_xbA@strlen.de>
 <58fc5150-76e7-46e5-a72f-41133c408109@linux.dev>
 <ahf2XAmRnsjK0krp@strlen.de>
 <c1383a3a-6c76-411a-8ae3-1dfe90052fb7@linux.dev>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c1383a3a-6c76-411a-8ae3-1dfe90052fb7@linux.dev>

Jiayuan Chen <jiayuan.chen@linux.dev> wrote:

[ CC Pablo ]

> > https://sashiko.dev/#/patchset/20260528042620.263828-1-jiayuan.chen%40linux.dev
> > 
> > "This is a pre-existing issue, but does copying only addr_len bytes when
> > priv->len is larger leave the remainder of the register uninitialized?
> > In nft_do_chain(), the register array is allocated on the kernel stack
> > without zero-initialization. If priv->len is 16 and addr_len is 4, only
> > the first 4 bytes are written."
> 
> I just spotted that too.  I think copying priv->len unconditionally
> is enough -- tuple->{src,dst} is zeroed in nf_ct_get_tuple() before the
> protocol pkt_to_tuple callback fills in only the relevant leading bytes,
> so the trailing bytes of tuple->{src,dst}.u3.all are well-defined zeros
> and no wrapper is needed.

Pablo, whats your take?

chain c {
 type filter hook output priority -300; policy accept;
 ct zone set 1
 ct original saddr 0.0.0.0 counter accept
}

Then: ping -c 1 127.0.0.1

should the rule match the template or not?
If not, we need:

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
index e684c8a91848..ecf7b3a404be 100644
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


If it should match, we need something like this:

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -180,12 +180,14 @@ static void nft_ct_get_eval(const struct nft_expr *expr,
 	tuple = &ct->tuplehash[priv->dir].tuple;
 	switch (priv->key) {
 	case NFT_CT_SRC:
-		memcpy(dest, tuple->src.u3.all,
-		       nf_ct_l3num(ct) == NFPROTO_IPV4 ? 4 : 16);
+		if (nf_ct_l3num(ct) != nft_pf(pkt))
+			goto err;
+		memcpy(dest, tuple->src.u3.all, priv->len);
 		return;
 	case NFT_CT_DST:
-		memcpy(dest, tuple->dst.u3.all,
-		       nf_ct_l3num(ct) == NFPROTO_IPV4 ? 4 : 16);
+		if (nf_ct_l3num(ct) != nft_pf(pkt))
+			goto err;
+		memcpy(dest, tuple->dst.u3.all, priv->len);
 		return;
 	case NFT_CT_PROTO_SRC:
 		nft_reg_store16(dest, (__force u16)tuple->src.u.all);

I am leaning towards both changes.  What do you think?
