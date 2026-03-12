Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B757A37B009
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Mar 2026 14:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773327245; cv=none; b=Gz6KwXh74jkm02HgaJJMCJCKSrjJ/4hgqzmUwCCTmOyGEkdWGJ2YeTikv18iBHjhzNEh8Zf+YWJ08C65N2a1H3/kVJp8/Npt7kN5HKULJDo5gCd2uUgvR13SsYQv7Mo8MCNf/c6ytgYaBY9abC3d3fCdidFlTciEBkpqkpNAdYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773327245; c=relaxed/simple;
	bh=6YdV9LHd6PRFBGZ4qs8kxdXrsQhI3C1rSWi852CO4iE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PDDMd0mR1GwQvWs3VZV8qasgmzD41gNerlaSlXiH+x3+SOseGXRawCFhEG4KIdqY71NHMUSPsiXMq4DOZRxXx4aSjtd27ANrbVVgH+dMWeW+za2VUJaU2Loey+4F1QGcBYXEU/b4rCakqGY7TJsq09EJT2X8YtDPqUOC/9+e314=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 725166047A; Thu, 12 Mar 2026 15:54:00 +0100 (CET)
Date: Thu, 12 Mar 2026 15:54:01 +0100
From: Florian Westphal <fw@strlen.de>
To: Jenny Guanni Qu <qguanni@gmail.com>
Cc: pablo@netfilter.org, kadlec@netfilter.org,
	netfilter-devel@vger.kernel.org, klaudia@vidocsecurity.com,
	dawid@vidocsecurity.com
Subject: Re: [PATCH] netfilter: ctnetlink: validate CTA_EXPECT_NAT_DIR value
Message-ID: <abLTiYt1Q4aZUAoJ@strlen.de>
References: <20260312144252.2985553-1-qguanni@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260312144252.2985553-1-qguanni@gmail.com>

Jenny Guanni Qu <qguanni@gmail.com> wrote:
> ctnetlink_parse_expect_nat() reads the CTA_EXPECT_NAT_DIR attribute
> from userspace via netlink and assigns it to exp->dir without checking
> whether it is a valid direction value. Since exp->dir is used as an
> array index into the 2-element tuplehash[] array, an out-of-range
> value causes an out-of-bounds access.
> 
> Add a bounds check to ensure the direction is less than IP_CT_DIR_MAX.

Please see:
https://patchwork.ozlabs.org/project/netfilter-devel/patch/20260310132857.1383-1-fw@strlen.de/

We are seeing a massive influx of bug reports, and sometimes same
issue is reported multiple times.

Due to the large backlog, we are unable to provide timely
pull requests to the net tree anymore.

I hope I can make another pull request with pending patches
this Friday.

We are aware that the conntrack expectation bugs remain
unresolved.

This is because some of the proposed fixes are not sufficient
and a further audit is going on.
