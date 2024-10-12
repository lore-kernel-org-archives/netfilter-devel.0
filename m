Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E25722564
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Oct 2024 22:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728773912; cv=none; b=d/IYOIccnPU/kgn9THYhWZVK+xwcsmAb6elBo3fisey+mXcgUF4YzVsFBdVscXt4NEeQSI0DelrsAiYyBCa/nG1NDoA9XOD6UmUMKSqBgFgpaK4mkkMdYpr3GVs/jsGSO+ZmBMx52G236LYaInWN71F1HbmsWKQ8IH3Y3+I2I+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728773912; c=relaxed/simple;
	bh=vhiow9m1XtTtwUCZ7XHB3mYTKlTLc7sDyJnX4vbRXVk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FHWhdjPcOpgmk6I0xioHoA381U4DWQ+FhNa4flOAt3ji5v7GKYZdWwlNWIOy+bVlAGF0er/57a7JTs7tH2bhkUKe8LArdAqbG5satN2K+/DHooyxnMqvKxSAE+qYdN7pDEX7EYkmHVZT7yYIv85OdG7ePmAa+BSUxwBgYxacXSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=laQ1HFik; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="laQ1HFik"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=DEjoLRKEZfCnqdJmjnH9rIRPH0VsHO7RS/GGIGVa/gY=; b=laQ1HFikk6WCnQfxS1CzAp8ZNT
	cDuImr/yQDOrR7d5l7TjtKwMwZcEjy+yo04HT0q/imFAhOuQ5odV95ISJPwKBCYsP4+cqZMPqrVs+
	J8tvZWvjV5hAxawegi/bWhKKQF6H4mF3YomzJhVwOmWLiUQpbwbKcXHx8AQopMrGRc8ykOgQvTkST
	dlD2+6AfpGCDjt9TtxTVS1ua5SbXOoS2y/cwOnnOPUjKCTtQRSIMHMMCl/rF1PnxvS5J1nINci+3k
	CrHF8DyfgUCr5Y9vtDRz3Gp/7HdYYkMQ6JoEM3X1yATNrMg97CYuNHCC0m1uzBxOq9BUyuvi8n4WH
	DvIP0PNQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1szl46-000000004C5-1A6O;
	Sun, 13 Oct 2024 00:58:26 +0200
Date: Sun, 13 Oct 2024 00:58:26 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, petrm@nvidia.com, danieller@nvidia.com,
	mlxsw@nvidia.com, kuba@kernel.org
Subject: Re: [PATCH libmnl] attr: expand mnl_attr_get_uint() documentation
Message-ID: <Zwr_EhpLQoNdEaNF@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, petrm@nvidia.com,
	danieller@nvidia.com, mlxsw@nvidia.com, kuba@kernel.org
References: <20241012222725.55023-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241012222725.55023-1-pablo@netfilter.org>

On Sun, Oct 13, 2024 at 12:27:25AM +0200, Pablo Neira Ayuso wrote:
> This function is modelled after rta_getattr_uint() in libnetlink to fetch the
> netlink attribute payload of NLA_UINT, although it was extended to make it
> universal for 2^3..2^6 byte integers.
                         ~~~~
This should be bits, not bytes.

> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  src/attr.c | 19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/src/attr.c b/src/attr.c
> index 399318eebaa8..afabe5fbc8d9 100644
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
> + * UINT64_MAX if the length of the netlink attribute is not 2^3..2^6 bytes.
                                                                        ~~~~~
Same here.

Apart from that, LGTM!

Cheers, Phil
