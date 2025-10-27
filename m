Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A780821D011
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Oct 2025 22:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761603840; cv=none; b=K/d0qT+1vJYtjLKOHauZ+mSF7xgQm0cVSZZU2qaPExRC942RkRRTieNAYc/x0YZH2fQZDsr6wtEcTFlz2RLsAmbEggDs+mTE0vLC9yWlfLL09pU/OqR1sPb7V5ST1gMwm44J7X9PNrnjpKwWDbgiBTXzZOKJ72jwUZsWzN7Sbe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761603840; c=relaxed/simple;
	bh=TwpBXNTzEVB9rNxDHO/YJ1OfqIzhxjLOG9srHpHlOAg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HjjD/zbFoyOjsbYmogrBi75ndNeUOTURH/MtZQpKVoP6tsRcVx0xrlYiBgyfR9kviW8ZFLPDzDsrgmvGfxCMJWmV062/Z2wos6pYT47O6xq/dzmmdCBmfOlaSrMBY5000FsRjnYLY0tEmOOGikISmtYOn70YlNGmY+gDSTjq/c0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=klMSqoBH; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="klMSqoBH"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C2C3160269;
	Mon, 27 Oct 2025 23:23:56 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1761603836;
	bh=ES8GFlmGenjG0BBsPeL4X97DOI81X734wcw37CZWzns=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=klMSqoBHguHMSdkA6k5u3XOnxWbPEQRzUbDbV+hcoXc+tyhsJ5jMp5B5aEWlhKO9y
	 0vuqjpSDM4Q7qF1rGfQ5S0CAGA9lmj0cWruoFP1BYyNSPksBugamHkAnTMgzFmwrjw
	 QoiJyawcJzRVgDoCDTMSG9zstZ/t7y3Bl5SAf7GQR/1Xtut5a5cxpFSXyrvJjoLLVH
	 1zVD0CSRvU/KvZ5fnJCvwySPNY+mZQdbjeGoudQp78jD1BRnu2TNy/j0guOyVo00/m
	 852osznrPfK/Ie3W2cmKr6HV/NE2AOPagxEUwMHbZt+pYXhcJeArS6wC5hw0GXQSLP
	 mNFyPdgtqxDeA==
Date: Mon, 27 Oct 2025 23:23:54 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft] doc: remove queue from verdict list
Message-ID: <aP_w-ot_Fq7ftU48@calendula>
References: <20251026085439.12336-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251026085439.12336-1-fw@strlen.de>

On Sun, Oct 26, 2025 at 09:54:36AM +0100, Florian Westphal wrote:
> While its correct that the queue statement is internally implemented
> via the queue verdict, this is an implementation detail.
> We don't list "stolen" as a verdict either.
> 
> nft ... queue will always use the nft_queue statement, so move the
> reinject detail from statements to queue statement and remove this.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

> ---
>  doc/statements.txt | 14 +++++---------
>  1 file changed, 5 insertions(+), 9 deletions(-)
> 
> diff --git a/doc/statements.txt b/doc/statements.txt
> index e275ee39dc4e..0633d023f2c0 100644
> --- a/doc/statements.txt
> +++ b/doc/statements.txt
> @@ -4,7 +4,7 @@ The verdict statement alters control flow in the ruleset and issues policy decis
>  
>  [verse]
>  ____
> -{*accept* | *drop* | *queue* | *continue* | *return*}
> +{*accept* | *drop* | *continue* | *return*}
>  {*jump* | *goto*} 'CHAIN'
>  
>  'CHAIN' := 'chain_name' | *{* 'statement' ... *}*
> @@ -22,11 +22,6 @@ afterwards in the processing pipeline.
>  The drop occurs instantly, no further chains or hooks are evaluated.
>  It is not possible to accept the packet in a later chain again, as those
>  are not evaluated anymore for the packet.
> -*queue*:: Terminate ruleset evaluation and queue the packet to userspace.
> -Userspace must provide a drop or accept verdict.  In case of accept, processing
> -resumes with the next base chain hook, not the rule following the queue verdict.
> -*continue*:: Continue evaluation with the next rule. This
> - is the default behaviour in case a rule issues no verdict.
>  *return*:: Return from the current chain and continue evaluation at the
>   next rule in the last chain. If issued in a base chain, it is equivalent to the
>   base chain policy.
> @@ -741,9 +736,10 @@ QUEUE STATEMENT
>  ~~~~~~~~~~~~~~~
>  This statement passes the packet to userspace using the nfnetlink_queue handler.
>  The packet is put into the queue identified by its 16-bit queue number.
> -Userspace can inspect and modify the packet if desired. Userspace must then drop
> -or re-inject the packet into the kernel. See libnetfilter_queue documentation
> -for details.
> +Userspace can inspect and optionally modify the packet if desired.
> +Userspace must provide a drop or accept verdict.  In case of accept, processing
> +resumes with the next base chain hook, not the rule following the queue verdict.
> +See libnetfilter_queue documentation for details.
>  
>  [verse]
>  ____
> -- 
> 2.51.0
> 
> 
