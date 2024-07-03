Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D662E17995
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Jul 2024 16:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720025573; cv=none; b=uXddjk8/pf9Qr3hA9/1Jhrtn/Ih45MXsfeiYUIfIdK79ZdgkwrA3jsBNYBDckgvU9NCInMU7M0kAtTMCYcvguwt6qr1AripnerNRf0MgWbdq0EZ/vSfPKhvccSBEhOL0LCBSqTuuVvHP89m0k+zMJZU9Gt/pTwtFDq8iFZ6yrhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720025573; c=relaxed/simple;
	bh=EMnIVg7FiY66nAUS1p+CZzokJe9e8aemC0u0FvR5mFE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ul/dnIbROlZJqkWsTLOSiSPhUGDi12ulRmS1BKWor04L/OQ8ppz04J1IYWqFH2RXvxrwzplh9QCN/5/kNGvoPCezDfuty11gmHi1RmCchwA/FSnq16oukG+5fiV8nfhANOTXUMngaRl9coiGPeM4KuA2symW6ETMvNa237H/N7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=VIeB8byD; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="VIeB8byD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Su/x24wv4SFD+RGVpP23qJ/ihs73zKdvTN32MCopXAQ=; b=VIeB8byDmaMmgEaQzVK1yMXVr4
	vx2MjReSdvV+EkFJBHBTIxljsGuqHkcgeX/yMYlwFwJ4FLjxYLxJu+lpNlYro5vJzNM8oOhqCCcAd
	6BKebSFNUyC3yUbwFvWu7rxgFoNvS/HkwYfrC/G686AQKiqyyKTgAu9S5igoJM0GeIyLcOzFkDuab
	ReMfug3AGKBkbxl9hcsQtq7QNqBLVaQj/dAIFowETMLbTB23b/qfvb1Fh39WLytAOM+vvNCjZDj2X
	gzLxSQVZTPIlZyRBRipPAPNHb/4Ub3xHyR42FeelXkee8IOIZ/NJMoMIxMeJDpkRpSoAzXOHgBXRn
	tjnQHG8Q==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sP3Dl-000000003zP-3obU;
	Wed, 03 Jul 2024 18:52:41 +0200
Date: Wed, 3 Jul 2024 18:52:41 +0200
From: Phil Sutter <phil@nwl.cc>
To: Jeremy Sowden <jeremy@azazel.net>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>,
	Michael Biebl <biebl@debian.org>
Subject: Re: iptables: reverting 34f085b16073 ("Revert "xshared: Print
 protocol numbers if --numeric was given"")
Message-ID: <ZoWB2Qo_vi-YIRqc@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Jeremy Sowden <jeremy@azazel.net>,
	Netfilter Devel <netfilter-devel@vger.kernel.org>,
	Michael Biebl <biebl@debian.org>
References: <20240703160204.GA2296970@azazel.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240703160204.GA2296970@azazel.net>

Hi Jeremy,

On Wed, Jul 03, 2024 at 05:02:04PM +0100, Jeremy Sowden wrote:
> At the beginning of the year you committed 34f085b16073 ("Revert
> "xshared: Print protocol numbers if --numeric was given""), which
> reverts da8ecc62dd76 ("xshared: Print protocol numbers if --numeric was
> given").

I did this in response to nfbz#1729[1] which argued the names are more
descriptive. This is obviously true and since commit b6196c7504d4d there
is no real downside to printing the name if available anymore (--numeric
still prevents calls to getprotobynumber()).

Personally I don't mind that much about changing --list output as it is
not well suited for parsing anyway. I assume most scripts use
--list-rules or iptables-save output which wasn't affected by
da8ecc62dd76. Of course I am aware of those that have to parse --list
output for one or the other reason and their suffering. The only bright
side here is that whoever had to adjust to da8ecc62dd76 will know how to
adjust to 34f085b16073, too. Plus it's not a moving target as there are
merely twelve names which remain in '-n -L' output.

> In response to a Debian bug-report:
> 
>     https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1067733
> 
> I applied the change to the iptables package and uploaded it.  However,
> this caused test failures in the Debian CI pipeline for firewalld
> because its test-suite has been updated to expect the new numeric
> protocol output.  Michael Biebl, the firewalld Debian maintainer, (cc'ed
> so he can correct me if I misquote him) raised a point which I think has
> some merit.  It is now eighteen months since 1.8.9 was released.  One
> imagines that the majority of iptables users, who presumably are not
> building iptables directly from git, must, therefore, have adjusted to
> the new output.  Is it, then, worth it to revert this change and force
> them to undo that work after what may have been a couple of years by the
> time 1.8.11 comes out?
> 
> What do you think?

I think it's a mess and there's no clean way out. The current code is at
least consistent between '-S' and '-L' output (iptables-save should not
be "less numeric" than '-n -L'). If it helps, I can work with Eric to
solve the problem for firewalld so Michael will have something to
backport to fix it.
All in all I have not seen many complaints about this change, I expect
few people scraping iptables output and only a fraction doing --list.
In addition to that, I plan on soon having a 1.8.11 release (we're far
ahead already to make backports a pain).

What do you think?

Thanks, Phil
