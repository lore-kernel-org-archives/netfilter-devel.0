Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83027440631
	for <netfilter-devel@vger.kernel.org>; Wed, 19 Aug 2026 22:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787177898; cv=none; b=ADQHbmPdYEcps3Irp/FV69eC+g4XOu0zTRPfPo4w/4qN2Mje3UI8FDwdpet2xPsWjzMkGAbSct4pqq1SW8+ByiI5YbhMY+DKvjILTGeEncHnLk5iXAgJo0f1Yq0LWYWp1cIlFgftoysoGL4zUfMu94G9Iblad1fyzH1IfSf7nsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787177898; c=relaxed/simple;
	bh=qvlG1tIUD6WzdxpLcCj1qrrjSmBNQhBFzJi7UNJ2DRs=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=doDymd+XCkuQPcWUz72Fd9bRdU2k/85MhDd1aqrRtYpV8qK+dWH6sMtjPaohnpOKR5g6xjDEc+sYGsaAXz3i52BZFU/CPciBpsG0yVfjIorRCjyWaFllZe7O7wYK06VFK5CnDohCHNUqRN/7qPwxApi1PJ50ziwYli8Sw9Q5Ixc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=bWRW61CL; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="bWRW61CL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787177894;
	bh=fzWQRfidhJkzCAmSNsfD5V/lDjYj+Z4KTHNO3mPfZEg=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=bWRW61CL/evDaKf0/LhGvto/fWZmWPMiIkKLbgNY/mP8BQTJEni/iQEqPjhVXtixU
	 A7mq2CKW5+1c6V5/AtvjaEqawtM8sDTAsCuetHq/DRrarz2Ld/3a7uivOxjNcR3mAA
	 G+1gdv7s7x37vj78XNZ+ZJ5MGXGdlTa3qkYUwM+pV1ERSxcJZjcufti5vDcb/m+orp
	 +o45MtzU3PQ3I5RNoulAvrfF8xw/cDVUq8Ps8+dGxiz9Q/XTD3hO2llinacgbG8sX3
	 dzauqyRgjT6pXua7uBos1uEwnbGbRBBig5ExmMG5zL2fq6sj1wlCZDQSncQazakRKN
	 f4vapbBMv4BAQ==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 22CC36005F;
	Thu, 20 Aug 2026 00:18:14 +0200 (CEST)
Date: Thu, 20 Aug 2026 00:18:11 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH nft v3] src: add connlimit stateful object support
Message-ID: <aoYroy95PDpVGwWH@chamomile>
References: <20251124173557.4345-1-fmancera@suse.de>
 <aScsaQxELgnDDzHp@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aScsaQxELgnDDzHp@orbyte.nwl.cc>

On Wed, Nov 26, 2025 at 05:35:53PM +0100, Phil Sutter wrote:
> On Mon, Nov 24, 2025 at 06:35:57PM +0100, Fernando Fernandez Mancera wrote:
> > Add support for "ct count" stateful object. E.g
> > 
> > table ip mytable {
> > 	ct count ssh-connlimit { until 4 }
> > 	ct count http-connlimit { over 1000 }
> >         chain mychain {
> >                 type filter hook input priority filter; policy accept;
> >                 ct count name tcp dport map { 22 : "ssh-connlimit", 80 : "http-connlimit" } meta mark set 0x1
> >         }
> > }
> > 
> > The kernel code has been there for a long time but never used.
> > 
> > Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
> 
> Reviewed-by: Phil Sutter <phil@nwl.cc>

I have applied this patch that has been around for a while.

JFR: I had to make a minor rebase on top of main.
