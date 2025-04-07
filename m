Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03FD81AE005
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Apr 2025 13:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744033960; cv=none; b=tnHbwxcd/LrsGhccaDjLX4Gjxytm4B/3QRzF0j6grdPbCGZVbPW+UD/HYggEcAiL7ZbXbcLKey+TLtsUls6HEhJAN4zUOzpW+GSH9zZBF/mWAI5iuqPYv60c4uUQKmRleX90Ifz4pTdtgkd1Z1oWmY4K5AYleTh5S2H38RhIRT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744033960; c=relaxed/simple;
	bh=y3nsb2wufjoVuI6/GrJJ0gqa1txh31hxeXbhpSs7NwQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NsqViSEx9lb2wnxol1NAnQQv6k1tQxiBnKndySzUs/hkCQt2kt6NO7q6rybDOrcQtCmSJs35wXFdnlx3lyVkajgGJM6pg2999q2gnY+Vl9QIVDk8fp05uk+qGdZ2qWFkIDAIkA68yKdA8QWHzLSFui5GDNfAHZHF9a32w9a3eQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=B7v2oLSt; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=v4FXapGy; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="B7v2oLSt";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="v4FXapGy"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 189D46036D; Mon,  7 Apr 2025 15:52:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1744033949;
	bh=3sD0IiPx+hSEHlxvCpjpfw0P49RpM+0ECeExjPceoZE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B7v2oLSt9oobX1tKDvNvEeNb0La3kYnHW1VhvMGjqlSBIaIWVaX63kB2ihdF3Ue4/
	 ailK9F1wQRVtnlqFrNL7LIP6NvzRiPLdivCpdxSCjiZT3dTr60vJyCHsFMLJhFEYL3
	 tz3UZx4ELX0Ct7SIubNQ3CXLMVCJFc9LkOTs+eexIR5/ANoex/m83hBxi2iKWA01gO
	 Tb91yumMfTh28JyWSIgoRbFZV0BYWuJhuoIyDnVQSh3t0URlxgIo4009HFuhuwc+KH
	 VRtC3fhFSDPVK1yh8lrxskj2xGljxGrIX0OeK7Q1XbKazGfaTT9akCkuLjUZynqy8N
	 CNUNrwOOUsbtQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 692FA6036D;
	Mon,  7 Apr 2025 15:52:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1744033948;
	bh=3sD0IiPx+hSEHlxvCpjpfw0P49RpM+0ECeExjPceoZE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=v4FXapGyuQh8nycDArdCNuA/zxIAp+1NDTPL0FlAjF2VA7rS+pJ3JrS+GCAgFmU2U
	 coGmHJoJM2cy4UElL74XcsnKNpIeNBzFwORRthcHc6mNXNEFZF90w8c0ECwCsrQj1R
	 GGDNNb4RLT+iu2GooRpUOnUeTGwiylrv8jvG8P9zbOR5F6581g62EzcC0JZdzDk48o
	 VaILD4P5sD8vSRJ+VcxHMETT4e6+MGKq1n4Mnn99a29uG0fq/9lUpOtrLfxGUTNllW
	 krR10hqRiA09lVSs2NQiP1yJ74pxkMcsTK5cg4CclHG5UpCpShck8X9bI6YPGzjV3V
	 5bAsdocGO0UBA==
Date: Mon, 7 Apr 2025 15:52:26 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] evaluate: bail out if ct saddr/daddr dependency
 cannot be inserted
Message-ID: <Z_PYmglWmIqO-dId@calendula>
References: <20250402230930.28757-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250402230930.28757-1-fw@strlen.de>

On Thu, Apr 03, 2025 at 01:09:22AM +0200, Florian Westphal wrote:
> If we have an incomplete rule like "ct original saddr" in inet
> family, this function generates an error because it can't determine the required protocol
> dependency, hinting at missing ip/ip6 keyword.
> 
> We should not go on in this case to avoid a redundant followup error:
> 
> nft add rule inet f c ct original saddr 1.2.3.4
> Error: cannot determine ip protocol version, use "ip saddr" or "ip6 saddr" instead
> add rule inet f c ct original saddr 1.2.3.4
>                   ^^^^^^^^^^^^^^^^^
> Error: Could not parse symbolic invalid expression
> add rule inet f c ct original saddr 1.2.3.4
> 
> After this change only the first error is shown.
> 
> Fixes: 2b29ea5f3c3e ("src: ct: add eval part to inject dependencies for ct saddr/daddr")
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks Florian

> ---
>  src/evaluate.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/src/evaluate.c b/src/evaluate.c
> index 0c8af09492d1..d6bb18ba2aa0 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -1190,7 +1190,8 @@ static int expr_evaluate_ct(struct eval_ctx *ctx, struct expr **expr)
>  	switch (ct->ct.key) {
>  	case NFT_CT_SRC:
>  	case NFT_CT_DST:
> -		ct_gen_nh_dependency(ctx, ct);
> +		if (ct_gen_nh_dependency(ctx, ct) < 0)
> +			return -1;
>  		break;
>  	case NFT_CT_SRC_IP:
>  	case NFT_CT_DST_IP:
> -- 
> 2.49.0
> 
> 
