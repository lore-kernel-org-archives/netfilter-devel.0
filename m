Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F981B393A
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Oct 2024 07:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729063578; cv=none; b=JvMVGrZy3pLoylbxGG5Ol/gGG0KRjrlto2AkFjUYvIj/faLqblXZQgqoqFqMfsQekojERzZD9I2imX3Ue1tg9TU7lscYpUKMUF/EZA5EEpF74Qq14V4ihxXjw5HKL80K0o/WGynyY6fmfjCJMwweYpZFZF8ArmBdBQ7FcbQ26Yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729063578; c=relaxed/simple;
	bh=3rjL2st/HIkNouX72WHgS7xiYHSTH/PwZ8X3vkYFcoo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lVcD7I92RHc580sbWMCyv2xoeOt8pE/wTiTps0T0nq4VZt1g5Now79HhHwyaSbq7IKIx7uDO3JsvXIJQrpKTywjGm7uM4L8eNf9LLhuG0iCrj2Hu0SRKr2nr/YWU54mLxHBi5MdyIqUDvriuFqfbGAb6XrDAu83+tyuvQ5lvMns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=46418 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t0yQ7-00BLPy-3n; Wed, 16 Oct 2024 09:26:13 +0200
Date: Wed, 16 Oct 2024 09:26:10 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Duncan Roe <duncan_roe@optusnet.com.au>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libmnl v2] build: do not build documentation automatically
Message-ID: <Zw9qkveNN6DkpvHM@calendula>
References: <20241012171521.33453-1-pablo@netfilter.org>
 <ZwzOgRoMzOiNfgn0@slk15.local.net>
 <ZwzRn6EQpRJWxYA-@calendula>
 <n4r27125-61q3-r7p2-ns82-77334r0oo3s3@vanv.qr>
 <Zwz-e5ef9uyTG6Yv@calendula>
 <Zw8UOCbpwSOupUcf@slk15.local.net>
 <Zw9qbppRAtX4VbIv@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Zw9qbppRAtX4VbIv@calendula>
X-Spam-Score: -1.8 (-)

On Wed, Oct 16, 2024 at 12:17:44PM +1100, Duncan Roe wrote:
> On Mon, Oct 14, 2024 at 01:20:27PM +0200, Pablo Neira Ayuso wrote:
> > On Mon, Oct 14, 2024 at 01:12:02PM +0200, Jan Engelhardt wrote:
> > [...]
> > > Having worked extensively with wxWidgets (also doxygenated) in the past
> > > however, I found that when the API is large, needs frequent lookup,
> > > documentation has many pages, and online retrieval latency becomes a
> > > factor, I prefer a local copy as a quality-of-live improvement.
> >
> > For reference, there is one online available at:
> >
> > https://www.netfilter.org/projects/libmnl/doxygen/html/
> >
> > for the current release.
>           ^^^^^^^
>           (since I prompted you to update it last month)

Indeed, I appreciate your reminder.

> > [...]
> > > Removals are a powerful action that is seldomly undone at the distro
> > > levels, so it can be regarded as the final say (well, in "95% of
> > > cases").
> > [...]
> > > Hiding stuff behind a configure knob is not a removal though,
> > > so it is not too big a deal.
> >
> > Exactly.
> >
> > > >Moreover, documentation is specifically designed for developers who
> > > >are engaged in the technical aspects. Most users of this software are
> > > >building it because it is a dependency for their software.
> > >                                             ^^^^^^^^^^^^^^
> > >
> > > The way it's phrased makes those users users of the libmnl API (i.e.
> > > developers), and documentation is warranted.
> > >
> > > (The following statement would be more accurate:
> > >
> > > >Most users of this software are
> > > >building it because it is a dependency for someone else's software
>     ^^^^^^^^^
> > > >they want to utilize.
> 
> WRONG. These users get the built package from their distributor. Many would not
> have the know-how to do anything else.

... And it seems distros don't include already built doxygen
documentation in their packages.

> Our direct end-users are developers and distributors.
>  - developers typically work at the tip of the master branch so will want
> current documentation
>  - Distributors can easily strip ot what they don't want, as Jan mentioned. But
> I don't agree with him that "Hiding stuff behind a configure knob ... is not too
> big a deal". It's not immediately obvious what --with-doxygen does.
> >
> > That sounds more precise, yes.
> >
> A precise description of users we don't have :)
> 
> Pablo, could you perhaps share with us what triggered you to think of doing this
> at all?

I believe we have provide a good number of reasons already.

Thanks.
