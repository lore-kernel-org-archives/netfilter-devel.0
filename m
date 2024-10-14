Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A789D154C15
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Oct 2024 09:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728896837; cv=none; b=ms/UT0X9GE/POecMn6MRQdVg8mw4lmaZuBSlzrn1Ko9wP5AVK9IOBKkmNDcR3Jl1Huzs4x+wsoaZ3ZF+retbU/3Bdca7u6X0jpbRSKBXGq5f5ZQKUE54B/Z9gF8QLW1LSEmqopgDfwhxwmmmlzwg1n1gv5s5TYTHCYUIEEhyt/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728896837; c=relaxed/simple;
	bh=7Ucxkd0zRdLB8CcU3r14FGGiy9qsvqB71slVgllHAeM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mBr9zxuvw/VBAaxtNxnUXIrQ7z7ujmGSWR9RRceeAAzBLE7G7bdaizIyBa9WTGZTEqobiSzVBqUuwy3BKzCNNajpP0bWjUbqetevqf+Bx2yDZFwmOnUMcrB/Z7lvumzzsp9vf53zB6JRFkYeSMZwaTrBWMzC+Owjn1CW+HBmND0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=ZMGaPpjY; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="ZMGaPpjY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=e7j3PcF37NyIZyISWxpWBI3GVEoQ5UZkW4iredk1VJc=; b=ZMGaPpjYHOR8nPpDoHaIA8Mu6E
	48cZpHymDzRUL4wFeGTxVJgLtI3PbuHAiF/E8vwt+It2n37tmNh0fQIJi1DEcXUtuzRRLXpZSuGH0
	MWrQGZEN4bqWHBydFOJRKEHDNdgdDSzOzkd0FSndRqaRd/hIK5dzjzI8FYT3SXNzYpgWmXIkm+tcG
	9QemmB6ZU1IT8cSkm2yn2i2R2LDMpnZNxGWZHX/zfWhEQBM4E6/+RG981Em8sOJ7Z2AkjlJq2xroX
	xxt7ANcNIStcjn2iM+VtDlGa+yLcMrz035t7qp2G3u/KzkuyBiYwp3dYlLspY9YK4DJWFXDuXTgiU
	BW3MVOyg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t0H2n-0000000068E-1TfB;
	Mon, 14 Oct 2024 11:07:13 +0200
Date: Mon, 14 Oct 2024 11:07:13 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, petrm@nvidia.com, danieller@nvidia.com,
	mlxsw@nvidia.com, kuba@kernel.org
Subject: Re: [PATCH libmnl,v2] attr: expand mnl_attr_get_uint() documentation
Message-ID: <ZwzfQa_oxe-DjHBA@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, petrm@nvidia.com,
	danieller@nvidia.com, mlxsw@nvidia.com, kuba@kernel.org
References: <20241013194319.3703-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241013194319.3703-1-pablo@netfilter.org>

On Sun, Oct 13, 2024 at 09:43:19PM +0200, Pablo Neira Ayuso wrote:
> This function is modelled after rta_getattr_uint() in libnetlink to fetch the
> netlink attribute payload of NLA_UINT, although it was extended to make it
> universal for 8-bit, 16-bit, 32-bit and 64-bit integers.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> v2: fix reference to bytes instead of bits per Phil Sutter.
> 
>  src/attr.c | 19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/src/attr.c b/src/attr.c
> index 399318eebaa8..20e99b195ab7 100644
> --- a/src/attr.c
> +++ b/src/attr.c
> @@ -393,7 +393,24 @@ EXPORT_SYMBOL uint64_t mnl_attr_get_u64(const struct nlattr *attr)
>   * mnl_attr_get_uint - returns 64-bit unsigned integer attribute.
>   * \param attr pointer to netlink attribute
>   *
> - * This function returns the 64-bit value of the attribute payload.
> + * This helper function reads the variable-length netlink attribute NLA_UINT
> + * that provides a 32-bit or 64-bit integer payload. Its use is recommended only
> + * in these cases.
> + *
> + * Recommended validation for NLA_UINT is:
> + *
> + * \verbatim
> +	if (!mnl_attr_validate(attr, NLA_U32) &&
> +	    !mnl_attr_validate(attr, NLA_U64)) {
> +		perror("mnl_attr_validate");
> +		return MNL_CB_ERROR;
> +	}
> +\endverbatim
> + *
> + * \returns the 64-bit value of the attribute payload. On error, it returns
> + * UINT64_MAX if the length of the netlink attribute is not an 8-bit, 16-bit,
> + * 32-bit and 64-bit integer. Therefore, there is no way to distinguish between
             ~~~

Nit: This should be "or", since the length is expected to be either one
of the listed values.

That aside:

Acked-by: Phil Sutter <phil@nwl.cc>

Thanks!
