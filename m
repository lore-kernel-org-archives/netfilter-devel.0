Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B9F5680
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Jul 2025 00:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753229273; cv=none; b=NGCMPWQQA8ZS8MNh1AsclTa+XJgz9zZLdr+5h2dfq2Olf1MRb/mCZ1+RInZmLeHhIBBolrixy3CyEEo8apDRNM5KmXjizEq8caD6+HpXtPXd6+D6uxVHUqK00s6V6AVukyPU9f0788lb+nxy8tM0N3+++L58xf78wPMncMuEvsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753229273; c=relaxed/simple;
	bh=Q07dgzFa5C6JYYnzXbLfGgJInmhe/tHmCanFO2QgVhM=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uWN/eRKu4AH/Xy4SdKhrg0LReTpSGUzOxDxWf/Xs/4aOiRrc1NiZKr8eINpN7crXdT6wzR5BdV/+15oDHEGhtFHVMOf6W53lqQWg6daI1nrKLSwApGexoqCLzc6f+94m27JWCVAu6FPDhdpQ1D0vruPdMBiEk4zR3Ptx+IIqJog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=P5ubG2tj; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=SkEzIqDp; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="P5ubG2tj";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="SkEzIqDp"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 88EF360255; Wed, 23 Jul 2025 02:07:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753229268;
	bh=sneoLxIoXoS02q3NSPSsbGfF9InDzhjWAUFpQqPEHdA=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=P5ubG2tjK68MpUgOSDi+YfhleSK53110LTJyjirShdgW/mfVtpXB3jgCQAfZwg2c8
	 Ee97kgL5Z9ia7DFMMsmKYGheaY7iYYICy3OfT9fS59lj1TLgPKz70Bw6H2Nd+nvobr
	 gYqCOfIHI6cyQuEa/3SXQ9TqSeyim2FvgfiwgUAWwObrHUGiH7mSgVJqnnrNKsvPc5
	 wLTjtwiMnJhfxfb2LZvxW9Yd4r9sy8F7MZWa00fjU2mBcZx8gRhY0reuIq5Evze8Id
	 /agPSpovLJ2ePagQFJBaPAOGeeC2TY8qE8KFXx2mqF5foV0B0RWeltc+D9kiY6A6yK
	 PVs1cNyJNJ5Jg==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 3B53A6024E;
	Wed, 23 Jul 2025 02:07:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753229267;
	bh=sneoLxIoXoS02q3NSPSsbGfF9InDzhjWAUFpQqPEHdA=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=SkEzIqDp47BshFqGDdFWbhJYi7OgUMy61+H+pxUEUM/fkbRsq8lhMtIBVR50s8SyB
	 STnSU80TX2si3UuyftsbLvOaMHRTsOJc9qai/Um1JGsPfNcjiXQA+qkejqk92ywVFw
	 R2j7516eXRRNGJgkUQm9cdNR+mZl4uSwiTXQlqwOhAIZ9nmSV45clNe/2AqmbzwzN1
	 QjsH9MmI8oowqLMZ/NPOUie1ptnvTXtaHjuQG2qdxmC5oAqOpOgKZEx6ox4kjvEWBu
	 YfdnVMnQfxPv6+lNm8+OW1dDHfdt0YXebvQhIhHbygt64yvYOsRvoulLWSaERZTy33
	 pDiDLJWU2Cz+Q==
Date: Wed, 23 Jul 2025 02:07:43 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH] utils: Add helpers for interface name wildcards
Message-ID: <aIAnz3RASqGt2hHY@calendula>
References: <20250716132209.20372-1-phil@nwl.cc>
 <aH77oyMqwmO3x3V9@calendula>
 <aH-VlSW8TxjMNrHN@orbyte.nwl.cc>
 <aIAfwFczsAt-fhoU@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aIAfwFczsAt-fhoU@calendula>

On Wed, Jul 23, 2025 at 01:33:43AM +0200, Pablo Neira Ayuso wrote:
> Hi Phil,
> 
> On Tue, Jul 22, 2025 at 03:43:49PM +0200, Phil Sutter wrote:
> > On Tue, Jul 22, 2025 at 04:46:59AM +0200, Pablo Neira Ayuso wrote:
> > > Hi Phil,
> > > 
> > > On Wed, Jul 16, 2025 at 03:22:06PM +0200, Phil Sutter wrote:
> > > > Support simple (suffix) wildcards in NFTNL_CHAIN_DEV(ICES) and
> > > > NFTA_FLOWTABLE_HOOK_DEVS identified by non-NUL-terminated strings. Add
> > > > helpers converting to and from the human-readable asterisk-suffix
> > > > notation.
> > > 
> > > We spent some time discussing scenarios where host and container could
> > > use different userspace versions (older vs. newer).
> > > 
> > > In this case, newer version will send a string without the trailing
> > > null character to the kernel. Then, the older version will just
> > > _crash_ when parsing the netlink message from the kernel because it
> > > expects a string that is nul-terminated (and we cannot fix an old
> > > libnftnl library... it is not possible to fix the past, but it is
> > > better if you can just deal with it).
> > 
> > Yes, this sucks. In a quick test, my host's nft would display "foo" for
> > a device spec of "foo*", but I believe this largely depends upon string
> > lengths, alignment and function-local buffer initial contents.
> 
> I see.
> 
> > > I suggest you maybe pass the * at the end of the string to the kernel
> > > so nft_netdev_hook_alloc() can just handle this special case and we
> > > always have a nul-terminated string? There is ifnamelen which does in
> > > the kernel what you need to compare the strings, while ifname can
> > > still contain the *.
> > 
> > We can't distinguish this from real device names ending with asterisk,
> > though (Yes, no sane person would create those but since it's possible
> > there must be at least one doing it).
> 
> This is hard by looking only at the Value of the TLV.
> 
> > We could use a forbidden character to signal the wildcard instead.
> > Looking at dev_valid_name(), we may choose between '/', ':' and any of
> > the characters recognized by isspace(). I'd suggest to use something
> > fancy like '\v' (vertical tab) to lower the risk of hiding a user space
> > bug appending something the user may have inserted.
> 
> Let's look at this problem from a different side.
> 
> I'd suggest you add new netlink attribute NFTA_DEVICE_WILDCARD to
> address this, ie.
> 
> enum nft_devices_attributes {
>         NFTA_DEVICE_UNSPEC,
>         NFTA_DEVICE_NAME,
> +       NFTA_DEVICE_WILDCARD,
>         __NFTA_DEVICE_MAX
> };
> 
> And use this new attribute for wildcard interface matching.
> 
> > > Worth a fix? Not much time ahead, but we are still in -rc7.
> > 
> > Fine with me if we find a solution that works!
> 
> This approach allows for newer nftables version to fail with old
> kernels, ie. user requests to match on wildcard device and kernel does
> not support it. I think it is convenient to bail out if user requests
> an unsupported kernel feature.
> 
> As for matching on an interface whose name is really eth*, nftables
> userspace already allows for ifname eth\* to represent this, ie.
> 
>         iifname eth*   <-- wildcard matching (99% use-case)
>         iifname eth\*  <-- to match on exotic (still valid) device name (1% use-case)

Actually, this example above is missing quotes:

         iifname "eth*"
         iifname "eth\*"
