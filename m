Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6818C1DFFC
	for <netfilter-devel@vger.kernel.org>; Wed, 28 May 2025 21:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748468930; cv=none; b=Pe5xoyua4/M7jqNpaox360iDsiYUhuj7Km4j9/Eevr27q+T3zgGF7DUYtLA+yECTgPJkzIr4H0vM/MvqDcz6bCPOaTWQDunjAc/aojkYUMLAu3iZ87c0JvBhraVPKG5TojKO89ByqVqHWCj4Pb7cAL5IlsQ41wMgjAa7GVK8R3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748468930; c=relaxed/simple;
	bh=bx89bjJMkjAUr5JfKsvweDwrVwUmX722osBovbHYptQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dme5cvEGeaVA+1qoRHbtUjQrrvm7wrJRFmaoX0qsD//nzMtBpdfJl1apf+Hb2i7jzBm/4gZCI60XL8DjPUZUdap2NKA/PxTXM6uoMCMg7gnAS3sP/jh8bYCaPU14qbYWCEnDktI56OT90d4qalLBkXUJw53E3fI9Jbsaamso1DU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 443D760115; Wed, 28 May 2025 23:48:45 +0200 (CEST)
Date: Wed, 28 May 2025 23:48:44 +0200
From: Florian Westphal <fw@strlen.de>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: pablo@netfilter.org, kadlec@netfilter.org,
	David Miller <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Subject: Re: [BUG REPORT] netfilter: DNS/SNAT Issue in Kubernetes Environment
Message-ID: <aDeEvHI-qJNkrruz@strlen.de>
References: <CALOAHbBj9_TBOQUEX-4CFK_AHp0v6mRETfCw6uWQ0zYB1sBczQ@mail.gmail.com>
 <aDbyDiOBa3_MwsE4@strlen.de>
 <CALOAHbAeVhLAe3o3UL8UOJrCRbRP8mqYZy37CYNHYFa3zss6Zg@mail.gmail.com>
 <aDb-G3_W6Ep19Zjp@strlen.de>
 <CALOAHbCYhYCLt7zJfdmSUWk_jpWXudLokXvQTGSJt_g4WALGsw@mail.gmail.com>
 <aDcNjpqOKNonzrT-@strlen.de>
 <CALOAHbA2fT+zcnjivX8-D00FrNyGnj3tvvEX1PghAEwk+uyRSg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALOAHbA2fT+zcnjivX8-D00FrNyGnj3tvvEX1PghAEwk+uyRSg@mail.gmail.com>

Yafang Shao <laoar.shao@gmail.com> wrote:
> On Wed, May 28, 2025 at 9:20 PM Florian Westphal <fw@strlen.de> wrote:
> > ... and that makes no sense to me.
> > The reply should be coming from 127.0.0.1:53.
> >
> > I suspect stack refuses to send a packet from 127.0.0.1 to foreign/nonlocal address?
> >
> > As far as conntrack is concerned, the origin 169.254.1.2:53 is a new flow.
> >
> > We do expect this:
> > 127.0.0.1:53 -> 10.242.249.78:46858, which would be classified as matching response to the
> > existing entry.
> 
> Could this issue be caused by misconfigured SNAT/DNAT rules? However,
> I haven't been able to identify any problematic rules in my
> investigation.

No, because even if there was an SNAT rule it would not be used
for a reply packet.

Can you check the dns proxy and confirm that it is using the "wrong",
i.e. the public address as source for the udp packets?

Alternatively you could also try adding a NOTRACK rule in -t raw OUTPUT, for
udp packets coming from sport 53.  It should prevent this problem and
make your setup work.

Assuming the dns proxy already uses the public address, no dnat reversal
is needed.
