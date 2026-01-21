Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC7E3ECBC4
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Jan 2026 16:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769011458; cv=none; b=iBw6t5mUOkgb0vMamJPuq4ThD6T5kJDWez1m3kMsJaxicWc2cimQZ4qgjEF+1OtMzQXWV/RyEaD6RIVzj1Ry+jD5EZz+XUfjuicA+mSO8LDGRCO/rlpl+GHZIq6Upmyh2yjKyYG3hpHnme+FhAMDXxNvbq++I8GDdPBPgIXf9qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769011458; c=relaxed/simple;
	bh=00nnYyjbbcH7nqzimPnexzOUXPjQhm3Vr6q9pxjER2Y=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iPzoZDk5xLKWmfWLz2jg4CNBr18W4AR5lHbOrVgG/W4hu2r4vvJF/1/SfdhOsVJ5DvzdYqg2q0DQ3JF7RcpYQUIIcgTdM4/jbcIShcJgMNDEIJZ0l1ex3s4xN9VHuiZko8xvxvoRkWkfL2P1n2DZPtMxcU3SqkxjAykR6uLxnYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 6A488604E3; Wed, 21 Jan 2026 17:04:13 +0100 (CET)
Date: Wed, 21 Jan 2026 17:04:13 +0100
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] monitor: fix memleak in setelem cb
Message-ID: <aXD4_Ye_KaOJgywb@strlen.de>
References: <20260121133917.11734-1-fw@strlen.de>
 <aXD4dVwPHZHGhhrh@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXD4dVwPHZHGhhrh@orbyte.nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> On Wed, Jan 21, 2026 at 02:39:08PM +0100, Florian Westphal wrote:
> > since 4521732ebbf3 ("monitor: missing cache and set handle initialization")
> > these fields are initied via handle_merge(), so don't clear them in
> > the json output case.  Fixes:
> > 
> > ==31877==ERROR: LeakSanitizer: detected memory leaks
> > Direct leak of 16 byte(s) in 2 object(s) allocated from:
> >  #0 0x7f0cb9f29d4b in strdup asan/asan_interceptors.cpp:593
> >  #1 0x7f0cb9b584fd in xstrdup src/utils.c:80
> >  #2 0x7f0cb9b355b3 in handle_merge src/rule.c:127
> >  #3 0x7f0cb9ae12b8 in netlink_events_setelem_cb src/monitor.c:457
> > 
> > Seen when running tests/monitor with asan enabled.
> > 
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> 
> Looks like a fix of commit 4521732ebbf34 ("monitor: missing cache and
> set handle initialization")?

Yes
