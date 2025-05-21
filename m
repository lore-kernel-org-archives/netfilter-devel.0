Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E482525B688;
	Wed, 21 May 2025 10:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747822036; cv=none; b=Rd6kGuZI0YOaKhhP7Efua1EUse23TJpSXLBj6fzCLdOqcnLJBr4cBRxe7TUW3mv/UuF19MfMjStAiJaSsVLQCZ0aok2QpurCR3GHyybOtQuMZo4/OA9TXFhpKdWveptzSf1ym5Xr0raV2Xe2a1h+jdMiQ0AbMTFDCPq+mXETSPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747822036; c=relaxed/simple;
	bh=S5Z4lpB+PVEMLATY/9LtfcmptgY13HExZPi6ZL1tZ9I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WOIc/X3aCGBguGv3Jsc5pN09rg8no+GAnDAgrJZJ172suYWVyoHjUttJfQlN+jNpsZQTeciGBVKva4pf+FOSPit7ISaf9oNcUjTjn9M8bYo851icOEkyfFJo4Lh4mvsErmBFZZA45RgfeJcT7LwndJn8bwZLMmT2hUVmBAw9SVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=m55KzAKi; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=RYAiDCX2; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="m55KzAKi";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="RYAiDCX2"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id BB40C60724; Wed, 21 May 2025 12:07:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747822031;
	bh=FCKLw1/BI8fQGqiFzPRPzkBL4jrZBBv292m0Eoh2Ad8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=m55KzAKirQEN2JgIW0IxRi4qNm2RpFBITJ4UCGcsunYkwREFnWb+2PcC4GfTTg5hg
	 rBcCYGyaj5YTUHtDNnH4Ok0YHtPVBcYnlv1eFMSRJBnaIth86s74tnYNn9YOhmDLCZ
	 Xhn4OHGggu2skk2uj4DGu1lN65iHe/obg5jXNWCrAkkbNICmbHUA1fYHK/XlkWglSe
	 ufLjV3nagZdS7+P/5hEX/bhIFMNN+DEQ+B0p+b+DLENyy2eGvPlK7qGcl0n9/pYU6T
	 gsJyfBUzTVly5HW1xOjLRNCRzSljJ9VFPbtw/jWGqcqYZgprZOkCyVoHkGP2jLWFjh
	 kjwznBXzIZ9AQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 4537C606ED;
	Wed, 21 May 2025 12:07:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747822028;
	bh=FCKLw1/BI8fQGqiFzPRPzkBL4jrZBBv292m0Eoh2Ad8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RYAiDCX2OcSSzxyuBAls8SzlhXb1m5VY+qAabqz3ZwGb/StUlrOsNnyyX77Wq4ldu
	 MZBPnqMfeqh0+e605adkl6cUWwc2+741hOBZAQNufbNrOXKAVoW7bhs3+tS2md3Ryn
	 c3Z6QT6hVzl60hyMNn3gj/nQEBXFSFq3C3RInYGK/YeQbAl5mRXq9J/v/UOpbYdz0T
	 MVi0BHncJsV3I9OCUFyNRWjlZw1z/29HCUbWMKB+wcjJuhZCTBH/V+wOUYjSjzVv6f
	 sVAF4wxT14R2Zpehp6356fc6156xag3KpLpHUmrqt/22y2dcQbO4a44yyOem5cKHAZ
	 u4lVeki4xC0IQ==
Date: Wed, 21 May 2025 12:07:05 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Lance Yang <ioworker0@gmail.com>
Cc: kadlec@netfilter.org, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
	coreteam@netfilter.org, linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org, Zi Li <zi.li@linux.dev>,
	Lance Yang <lance.yang@linux.dev>, fw@strlen.de
Subject: Re: [RESEND PATCH 1/1] netfilter: load nf_log_syslog on enabling
 nf_conntrack_log_invalid
Message-ID: <aC2lyYN72raND8S0@calendula>
References: <20250514053751.2271-1-lance.yang@linux.dev>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250514053751.2271-1-lance.yang@linux.dev>

Hi,

Cc: Florian Westphal.

On Wed, May 14, 2025 at 01:37:51PM +0800, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
> 
> When nf_log_syslog is not loaded, nf_conntrack_log_invalid fails to log
> invalid packets, leaving users unaware of actual invalid traffic. Improve
> this by loading nf_log_syslog, similar to how 'iptables -I FORWARD 1 -m
> conntrack --ctstate INVALID -j LOG' triggers it.

I have been beaten by this usability issue in the past, it happens
since conntrack is loaded on demand.

Maybe add an inconditionally soft dependency? This is a oneliner patch.

        MODULE_SOFTDEP("pre: nf_log_syslog");

Florian, do you prefer this patch (on-demand) or a oneliner to load
this module when conntrack gets loaded too?

It is a bit more memory to make it inconditional, but better to expose
to users this soft dependency via lsmod.

Thanks.

> Signed-off-by: Zi Li <zi.li@linux.dev>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
>  net/netfilter/nf_conntrack_standalone.c | 20 +++++++++++++++++++-
>  1 file changed, 19 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
> index 2f666751c7e7..b4acff01088f 100644
> --- a/net/netfilter/nf_conntrack_standalone.c
> +++ b/net/netfilter/nf_conntrack_standalone.c
> @@ -543,6 +543,24 @@ nf_conntrack_hash_sysctl(const struct ctl_table *table, int write,
>  	return ret;
>  }
>  
> +static int
> +nf_conntrack_log_invalid_sysctl(const struct ctl_table *table, int write,
> +				void *buffer, size_t *lenp, loff_t *ppos)
> +{
> +	int ret;
> +
> +	ret = proc_dou8vec_minmax(table, write, buffer, lenp, ppos);
> +	if (ret < 0 || !write)
> +		return ret;
> +
> +	if (*(u8 *)table->data == 0)
> +		return ret;
> +
> +	request_module("%s", "nf_log_syslog");
> +
> +	return ret;
> +}
> +
>  static struct ctl_table_header *nf_ct_netfilter_header;
>  
>  enum nf_ct_sysctl_index {
> @@ -649,7 +667,7 @@ static struct ctl_table nf_ct_sysctl_table[] = {
>  		.data		= &init_net.ct.sysctl_log_invalid,
>  		.maxlen		= sizeof(u8),
>  		.mode		= 0644,
> -		.proc_handler	= proc_dou8vec_minmax,
> +		.proc_handler	= nf_conntrack_log_invalid_sysctl,
>  	},
>  	[NF_SYSCTL_CT_EXPECT_MAX] = {
>  		.procname	= "nf_conntrack_expect_max",
> -- 
> 2.49.0
> 
