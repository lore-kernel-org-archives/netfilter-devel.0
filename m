Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6606E5684
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Mar 2025 00:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741738550; cv=none; b=iMAwOn5pYN/B1Vm/ESYCYuexSt7VXnVDOvTj1QWnEJzY/EHooXNcj/AltKHV8iVY6oAJhHv2Iwa7cUSWNCgaNWbx5P5X7tQqb1CwrR5o2b3pdLmYAjjyo/FPNgIqVcVgQQl8hYZVxKnF+LB51BXB6qg3DRO8J55fJYdjmf8o8Fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741738550; c=relaxed/simple;
	bh=R5x7cLBoMe47wdDLMVibWEbBDYmMbfBucJlj5DLcyZY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p7UnIEoPyVY6TrlH1RImK+DXLebgSj9uTB2bnm22Q89tNjnxqq2w2eXMKtMM3nn7I2W+s4VDx+iFLkgk4IrRgp5pmlzKhW2rdIn9N1y5e6iroDG7CyXaVxnYMfrZXQ/lL7T4Spy8njO1dcBY2N43qUDy2gmcWf4OeY1Wm0gIZfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=tbmQzmiN; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=tbmQzmiN; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="tbmQzmiN";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="tbmQzmiN"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 918596028A; Wed, 12 Mar 2025 01:15:46 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741738546;
	bh=IvyS6B9hedwRU7n3jEyvD9iJYecBrj4hF1ESQTG0vBI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tbmQzmiNAZP3Yh+pTXL6M7dMaD3wAL0N2JsBS+k1+MmdlMOySEJrqdanXjf1JmCE/
	 evrDEmnUUnAaf9+oeBtcOSeaeqYZdq9WXNmmtSEHeQK7pHGB5MmcuNpIZAcjjJikhA
	 1UHOp2SxP8Uw1V2w/qOTDN1NTLBZoedLbKPuHVs7pJzwk3/9MqtLledVJiaAt3DzX1
	 OqQoTg6e7blSCxwBRpQ27ANuyoDCmJuCcHpGwaukmaQspWwgllnYVDshR9Vg2nXC/q
	 sRnv1B9Kl25T9FSHazumAMIngeWWPDfDXjqI62xPuqvsbfLan7TzIrx9AnbFjYzVqv
	 qmo6bUvW4znUw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 0463C60285;
	Wed, 12 Mar 2025 01:15:46 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741738546;
	bh=IvyS6B9hedwRU7n3jEyvD9iJYecBrj4hF1ESQTG0vBI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tbmQzmiNAZP3Yh+pTXL6M7dMaD3wAL0N2JsBS+k1+MmdlMOySEJrqdanXjf1JmCE/
	 evrDEmnUUnAaf9+oeBtcOSeaeqYZdq9WXNmmtSEHeQK7pHGB5MmcuNpIZAcjjJikhA
	 1UHOp2SxP8Uw1V2w/qOTDN1NTLBZoedLbKPuHVs7pJzwk3/9MqtLledVJiaAt3DzX1
	 OqQoTg6e7blSCxwBRpQ27ANuyoDCmJuCcHpGwaukmaQspWwgllnYVDshR9Vg2nXC/q
	 sRnv1B9Kl25T9FSHazumAMIngeWWPDfDXjqI62xPuqvsbfLan7TzIrx9AnbFjYzVqv
	 qmo6bUvW4znUw==
Date: Wed, 12 Mar 2025 01:15:44 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] tests: shell: skip interval size tests on kernel
 that lack rbtree size fix
Message-ID: <Z9DSMGuYq_jSEQVz@calendula>
References: <20250310124232.11796-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250310124232.11796-1-fw@strlen.de>

On Mon, Mar 10, 2025 at 01:42:29PM +0100, Florian Westphal wrote:
> Skip these tests for older kernels.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

> ---
>  tests/shell/features/rbtree_size_limit.nft      | 10 ++++++++++
>  tests/shell/testcases/sets/interval_size        |  2 ++
>  tests/shell/testcases/sets/interval_size_random |  2 ++
>  3 files changed, 14 insertions(+)
>  create mode 100644 tests/shell/features/rbtree_size_limit.nft
> 
> diff --git a/tests/shell/features/rbtree_size_limit.nft b/tests/shell/features/rbtree_size_limit.nft
> new file mode 100644
> index 000000000000..7eb44face077
> --- /dev/null
> +++ b/tests/shell/features/rbtree_size_limit.nft
> @@ -0,0 +1,10 @@
> +# 8d738c1869f6 ("netfilter: nf_tables: fix set size with rbtree backend")
> +# v6.14-rc1~162^2~7^2~13
> +table inet x {
> +        set y {
> +                typeof ip saddr
> +                flags interval
> +                size 1
> +                elements = { 10.1.1.0/24 }
> +        }
> +}
> diff --git a/tests/shell/testcases/sets/interval_size b/tests/shell/testcases/sets/interval_size
> index 6d0759672999..55a6cd4948e2 100755
> --- a/tests/shell/testcases/sets/interval_size
> +++ b/tests/shell/testcases/sets/interval_size
> @@ -1,5 +1,7 @@
>  #!/bin/bash
>  
> +# NFT_TEST_REQUIRES(NFT_TEST_HAVE_rbtree_size_limit)
> +
>  RULESET="table inet x {
>  	set x {
>  		typeof ip saddr
> diff --git a/tests/shell/testcases/sets/interval_size_random b/tests/shell/testcases/sets/interval_size_random
> index 701a1e73956c..3320b51245db 100755
> --- a/tests/shell/testcases/sets/interval_size_random
> +++ b/tests/shell/testcases/sets/interval_size_random
> @@ -1,5 +1,7 @@
>  #!/bin/bash
>  
> +# NFT_TEST_REQUIRES(NFT_TEST_HAVE_rbtree_size_limit)
> +
>  generate_ip() {
>  	local first=($1)
>  	echo -n "$first.$((RANDOM % 256)).$((RANDOM % 256)).$((RANDOM % 256))"
> -- 
> 2.45.3
> 
> 
