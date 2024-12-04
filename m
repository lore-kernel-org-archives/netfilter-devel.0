Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907241F759E
	for <netfilter-devel@vger.kernel.org>; Wed,  4 Dec 2024 14:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733322668; cv=none; b=iP3wY2sXbgNS3/gtMOV8AZxLEfu9e8ZdRaPPqIQOYMztSI+PEbTGDsv6pQGHGSp3lqdoNko0agjdwmLi62ys1Nx9b75tx7BZDDFaHGLCQ5V2MZUkP4HBUSQOlr/K1cEcl1JfKiPIbjc1WcCPtQCGTyPJ05w1KSeuXUJjenZGT6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733322668; c=relaxed/simple;
	bh=ia2b/OjLV93h8mQOh1Jih48jy80sk2ZcDyGjIb0C2js=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sV93Y6WIGX7xCJdALTXKAX7hnZwxi39tAlgmAegSV6vnesDIBZ2xYCQW51JdyzeNBBmqdVasCnM5JEN0EPhr4Mcp7AzDLNpcfPQLzdzEwL8nUUUR4N44BAf11cmI/oOSC3QPWLny5IV5UG2Sw+U3tZ9ClOQZZBvsMxG+dHXg1wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.39.247] (port=43626 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1tIqP4-00985K-AK; Wed, 04 Dec 2024 15:31:00 +0100
Date: Wed, 4 Dec 2024 15:30:56 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH 1/3] set: Fix for array overrun when setting
 NFTNL_SET_DESC_CONCAT
Message-ID: <Z1BnoHnLGem-1KFV@calendula>
References: <20241127180103.15076-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241127180103.15076-1-phil@nwl.cc>
X-Spam-Score: -1.9 (-)

Hi Phil,

On Wed, Nov 27, 2024 at 07:01:01PM +0100, Phil Sutter wrote:
> Assuming max data_len of 16 * 4B and no zero bytes in 'data':
> The while loop will increment field_count, use it as index for the
> field_len array and afterwards make sure it hasn't increased to
> NFT_REG32_COUNT. Thus a value of NFT_REG32_COUNT - 1 (= 15) will pass
> the check, get incremented to 16 and used as index to the 16 fields long
> array.
> Use a less fancy for-loop to avoid the increment vs. check problem.

for-loop is indeed better.

Patch LGTM, thanks.

> Fixes: 407f616ea5318 ("set: buffer overflow in NFTNL_SET_DESC_CONCAT setter")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

> ---
>  src/set.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/src/set.c b/src/set.c
> index f127c19b7b8b8..5746397277c48 100644
> --- a/src/set.c
> +++ b/src/set.c
> @@ -185,8 +185,10 @@ int nftnl_set_set_data(struct nftnl_set *s, uint16_t attr, const void *data,
>  			return -1;
>  
>  		memcpy(&s->desc.field_len, data, data_len);
> -		while (s->desc.field_len[++s->desc.field_count]) {
> -			if (s->desc.field_count >= NFT_REG32_COUNT)
> +		for (s->desc.field_count = 0;
> +		     s->desc.field_count < NFT_REG32_COUNT;
> +		     s->desc.field_count++) {
> +			if (!s->desc.field_len[s->desc.field_count])
>  				break;
>  		}
>  		break;
> -- 
> 2.47.0
> 
