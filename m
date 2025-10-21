Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8372459F7
	for <netfilter-devel@vger.kernel.org>; Tue, 21 Oct 2025 12:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761049109; cv=none; b=CDhry/H0iFcKKd33s4WrA0gyqcRRkur0LDTvmn2LpfECiNuIt3BMNFcHLUYim2m/URLzdpA48EapG29xhenG6CSxjeFUaCRYbWKFIMCxjoNfEudbhvAcwsJNBbz8AZEsvaLAF7yG8NE8Zdh0ILVfx9UwgZP6s0Cw1TGO2/FnfPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761049109; c=relaxed/simple;
	bh=DuBYI3vdx3DYPz0ukJKKfCvY/SfxxRl35m8f+20+COY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dm0zlhFDp10mAt7C9bGfZ11iIhc0QzI77yzVjZcfhnwol5X9fvMONNAnZk8PDTWmJMN5J61rk2hOsLkyndDC5GTYJRCSCDk/CB1DBrVDex5alGtD8s6x6AUdcmbaj1oW/2YmhdFmxh8G0E11opTaXaFiY8yqJ7OgTlkrOHPRi3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 2B8E4618FC; Tue, 21 Oct 2025 14:18:23 +0200 (CEST)
Date: Tue, 21 Oct 2025 14:18:18 +0200
From: Florian Westphal <fw@strlen.de>
To: Antonio Ojea <aojea@google.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Eric Dumazet <edumazet@google.com>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] selftests: nft_queue: conntrack expiration requeue
Message-ID: <aPd6Ch7h6wdJa-eE@strlen.de>
References: <20251020200805.298670-1-aojea@google.com>
 <aPah2y2pdhIjwHBU@strlen.de>
 <CAAdXToT14bjkvCrP=tG4V4XJhhyGMfuJz+FdfTO+xJ10Z-RezA@mail.gmail.com>
 <aPay1RM9jdkEnPbM@strlen.de>
 <CAAdXToQs8wPYyf=GEnNnmGXVTHQM0bkDfHGqVbLhber04AyM_w@mail.gmail.com>
 <aPdkVOTuUElaFKZZ@strlen.de>
 <CAAdXToRzRoCX4Cvwifq9Yr7U663o4YLCh1VC=_yhAYqAUZsvUA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAdXToRzRoCX4Cvwifq9Yr7U663o4YLCh1VC=_yhAYqAUZsvUA@mail.gmail.com>

Antonio Ojea <aojea@google.com> wrote:
> > Does it start to work for new flows when you add a rule like
> > 'ct label foo'?
> 
> It does work, but it still shows the error
> 
> conntrack -U -d 10.244.2.2 --label-add test
> tcp      6 86382 ESTABLISHED src=10.244.1.8 dst=10.244.2.2 sport=39133
> dport=8080 src=10.244.2.2 dst=10.244.1.8 sport=8080 dport=39133
> [ASSURED] mark=0 use=2 labels=test,net
> conntrack v1.4.8 (conntrack-tools): Operation failed: No space left on device

Looks like one needs to set a label somewhere, no need for it to match.

chain never { ct label set foo }

makes this work for me.
We could change this so that *checking* a label also turns on the
extension infra.

Back then i did not want to allocate the extra space for
the extensions and i did not want to add to a new sysctl either.

So I went with 'no rules that adds one, no need for ct label
extension space allocation'.
