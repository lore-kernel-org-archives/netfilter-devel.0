Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F51E2E06C3
	for <netfilter-devel@vger.kernel.org>; Mon, 25 Aug 2025 11:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756121318; cv=none; b=WqRTd+GMH5eOsUJzPbPhNCWKlzSmjIyXkRgX5OOz9iBXZCwAVv20PmB6sskxlkOA8fV7KOAUVespQkWxFsLngo0gtUYb3qVjxOhWKMxCkgAN6qvFPNdIOxXLnBMkUMpVm+BzjqA/t5tlptwnVSpUmiKnPk+AxuQpUEgoWVbNFa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756121318; c=relaxed/simple;
	bh=3ugyLXrOC7tUNzeBrHp8Jw091H6GdXeo+1JKjhL2y4Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h1hp+e7ObLlXlFvxAxLQnyEpVTZ1NLt4aW3FVrrAekhY+s/LbSZt/765MEqBn/YoUdzCErgBAzDhtKyFH66jqJq4S1XewN3JFNZPW15nMYJO024T5T9adn47U0g2oRstehLg+8hetAOzqVIUb5AQSNA0ADlBW6q33QrbnKlnktg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=FUL6fCVB; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=FUL6fCVB; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="FUL6fCVB";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="FUL6fCVB"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 88A7860262; Mon, 25 Aug 2025 13:28:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756121313;
	bh=Uod0Yqa/4GjRg2GOEN523pB7JpcLy6hMziAefxJNFus=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FUL6fCVBbRMJqw7Zwx0DfE2H5k63k1GVYbgpmsntzxMxYo2CrwytSvaKWJ42/4zuq
	 +tZ6cPXpLgiAeqHiq82OP9nf4Ei5OhA9u4PT7zADVrxlOtYLHQ7UV3JW86d40w2L1Z
	 FVKXOXkIF/5MIjIug1GJaT+U45d4Ya+4lIQZRulZExMajkHS/NvUIeHatvQEU3U80Q
	 DzgpjeoxHN7772p+9v94Lw2M/wE+LvasvndWvuBk6POE3BfiLBSfQi8MU7/BnHIAp/
	 69jQfDcBQePsSzPl+p7Ovyxx4+tXnOnrcMtSJ2SNXzKsnShD613elCH75PAQWS+8Ta
	 9yyY2r8AEEhww==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D328E60262;
	Mon, 25 Aug 2025 13:28:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756121313;
	bh=Uod0Yqa/4GjRg2GOEN523pB7JpcLy6hMziAefxJNFus=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FUL6fCVBbRMJqw7Zwx0DfE2H5k63k1GVYbgpmsntzxMxYo2CrwytSvaKWJ42/4zuq
	 +tZ6cPXpLgiAeqHiq82OP9nf4Ei5OhA9u4PT7zADVrxlOtYLHQ7UV3JW86d40w2L1Z
	 FVKXOXkIF/5MIjIug1GJaT+U45d4Ya+4lIQZRulZExMajkHS/NvUIeHatvQEU3U80Q
	 DzgpjeoxHN7772p+9v94Lw2M/wE+LvasvndWvuBk6POE3BfiLBSfQi8MU7/BnHIAp/
	 69jQfDcBQePsSzPl+p7Ovyxx4+tXnOnrcMtSJ2SNXzKsnShD613elCH75PAQWS+8Ta
	 9yyY2r8AEEhww==
Date: Mon, 25 Aug 2025 13:28:30 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH xtables] man: iptables-restore.8: document flush
 behaviour for user-defined chains
Message-ID: <aKxI3nRyAVy3N_5I@calendula>
References: <20250825090743.12198-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250825090743.12198-1-fw@strlen.de>

On Mon, Aug 25, 2025 at 11:07:35AM +0200, Florian Westphal wrote:
> There is no way we can change this after two decades.
> Add an example and document that declaring a user defined chain
> will flush its contents in --noflush mode.
> 
> Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1242
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks.

> ---
>  iptables/iptables-restore.8.in | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/iptables/iptables-restore.8.in b/iptables/iptables-restore.8.in
> index df61b2a623f6..abf8d6decc27 100644
> --- a/iptables/iptables-restore.8.in
> +++ b/iptables/iptables-restore.8.in
> @@ -48,6 +48,20 @@ Print a short option summary.
>  \fB\-n\fR, \fB\-\-noflush\fR
>  Don't flush the previous contents of the table. If not specified,
>  both commands flush (delete) all previous contents of the respective table.
> +Note that this option will flush user-defined chains if they are declared.
> +Example:
> +.P
> +.in +4n
> +.EX
> +*filter
> +:FILTERS - [0:0]
> +-A FILTERS ...
> +.EE
> +
> +will flush and re-build the FILTERS chain from scratch,
> +while retaining the content of all other chains in the table.
> +.in
> +.P
>  .TP
>  \fB\-t\fP, \fB\-\-test\fP
>  Only parse and construct the ruleset, but do not commit it.
> -- 
> 2.51.0
> 
> 
