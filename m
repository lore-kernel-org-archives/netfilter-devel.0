Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F5241991AE;
	Tue, 28 Jan 2025 23:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738105243; cv=none; b=WMhIlTF8pa4mkOhVGexW90BjcEYF/p4iiNB6y4vEYz20XMd2wpSaiKD30nrPWdqwAicQwbC5qVwH9vC1qijtDnh9cVt2ssjdJhrqNBuZXi6WOTNz6fSqWI+ogcTpQQncphE0rTGDjkEE4bpFVoecDKq8EVvosPHCKME+uqGvSNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738105243; c=relaxed/simple;
	bh=4lrW8B/Ks7dmksUO/r9iAbBxO5SOn/tFewwNmZL0GT0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RlFnuo40YT/SEH1lpY5s7d86k7fMMfbv2IdUuyxoXamMvatBCgjstp6Tk3GW4yCn4luSRtPYO8TuCQeVROz8dlQoW9P91SevMS9NqSCpoPzr6kTmvpDNNF6yqvADHI63JmVyRMq41/XfGtVDgB1PRslNoe47hJCNjnExOFhVKFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=J/G8kirw; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=A0+vP5tV; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="J/G8kirw";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="A0+vP5tV"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 5ECF36029E; Wed, 29 Jan 2025 00:00:38 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1738105238;
	bh=s+ipqSn3PJpkOvV5RX8Pq3oL2ReB/A8vdgVcQ23wwk8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J/G8kirwqp5j0Wtvk71CcmpwMnxra1LcGGI9Ijc5eV0obVa93ywnBeFvCjiq1I9U2
	 Of5CKER3KiLLSJr06zIC1Q33G7PONNafNhOpBwKVbzYS0BJ1/y6RPENpUeFeVrSpr6
	 YZisPOjCYAgw6oupgn6J8IllUQ4nsGYwax0EEcl5R6ZgdMvBAQJDcLwgpyZk6jnU7V
	 DVZzF8Nzaa6CMuIblKHTMFIbjB37LdCWfOqa6COvt2rIcl0K/Ls2gOUrD9Lsw3zOIy
	 IQQ3TrjzvvgqjGAkG61A1E7/nCvRdlMkL5BvLMyWKqtYwhmslX6+ZWXYQf4ds+AsM2
	 pTN/T5ucMapMg==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 4B9D06028C;
	Wed, 29 Jan 2025 00:00:37 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1738105237;
	bh=s+ipqSn3PJpkOvV5RX8Pq3oL2ReB/A8vdgVcQ23wwk8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=A0+vP5tV0wZ71l2uS0Z+utMhSGqpBVhwyiaF+6Efi1qHGnjn5JIU+8bfGlDlvmn3v
	 isFX+4Y1L7sSxs0Ri35CYbsx2qhsfyyX8MNF+p2tETGp5BX9GCpAmxXTsotxi6VshR
	 URzBhxomjoFUAys8cqN/wvDwTN1D0bL2SxwqvHZFLH+0Tu08guLhLCOOGRNThvhWPu
	 4ldjCyIr1OLEok9W03+dJ8WXLqWxfJyf0YhfYQA4JVbB/Ft2ypmN0r8F0S7biItH1y
	 yRjJjAbj6DSzn56k0gO7ruGemk9rK6sJP48/VU7v+zrCqy4MSnxLDTo052ZH+t9/Ud
	 ZDs4KsG4odrOQ==
Date: Wed, 29 Jan 2025 00:00:34 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: nicolas.bouchinet@clip-os.org
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Subject: Re: [PATCH v1 1/9] sysctl: Fixes nf_conntrack_max bounds
Message-ID: <Z5lhkiWI9-nP9O1g@calendula>
References: <20250127142014.37834-1-nicolas.bouchinet@clip-os.org>
 <20250127142014.37834-2-nicolas.bouchinet@clip-os.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250127142014.37834-2-nicolas.bouchinet@clip-os.org>

Hi,

Please, collapse patch 1/9 and 2/9 and post it to
netfilter-devel@vger.kernel.org targeting at the nf-next tree.

Thanks.

On Mon, Jan 27, 2025 at 03:19:58PM +0100, nicolas.bouchinet@clip-os.org wrote:
> From: Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>
> 
> Bound nf_conntrack_max sysctl writings between SYSCTL_ZERO
> and SYSCTL_INT_MAX.
> 
> The proc_handler has thus been updated to proc_dointvec_minmax.
> 
> Signed-off-by: Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>
> ---
>  net/netfilter/nf_conntrack_standalone.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
> index 7d4f0fa8b609d..40ed3ef9cb22d 100644
> --- a/net/netfilter/nf_conntrack_standalone.c
> +++ b/net/netfilter/nf_conntrack_standalone.c
> @@ -619,7 +619,9 @@ static struct ctl_table nf_ct_sysctl_table[] = {
>  		.data		= &nf_conntrack_max,
>  		.maxlen		= sizeof(int),
>  		.mode		= 0644,
> -		.proc_handler	= proc_dointvec,
> +		.proc_handler	= proc_dointvec_minmax,
> +		.extra1		= SYSCTL_ZERO,
> +		.extra2		= SYSCTL_INT_MAX,
>  	},
>  	[NF_SYSCTL_CT_COUNT] = {
>  		.procname	= "nf_conntrack_count",
> @@ -948,7 +950,9 @@ static struct ctl_table nf_ct_netfilter_table[] = {
>  		.data		= &nf_conntrack_max,
>  		.maxlen		= sizeof(int),
>  		.mode		= 0644,
> -		.proc_handler	= proc_dointvec,
> +		.proc_handler	= proc_dointvec_minmax,
> +		.extra1		= SYSCTL_ZERO,
> +		.extra2		= SYSCTL_INT_MAX,
>  	},
>  };
>  
> -- 
> 2.48.1
> 
> 
