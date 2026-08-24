Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA79E40F8D5
	for <netfilter-devel@vger.kernel.org>; Mon, 24 Aug 2026 12:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787576372; cv=none; b=JuRJ3o0aUIWlSNRNI+Dc6vB4ykw85B67gTO5Mg/acCbgJVIqUbC2BJ2NuSdPyHAQRDDX5mzfwicbaPR9TQMCmYtfybPsPYhb/QC7KAAuoplnooPzc/fRBa3NRtfN8cjVZtiZPc4AttL3JIK9mXG5BSm0Al0e77+TUrc+aHVbK/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787576372; c=relaxed/simple;
	bh=RVf1RfFaU+VMnAZOWAdpOAfBAWPj1/ZW4SL0/nFvQqE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YG3I/4kxekCjIVUXyqAailYukC7u93871G4BT0w6MAA1PxHAimz5dtpSgXgifQohuDkCAStvq61way/5A7w6mtP6rowCO0LrrxQMMxFvUQxaXxmkstNcFbTg8S26bEk/NRv3IDTc5ekPR0cUmBEPnF1ACMdCXPI2bIS9FPPmkkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=jOvXOkey; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="jOvXOkey"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787576366;
	bh=kXMSAn+NlcOHIlLJaTrX6laClgcruZgOsMFMuIDYUGk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jOvXOkey8dLhQzhhyNLq6Wwx/+uL2QgYZvZwOqryy+NWMNCiF8PhSGm3v7w6olfNa
	 jc4vx/YgqDq1GF0qkSl4DgVNx8Pm+rJWLQB02pGuiWKP4ZJSXQ4UcxDXPjV9yShiA+
	 RRzUa+vSPglO2utjl+yqBXutqXaYQAdbX9ZrLZq5UMkLif7VBk/ke2q4JnOTo4UEvE
	 +kb+49zS/4QWB0fARpO9amkqmi4a8Syv+CoHMMnI8Fwe0T4QIUdvzWMUnxSNsQyths
	 QQJdu1XaAAc8lR0YDsfQTvt29lOvNPmjjqeRb02HiFMcTOxToFC8n4A8jjKJx0+HpX
	 0I12cxo+f+BiA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id EC83360056;
	Mon, 24 Aug 2026 14:59:25 +0200 (CEST)
Date: Mon, 24 Aug 2026 14:59:23 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, fw@strlen.de,
	phil@nwl.cc, Wei Fang <void0red@gmail.com>
Subject: Re: [PATCH nf v2] netfilter: nf_tables: fix device name and prefix
 match in hook lookup
Message-ID: <aoxAK6NwkbdUSXeR@chamomile>
References: <20260824092805.4940-1-fmancera@suse.de>
 <aow3QRgFONC_OYnw@chamomile>
 <c409c65e-77b6-4bfa-bf42-027328b101dc@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c409c65e-77b6-4bfa-bf42-027328b101dc@suse.de>

On Mon, Aug 24, 2026 at 02:23:49PM +0200, Fernando Fernandez Mancera wrote:
> On 8/24/26 2:21 PM, Pablo Neira Ayuso wrote:
> > Hi Fernando,
> > 
> > On Mon, Aug 24, 2026 at 11:28:05AM +0200, Fernando Fernandez Mancera wrote:
> > > Currently, a netdev chain or flowtable hooked to a device prefix can be
> > > unintentionally deleted by a control-plane request targeting an exact
> > > device name or even a shorter one due to the usage of min() to calculate
> > > the length to match.
> > > 
> > > Fix this by making sure an exact device match never matches a prefix and
> > > that both the target and the candidate have the same length during
> > > delete operation. The add and update paths retain the existing overlap
> > > matching to prevent a single device from matching multiple hooks.
> > 
> > netdev maintainers prefer follow ups for LLM reported issues.
> > 
> > Please, provide an incremental patch for your v1 that we can take in
> > the next PR round.
> > 
> 
> Oh really? Even in this situation?

Yes, this helps reduce pressure on the mailing list.

> Will do once the PR is accepted. The patch won't be much different
> of course.

I guess so, it will be just a simple rebase.

Thanks
