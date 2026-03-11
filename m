Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC2F31F98C
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Mar 2026 14:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773237693; cv=none; b=C0duXAPDk2Ee/KnuHGqpLqugXGVGhI1tlnvLamiIk2tfVdPWO4hpwhWKybhwXHxpECklMYu1T7dZMnQqy6cBT0PtdEGCpL1BV4lO+yOBg6FQG68hPNzzZ1Cgp6b7PR4v+QZue44AXu+5luqHWV1MjHE27evSMdbJTS2LDxOAARg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773237693; c=relaxed/simple;
	bh=4wii8tBQrrXODQyIeqnYl+VqJuyHXo3yBIj5hgyRBqU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WnGokS3LMIm3/BM3h/XMQsrFBgro93XwD/WfPuWAPxtrI6IPaMTHZ5YiISo+YOoBZlUCHOjRFkJ5safHI2wiZRCvF5tPYxA4QGMIKak394Cm9q7c7RJDN4SQEb3NIIRh/5LXZctjaJich2zr/aC+HioRfpSxHQEdSIp7HPy9Mbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=m6eOyq0d; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="m6eOyq0d"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=GhLdWGhbDoNTPJC97YMJlcUVK5vw/IBjOO41VQ0wmRA=; b=m6eOyq0dqpoYGf/688+m/XSIRg
	gY2yvLqEgP01oxcLKHpF2tIX1DY0mVdViASJ8IWIgB2X9/IGqvXDtt0ivVR4fo30FUcC5azZflz1X
	Q7JKiOZSKYYBiZqV4gcqV5oi1jjVC6HIW8Vhl+bB8o7Pim3kJkg4Cn0ZWgThn+1kio4TFvS9rs3WN
	5V4EDiHd4HBdFyx/VrocCCyYjmqCEChy0XzxceiHmmHap2ga9mdioVsdajrzchFg+rvAYqhhngJpS
	JK4QhLNNcMR7ghTzS8CRAF4RgHNMnW+7JJqNrBooGXnbtugpGcClKS6Fi5nSuOFbtc09lTVryEx3p
	oLeXotcA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1w0K7t-000000001Hu-0FXw;
	Wed, 11 Mar 2026 15:01:29 +0100
Date: Wed, 11 Mar 2026 15:01:29 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 2/5] cache: Respect family in all list commands
Message-ID: <abF1ubnpoMD9AJP_@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20260310231115.25638-1-phil@nwl.cc>
 <20260310231115.25638-3-phil@nwl.cc>
 <abE3Q6E9eZEm4-DZ@chamomile>
 <abFBziaYqOenTfVt@orbyte.nwl.cc>
 <abFcDNwnKzer7_r7@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abFcDNwnKzer7_r7@chamomile>

On Wed, Mar 11, 2026 at 01:11:56PM +0100, Pablo Neira Ayuso wrote:
> On Wed, Mar 11, 2026 at 11:19:58AM +0100, Phil Sutter wrote:
> > On Wed, Mar 11, 2026 at 10:34:59AM +0100, Pablo Neira Ayuso wrote:
> > > On Wed, Mar 11, 2026 at 12:11:12AM +0100, Phil Sutter wrote:
> > > > Some list commands did not set filter->list.family even if one was given
> > > > on command line, fix this.
> > > > 
> > > 
> > > Fixes: a1a6b0a5c3c4 ("cache: finer grain cache population for list commands")
> > 
> > Hmm. At that point, we didn't have 'filter' parameter in
> > evaluate_cache_list(). Struct nft_cache_filter was introduced later, in
> > commit 3f1d3912c3a6b ("cache: filter out tables that are not
> > requested").
> > 
> > Assuming that Fixes: tags are used for semi-automated backporting (at
> > least I do ;), pointing at that commit will cause trouble.
> 
> Good point.
> 
> Helping identify backporting in a semi-automated way is good,
> specially for small fixes like this.
> 
> At least for me, it helps me identify if it is an
> update/enhancement/feature or fix, it is just a bit more context
> information.
> 
> > Do you still think we should add that tag?
> 
> I get your point that tags need to be right if we use them.

How about:

Fixes: b3ed8fd8c9f33 ("cache: missing family in cache filtering")
