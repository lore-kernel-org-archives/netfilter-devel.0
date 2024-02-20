Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB08767A04
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Feb 2024 12:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708433077; cv=none; b=dq02+9q1OtKvV2YXLGEuCOks9xtxbFE7VjC10wfuyc75Blf8BLEtoF75GPAYoARqtWdhBWhMsDkKi0KCazrMSM+uzxOLiiABOAPzjCjZfDfLUatr0sEeSkvx7vcTmhhI8VwCkyKcCFO/HqoAWNb8kSf1NiBNOkrPeq1O1uGdUH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708433077; c=relaxed/simple;
	bh=tn0apeMAz+k7oPpmD4jNrK6HcOSWKuwrL0v6/SKZ3LA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FBXDBaKQMTjP52ZqUSj5Mx3T2vU/P5x/pLvonIOcBzLxNG61B1RYpI1WCj22zPdsOdTvwmSVqOHAEVENVISOYKkTsAqTFaq4Q6lDv097tJABtV0HjL67UaNu5XZtmQ+KwR4nnTwv5CNfj6bsHInIvxxDB/IKfgXVHYCspBrMRis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.41.52] (port=55118 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rcPU6-00A0kH-Vr; Tue, 20 Feb 2024 13:44:32 +0100
Date: Tue, 20 Feb 2024 13:44:30 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jeremy Sowden <jeremy@azazel.net>
Cc: Arturo Borrero Gonzalez <arturo@debian.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [RFC] nftables 0.9.8 -stable backports
Message-ID: <ZdSernUJ/EZp9ytc@calendula>
References: <20240218135600.GA4998@siaphelec.sdnalmaerd>
 <ZdSaqOwcEukd4lj4@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZdSaqOwcEukd4lj4@calendula>
X-Spam-Score: -1.9 (-)

On Tue, Feb 20, 2024 at 01:27:30PM +0100, Pablo Neira Ayuso wrote:
> Hi Jeremy,
> 
> On Sun, Feb 18, 2024 at 01:56:00PM +0000, Jeremy Sowden wrote:
> > On 2024-02-17, at 20:11:42 +0000, Jeremy Sowden wrote:
> > > Does this look good to you?
> > 
> > Forgot to run the test-suite.  Doing so revealed that this doesn't quite
> > work because `set_alloc` doesn't initialize `s->list`.
> 
> I'd suggest instead a backport of the patch that fixes the set cache
> for 0.9.8 instead.
> 
> See attached patch, it is partial backport of a upstream patch.
> 
> I have run tests/shell (two tests don't pass, because 5.15 does not
> support multiple statements) and tests/py for that nftables 0.9.8 version.

... multiple statements in set elements)
