Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB5F19D886
	for <netfilter-devel@vger.kernel.org>; Tue, 13 Aug 2024 14:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723559954; cv=none; b=m3hZiRZQjySs+aIU3XgogWd/OIwzZfkcBS2GOZT+byTYZD7kaj+oTq381JX/fPZI/2s0zSRWNcMdDovikb3LXoNHe/17knhzlcYzHpg/7pnzB6NDT26TVddnqOdAc5hs/Yz2rgOdiCl72Psq+2f8YF5cEMkKwKuAZIUbn6pOQnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723559954; c=relaxed/simple;
	bh=L6WYcDBSRJQLnjZiUFbHg2uTBWqkTK2u9Vwzs7ftnFE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qd3WUqP8VW+OLwxFopFDynfgdhlXVwsC2KN6goKzjphVWBNyn7Z2eTWN+0ocP1HvwC9lsgCs2q2C68FM/AXzBif/K5jJ8vPw0aC0IgN5gOHjNFI9DZH+W/hJ76nOB+/Kxr0qsFuNFvH4k0s3CwYL7QyGG/Pa5uFHTl58T+MXzjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=jXczJAp4; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="jXczJAp4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=baw7Oca3iyrUf2QwEGQsEZDIzYkvdFGQVqIE4BqoC/k=; b=jXczJAp49+/dKmDAu3RTH15x/r
	ofB5JoGLy2ZPd8C3Ts3EOyeGlY5SXd89ZpalvnH3TNZqKcqeOp8u4YXCGB0ls/YqTyFUPMCFp18Vn
	QQzCZOrRcOJ5GkIKGOK90Tkyf/1kUwrVWwJFHurivVPNkL1v+AlLx9IHOc3LE2ySGVsZcQm+53l+J
	lR5Uds8N0+IAQeTPNLEYDgGofRAqUcfDcJNzZzN8wwFHaHfkCxKEOt3Jwp9pDTR6w0LjJioqma9/Y
	xt8EVU/Fcv6KffTUUkHZbv7q8Y8qMX3Ud0sCoQK9GMl8E3pUSH01fXyCSow8KENCGf7uCzP2TMdTN
	9JunxVqw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sdsg1-000000002k6-1UzQ;
	Tue, 13 Aug 2024 16:39:09 +0200
Date: Tue, 13 Aug 2024 16:39:09 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 1/8] netfilter: nf_tables: elements with timeout
 less than HZ/10 never expire
Message-ID: <ZrtwDSyF5VXPqVtD@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20240807142357.90493-1-pablo@netfilter.org>
 <20240807142357.90493-2-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240807142357.90493-2-pablo@netfilter.org>

Hi Pablo,

On Wed, Aug 07, 2024 at 04:23:50PM +0200, Pablo Neira Ayuso wrote:
> Elements with less than HZ/10 milliseconds timeout never expire because
> the element timeout extension is not allocated given that
> nf_msecs_to_jiffies64() returns 0. Round up this timeout to HZ/10 to let
> them time out.
> 
> Fixes: 8e1102d5a159 ("netfilter: nf_tables: support timeouts larger than 23 days")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/netfilter/nf_tables_api.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 481ee78e77bc..0fb8f8f1ef66 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -4586,6 +4586,9 @@ int nf_msecs_to_jiffies64(const struct nlattr *nla, u64 *result)
>  	if (ms >= max)
>  		return -ERANGE;
>  
> +	if (ms < HZ/10)
> +		ms = HZ/10;
> +

This lower boundary works for HZ=100 only, right? With HZ=1000, the
mininum timeout is calculated to 100ms, but the kernel ticks once per ms
so 1ms is exactly 1 jiffie.

>  	ms *= NSEC_PER_MSEC;
>  	*result = nsecs_to_jiffies64(ms);

Why not simply sanitize *result? E.g. like so:

|	*result = nsecs_to_jiffies64(ms) ?: !!ms;

Cheers, Phil
