Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5778D1EB5F4
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Mar 2025 19:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741808730; cv=none; b=dA0XVdSvlHNJwwgKHezu5TfqROB4hptX8DcbCsDT92tDP61KVhx6FXcAE5B1Omo+uKWSx2mass2hvuuYQoX0rfvzL4WcVVtRAbFAlDkB3vQnmqO8fNHlcpSUJLfi8d5xhQBPkDtDNA0MUPScFBQWW2kea9kopEKXU/kTsLQW0N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741808730; c=relaxed/simple;
	bh=KUMA80HTTUfJ+boGJybF8ul1AHsL6iQWAS5o1JNXWUw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WPQlXDYyvy/1mkNwApqMwkgyPIePZCuHNpH5/zs1AhqzaN1RRtx/A/O3PeuyeJY06hTVqAvf/H4MJqRMHK9PE0ItrkYNSrqhsQleAbAubSWzWvziecU+sMvc0Pxkgtg/VB/ZglI2mz0vqqFL88n3iiFQXIvQHEcxKTQgKzuLvvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=D7YVOuUG; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=D7YVOuUG; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="D7YVOuUG";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="D7YVOuUG"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 9D492602CB; Wed, 12 Mar 2025 20:45:25 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741808725;
	bh=HWCW4GWnp2d+Coe2RKqGd2bJE29cUCGkjt8CxjroY+Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=D7YVOuUGENYNYfbqtXxBF3V7xUYa9//bU4CG02B1V0GtK5CWffwDe3RF+xeFkpQ+4
	 2aoSWkjPV+Tbw2L8obOP5MTfzTQ6hoizm7CITihnbbITa374aEc4VYA7AWi6Gw2kh+
	 +nGAMc0dSZmCyQW3FfpwCAduVqqQ7bVVbxsJvf6jZKjnPnJHyrurQ5m1X3Z+T0w5KU
	 4XweQx68w4yQsXcj7TLXCtk4xS40ZYRTq5t+J2JlyCVKsJOrT+fuXVxdLnS2qXUdkP
	 cHnC2hVtpu755M89MSEzlaOMwokbRilSvsnBlur6JEPm4JvEbzNn2PGlZtxlyGg4/C
	 eglT/kfL3GmTQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id F2032602CB;
	Wed, 12 Mar 2025 20:45:24 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741808725;
	bh=HWCW4GWnp2d+Coe2RKqGd2bJE29cUCGkjt8CxjroY+Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=D7YVOuUGENYNYfbqtXxBF3V7xUYa9//bU4CG02B1V0GtK5CWffwDe3RF+xeFkpQ+4
	 2aoSWkjPV+Tbw2L8obOP5MTfzTQ6hoizm7CITihnbbITa374aEc4VYA7AWi6Gw2kh+
	 +nGAMc0dSZmCyQW3FfpwCAduVqqQ7bVVbxsJvf6jZKjnPnJHyrurQ5m1X3Z+T0w5KU
	 4XweQx68w4yQsXcj7TLXCtk4xS40ZYRTq5t+J2JlyCVKsJOrT+fuXVxdLnS2qXUdkP
	 cHnC2hVtpu755M89MSEzlaOMwokbRilSvsnBlur6JEPm4JvEbzNn2PGlZtxlyGg4/C
	 eglT/kfL3GmTQ==
Date: Wed, 12 Mar 2025 20:45:22 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: nf_conntrack: speed up reads from
 nf_conntrack proc file
Message-ID: <Z9HkUgJgQBHXrR6Z@calendula>
References: <20250211130313.31433-1-fw@strlen.de>
 <Z9G8TcHOTdn7LBsj@calendula>
 <20250312182838.GB3007@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250312182838.GB3007@breakpoint.cc>

On Wed, Mar 12, 2025 at 07:28:38PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > -	struct ct_iter_state *st = seq->private;
> > > +		hlist_nulls_for_each_entry(h, n, &st->hash[i], hnnode) {
> > 
> >                 hlist_nulls_for_each_entry_rcu ?
> 
> Yes.
> 
> > > -		if (likely(get_nulls_value(head) == st->bucket)) {
> > > -			if (++st->bucket >= st->htable_size)
> > > -				return NULL;
> > > +			++skip;
> > >  		}
> > > -		head = rcu_dereference(
> > > -			hlist_nulls_first_rcu(&st->hash[st->bucket]));
> > 
> > This does not rewind if get_nulls_value(head) != st->bucket),
> > not needed anymore?
> 
> There are only two choices:
> 1. rewind and (possibly) dump entries more than once
> 2. skip to next and miss an entry

I think we can still display duplicates in 2. too since nulls check if
the iteration finished on another bucket? Then 2. means skipped
entries and duplicates.

> I'm not sure whats worse/better.

Skipping looks simpler, it is less code. But if entries are duplicated
then userspace has a chance to deduplicate?

I am not sure how many entries could be skipped without the nulls
check in practise TBH.

If you prefer to simple and skip entries, I suggest to add this to the
patch description, this is a change in the behaviour that is worth
documenting IMO.

Thanks.
