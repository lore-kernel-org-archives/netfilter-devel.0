Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E759A204F9B
	for <netfilter-devel@vger.kernel.org>; Wed, 14 May 2025 12:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747224062; cv=none; b=FVTROSyHSlT+4nP7pJ9sXMA4WrhlIcvnSsTFgmTonv4hFUnxkJ73m1R1TSQy86G4dWvXq7j1VjAfkjCsCon3Eph3FgWxLPUsz7MIhjSUnideh1B4Je4o39RD4WNofS8rzr7lf72be+sy8KTjQen7LmQ8TDpvGLInjBf5r4U2eN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747224062; c=relaxed/simple;
	bh=Grwja6nnrh/ZXtPdd75N5QvUUhTJJud4Q7bquWQA694=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AitD26lp1XKs506GFCOlQ5cyskpJJtVyiAVu3p21u1CNBuBNvUdKXia6SN9h+w72ciP99jYMT3CU4cny9F94kwfRdPmST1eRVxQq91pAunZj7qnp4XUbxc+OdBv2wkDkSXRaUSZh5HLgxA0T3RQTUnN0JgwabtzfYEOo0QoYdOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id AC70B60043; Wed, 14 May 2025 14:00:50 +0200 (CEST)
Date: Wed, 14 May 2025 14:01:19 +0200
From: Florian Westphal <fw@strlen.de>
To: Shaun Brady <brady.1345@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: Looking for TODO
Message-ID: <aCSF_RwSPS8zkSiS@strlen.de>
References: <aCQF1eDdqgmYE3Sx@fedora>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aCQF1eDdqgmYE3Sx@fedora>

Shaun Brady <brady.1345@gmail.com> wrote:
> To find the work, I browsed the netfilter bugzilla, looking for
> something I felt I was capable of, and started hacking.
> 
> If there are better strategies to knowing what is the best thing to do,
> even if that's back to the bugzilla mines, I'm all ears.

Bugzilla mines are good, or look at mailing list for bug reports,
e.g.
https://lore.kernel.org/netdev/PH0PR10MB4504888284FF4CBA648197D0ACB82@PH0PR10MB4504.namprd10.prod.outlook.com/

I'ts been on my list but so far I did not have time to look at it.

If you want to have a go at it, first step would be to either add or
extend an existing test case to repro the problem.

(see tools/testing/selftests/net/netfilter/ in kernel dir).
