Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A94281520
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Jul 2025 21:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751922163; cv=none; b=g7lQffBR5/LBLgGsg+VkJ4PViTFxOxuYtaPfLfZO7/2ry29FCPtrIDzYYjZ/2ySstECpeACEVmRGY41Jx2g9u7LVe1s0P2wGr5o+nBGO18yZi+X5NZuh3FAq5ObtZNZpKg+ueCByXuzCeOH4vXTNjZmLsl7x96FNdv2rmu24Yjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751922163; c=relaxed/simple;
	bh=uzbtxMyx3K7qy/uPCAZ7q4WRd3AA3Ci3AaxavrtGBEs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U4Q4qGMSy2iuRudwtUqTqp5xb70XflWjJXObuVKGKVak/YIGcfJzVUW7ZDm/W6zDbAkqGdBHibpfmEqf2SIuJC84HpG+0phXXm0XwzvX/rooF0+b++wT7jGhMuX/wcb2OQLComlHr48A72nicl1uP7qBi+Q4mU5FLuDQl6glwY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=H4DsrRBP; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=XqiQp14u; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="H4DsrRBP";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="XqiQp14u"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 7088160262; Mon,  7 Jul 2025 23:02:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1751922158;
	bh=BMoyG7XjkvUUXI6XIthEe1WE5Mhf2wALtDAUZ13a+Yw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H4DsrRBPOeFlCARKbQgh0bBBS8PFiS4xN4LHyO5aZFWG/M7fZlyiGI6JKPRh7YFQ9
	 7kMv5qXp0J9Ogap/AJZU0CunaF9dpF9iTuXJH1vSkRMgL1PnVsxT98JVVZCty/BNMf
	 BW/+IMC0m0kLrPnjU0+6AXaQbYaLNLJ96aGBBKgvUerWDSh2GZ7eIQOhqrH5FQrjxO
	 1KxCwlQ1VTx3FpJqSQxED/V1eeyc0LJnnRF/YI77zjfp8jqPwO6BKpx9XEKj5nWJK2
	 hXN5z2sD7NbrSvdr1uRtosNpr2mwo3D/VU88+B+l0d06qJ1/pQYIhaYdXQoZholGIK
	 3hjsgFQQpWn8Q==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B432160251;
	Mon,  7 Jul 2025 23:02:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1751922157;
	bh=BMoyG7XjkvUUXI6XIthEe1WE5Mhf2wALtDAUZ13a+Yw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XqiQp14uRNRE5RPjsK5pTsL7YM1JarvnNoyihDlLNfSwpyxKaeJ9L2Kf5cZjXfgCy
	 ePJYbw6Ean+NQ0XhYo0sT49q8uSja9GXg0ttnkMKzt1zS5yClb1ZPorVAXSeBJtgfl
	 bYmj2aPD/sm7t55YIweDlOj9Zex0lzlKIrIHCx5t4UH3shk7Y4vVizekCrWWIVMOZX
	 QdvY14QWlWSXKK0VGAyWpCVwnZn75azq556LJipOZe+Jl767cCgFF40wEyMcxjMXL4
	 KLhWCaK/0DL2Tp/i9jS0ebt0tl1ML5maAJz/LtMjZmDkO6RCoJhPyILyX9nSxQgjKP
	 A0mc9L/RqWW4w==
Date: Mon, 7 Jul 2025 23:02:35 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v3] src: add conntrack information to trace monitor
 mode
Message-ID: <aGw16xG1YoxAx-l-@calendula>
References: <20250707203816.25429-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250707203816.25429-1-fw@strlen.de>

On Mon, Jul 07, 2025 at 10:38:13PM +0200, Florian Westphal wrote:
> Upcoming kernel change provides the packets conntrack state in the
> trace message data.
> 
> This allows to see if packet is seen as original or reply, the conntrack
> state (new, establieshed, related) and the status bits which show if e.g.
> NAT was applied.  Alsoi include conntrack ID so users can use conntrack
> tool to query the kernel for more information via ctnetlink.
> 
> This improves debugging when e.g. packets do not pick up the expected
> NAT mapping, which could e.g. also happen because of expectations
> following the NAT binding of the owning conntrack entry.
> 
> Example output ("conntrack: " lines are new):
> 
> trace id 32 t PRE_RAW packet: iif "enp0s3" ether saddr [..]
> trace id 32 t PRE_RAW rule tcp flags syn meta nftrace set 1 (verdict continue)
> trace id 32 t PRE_RAW policy accept
> trace id 32 t PRE_MANGLE conntrack: ct direction original ct state new ct id 2641368242
> trace id 32 t PRE_MANGLE packet: iif "enp0s3" ether saddr [..]
> trace id 32 t ct_new_pre rule jump rpfilter (verdict jump rpfilter)
> trace id 32 t PRE_MANGLE policy accept
> trace id 32 t INPUT conntrack: ct direction original ct state new ct status dnat-done ct id 2641368242
> trace id 32 t INPUT packet: iif "enp0s3" [..]
> trace id 32 t public_in rule tcp dport 443 accept (verdict accept)
> 
> v3: remove clash bit again, kernel won't expose it anymore.
> v2: add more status bits: helper, clash, offload, hw-offload.
>     add flag explanation to documentation.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks.
