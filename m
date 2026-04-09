Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F593DD524
	for <netfilter-devel@vger.kernel.org>; Thu,  9 Apr 2026 15:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775747558; cv=none; b=pvSumObCCrUG6qmwqEXZkr0U1vLpkwiK2o9G37nlze39O9wiUMmYH2Jbb8Xm/eS9rHOrM92/V+bLDK8Q6r6lNUvhuwSf8ByBIHc8YMKL1fjyvF43VRP5IoA4U6nWPHcjTPWnrKcIB8rMpXH/FrbrB02jpRhBHjyUv4wJyy9kbzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775747558; c=relaxed/simple;
	bh=J7GoitVHIjtYXm7nb37BNfDX0gi/NO1WvmzZwVMuYwU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GmFjalQ5ltQ2OVHIGn5dyU5ZBIymd4TO9+x4+LbfFI0bNnN2dzbfB+MSOlBnFJqrbwdH7WKeCucV3xcmq2V32gz+dD06DZ7gYDbBSiHem7KqOUaTpqTruI7biJTxqEr25jA1+6p33d3YF6lf6NtlihIdiysyDFvo86401YNw3+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=gd4PyB2d; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="gd4PyB2d"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 5B75F60178;
	Thu,  9 Apr 2026 17:12:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1775747553;
	bh=A2dwcWRD9Q2UykttaY/JcJRxY+P6KtVH+jisG9N4uOk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gd4PyB2dtbiVAnSgffpeOpsemaBfbpgsANB117Oxx6roUBT950eWToBMsOZ3Nt6fP
	 wA/tE9nIEXa/Ttvi/rwPiarqv0ZwJuaG2hjwGsW7f0P6mUK1d46lj/73Upq+KgVZuL
	 qdusGlcup5Ea/OYk+UljAkQCfg2hbkpjCGKxa/QuCj+Hs7ptpc4mWEyaffb5PEt3tJ
	 gzCoVz2Pr7tP7UXY7TEiBGX4cLrjubO0gbhIjflEi477Z5Dra743Se5bXFrHmyFkGm
	 fBUxgNrDvcRiFZQCMowZaB2GnHs/2Pjd+F/EzegIG7HqafkM67e619YN/IFnGiG+5X
	 eknCp8YXnBmRw==
Date: Thu, 9 Apr 2026 17:12:30 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] doc: ct count should be restricted via new
Message-ID: <adfB3qNaLyuEYz-X@chamomile>
References: <20260409115756.27931-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260409115756.27931-1-fw@strlen.de>

On Thu, Apr 09, 2026 at 01:57:53PM +0200, Florian Westphal wrote:
> Not doing it will affect existing flows, which is likely not wanted.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

> ---
>  doc/payload-expression.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/doc/payload-expression.txt b/doc/payload-expression.txt
> index 8b538968c84b..817b7a3c76b1 100644
> --- a/doc/payload-expression.txt
> +++ b/doc/payload-expression.txt
> @@ -934,5 +934,5 @@ ct_id|
>  .restrict the number of parallel connections to a server
>  --------------------
>  nft add set filter ssh_flood '{ type ipv4_addr; flags dynamic; }'
> -nft add rule filter input tcp dport 22 add @ssh_flood '{ ip saddr ct count over 2 }' reject
> +nft add rule filter input ct state new tcp dport 22 add @ssh_flood '{ ip saddr ct count over 2 }' reject
>  --------------------
> -- 
> 2.52.0
> 
> 
