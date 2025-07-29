Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 318B89461
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Jul 2025 00:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753749066; cv=none; b=g+WANmn0/ukxE0Iue7lUUJuVKt0gVPg034O3hdHPHyLYP1GrJeswCdSXsU3o+L6QYryC5wdY1lKGOk4UfZW2gGsyCvwYIXuD3jt3mHMrWz1BmJaf5QjGJZ9SDx19UYRuQzhaeg908QaJ68X5KRVTIlaB03lnEiQrL1uQtKEhoRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753749066; c=relaxed/simple;
	bh=NX1vxmFrvuTAPnyWzQjnhvZ7Kj7qbcaLFzKqrmIxpVI=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GUpgAFxpQzTEGb4+q6pqr5USm/QI0ID53Fz6S0eLPfaySF+JKRMO3/HoSHL1SLJjFqQqkWQdsor+KwVLLT4+0r3zexnMCZ+Nfxs+aRC5XByL0677b+xVA7z+xvRxttcShHqY1jdijMk0W48ZmlNLV6/0ATnx3n5V+lczFy80F0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=o+OKX6Yk; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=eLyNcM9/; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="o+OKX6Yk";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="eLyNcM9/"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 8555E60307; Tue, 29 Jul 2025 02:30:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753749059;
	bh=RjApadua/3/wu3T+xR11rmdB3rfeEWIgLg0LvuOcMOw=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=o+OKX6Ykbv+h6CqvdUBMhcdgnoFnkmfwbAUe1bXnzaUjZrLP7tAvRqkfF5OTCZwcW
	 wxJrIMUDrbXLCcew4XV5CYtF6jOw+teAdB9b6J++wjFL2E1pKXzhvWi1o6HFqBCS5i
	 X529XBjp+AcsfRXhYUXGL0XXK4orfv0FKzEbiOJDu51jOB/Anorv/YmQLx6HVnoRAt
	 Y5JANV9pQSyqT9tnhusmAyzno4smSpcIAZ71DHNIvflLpcbAkOM6GwkKt87xE8FCnC
	 WZ/7HTwqs3n1m10X6+dG6xFptgI5P7mRzwiSJnGo1Y1YWxfaYBGCNrMYRbWjXb6OE9
	 tlfTfeI5y+Qvg==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 1295E60303;
	Tue, 29 Jul 2025 02:30:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753749058;
	bh=RjApadua/3/wu3T+xR11rmdB3rfeEWIgLg0LvuOcMOw=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=eLyNcM9/P70DF2lTEL6j7gmY+FYh5RrcWl6Us3HJiTgXjO5AlImlvKEuW4NGZi67N
	 vrmz8PB8ZovlZfFewXgLWbvZ00MBTHtiDaoro//z7621ly16U0tIYTQFkHopS5tf61
	 UKhxOOZvqVMogZiTYM9zXcOAXiI8IdJeowWSGGPdOorCsF9NIo94PBZoYrWJGT33LQ
	 DjVrPPs0oBpqOfE7Bd+TrDGszvrjh+Qw2XwCJizxNYBvzCzLMMyvp+UL1LXegY6cKj
	 zqnvi6L03AeVr66bEvvONbqsGF9yN64JKclK6iar9cTCxnT1w+kE9KJ2Yxbj9urG/a
	 OqNVGmH3REZpg==
Date: Tue, 29 Jul 2025 02:30:54 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nf-next RFC] netfilter: nf_tables: Introduce
 NFTA_DEVICE_WILDCARD
Message-ID: <aIgWKhR0RQwKMK3p@calendula>
References: <20250724221150.10502-1-phil@nwl.cc>
 <aIOe6gUjXTXwR2Nv@calendula>
 <aIP8UIYPzLokNbWq@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aIP8UIYPzLokNbWq@orbyte.nwl.cc>

Hi Phil,

On Fri, Jul 25, 2025 at 11:51:12PM +0200, Phil Sutter wrote:
> Hi Pablo,
> 
> On Fri, Jul 25, 2025 at 05:12:42PM +0200, Pablo Neira Ayuso wrote:
> > On Fri, Jul 25, 2025 at 12:00:31AM +0200, Phil Sutter wrote:
> > > On netlink receive side, this attribute is just another name for
> > > NFTA_DEVICE_NAME and handled equally. It enables user space to detect
> > > lack of wildcard interface spec support as older kernels will reject it.
> > > 
> > > On netlink send side, it is used for wildcard interface specs to avoid
> > > confusing or even crashing old user space with non NUL-terminated
> > > strings in attributes which are expected to be NUL-terminated.
> > 
> > This looks good to me.
> > 
> > > Fixes: 6d07a289504a ("netfilter: nf_tables: Support wildcard netdev hook specs")
> > > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > > ---
> > > While this works, I wonder if it should be named NFTA_DEVICE_PREFIX
> > > instead and contain NUL-terminated strings just like NFTA_DEVICE_NAME.
> > > Kernel-internally I would continue using strncmp() and hook->ifnamelen,
> > > but handling in user space might be simpler.
> > 
> > Pick the name you like.
> 
> Ah, it's not just about the name. The initial version using
> NFTA_DEVICE_NAME for both, distinction of wildcards from regular
> names came from missing '\0' terminator. With distinct attribute types,
> this is not needed anymore. I guess it's more user (space) friendly to
> include the NUL-char in wildcards as well, right?

Yes. In practise, you can put anything over netlink (someone decided
to sending strings, not even TLVs)...

But two different types provides clear semantics, no need to peek on
the value to know what to do.

> > > A downside of this approach is that we mix NFTA_DEVICE_NAME and
> > > NFTA_DEVICE_WILDCARD attributes in NFTA_FLOWTABLE_HOOK_DEVS and
> > > NFTA_HOOK_DEVS nested attributes, even though old user space will reject
> > > the whole thing and not just take the known attributes and ignore the
> > > rest.
> > 
> > Old userspace is just ignoring the unknown attribute?
> 
> Attribute parser in libnftnl will abort if it finds an attribute with
> type other than NFTA_DEVICE_NAME nested in NFTA_HOOK_DEVS (or the
> flowtable equivalent). So old userspace will refuse to parse the data,
> but not crash at least.

Please, fix it so we can do better in the future.

> > I think upside is good enough to follow this approach: new userspace
> > version with old kernel bails out with EINVAL, so it is easy to see
> > that feature is unsupported.
> 
> ACK, it is definitely much more sane than before!

OK.

I suggest you formally submit this for nf.git including userspace
patches? Then, request it to be included in -stable. We probably have
to skip including this userspace code in the next 1.1.4 release.
Unless anyone have a better proposal to handle this. I'm sorry I did
not bring up this issue sooner.

> > As for netlink attributes coming from the kernel, we can just review
> > the existing userspace parsing side and see what we can do better in
> > that regard.
> 
> We could introduce a "NFTA_DEVICE_NAME_NEW" which may hold wildcards or
> a regular name (thereby keeping the NUL-char distinction mentioned
> above) and at some point drop NFTA_DEVICE_NAME. Basically a merge
> strategy to upgrade NFTA_DEVICE_NAME to support also wildcards, but I'm
> not sure how long this transition period will take. At least it would
> never crash old user space, but "merely" become incompatible to it at
> some point.

I don't think it is worth, as for old user space, IMO the only
reasonable thing we can do is:

- do not crash.
- highlight that old user space is skipping unknown stuff.

Other than that, we would have to explore a generic way to print raw
attributes, then extend the parser to allow this, which I am not
convinced yet it is worth the effort.
