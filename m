Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA961EFF96
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Aug 2025 14:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756392353; cv=none; b=GXKraRydqWwix8xsEUXQDw1LcLCl2unsfwb+Msa2ZrIhU58VdGULntOS+ELwPOB6e3B2Yn8UFLoUJh71+rRZldYr2kI2q8wR+dx1/IE+jGoVPMUjCQSV5A/ONZzYXg5Jcpfn87g6UOpWt3ooL0XWAYe0sgOgIH43luD7H3+a7Xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756392353; c=relaxed/simple;
	bh=K2Kp10ssv7JVoeOBXOc4m5ZRzrcFvrdsZB5o8Zt0mUc=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xj8EmSRyK0qYnqnberO8wZBQksMBQ4zUAa8x6RLZ8O8DDPCidhRMDpHYOqmBW6L1YwuouTYuEhyBHHcLncHNL9nTBoIJeKDVtlaVs5o1M7GmPyTHOxnln5HWkulYwMcSNRe/xEO8mehEs7lB7GCTordgycr1HNF1g/HJ5EEddak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=poL/Hhi0; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=sA6dxMhh; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="poL/Hhi0";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="sA6dxMhh"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id A0007606D3; Thu, 28 Aug 2025 16:45:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756392348;
	bh=CGYJjg8RjASyJInfNASy8uPTyo9Oy3RkLkkMHuIOSbQ=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=poL/Hhi0zvecX71LgoZH4ZmGWwLC7pGk/0xzSUHHQSEPyNzAJmfTkcXiy17Lr4+Pa
	 z1FI8u73wMpZB0dW2NDQ6T8aW10xy137CHbXfyd6G5fyTkiTBt7WKji//L/B4fBog9
	 UW1KpnP0VuYZxAxy9XT9+kZgJ70PbEdfDskblBpV/jC91RQt+hUoSbW4dpNaKVVJcb
	 nIqonfQSMKiAOZHFTr41PNILoSSQeczFfo/Ap3zPI1u3IYP+opHlpMOeg6Cj4Zz372
	 zwxsGMy2FRi8Kz87o6KWQJWL1a10b1iNaKo8915EL6quByv68aRALcI7TwZLAQQCkA
	 a0bXnW2CqNuFw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 19AA3606D3;
	Thu, 28 Aug 2025 16:45:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756392347;
	bh=CGYJjg8RjASyJInfNASy8uPTyo9Oy3RkLkkMHuIOSbQ=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=sA6dxMhh9pwsrarY8OBTgMwHhsEbeERuuRJNvG79NTN2UHyIDCdbnbcjoPjnGJFeX
	 K12iVes/WRR3wIoHdyP40spyEdam5VZzD1FU3CBNjPDi4KoKMJhYhmrfF0jekBiJSP
	 Tyh2B+h0CqpoWSr/Ma5YT/zdNuhKbZoXYv7ZYAKaGdmz/2UoeQx/zl4TzgYi8Nkl7E
	 WCDmUPBOeEGroyGGk/YGHK9IzXuLIj+Jj8liqh5ZF3fx+7s9dFFoxSejU8EyDVkGfG
	 f5VHWSYEf1k10C74wUyFeH0X5uw1fb17JsiICcsCn1b0Gc4oa0wNoPMX5zdhOuYyia
	 DVWva3EXO0+YA==
Date: Thu, 28 Aug 2025 16:45:44 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	Dan Winship <danwinship@redhat.com>
Subject: Re: [nft PATCH] table: Embed creating nft version into userdata
Message-ID: <aLBrmD240kxqrNPr@calendula>
References: <20250813170833.28585-1-phil@nwl.cc>
 <aLBRSR5AXpt5M_7x@calendula>
 <aLBfSlle-zZqLygE@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aLBfSlle-zZqLygE@orbyte.nwl.cc>

On Thu, Aug 28, 2025 at 03:53:14PM +0200, Phil Sutter wrote:
> On Thu, Aug 28, 2025 at 02:53:29PM +0200, Pablo Neira Ayuso wrote:
> > Hi Phil,
> > 
> > I know this is applied, but one late question.
> > 
> > On Wed, Aug 13, 2025 at 07:07:19PM +0200, Phil Sutter wrote:
> > > @@ -806,6 +815,29 @@ static int table_parse_udata_cb(const struct nftnl_udata *attr, void *data)
> > >  	return 0;
> > >  }
> > >  
> > > +static int version_cmp(const struct nftnl_udata **ud)
> > > +{
> > > +	const char *udbuf;
> > > +	size_t i;
> > > +
> > > +	/* netlink attribute lengths checked by table_parse_udata_cb() */
> > > +	if (ud[NFTNL_UDATA_TABLE_NFTVER]) {
> > > +		udbuf = nftnl_udata_get(ud[NFTNL_UDATA_TABLE_NFTVER]);
> > > +		for (i = 0; i < sizeof(nftversion); i++) {
> > > +			if (nftversion[i] != udbuf[i])
> > > +				return nftversion[i] - udbuf[i];
> > > +		}
> > > +	}
> > > +	if (ud[NFTNL_UDATA_TABLE_NFTBLD]) {
> > > +		udbuf = nftnl_udata_get(ud[NFTNL_UDATA_TABLE_NFTBLD]);
> > > +		for (i = 0; i < sizeof(nftbuildstamp); i++) {
> > > +			if (nftbuildstamp[i] != udbuf[i])
> > > +				return nftbuildstamp[i] - udbuf[i];
> > > +		}
> > > +	}
> > 
> > One situation I was considering:
> > 
> > 1.0.6.y (build today) in the host
> > 1.1.5 (build n days ago) in the container
> > 
> > This will display the warning.
> > 
> > I suggested to use build time only when version is the same?
> > 
> > If the scenario is nftables in the host injects tables into container,
> > then host binary will likely be updated more often.
> > 
> > IIUC, the build time here will actually determine when the warning is
> > emitted, regardless the version.
> 
> It should not:
> 
> Here's version_cmp() pseudo-code:
> 
> | for attr in NFTNL_UDATA_TABLE_NFTVER, NFTNL_UDATA_TABLE_NFTBLD:
> | 	for idx in len(attr):
> | 		if local_data[idx] != attr[idx]:
> | 			return local_data[idx] - attr[idx];
> 
> This algorithm considers following bytes only if all previous ones were
> identical. Precedence is from highest order version bytes to lowest
> order build bytes (data is therefore stored in Big Endian).
> 
> So your version 1.1.5 will always be "newer" than 1.0.6.y, no matter the
> build date, due to minor version 1 > 0.

Ah, I misread this smart function, thanks for clarifying.
