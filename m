Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594014A014B
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Sep 2026 18:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789582968; cv=none; b=UgVSxswiAZ0lmAf/SUaKGU3RaC8G0wLEaV9u+b7LvoOoLCqsKRV44w8MAoWRTccggWbO0sRTp8Y0Bimtw0zYIFr4ZUWyHTxqm5VuHRGf9hn7GI/B/1713dswZmVDDlvhOqdkcX7ByCkn2VkZAmIF7/5Cz6oTGCnjWfZnrK5lNjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789582968; c=relaxed/simple;
	bh=qKwjCG6U9UM8qIs0cJwmBOwdSsCWkai9eduprNRFVa8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I9Anz+pT3Q23CPrk3R6MfNgKoEGVZxMft7tiiAHbBxFhCVBO3hEUzlFJu0Feoab7cjQ6eYHW67Lo2RhDQ4hClwON9wNSWqrsENkctIP8GgW09leJgwasnU+XQ9r4K5BQ/6delLWHAPCMWYBBXC4DtFzlGuDPtWmEJemFiSSGf2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=elkFqQGE; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="elkFqQGE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789582951;
	bh=mI2zh/U+XeY4H6YJAFT+q2Ly0tWBGT8hA7RhuuKmxLY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=elkFqQGES7jf2pnz3XoMmg4eqHsIQEy0/WrYjpuRaXoLWYbzgtfa6h1LPJQQEumO+
	 SXYPfY0E8ZXawUTnZctCsA9ooxksGrKInyi5QEzG1SdOmw4FcYsmUp3jP3oyz+0oy/
	 hcRuapsPOjoIlBbF43Nd5+VcoFh/Jrr+4PmfOC5Cggj+Cb4vNCAux2oFbWzUH6hMU/
	 7FwfdNLkiqJ9ftia9MIVMoGor+X5sSw3MCxseGfOrfnYvHOQGjFoS2Rhfh8PkJwGsz
	 +kVVrBLu+sE0iuLW+9pkmk75tL4fn1r5fcl++C8lOtEBKDTKR3Sfg23k9ZXlSns9Zw
	 EhT6r/0j1fucw==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 82EA260055;
	Wed, 16 Sep 2026 20:22:31 +0200 (CEST)
Date: Wed, 16 Sep 2026 20:22:28 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Shaojie Sun <sunshaojie@kylinos.cn>
Cc: Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] netfilter: conntrack: fix nf_conntrack_expect_max
 default value in documentation
Message-ID: <aqreZOGHlFJfrZYd@chamomile>
References: <20260820125718.1027116-1-sunshaojie@kylinos.cn>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260820125718.1027116-1-sunshaojie@kylinos.cn>

On Thu, Aug 20, 2026 at 08:57:18PM +0800, Shaojie Sun wrote:
> The documentation for nf_conntrack_expect_max incorrectly states that the
> default value is nf_conntrack_buckets / 256. However, the code in
> nf_conntrack_expect_init() shows:
> 
>     nf_ct_expect_hsize = nf_conntrack_htable_size / 256;
>     nf_ct_expect_max = nf_ct_expect_hsize * 4;
> 
> This means the default value is actually nf_conntrack_buckets / 64
> (i.e. 4 times the hash table size, which defaults to
> nf_conntrack_buckets / 256).
> 
> Fix the documentation to reflect the correct default value and add
> explanation of the calculation.
> 
> Signed-off-by: Shaojie Sun <sunshaojie@kylinos.cn>
> ---
>  Documentation/networking/nf_conntrack-sysctl.rst | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/networking/nf_conntrack-sysctl.rst b/Documentation/networking/nf_conntrack-sysctl.rst
> index 35f889259fcd..77521253fe22 100644
> --- a/Documentation/networking/nf_conntrack-sysctl.rst
> +++ b/Documentation/networking/nf_conntrack-sysctl.rst
> @@ -44,7 +44,8 @@ nf_conntrack_events - BOOLEAN
>  
>  nf_conntrack_expect_max - INTEGER
>  	Maximum size of expectation table.  Default value is
> -	nf_conntrack_buckets / 256. Minimum is 1.
> +	nf_conntrack_buckets / 64 (i.e. 4 times the hash table size,
> +	which defaults to nf_conntrack_buckets / 256). Minimum is 1.

I'd suggest to remove the parens explaination here.

>  
>  nf_conntrack_frag6_high_thresh - INTEGER
>  	default 262144
> -- 
> 2.50.1
> 
