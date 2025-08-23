Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92471D8E10
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Aug 2025 22:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755986922; cv=none; b=ZoDX07EadhBmhvyIxfsf2SmMJERrZkjNLnnMkFJ6v2MJ19akje/iv7/QCstsvi9uURfnrJRtTCF57pDatU/8Pkj8wcuRT6xENMpgCW7v5J1pfpjbAIb+OT7HLChP25wr6g28wo/Brm2t/30NItMJsQnJoTho/7VrmXSsrwDjKos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755986922; c=relaxed/simple;
	bh=4127LSvE6xUzIregW2cJb9e+3l3Y5rfwZtH4LbZ0giE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZR3dLfo+feeocbCzjmrGMyCdMLS/2/tPx5j8zhbcSPydQ4wXWtfsNJQkgGJZOejt0Yt2yMMZ5dXPG6yUxkj1FwEVxlqw4eIvFtY8ukKUNj+Uw7/SDjHD2i/p2tQw6X9osi44SWwgOlfa/koIJSX8L5NVOtYTyAnRFW7bS87/cVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=AoDOt1X3; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="AoDOt1X3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=5nOiy6sKrj5N4KXrlWPuW5JCwsIR2slG7WBH4uUwSWg=; b=AoDOt1X3mnGlja7cuRXUX7SGWI
	7636JM6kyxZy8uoyRXSleFEwYHEUrp3oZiSw//syN/0ouUD8PPMrRhVGFZqOXCeEcST/jwVyHX+TW
	RmPn+HQspewMa8AIEg8fg8vYrr1STBySt+aLy+6kS5maG9XCuoM9XlMSxCQ0v6ItzbP4ZmnCYi4xV
	6Gm7wnF8kPQ8SGGxvyNZy9tN7SFp2WBrH/PncLLBkyz1py0FyuWBzy5tM0PKsPu99oYQzCa/6yaH/
	1JVq1ZVK3w8kU7OhKGP47Odc14PZIfuy9CJShJ6rqsrgpiIemvyw6qhwCmalsMgm6+FWLa6Fx1DBP
	B9kFzAUg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1upwPe-000000006n5-3PAi;
	Sun, 24 Aug 2025 00:08:38 +0200
Date: Sun, 24 Aug 2025 00:08:38 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [nft PATCH] tests: monitor: Fix for flag arrays in JSON output
Message-ID: <aKo75vgwY6F5KNVh@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
References: <20250823220357.18949-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250823220357.18949-1-phil@nwl.cc>

On Sun, Aug 24, 2025 at 12:03:57AM +0200, Phil Sutter wrote:
> Missed to adjust the expected JSON output in this test suite, too.
> 
> Fixes: 5e492307c2c93 ("json: Do not reduce single-item arrays on output")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
