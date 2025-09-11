Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23FF1215767
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Sep 2025 14:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757600461; cv=none; b=qkXfcLquCIpKxD0te/wcUKMzVM65Kvh/p9ZTbc1imecI7D2mqOGqL+5jTg9MjJMpcC0KOutyXcaEM3Qd49jS+vZv9tT+ODHb6swMJA4c4UiGsvIMbCiEphvbF0YIurRA+tIyZKBFamrxYieoTpebwJjpB9bzaivoCkGyRMYW7Yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757600461; c=relaxed/simple;
	bh=IgVkdCKumcwfLOpctzcRbieRUoIXKbj1Vjha1iCc1DU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=izVVvHwa0BIZxV0nUZ+AA/yVMEa3/+/c6QACDK+bKf3nReuMa/sA2OFs+UNoUUJRc5iUEJNV2SyAbAaL/Oy3wwL7SBmqOUCuIsj8R5dgq6zVPlAGA6NFAvSdXve2amSbnvK8FHIuScKpZZ85ih8UvaqRzQakfsnB1PP3YAma548=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=mqgJLtbH; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=oYMRLic7; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="mqgJLtbH";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="oYMRLic7"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id AEF32607DC; Thu, 11 Sep 2025 16:20:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1757600454;
	bh=NZToLWN7iAxOXfMrESbHCU7AICjhKVN0HfFltt5bV9s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mqgJLtbHKTm8bALte3YITbqMV3STbFSMasZSeUcxpxgJr9M9Hs3Mmrb2bICEKcbQK
	 k8vbcOZWBUOl+bcMJdW98TODpUIcT59Ob+nXG0if03udea0iAUf9G8hXdxB61mxCh8
	 YSzstrOJuJg9NOkdV6DIUgsrgnPLsbiX5/qCM4UW4l20TfQEAJNzfzHc8xTfSkQgsv
	 1CUxs2Mg/TewEIgFzbirLq+IMIcJkxHFcHQMuOxDEt06QEeghgpIFogEo4EERufB4A
	 XINtrkltE/KHTAzAw7xu90tZILK87cFsiz3HulsiegcLJQuqplEZlvj0nnxq9Tla7F
	 4Xu69nb8juWxQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 980AE607D8;
	Thu, 11 Sep 2025 16:20:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1757600453;
	bh=NZToLWN7iAxOXfMrESbHCU7AICjhKVN0HfFltt5bV9s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oYMRLic77MwpvngZj9/5aw7DYYFFrRkrvLvgc2mT0q5jqGmAVsn7vvfkzy4PmfQLN
	 l8GrS73hQH2cQNpl9O0lkZMcT486H4Tvbn+ddc30CaFB1HdnpLwOe5y/9KXYax+4U3
	 aqfIADXPgVbLdDZtas9fkQ/DDNBr3HCvnJGFhor7cqJeiyAnGRIPodsjR5RRyLiTid
	 NOlwmXMWKcCPLgKYpEUTvhV4hGLysv9j47kYyzqm2owzWVSiGGClCHFVnU1NpiVuSI
	 J5RWz1Kc9wR+yGNRNz5D/DbNagsHifg/HNyJJJiB71o5Fq6nuIxHa/bjyv91UgSGNk
	 q1yK3XMU0Hciw==
Date: Thu, 11 Sep 2025 16:20:51 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org, Yi Chen <yiche@redhat.com>
Subject: Re: [nft PATCH] fib: Fix for existence check on Big Endian
Message-ID: <aMLaw30XihPy0Moc@calendula>
References: <20250909204948.17757-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250909204948.17757-1-phil@nwl.cc>

On Tue, Sep 09, 2025 at 10:49:48PM +0200, Phil Sutter wrote:
> Adjust the expression size to 1B so cmp expression value is correct.
> Without this, the rule 'fib saddr . iif check exists' generates
> following byte code on BE:
> 
> |  [ fib saddr . iif oif present => reg 1 ]
> |  [ cmp eq reg 1 0x00000001 ]
> 
> Though with NFTA_FIB_F_PRESENT flag set, nft_fib.ko writes to the first
> byte of reg 1 only (using nft_reg_store8()). With this patch in place,
> byte code is correct:
> 
> |  [ fib saddr . iif oif present => reg 1 ]
> |  [ cmp eq reg 1 0x01000000 ]
> 
> Fixes: f686a17eafa0b ("fib: Support existence check")
> Cc: Yi Chen <yiche@redhat.com>
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks.
