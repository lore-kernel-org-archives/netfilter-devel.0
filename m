Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88699274FE3
	for <netfilter-devel@vger.kernel.org>; Tue, 27 Jan 2026 23:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769555935; cv=none; b=W29ZaWKpznWa+RgJ9f6KjZ87Cq8sA3dv3zaIK029KbCUh5yAHmauxnVRrEhSZ4s0f8ec2WNSaXa0GnV1Ux9ojGbOoH/nb6EAwzahG0UavSbvtPfYRDqHgbRt8n5lqu4U9iSV2hXZDarQuUkfwAJIvL/uEtc90Zx2ckL9lDv6GjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769555935; c=relaxed/simple;
	bh=5gT2A0Obs5fJTz865oFH7H6eqWhP/E9OpFKwv4PrC9k=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sPPXf8FdO/RgDbzc0mAci2LeJt+E4MMMKMEwfxHv7mz7Wf5Y6uXf42uI8c9N53klnd5IAUcYKNrlbzb/fRWIxYdBeQ6Jg7dqunUXbKNqutLE3HYeUxXi8IvJNmtoHwNOC308t0Z532U0Z+h/t7DD5engUtd/881spJ8rQk5qIi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 6F2BA602B6; Wed, 28 Jan 2026 00:18:51 +0100 (CET)
Date: Wed, 28 Jan 2026 00:18:51 +0100
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] doc: nft.8: Describe iface_type data type
Message-ID: <aXlH2xBJdgX9gFgj@strlen.de>
References: <20260127221252.27440-1-phil@nwl.cc>
 <aXk5l4AQ4XHvyBrx@strlen.de>
 <aXk-ZPRpYwj_KZ5e@orbyte.nwl.cc>
 <aXlAdFAKM5SVfFfE@strlen.de>
 <aXlDPwtasLIQ9NMg@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXlDPwtasLIQ9NMg@orbyte.nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> As said, these headers are all structured as "<typename> TYPE":
> 
> - INTEGER TYPE
> - BITMASK TYPE
> - STRING TYPE
> - INTERFACE TYPE TYPE

- INTERFACE TYPE

> - LINK LAYER ADDRESS TYPE
> - IPV4 ADDRESS TYPE
> ...
> - ICMP TYPE TYPE

ICMP TYPE

> - ICMP CODE TYPE
> - ICMPV6 TYPE TYPE

> - ICMPV6 TYPE

> IMO we could drop the " TYPE" suffix from them all, but only merging the
> "TYPE TYPE" cases is inconsistent.

Why?!

INTEGER TYPE
INTERFACE TYPE TYPE

Thats absolutely sounds inconsistent.

Sure:
payload expression, datatype integer (integer), 4 bits
meta expression, datatype iface_type (network interface type) (basetype integer), 16 bits

So what?
I don't see any implication that you can take 'FOO TYPE' to mean
that the type is called 'foo' internally.

> I get your point, it looks wrong and sounds odd when reading out loud
> but it is formally correct.

Ok, I give up.
