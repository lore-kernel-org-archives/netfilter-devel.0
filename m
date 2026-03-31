Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B56A73BFE2F
	for <netfilter-devel@vger.kernel.org>; Tue, 31 Mar 2026 21:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774993802; cv=none; b=NG0vhaQr/1Yhpe4ms5kSgPvyrX77Hm9JD9y9Mzv43+WtX4J3yM/kGP5w/UViD9/J7FE1SLYRJIJCvPT1+QOGC8TykX4mtNebVigZdLC5j8d06265Fhd+bnpG5Ew9xNYHMh5ME4TJkr9+H2TcozoG6P00mUJRRUt5JvdvPwpnvJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774993802; c=relaxed/simple;
	bh=4/dRqnERZjoJs36qsQnK+hmkkLgiGU/rXHgOKaRn0Eg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MX6mlvsFJrA6kcNvJw68d4ZO5CP3prNt2VbDER9CEvmRvYZ8RK7VvR+vuk9yQAvrrttyxCb1ps4tOKXJj71gDAaFVIWqBZMZSnd7lGwSYSI7CcxLXZdpPKvcKfGjTfyarAEJCnlJVD1ztJKzaxR0tXSDbpLFtbakMNuhN3kdzk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=bwP80jG0; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="bwP80jG0"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id ADE2C60251;
	Tue, 31 Mar 2026 23:49:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1774993798;
	bh=w2DjJDLtkkiioie7Oe4qkH6vhrTQcL/G4QLg6t4Q3V4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bwP80jG0nGfoM1s9ki1IqSkC274JDxGnYqioJvY5xxTR6Yj4OpVnTdsA/exvUaUTp
	 +JvI8HwK1IT4vIo0MWr8G2Y34F6KILJydaZcHR59o1ues3glQPhGJJp2I16A28ix8y
	 ByR8QYkQBmrR2pji2DsnsUMDUJk8VBYIga7miY7qxsTQgiM0koTNJ5ScmalwfOCyZz
	 O2hhZJZco8yQhZucIvDumuAJ9QUO8QgzIa5KD0OXN4pJxXYD5zi2B9yDhFtlRE8ccj
	 qgeDIb8mOzXiQXCpVql1JN7x3PgD3/K/ChGwyOPQ7gu9cWARGW0IEyjYB3Tnm078Ow
	 iRyZvsBhO5y/Q==
Date: Tue, 31 Mar 2026 23:49:55 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: Re: [PATCH nf] netfilter: nf_tables: reject immediate NF_QUEUE
 verdict
Message-ID: <acxBg87ddKWwbhtI@chamomile>
References: <20260331214145.976722-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260331214145.976722-1-pablo@netfilter.org>

On Tue, Mar 31, 2026 at 11:41:45PM +0200, Pablo Neira Ayuso wrote:
> nft_queue is always used from userspace nftables to deliver the NF_QUEUE
> verdict, reject immediate NF_QUEUE verdict.

Actually, a bit terse description, maybe this version is better:

    netfilter: nf_tables: reject immediate NF_QUEUE verdict
    
    nft_queue is always used from userspace nftables to deliver the NF_QUEUE
    verdict. Immediately emitting an NF_QUEUE verdict is never used by the
    userspace nft tools, so reject immediate NF_QUEUE verdicts.
    
    The arp family does not provide queue support, but such an immediate
    verdict is still reachable. Globally reject NF_QUEUE immediate verdicts
    to address this issue.

> Fixes: f342de4e2f33 ("netfilter: nf_tables: reject QUEUE/DROP verdict parameters")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/netfilter/nf_tables_api.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 3922cff1bb3d..8c42247a176c 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -11667,8 +11667,6 @@ static int nft_verdict_init(const struct nft_ctx *ctx, struct nft_data *data,
>  	switch (data->verdict.code) {
>  	case NF_ACCEPT:
>  	case NF_DROP:
> -	case NF_QUEUE:
> -		break;
>  	case NFT_CONTINUE:
>  	case NFT_BREAK:
>  	case NFT_RETURN:
> @@ -11703,6 +11701,11 @@ static int nft_verdict_init(const struct nft_ctx *ctx, struct nft_data *data,
>  
>  		data->verdict.chain = chain;
>  		break;
> +	case NF_QUEUE:
> +		/* The nft_queue expression is used for this purpose, an
> +		 * immediate NF_QUEUE verdict should not ever be seen here.
> +		 */
> +		fallthrough;
>  	default:
>  		return -EINVAL;
>  	}
> -- 
> 2.47.3
> 
> 
