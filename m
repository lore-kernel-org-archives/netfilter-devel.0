Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B40B2FC890
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Oct 2025 18:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761763050; cv=none; b=Lrl1VBjljHpDMFT/24lA1nOpukJl0XvCerr+e+N3FTnVbgAxKYOoFGQn+Bhtg8HPSnYDYbBU/orMJp141uq2wFAtryE9Ph/zNOAadZvka38fEmsV/mLrbZzplIESD5yIvJhF2R7RXhfkAcD6n+xxoWaEP9qZi+yc6MslyRAM5Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761763050; c=relaxed/simple;
	bh=KanVw3XDllINaJJr/Fo4/3U+IvsZZq2fTTi7pgUdCmU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eQ/77oT0OCnJ3fJ8OBL6GjvEByHkP4UeB+nIZ8M+ECw9gWUHuC45JWzG8uIqDO5pFSIZEwjatkFJhIeQrKZfiCyNenUJGIqvmpAOXXggw6cnLG9f+5I5xqcf+YofbSNfi/Ao98OXg14tw+948V02v4rz+vGdQodtF+YXQZF+R9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=vCcQbpA3; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="vCcQbpA3"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 7B79760281;
	Wed, 29 Oct 2025 19:37:26 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1761763046;
	bh=8ruHwOnyIyXHLCufwj8ZIgI3qm9Qynsc7OyVX1KPiNA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vCcQbpA3GQO4b3vQB9kvComV2Fhp7SMbJYa1GIZmBEQjpXJc1I8k0ww+DjUqTLj9Q
	 yw4Q+O2QrfbnivUPR4dUmuXjhoSk4bvMiO687jZwIE7yqWP8qe+XnC3oyDlq31nMCC
	 dqmlewd75heRlibMUoCQQjt/KbN4OzaNg5mItlOkAdcBVnZDevSiDl89Ex8tVe+OnC
	 +Gf9RhjifBQ63b1EsUUArrCBmH1kx4gKHh4LGvFTGxpaKMciwr4OH67jsIFCfTtfks
	 fb203L3Jr5rusxMhZttoHxLz/qYkZ+c9sNIR8Pkcm72oISQU++U6pXxJ2+jxG/nW4g
	 w3eZZSnF0M8zQ==
Date: Wed, 29 Oct 2025 19:37:23 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 12/28] netlink: Zero nft_data_linearize objects when
 populating
Message-ID: <aQJe44ks8cDYQcBC@calendula>
References: <20251023161417.13228-1-phil@nwl.cc>
 <20251023161417.13228-13-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251023161417.13228-13-phil@nwl.cc>

On Thu, Oct 23, 2025 at 06:14:01PM +0200, Phil Sutter wrote:
> Callers of netlink_gen_{key,data}() pass an uninitialized auto-variable,
> avoid misinterpreting garbage in fields "left blank".

Is this a safety improvement or fixing something you have observed?

> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  src/netlink.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/src/netlink.c b/src/netlink.c
> index 7882381ebd389..3258f9ab9056e 100644
> --- a/src/netlink.c
> +++ b/src/netlink.c
> @@ -563,6 +563,8 @@ static void netlink_gen_prefix(const struct expr *expr,
>  static void netlink_gen_key(const struct expr *expr,
>  			    struct nft_data_linearize *data)
>  {
> +	memset(data, 0, sizeof(*data));
> +
>  	switch (expr->etype) {
>  	case EXPR_VALUE:
>  		return netlink_gen_constant_data(expr, data);
> @@ -580,6 +582,8 @@ static void netlink_gen_key(const struct expr *expr,
>  static void __netlink_gen_data(const struct expr *expr,
>  			       struct nft_data_linearize *data, bool expand)
>  {
> +	memset(data, 0, sizeof(*data));
> +
>  	switch (expr->etype) {
>  	case EXPR_VALUE:
>  		return netlink_gen_constant_data(expr, data);
> -- 
> 2.51.0
> 
> 
