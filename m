Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BBE03009E3
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Oct 2025 18:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761762879; cv=none; b=XkyirHhge1Pnz0uqgAZjpxAllSXPiMwldTamMwn11uh4nuovyf/OmP7ztjXetVPHsIGIQwVTB4oS2iO8eaGZq/sR2o3R2jpYaStKFO3CZ1X9lvMEWiIW0YQQYdCiCMNvahkqpYMMrgqO4EokS5Jc9I3hZ+VYzIziP8aMQ7Hc5jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761762879; c=relaxed/simple;
	bh=NTe6s2RHThsOAXyvQMgntlMvjgwucAKztewGw2hLUeA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ViSXXpcSL9e4DBwd6c1qAmDCapy92rAK4VXd6szGpzpzogYBIWblaqt8EOK4cMzwl2lJLiVfmzMfN1P3H8fCIaU0UKUnTZZQsIzNGmkbDQu71x/Co06Wy7MDAJ0cpRY2gvJ7Ly/Wla4Zyme10ojO0e/pYUZp/ZTWhRW8AJc1zaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=dtb6Md2r; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="dtb6Md2r"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 81AB56027A;
	Wed, 29 Oct 2025 19:34:35 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1761762875;
	bh=ECuNuLplOuvwTxtBpn73nH2OanUergraVMqK0qwealI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dtb6Md2rU/pWlyq75Ba+gMH1Q77zkvoS1/H/ZHjoqYfcZ6CG+TqYPqux7OJgvmk2w
	 AdZPpDq88Hi8cGalbMzRziMe6MCQ18R77FPbDi/3rdKR+9gpozoQGyEqdFYCpJY6LU
	 4+dzpaEx8x6X/DAbJsyT5RN5FOWex0M04zLI4M+39rLtJkErxc2LMghy36F+js2sVG
	 dTRVuuq/S3n/JGU0MfBWQSwlLxjp+1Y0GU+nsBnwMshHph7NTZACespQ0blkSnQomK
	 cjdiUXcz9EBjH2tnnIIZIjlAw4PLyzrYW6EcWiY78OHJIvVYOzoaGLxAWbaqKhlj7j
	 SbowltqEPXpzA==
Date: Wed, 29 Oct 2025 19:34:32 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 20/28] netlink: Introduce struct
 nft_data_linearize::sizes
Message-ID: <aQJeONBDnSzvjDq3@calendula>
References: <20251023161417.13228-1-phil@nwl.cc>
 <20251023161417.13228-21-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251023161417.13228-21-phil@nwl.cc>

On Thu, Oct 23, 2025 at 06:14:09PM +0200, Phil Sutter wrote:
> This array holds each concat component's actual length in bytes. It is
> crucial because component data is padded to match register lengths and
> if libnftnl has to print data "in reverse" (to print Little Endian
> values byte-by-byte), it will print extra leading zeroes with odd data
> lengths and thus indicate number of printed bytes does no longer
> correctly reflect actual data length.

What patch is the first client for this new field?

> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  include/netlink.h |  1 +
>  src/netlink.c     | 14 ++++++++++----
>  2 files changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/include/netlink.h b/include/netlink.h
> index a762cb485784f..aa25094dc7c1d 100644
> --- a/include/netlink.h
> +++ b/include/netlink.h
> @@ -107,6 +107,7 @@ struct nft_data_linearize {
>  	uint32_t	chain_id;
>  	int		verdict;
>  	uint32_t	byteorder;
> +	uint8_t		sizes[NFT_REG32_COUNT];
>  };
>  
>  struct nft_data_delinearize {
> diff --git a/src/netlink.c b/src/netlink.c
> index 2a4315c691059..9d6cc31e40fb5 100644
> --- a/src/netlink.c
> +++ b/src/netlink.c
> @@ -365,7 +365,7 @@ static void netlink_gen_concat_key(const struct expr *expr,
>  		offset += __netlink_gen_concat_key(expr->flags, i, data + offset);
>  		if (i->byteorder == BYTEORDER_HOST_ENDIAN)
>  			nld->byteorder |= 1 << n;
> -		n++;
> +		nld->sizes[n++] = div_round_up(i->len, BITS_PER_BYTE);
>  	}
>  
>  	nft_data_memcpy(nld, data, len);
> @@ -434,14 +434,14 @@ static void __netlink_gen_concat_expand(const struct expr *expr,
>  		offset += __netlink_gen_concat_data(false, i, data + offset);
>  		if (i->byteorder == BYTEORDER_HOST_ENDIAN)
>  			nld->byteorder |= 1 << n;
> -		n++;
> +		nld->sizes[n++] = div_round_up(i->len, BITS_PER_BYTE);
>  	}
>  
>  	list_for_each_entry(i, &expr_concat(expr)->expressions, list) {
>  		offset += __netlink_gen_concat_data(true, i, data + offset);
>  		if (i->byteorder == BYTEORDER_HOST_ENDIAN)
>  			nld->byteorder |= 1 << n;
> -		n++;
> +		nld->sizes[n++] = div_round_up(i->len, BITS_PER_BYTE);
>  	}
>  
>  	nft_data_memcpy(nld, data, len);
> @@ -465,7 +465,7 @@ static void __netlink_gen_concat(const struct expr *expr,
>  		offset += __netlink_gen_concat_data(expr->flags, i, data + offset);
>  		if (i->byteorder == BYTEORDER_HOST_ENDIAN)
>  			nld->byteorder |= 1 << n;
> -		n++;
> +		nld->sizes[n++] = div_round_up(i->len, BITS_PER_BYTE);
>  	}
>  
>  	nft_data_memcpy(nld, data, len);
> @@ -541,6 +541,8 @@ static void netlink_gen_range(const struct expr *expr,
>  	offset = netlink_export_pad(data, expr->left->value, expr->left);
>  	netlink_export_pad(data + offset, expr->right->value, expr->right);
>  	nft_data_memcpy(nld, data, len);
> +	nld->sizes[0] = div_round_up(expr->left->len, BITS_PER_BYTE);
> +	nld->sizes[1] = div_round_up(expr->right->len, BITS_PER_BYTE);
>  }
>  
>  static void netlink_gen_range_value(const struct expr *expr,
> @@ -557,6 +559,8 @@ static void netlink_gen_range_value(const struct expr *expr,
>  	offset = netlink_export_pad(data, expr->range.low, expr);
>  	netlink_export_pad(data + offset, expr->range.high, expr);
>  	nft_data_memcpy(nld, data, len);
> +	nld->sizes[0] = div_round_up(expr->len, BITS_PER_BYTE);
> +	nld->sizes[1] = nld->sizes[0];
>  }
>  
>  static void netlink_gen_prefix(const struct expr *expr,
> @@ -577,6 +581,8 @@ static void netlink_gen_prefix(const struct expr *expr,
>  	mpz_clear(v);
>  
>  	nft_data_memcpy(nld, data, len);
> +	nld->sizes[0] = div_round_up(expr->prefix->len, BITS_PER_BYTE);
> +	nld->sizes[1] = nld->sizes[0];
>  }
>  
>  static void netlink_gen_key(const struct expr *expr,
> -- 
> 2.51.0
> 
