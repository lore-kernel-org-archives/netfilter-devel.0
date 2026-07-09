Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2597409631
	for <netfilter-devel@vger.kernel.org>; Thu,  9 Jul 2026 11:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783596522; cv=none; b=MxrGx39F488MQBS5yRISOjmwfsGNnx+JHwIJFKNnsNrc54VscHS0dfSbdY2x8BaF+AZtJiKZGqssNVC02vkU0Z3ADPenwVtQR0UD/xYTdyQ0ikAXrg+PCI8a/qQMqLt/UXnXBnWMriA4yrk0tFMrRL4h+mPZOX311DVpHgR+jgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783596522; c=relaxed/simple;
	bh=F6oemxPG6PEgQ9iR5P7rfWM6JzOC6u1d9X4bfcMeUoM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UmwxBxphTKe81H0XxTcO9uT4sqdoaCI9KkTYXy+JSM3G3BQUzeigmM454b80yOvm+IxhEnm7JlXLlaXRrJQxQreQgD9sWp2Uc17bpgGrM7lhVFJLeqBZLz+/fDeHA7HxpmTYr0SVHW1pbYxVk0MXZBJHq6auPT21u1A4p5fUpP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=an5bK1Sc; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="an5bK1Sc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=9gJmsq+V4DMPgCeNWDopDjW8sG7rW+mhAOc+hVHrkI4=; b=an5bK1ScSO0C5ZOxJafP/5PmU4
	xq+8jn2v09v3QxFX6eQYZ+4zD3vntpDzrQdZwst8moSevBLbYXmm77+xz6Ax3lS9UTZDug9srAjV1
	WOruMw2oklgzYaaitvKVpskco3oQuM0dHg0zSY4561Km7s9eJtWP4D3qefB1dR1eu/rb88StQSW7y
	n/1ojIXO7jyIgOdNEoWuIXKDVBRNMO/e3jgeFAbTG2hPUrB9EETVI4Eg55Kq5y/W9fW0d3lOVvAxR
	joz66IOzC0xFph+Fi7i1zKXiQcO9SEEvioWYocd4ErTMb72U7ky0fCsS0NRZhQcofudRKLX3LvF2q
	lG9q+VMw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1whmvn-000000004yf-0Tvi;
	Thu, 09 Jul 2026 13:28:39 +0200
Date: Thu, 9 Jul 2026 13:28:39 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [nf-next PATCH 4/4] netfilter: nfnetlink_hook: Fix for
 concurrent NAT hooks dump and change
Message-ID: <ak-F5wxDnAQ8qfYU@orbyte.nwl.cc>
References: <20260708161940.1477671-1-phil@nwl.cc>
 <20260708161940.1477671-5-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260708161940.1477671-5-phil@nwl.cc>

On Wed, Jul 08, 2026 at 06:19:40PM +0200, Phil Sutter wrote:
[...]
> diff --git a/net/netfilter/nfnetlink_hook.c b/net/netfilter/nfnetlink_hook.c
> index 0657fbb3e605..e01e59eddd64 100644
> --- a/net/netfilter/nfnetlink_hook.c
> +++ b/net/netfilter/nfnetlink_hook.c
[...]
> @@ -361,8 +371,10 @@ static int nfnl_hook_dump_nat(struct sk_buff *nlskb,
>  			break;
>  	}
>  
> -	if (!err)
> +	if (!err) {
> +		ctx->natv = 0

There's a typo here (missing semi-colon), kindly spotted by kernel test
robot. I'll send a v2 once it has cooled down a bit.

Sorry, Phil
