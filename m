Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A613F30C359
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Jun 2026 09:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782208108; cv=none; b=CMfRrLjXDNHy/9hEDsLFVUQoE1gjfyy9SNhVIxcTi1jR2ntEw2xEArp8Il8YXmvWwMwvBPwEJp+R9xEg6PiFooJ5FWD9JF7MmLaa0CTvlJ2qsiSn0auo51HhTpINfDjpmobpAdutYfWl4Ae5RsKR9DEx19m7U8gGRm2NrxFrtQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782208108; c=relaxed/simple;
	bh=qhK9z6zKO/RpsbbHtKP9kBwMgR1RXLoNV7pYx38/C4g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C/2OMSIweNryNr+IsbEMzjwRgNsg+QCah0xvpI3+9xK97ccELXsqDzraHCFMvPlKZXapr1MC/2U8qMUpnPhgyopGUkAWJVu4mWEn4rwSysj/gyOqQZTiXqhmMgH2wz7WLK7NFXxHdkHzpPo7HBqfesmJq2KpEwOwdrP0iXx3LfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=alrXHWFV; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="alrXHWFV"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 836EF60193;
	Tue, 23 Jun 2026 11:48:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1782208098;
	bh=pCu1qmnqeaW4lIOT8FVYAKa/gUkBOOHtFXMRdijVI1c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=alrXHWFVpv3v0Jd/DgQ7NmAdlg4Y2Qui0LHGXiiysO1IX45ES1vpxh9npSNrCtd1h
	 2htZTVijuUVTWpbpeC/hmStvxXFFhWBwzwFHm4OgWt2H1HNWUorzTYYGwv6vcKUgNp
	 Vw93eV6iJce9AA0/NFn4Em1beR0KbeDyRj57qCBx+f36aDvnQyRjFIXx6VrUWq61XN
	 mdI/8+L28U15aO6o45HZ/CwLDMcWLtG3Vl0a7JEJ0Z51sEkfYjn6XHkVcaMIa+zPJO
	 siRPK18FLnt/DrLcDA78GwWV9hEjjqsS1LgvzfjKYBHhm3/zd6L7f2lwI82/+7zeaP
	 Vng6zsboxaAvw==
Date: Tue, 23 Jun 2026 11:48:16 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Ratheesh Kannoth <rkannoth@marvell.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] libmnl: add MNL_TYPE_UARR for devlink u64 array
 attributes
Message-ID: <ajpWYAQ1Od2ilpAk@chamomile>
References: <20260623043755.2435685-1-rkannoth@marvell.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260623043755.2435685-1-rkannoth@marvell.com>

On Tue, Jun 23, 2026 at 10:07:55AM +0530, Ratheesh Kannoth wrote:
> Add MNL_TYPE_UARR (129) to enum mnl_attr_data_type to match
> DEVLINK_VAR_ATTR_TYPE_U64_ARRAY in the kernel. That type represents
> devlink param values encoded as a nested list of u64 attributes in
> DEVLINK_ATTR_PARAM_VALUE_DATA, allowing drivers and userspace to
> exchange variable-length u64/u32 arrays (e.g. multi-value devlink params).
> 
> Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
> ---
>  include/libmnl/libmnl.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/libmnl/libmnl.h b/include/libmnl/libmnl.h
> index 0331da7..078d517 100644
> --- a/include/libmnl/libmnl.h
> +++ b/include/libmnl/libmnl.h
> @@ -133,6 +133,7 @@ enum mnl_attr_data_type {
>  	MNL_TYPE_NESTED_COMPAT,
>  	MNL_TYPE_NUL_STRING,
>  	MNL_TYPE_BINARY,
> +	MNL_TYPE_UARR = 129,

Why 129?

>  	MNL_TYPE_MAX,
>  };
>  
> -- 
> 2.43.0
> 
> 
