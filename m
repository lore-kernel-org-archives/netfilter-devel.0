Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F83204C30
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Apr 2025 14:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743518396; cv=none; b=tnCzgF4tihJ9UEL3bBXTL74FJUlZvvX3mmGGKtTmJU1ssOieiZXsbokjgZ8KBMAWn8tsYlSD5ou8FRdgYyQrrd2hS8rLmJLH8pf6UrMfDfwZy19YMRvsjIVOo0mPwFypbU0OlpWOOBOsnNxupq5vKvRWKGXBQLr6NbcSVIKfsAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743518396; c=relaxed/simple;
	bh=XkyVvMowSXAS5feey7ZzNIJZlPwHBoJW30lTngXN1vo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F5C3U2/MKCDUbZEnk8SXpoNmgEb8nQxw2fXmZRzJYeZ9PUihsia0bRE03e6QBRFMkIZUx85YI1uTIrVERnmX/cVxAC1MmI73JWOpe/s4NwC/u2gk2l0ikWDnRAWu7wqYZd8o9cWqCsQetI6rW7VNLSvBX3WK0Yu8J2a1hT953QU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=VsMLLolY; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=VsMLLolY; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="VsMLLolY";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="VsMLLolY"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 928D560389; Tue,  1 Apr 2025 16:39:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743518392;
	bh=suz4pEndyIKI7FEZemgY1R0FmlW/K+j0Iqui/QZI8zg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VsMLLolYM5z9fDuT7iHHgARpVLeSZYfyI60LSb3O90noSWxOv/qk04dbyVsq24lp/
	 KGFnFMauyFdlXI5uI8gwS8d2OJjnvZgxK5LwkBJP3Di/6hMuhZ0gOBM32wARCLnQry
	 8HlxqF5GoLzXmUZg8eapSDDl45Qn/hPcxK7kmvuPi9jouC7UmD2FSOi4aI/Kpj6vKW
	 8TVCsFPwureV158iDTYlb///cqbp3wrYbu3JLDj+jr1hp5LHgqygfwGUF5vVrrWqZ6
	 OJjDOyj/ml8T2PlKBnp6XB0Lvc6MRIop+KjFJ5qEmgCIVAiZkkbh/9sHiea3PVZbDy
	 7Se+XemLlIh2g==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id EE00060389;
	Tue,  1 Apr 2025 16:39:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743518392;
	bh=suz4pEndyIKI7FEZemgY1R0FmlW/K+j0Iqui/QZI8zg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VsMLLolYM5z9fDuT7iHHgARpVLeSZYfyI60LSb3O90noSWxOv/qk04dbyVsq24lp/
	 KGFnFMauyFdlXI5uI8gwS8d2OJjnvZgxK5LwkBJP3Di/6hMuhZ0gOBM32wARCLnQry
	 8HlxqF5GoLzXmUZg8eapSDDl45Qn/hPcxK7kmvuPi9jouC7UmD2FSOi4aI/Kpj6vKW
	 8TVCsFPwureV158iDTYlb///cqbp3wrYbu3JLDj+jr1hp5LHgqygfwGUF5vVrrWqZ6
	 OJjDOyj/ml8T2PlKBnp6XB0Lvc6MRIop+KjFJ5qEmgCIVAiZkkbh/9sHiea3PVZbDy
	 7Se+XemLlIh2g==
Date: Tue, 1 Apr 2025 16:39:49 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] cache: don't crash when filter is NULL
Message-ID: <Z-v6tZQP89dzUqeo@calendula>
References: <20250401142917.11171-1-fw@strlen.de>
 <Z-v5Q5H7_am0OMOg@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="+Tm/TJr2YgoPX8Qd"
Content-Disposition: inline
In-Reply-To: <Z-v5Q5H7_am0OMOg@calendula>


--+Tm/TJr2YgoPX8Qd
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Tue, Apr 01, 2025 at 04:33:42PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Apr 01, 2025 at 04:29:14PM +0200, Florian Westphal wrote:
> > a delete request will cause a crash in obj_cache_dump, move the deref
> > into the filter block.
> > 
> > Fixes: dbff26bfba83 ("cache: consolidate reset command")
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> 
> Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

BTW. Same pattern in:

- rule_cache_dump()

Maybe collapse this chunk too?

--+Tm/TJr2YgoPX8Qd
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="x.patch"

diff --git a/src/cache.c b/src/cache.c
index b75a5bf3283c..52f7c9abd741 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -714,6 +714,7 @@ static int rule_cache_dump(struct netlink_ctx *ctx, const struct handle *h,
 	const char *chain = NULL;
 	uint64_t rule_handle = 0;
 	int family = h->family;
+	bool reset = false;
 	bool dump = true;
 
 	if (filter) {
@@ -727,11 +728,12 @@ static int rule_cache_dump(struct netlink_ctx *ctx, const struct handle *h,
 		}
 		if (filter->list.family)
 			family = filter->list.family;
+
+		reset = filter->reset.rule;
 	}
 
 	rule_cache = mnl_nft_rule_dump(ctx, family,
-				       table, chain, rule_handle, dump,
-				       filter->reset.rule);
+				       table, chain, rule_handle, dump, reset);
 	if (rule_cache == NULL) {
 		if (errno == EINTR)
 			return -1;

--+Tm/TJr2YgoPX8Qd--
