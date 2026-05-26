Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656DF3FA5E8
	for <netfilter-devel@vger.kernel.org>; Tue, 26 May 2026 13:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779800762; cv=none; b=QHIRNT76rN/Qw+m32M3j82nh4369JmzSq/1hTJSYEvxXlbxqFtlB271z5fRmZRzMnCdVrCVtgt424ZnlVJux0lkufl+4b2KhPVBpspDXHG7R7yMyEmV9Aoo60n3kAy7gk5GaR0XI8YoIOFtJgb/IZoSMwhyNm4T8l0Eq9OrcoW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779800762; c=relaxed/simple;
	bh=XXAbWZZfBXvZH68HSOM7V/nmGpSbmIwjSPBQe3crElA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PfgLKYmAu2+YxseEHZOJm+Q5pRv0fbmdPKf/kiqooqF2IUngns/ya1XlJwRkfk3rD8Amk3wyozNfJMRgmdvmsHL1Rc2H+HI+yEkC+M4ylvxuwe3X+A66zBmEeaR37ryzKP4baa85fhl5+S54AugGery0ZSr/QGZaCStiD48nGxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 1029260551; Tue, 26 May 2026 15:05:58 +0200 (CEST)
Date: Tue, 26 May 2026 15:05:57 +0200
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	pablo@netfilter.org, phil@nwl.cc
Subject: Re: [PATCH 4/4 nf v2] netfilter: synproxy: fix possible write to
 stale pointer
Message-ID: <ahWatXyiNiBrE9FX@strlen.de>
References: <20260525124450.6043-1-fmancera@suse.de>
 <20260525124450.6043-5-fmancera@suse.de>
 <df64cebb-1279-4e66-afa7-3d8ffca4928f@suse.de>
 <ahSb-UU8n9o1aHoI@strlen.de>
 <4887bf00-d044-4366-8588-a83e4bce0274@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4887bf00-d044-4366-8588-a83e4bce0274@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> > In particular, seqadj and concurrent registration.  As these bugs aren't
> > as severe as patch 4, I think nf-next would be fine as well.
> > 
> > 
> 
> I have been taking a look to this. The seqadj issue isn't real IMHO.

We could be processing a 2nd packet in parallel, in particular reply
direction is a concern.

> The logic here is protected by the TCP state machine. AFAIU, ALGs only 
> look at fully established connections, I don't see how this can happen 
> even for retransmitted packets, the TCP state would remain the same so 
> nf_ct_seqadj_init() should never race with nf_ct_seqadj_set().

Can't we race with nf_ct_seq_adjust(), e.g. for closed state when
connection is reopened?

> FWIW; the concurrent registration issue is real. I am writing a fix.

Thanks.
