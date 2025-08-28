Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58701208994
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Aug 2025 11:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756382215; cv=none; b=p2nMJNueasHMzfcjFM0HlZsB/5FW+vfGMOBt1efDQ/DBzaLe+L9b3hdC0vZnLO43in5rHMn1k2oR2SABQywBLOAPTOHHCDUKf4qt4F9g/B8kY7BP408I0qv8SMP9lfx6fh2y12d9YLwE9TYhWJrHFkesVwy5+PEMTKn2ZbnXE5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756382215; c=relaxed/simple;
	bh=73rJmY5fnMCY8LviToXMwK8glxevgYYU6C/NJ7zp61g=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c1m/3nK14yLSqvAeC+TN36baZ0rVCLSv4sQlFfmImOWo9901BwcNdqPNhU8VUcCreNIuxVRHudCBmpXDXGoLuNYXSd//7qSTq+53CSv7sKae5/7cNjWHGLhToHH6WT28eSG2u/U/gJCtGEVbvfzZXUSq6kfgsJYWHamWpFNk5cY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=EUaCeJse; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=WiHmCEZY; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="EUaCeJse";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="WiHmCEZY"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 2DA1360624; Thu, 28 Aug 2025 13:56:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756382209;
	bh=QPs4N6oXwUmlvrG5BjlcYo6CDe9mhvf5ft460/O28sg=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=EUaCeJseHyIpMf7zRHqHcA0OeG2yz0qnVkpP+oQYKavjHxGh97hnrLoR5j7y3KsrU
	 fi45XbUOt4wAL6x2X5Egg/brjRGgJ9PhUSUQYS0xUh3R+OS7chHHeLBecMVeLJoMeh
	 WjSyipAr5QJExu4+5SSLHj4cWO77WqM51CoIz+6tSUDSQsaIryxMMX0FjCMrab/hP/
	 rgvP2QCbBOKqPuPhMTcK3OIvkF0vT3832RgxaFxAEtkXA6FAU9ebbSxBLSS4PFvE8E
	 KNi66IEMRzeKGLWCZro9vWnMo/6MrtrWO6mpWbIYCes6qbKkCqNIdUnBjLdBSD3GfR
	 5Sto5jWH6rTMA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 27B1E60624;
	Thu, 28 Aug 2025 13:56:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756382207;
	bh=QPs4N6oXwUmlvrG5BjlcYo6CDe9mhvf5ft460/O28sg=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=WiHmCEZY+/UBuvz07DqtXZWT2byj3uTMajtyNUuhRDad8F59VnUlH3s//hSUJFGIu
	 SXtkTuCcwxf255tKdo47vN+Xb7vszuC2XCLGlp6ITSIiygi9mOmfR7sQQAsW8QUjIY
	 E9iiCfXONeALZ0OlNMEMSUZz5peKmZQ7LqoIqws/K8f6tZMggDOWMhrjMi6QaTyENJ
	 SsD+ngzQTQ1YVmAJwmL2coMuDy2im0o8FjYa73eg9cyjXt64tCtjBLNisV+0Co1w2E
	 YuAUtceYJZcRPcSKsMLXgjotm/S0ZjI+BxlXOyW1aHqoyneWV13v+BedsZMX5rpG/g
	 nlm9LRlvRSR9w==
Date: Thu, 28 Aug 2025 13:56:45 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, Yi Chen <yiche@redhat.com>,
	netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [conntrack-tools PATCH] nfct: helper: Extend error message for
 EEXIST
Message-ID: <aLBD_Ur0qeT9yLbz@calendula>
References: <20250815155750.21583-1-phil@nwl.cc>
 <CAJsUoE2zCJYSvm9_=784BtH26GsRDJGBTn8930wW4ZSU8nTjYA@mail.gmail.com>
 <aK-H5xydGbsYIvBU@calendula>
 <aLA3pp6yXJjdEjjl@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aLA3pp6yXJjdEjjl@orbyte.nwl.cc>

On Thu, Aug 28, 2025 at 01:04:06PM +0200, Phil Sutter wrote:
> On Thu, Aug 28, 2025 at 12:34:15AM +0200, Pablo Neira Ayuso wrote:
> > On Mon, Aug 18, 2025 at 11:47:08AM +0800, Yi Chen wrote:
> > > This patch adds a hint when:
> > > 
> > > # modprobe nf_conntrack_ftp
> > > # nfct helper del ftp inet tcp
> > > # nfct helper add ftp inet tcp
> > > *nfct v1.4.8: netlink error: File exists*
> > > 
> > > or other type of helper.
> > 
> > This patch changes EEXIST by EBUSY:
> > 
> >   https://patchwork.ozlabs.org/project/netfilter-devel/patch/20250818112220.26641-1-phil@nwl.cc/
> > 
> > This userspace patch is not very useful after this.
> 
> Oh! I missed that nfnl_cthelper_create() also just passes through the
> return code from nf_conntrack_helper_register().
> 
> > So maybe a follow up fix to retain EEXIST for nfnetlink_cthelper in
> > the kernel is needed?
> > 
> > I mean, return EEXIST in nfnetlink_cthelper but EBUSY in case of
> > insmod, ie. add a bool insmod flag to the helper register/unregister
> > functions to return EBUSY for insmod and EEXIST for
> > nfnetlink_cthelper.
> 
> Do we need to retain the old return code?

I have change return codes in the past myself, when I considered error
reported to userspace was misleading, but I heard once it is a good
practise not to change them as a general rule.

> I would just update the patch to print the message for EBUSY instead
> of EEXIST.

It is OK, I could not find any code in conntrackd running in helper
mode than relies on this error code. The only case that I can think of
is combining old kernel with new userspace defeats the purpose of this
patch.

Maybe it is not worth the effort to bother about this, judge yourself.
