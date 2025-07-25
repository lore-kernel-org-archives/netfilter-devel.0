Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6641E7DA6C
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Jul 2025 21:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753480276; cv=none; b=NoLNFzisjPxTXw2cmrGFLMf7bUPxpcxqfcMUWmOBntfTPfYJAdAMoWZ732qe9NJPTi1J6uYXg2GMv3t3UCA8Ffv4q9BYPfCCRaDQnwu4Zik1GVBSAt6b72vA4Tq6hYCpWFJcrdeDEY/zVM7UlQ6nCZCsYLEC/+/2e0lJP2IoQNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753480276; c=relaxed/simple;
	bh=lbkKDWVbZAyzoPCxhO4ohz93EvXbT8MBYqDFKnFB4oI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rQXj2sjo0Okeox96I8E6wyeVBBfCK5vYYYOQZhodjL1PdXxnX96Ud6KRy/yV1WKFGCs41DyfVUWc3zVfCC6tjxZ0Eqp79jZgq1D4VpAx0XK/cBBNJaqLKTfjjHmPJT4vtLKAnjioPRWFzN4sND2JFcVNDreph8MmJvGxDHil0qE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=aJxr3AVr; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="aJxr3AVr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=nRjghrLj9ky4BEILYTBIt3IGonBcjF+qnT7TpfvTlmk=; b=aJxr3AVrWI6xDjCuzvA1g1Wyrh
	TGJUEinnbB+ZIAwlYvgYSVgGv5ulN6XTppqprVH5spgj2D8g45fnRYbL2seuFxSp520r2joVhnA0Y
	8ymp571sMw3ezidaotk+h3SlYIVc8S90047JQ1tIJEZR7kwnDAN3BdSFk5iXhKv4ClpuBogX2nuiB
	yhiEtWUID332LHAhk88IxDnf2JSwZGbhqFPKbmNxwaGTleCLCyKrqkV5Z2AV1D9noj1LLI76yt0sO
	JCnUhJV10nOHKxnUqYaGs0arR3mwZFcELe3RNSoPxVS/xvBSQI6bjKsYImEu4oE1a89Bh9dwZSTo7
	8QCoGeJA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1ufQJs-000000004Vj-1UCS;
	Fri, 25 Jul 2025 23:51:12 +0200
Date: Fri, 25 Jul 2025 23:51:12 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [nf-next RFC] netfilter: nf_tables: Introduce
 NFTA_DEVICE_WILDCARD
Message-ID: <aIP8UIYPzLokNbWq@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20250724221150.10502-1-phil@nwl.cc>
 <aIOe6gUjXTXwR2Nv@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aIOe6gUjXTXwR2Nv@calendula>

Hi Pablo,

On Fri, Jul 25, 2025 at 05:12:42PM +0200, Pablo Neira Ayuso wrote:
> On Fri, Jul 25, 2025 at 12:00:31AM +0200, Phil Sutter wrote:
> > On netlink receive side, this attribute is just another name for
> > NFTA_DEVICE_NAME and handled equally. It enables user space to detect
> > lack of wildcard interface spec support as older kernels will reject it.
> > 
> > On netlink send side, it is used for wildcard interface specs to avoid
> > confusing or even crashing old user space with non NUL-terminated
> > strings in attributes which are expected to be NUL-terminated.
> 
> This looks good to me.
> 
> > Fixes: 6d07a289504a ("netfilter: nf_tables: Support wildcard netdev hook specs")
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> > While this works, I wonder if it should be named NFTA_DEVICE_PREFIX
> > instead and contain NUL-terminated strings just like NFTA_DEVICE_NAME.
> > Kernel-internally I would continue using strncmp() and hook->ifnamelen,
> > but handling in user space might be simpler.
> 
> Pick the name you like.

Ah, it's not just about the name. The initial version using
NFTA_DEVICE_NAME for both, distinction of wildcards from regular
names came from missing '\0' terminator. With distinct attribute types,
this is not needed anymore. I guess it's more user (space) friendly to
include the NUL-char in wildcards as well, right?

> > A downside of this approach is that we mix NFTA_DEVICE_NAME and
> > NFTA_DEVICE_WILDCARD attributes in NFTA_FLOWTABLE_HOOK_DEVS and
> > NFTA_HOOK_DEVS nested attributes, even though old user space will reject
> > the whole thing and not just take the known attributes and ignore the
> > rest.
> 
> Old userspace is just ignoring the unknown attribute?

Attribute parser in libnftnl will abort if it finds an attribute with
type other than NFTA_DEVICE_NAME nested in NFTA_HOOK_DEVS (or the
flowtable equivalent). So old userspace will refuse to parse the data,
but not crash at least.

> I think upside is good enough to follow this approach: new userspace
> version with old kernel bails out with EINVAL, so it is easy to see
> that feature is unsupported.

ACK, it is definitely much more sane than before!

> As for netlink attributes coming from the kernel, we can just review
> the existing userspace parsing side and see what we can do better in
> that regard.

We could introduce a "NFTA_DEVICE_NAME_NEW" which may hold wildcards or
a regular name (thereby keeping the NUL-char distinction mentioned
above) and at some point drop NFTA_DEVICE_NAME. Basically a merge
strategy to upgrade NFTA_DEVICE_NAME to support also wildcards, but I'm
not sure how long this transition period will take. At least it would
never crash old user space, but "merely" become incompatible to it at
some point.

Cheers, Phil
