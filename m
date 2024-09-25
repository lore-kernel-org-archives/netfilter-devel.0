Received: from smtp-42a9.mail.infomaniak.ch (smtp-42a9.mail.infomaniak.ch [84.16.66.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 111984D8BF
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Sep 2024 18:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=84.16.66.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727289093; cv=none; b=SulkbL57j/RVn4sSIZVBLrFKRCPLNh/ofbWjqAdnFiX3vuve9qONf7FU43HGnY/Pp57WSx2chZZJIOVMYcZAoUrwwAknPoba14f3ntMkfEA6g0QXrcuoWypsjidsKBBzYHV8kPrsKV5qJbKfdEhVvZqh6DBbRAz6+Os/k+7jtgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727289093; c=relaxed/simple;
	bh=O8iYvYw3zsv7+xeHawxeg0kYWliGnBVpbxH7QFAnDPg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LqrSlOdXMKCeCxNAQrdIUIG5BUGgj01DDi+vJrLZvlr6ScuTyuf7tvDGYu8PUAC74O8jllNO+qW+gx+ktkUPEO67hZJWwh83m6DLRgc8NrEuPHcM0ySc6bMues7QzWfb/b/q4nDcmlbZ6ZXO/p/mwrgK4ZWXqb1IZmMnkIDt8FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=MZShkSLm; arc=none smtp.client-ip=84.16.66.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="MZShkSLm"
Received: from smtp-4-0000.mail.infomaniak.ch (smtp-4-0000.mail.infomaniak.ch [10.7.10.107])
	by smtp-4-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4XDQKh3PNszK8F;
	Wed, 25 Sep 2024 20:31:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1727289080;
	bh=mkpu7cuq+yO3FRbUc5w7sH1IMCpOtL6ugJfjenJnpAs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MZShkSLmGqawVT7d/guPX4Gu1I+Wa5LPMZSFX6eq7Au/iiGV2zm6Ksvfs2GIBqeg3
	 QAn5gtO8iCLtjxAS/T981JutmUopRoY+5rHbYs+ao1y85lxNN4b9dioYtjEpu1nNA5
	 u7djLgh+AVVJ1gAgz4/Wm/xM7LHQVNDQu9iPdWas=
Received: from unknown by smtp-4-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4XDQKg53NVzNL0;
	Wed, 25 Sep 2024 20:31:19 +0200 (CEST)
Date: Wed, 25 Sep 2024 20:31:15 +0200
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
Cc: =?utf-8?Q?G=C3=BCnther?= Noack <gnoack@google.com>, 
	willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com, linux-security-module@vger.kernel.org, 
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, yusongping@huawei.com, 
	artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com, 
	Matthieu Buffet <matthieu@buffet.re>
Subject: Re: [RFC PATCH v2 02/12] landlock: Add hook on socket creation
Message-ID: <20240925.jah8aibekaH3@digikod.net>
References: <20240524093015.2402952-1-ivanov.mikhail1@huawei-partners.com>
 <20240524093015.2402952-3-ivanov.mikhail1@huawei-partners.com>
 <ZlRI-gqDNkYOV_Th@google.com>
 <3cd4fad8-d72e-87cd-3cf9-2648a770f13c@huawei-partners.com>
 <ZmCf9JVIXmRZrCWk@google.com>
 <3433b163-2371-e679-cc8a-e540a0218bca@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3433b163-2371-e679-cc8a-e540a0218bca@huawei-partners.com>
X-Infomaniak-Routing: alpha

On Fri, Jun 07, 2024 at 05:45:46PM +0300, Mikhail Ivanov wrote:
> 6/5/2024 8:27 PM, Günther Noack wrote:
> > Hello!
> > 
> > On Thu, May 30, 2024 at 03:20:21PM +0300, Mikhail Ivanov wrote:
> > > 5/27/2024 11:48 AM, Günther Noack wrote:
> > > > On Fri, May 24, 2024 at 05:30:05PM +0800, Mikhail Ivanov wrote:
> > > > > Add hook to security_socket_post_create(), which checks whether the socket
> > > > > type and family are allowed by domain. Hook is called after initializing
> > > > > the socket in the network stack to not wrongfully return EACCES for a
> > > > > family-type pair, which is considered invalid by the protocol.
> > > > > 
> > > > > Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
> > > > 
> > > > ## Some observations that *do not* need to be addressed in this commit, IMHO:
> > > > 
> > > > get_raw_handled_socket_accesses, get_current_socket_domain and
> > > > current_check_access_socket are based on the similarly-named functions from
> > > > net.c (and fs.c), and it makes sense to stay consistent with these.
> > > > 
> > > > There are some possible refactorings that could maybe be applied to that code,
> > > > but given that the same ones would apply to net.c as well, it's probably best to
> > > > address these separately.
> > > > 
> > > >     * Should get_raw_handled_socket_accesses be inlined
> > > It's a fairly simple and compact function, so compiler should inline it
> > > without any problems. Mickaël was against optional inlines [1].
> > > 
> > > [1] https://lore.kernel.org/linux-security-module/5c6c99f7-4218-1f79-477e-5d943c9809fd@digikod.net/
> > 
> > Sorry for the confusion -- what I meant was not "should we add the inline
> > keyword", but I meant "should we remove that function and place its
> > implementation in the place where we are currently calling it"?
> 
> Oh, I got it, thanks!
> It will be great to find a way how to generalize this helpers. But if
> we won't come up with some good design, it will be really better to
> simply inline them. I added a mark about this in code refactoring issue
> [1].

Making such simple helper more generic might not be worth it.  Landlock
doesn't handle a lot of different "objects".

> 
> [1] https://github.com/landlock-lsm/linux/issues/34
> 
> > 
> > 
> > > >     * Does the WARN_ON_ONCE(dom->num_layers < 1) check have the right return code?
> > > 
> > > Looks like a rudimental check. `dom` is always NULL when `num_layers`< 1
> > > (see get_*_domain functions).
> > 
> > What I found irritating about it is that with 0 layers (= no Landlock policy was
> > ever enabled), you would logically assume that we return a success?  But then I
> > realized that this code was copied verbatim from other places in fs.c and net.c,
> > and it is actually checking for an internal inconsistency that is never supposed
> > to happen.  If we were to actually hit that case at some point, we have probably
> > stumbled over our own feet and it might be better to not permit anything.
> 
> This check is probably really useful for validating code changes.

Correct, this is mostly useful for developers when changing the kernel
code.  We'll remove this kind of check when we'll have a proper struct
landlock_domain. ;)

> 
> > 
> > 
> > > >     * Can we refactor out commonalities (probably not worth it right now though)?
> > > 
> > > I had a few ideas about refactoring commonalities, as currently landlock
> > > has several repetitive patterns in the code. But solution requires a
> > > good design and a separate patch. Probably it's worth opening an issue
> > > on github. WDYT?
> > 
> > Absolutely, please do open one.  In my mind, patches in C which might not get
> > accepted are an expensive way to iterate on such ideas, and it might make sense
> > to collect some refactoring approaches on a bug or the mailing list before
> > jumping into the implementation.
> > 
> > (You might want to keep an eye on https://github.com/landlock-lsm/linux/issues/1
> > as well, which is about some ideas to refactor Landlock's internal data
> > structures.)
> 
> Thank you! Discussing refactoring ideas before actually implementing
> them sounds really great. We can collect multiple ideas, discuss them
> and implement a single dedicated patchlist.
> 
> Issue: https://github.com/landlock-lsm/linux/issues/34.

Yes, we are continuing the discussion there.

> 
> > 
> > 
> > > > ## The only actionable feedback that I have that is specific to this commit is:
> > > > 
> > > > In the past, we have introduced new (non-test) Landlock functionality in a
> > > > single commit -- that way, we have no "loose ends" in the code between these two
> > > > commits, and that simplifies it for people who want to patch your feature onto
> > > > other kernel trees.  (e.g. I think we should maybe merge commit 01/12 and 02/12
> > > > into a single commit.)  WDYT?
> > > 
> > > Yeah, this two should be merged and tests commits as well. I just wanted
> > > to do this in one of the latest patch versions to simplify code review.
> > 
> > That sounds good, thanks!
> > 
> > —Günther
> 
