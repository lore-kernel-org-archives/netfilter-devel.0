Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E970919E96F
	for <netfilter-devel@vger.kernel.org>; Mon,  2 Sep 2024 12:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725280394; cv=none; b=EMTqATvzE7cFLiXd3fUo8Ew07AYxb/AEOdxgJT4lCmbDo0WAYgkfnDKJC9CeiYYk5U4e1j24V3tbJahKuDUVUgRt4oOEVMIyVe8MWBviEo0757FJ5Ftx0Yj4Ta2Zsuw6ffE3Lux+q1aFvmH6Ow1tNa7cy3KtlQVXvfTAwOooKAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725280394; c=relaxed/simple;
	bh=n7gYZEbI29xouVVObOu+iksmiwmoNLY6HifBg9m7IXE=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KML+sdWOZF7ONy5SlTIDRskiJ7MS3HWBI4yLkDwCPp1FyJT/3dGz/NvEhVZV1I3uy2JC2TfGRfB2VK1fTtCfHV38VlTkz8IoOBC9YFYhG2mTI61vnCbvglz0Hiet3CiTb8zUSwc12WibXokiA07WppH1JRg7pFlNx4jdDUmQ6EI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=56848 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sl6Ex-0092cs-5l; Mon, 02 Sep 2024 14:33:05 +0200
Date: Mon, 2 Sep 2024 14:33:01 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>,
	Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: Request for comments
Message-ID: <ZtWwfYTF1TC8UMh_@calendula>
References: <ZtVPczkT/T9Zz0ep@slk15.local.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZtVPczkT/T9Zz0ep@slk15.local.net>
X-Spam-Score: -1.9 (-)

Hi Duncan,

On Mon, Sep 02, 2024 at 03:38:59PM +1000, Duncan Roe wrote:
> Hi Florian,
> 
> Recently I submitted patch series
> https://patchwork.ozlabs.org/project/netfilter-devel/list/?series=407990 which
> converts libnetfilter_queue to not need libnfnetlink.
> 
> The series re-implements all the libnfnetlink-wrapper functions so they use
> functions from libmnl. I understand from previous correspondence that you had a
> shot at doing the same thing a while back. With that in mind, would you be able
> to find the time to take a look at the series and comment on it?
> 
> Additionally, the series re-implements the nlif_* functions from libnfnetlink.
> conntrack-tools and ulogd also use these functions, so I wonder if they belong
> in libmnl. Would you have an opinion on that?
> 
> Please disregard my use of kernel headers - I now understand the idea of cached
> headers is to be able to do standalone builds without them. v3 would fix that.

I have huge concerns this will break existing applications for the
benefit of nothing? Because other existing libraries rely on
libnfnetlink.

Unless he finds a way to carefully sends us patches to incrementally
move to libmnl.

I think it is more sensible to extend the new API to fill the missing
gaps, I remember people mentioned it is too low level. With a few
helper function it should be possible to make it as easy to use for
simple applications a libnetfilter_queue.
