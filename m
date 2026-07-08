Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD73390228;
	Wed,  8 Jul 2026 14:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783522525; cv=none; b=lECXL9R5ViXOWkYZtHH/c6Yqy7yV4VozRShKqNm5hBhBNGk/mIethq+zhmN8ktuOwjPf1UAm98tQgwuRgzUGAbHf/6zQcV6HZgxIId8gvt3JGPtW0PK9xnGNC0+Aj1/CTqYD44cxBzjcNKRx8aDV4oh3+d2CVti0iJ8aWQH/OH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783522525; c=relaxed/simple;
	bh=8FhydZ5T6HRYZO1CUeYB4dyiCSrzViAcpUgRLUr8FGE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lDqECGGqAv/K8iNiHQgOYUbpAzz6KaspXfStnSid8Nsf05jpJ7X0LhAPlfWcG/6wZC3Wk5A6tgzq5mp5wceh+fMJGL7nNW9bs2yukhARnpVquKjwvMqKeBSlHPVaX21hUp0GjQA25VGEO0noaX1JgDcOnzHxdhDoRblOzJ/62Lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xW4i8IH0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xW4i8IH0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE281F000E9;
	Wed,  8 Jul 2026 14:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783522523;
	bh=N4tk33+gGzEvWhx3TAYATpFb6wxOHUQmG8/nMmeWOk0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=xW4i8IH00Xp6ZAjNrt4/A3qUb/gBuHTe/GlvTkuACu4a9Pz0zHAJa6o5Zjifg3gJ7
	 RZjLOgySpbzaGfHe1VBkUx6uoZ7r9my1/m1uZVWhbuNgeO+eZ7cckcAXUw1lPNde4o
	 QVN2IHGaRvCryL30/1DVjQWiXXoyUMZ7O05dyy0E=
Date: Wed, 8 Jul 2026 16:55:20 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Yuan Tan <yuantan098@gmail.com>
Cc: linux-kernel@vger.kernel.org, workflows@vger.kernel.org,
	jhs@mojatatu.com, sven@narfation.org, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [RFC] VEGA: a syzbot-like workflow for LLM-found kernel bugs
Message-ID: <2026070828-carried-extortion-789e@gregkh>
References: <20260708092247.4188498-1-yuantan098@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260708092247.4188498-1-yuantan098@gmail.com>

On Wed, Jul 08, 2026 at 02:22:47AM -0700, Yuan Tan wrote:
> Hi all,
> 
> We would like to ask for feedback on a proposed workflow for reporting Linux
> kernel bugs found by an LLM-assisted code auditing tool that we have
> been developing since earlier this year.
> 
> Since February, we have been developing an LLM-driven kernel code auditing
> tool called VEGA. It started as a side project, but the results became much
> substantial than we expected: VEGA has found hundreds of valid bugs in Linux
> kernel.
> 
> That immediately created a practical problem: we do not want to dump a large
> pile of bug reports onto mail lists and annoy the maintainers.

True, which is why we all end up with long lists of issues/patches at
the moment.  The initial reaction is "we need a dashboard for everyone
to collab around!" like you did here, but I'd like to say this is not
the best thing to do at all.

syzbot can get away with a dashboard because someone is tending to it,
triaging the "serious" bugs before they become public, and only letting
the "would be nice to fix one day" type issues remain.  That's a huge
resource commitment that Google has made here, and that's great, but I
doubt that anyone else will have those resources to do this type of
thing.

Instead, let's just work to get these things fixed.  We all have
hundreds of patches/reports in our internal systems right now,
attempting to triage/rank/coordinate would just waste time.  In other
words, just grind through them, send patches out, and get these fixed.

I'm doing this now, and I know many others are as well.  We are all
running "different" tools, and so we find different issues, so we can
all just keep sending patches as we get them done.  It's going to take a
lot of effort (I've somehow convinced 8 interns to help me out with this
this summer), but once we get it done, we'll be much better off.

> The first thing we tried was to fix as many as we could ourselves. We
> started working with a group of student volunteers. Most of them are
> college students, so we have been training them, reviewing their patches,
> and trying to build an internal review process before anything is sent to
> the mailing list. The goal is to turn these findings into useful fixes, and
> also to help new contributors grow into people who can reduce maintainer
> workload instead of adding to it.
> 
> The process was not perfect. Some patches were not good enough, and we also
> made some mistakes early on when deciding what should be called a security
> issue.  Our internal review process has been improving with the help of the
> community.

That's great, keep it up!

> But the remaining queue is still too large for us to handle.
> 
> Recently Jamal pointed out problems around our tags. That made me realize
> that we should probably stop treating this as an ad-hoc patch effort and
> build something closer to syzbot: public, reproducible, trackable,
> deduplicated, and useful to maintainers.

Again, I think that effort is going to be larger than just getting the
patches fixed and pushed out.  It also turns into a central
point-of-failure, which is what we do not want to have at all for the
kernel.

But hey, I could be totally wrong.  Maybe some generous company that is
involved in unleashing this hell on us would be so kind as to pony up to
do the work to create this and help fix the issues that their tools are
finding.  Just like Google did in the past, there is precedent, but for
some reason people don't like learning from history...

It's going to be a long 18 months...

greg k-h
