Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86ABD377558
	for <netfilter-devel@vger.kernel.org>; Tue, 19 May 2026 19:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779220636; cv=none; b=OU36z6MLUJopzSuHGWgeDs0RswTq0BNaI7pnM94GzLb0qXrTs37vMgqC6Su2M5nHvrukF9BGBH9pcRkUylNg9/4oHoYpRKtsBBmc+odL7DCyzReA+J2fRoz6zMlCR2MmOphcmk9ZheynW2i4ucUT66a0h3W9eGFQ/HXdaP4uI9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779220636; c=relaxed/simple;
	bh=pN3XIHdrqx3ijqdYZ8bCAuOjdKRqQEOxjyYIVsEIzjc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UfCCH2G90qN+AVrgDmkzB+FwlW3ZjADZRnD1hekq0XBYk7kfsWED5Yjn2TZzSl/QvtA5TIbKB9/ETwJ8j3g6eDVBR1ZgTniqMuVdEWZDVm/MlwUiIvR4qi2CYr11gyxEcMHo6oIZVHCu+Ss2QZOveD4ubnV5Z2/+bL82VGHSre8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=vsG+k6tP; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="vsG+k6tP"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id C552E601B4;
	Tue, 19 May 2026 21:57:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1779220632;
	bh=X5egwXWm1X/NLOsH8bZlXJgnmS4sCk7h9yzgAwhN4ks=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vsG+k6tPVy0s/2uubzL7P9QZJIYrOetw6U6IAEMxd4kSJQRn7jEtNFC7mFhdJAAH4
	 Z1mSUofTUtwEmAL7t42ojkgb7NTc1JEOU79QU89ucizEOnRFWQ71FCHkSbyPqDrKQQ
	 jj2tG3E/XOYvF9YgHFS3g0qHt6CA71wi7AJKx9Mvh1F7fURc6MDRHXxrdHPCntxlJx
	 wsv9LGbbAtB+M0uaA5Y3BKTcVVTAWOw7IjGcfvNKD/sTI/My4T54TO3+4+YiOjpitL
	 2ynxWItcjY2wP663j1FTFQoACVJreLCaUPLbu3DbL+AXMJ6cD+C+d9E4GXoJLi4Q1p
	 p9QE+a+dWjBYw==
Date: Tue, 19 May 2026 21:57:09 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: =?utf-8?Q?=C3=80lex_Fern=C3=A1ndez?= <tomaquet18@protonmail.com>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v4] netfilter: conntrack: fix integer overflow in
 expectation timeout
Message-ID: <agzAlQb36seb2Rhr@chamomile>
References: <20260504112300.715192-1-tomaquet18@protonmail.com>
 <agy8JBZYvx54GYfL@strlen.de>
 <agzAFhNpiYNcBeZ5@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <agzAFhNpiYNcBeZ5@chamomile>

On Tue, May 19, 2026 at 09:55:06PM +0200, Pablo Neira Ayuso wrote:
> On Tue, May 19, 2026 at 09:38:12PM +0200, Florian Westphal wrote:
> > Àlex Fernández <tomaquet18@protonmail.com> wrote:
> > >  		x->timeout.expires = jiffies +
> > > -			ntohl(nla_get_be32(cda[CTA_EXPECT_TIMEOUT])) * HZ;
> > > +			(u64)ntohl(nla_get_be32(cda[CTA_EXPECT_TIMEOUT])) * HZ;
> 
> Yes, for correctness, fixing this is fine but...
> 
> > https://sashiko.dev/#/patchset/20260504112300.715192-1-tomaquet18%40protonmail.com
> > 
> > Does this fully resolve the overflow on 32-bit architectures?
> > The expires field in struct timer_list is an unsigned long, which is 32 bits
> > wide on 32-bit systems. Assigning the 64-bit multiplication result directly
> > to expires will silently truncate it back to 32 bits, causing the same
> > wraparound this patch intends to fix.
> > Additionally, does providing a timeout delta larger than INT_MAX break the
> > kernel's signed timer comparisons?
> > If the delta exceeds INT_MAX, macros like time_after() will evaluate the
> > timer as being in the past, causing it to expire immediately.
> 
> the submitter claims you can create expectations that expires
> inmediately, but what is the issue with this?
> 
> > Should the computed timeout delta be explicitly clamped to a safe maximum
> > (such as INT_MAX or MAX_JIFFY_OFFSET), similar to the logic used for
> > standard conntrack timeouts?
> 
> I think this is just a cleanup / nf-next material?

But this can also go through nf.git for correctness, we can just
describe in the PR the effect of this bug.
