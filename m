Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE0C85474F;
	Thu, 12 Mar 2026 23:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773357025; cv=none; b=LjHqu+y/iS75uKlJHkgmCXdR1SBXx14aEbQh4XwYJ0ibwsez2DUKuoO20PDZ9W9T3X66HfpLLOzGbYhvVSSALBEs6RfFZRK50Ixczd62wNQSSI97Z0+rHR2LT81LOU31oW5sfzzakJNHZgbx7haERZ6UdrGlJMBhpguHhQ70VIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773357025; c=relaxed/simple;
	bh=V9MsJas5VqrwU+ZQcIln6/NPhLNGcGpWJ1IqyvVpnQc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E0/ZNtY4oUoTGdoJyV1OjbOZ6A+x3KZEvAYpVUM37JDcldFRmfN9+iD77Todfus23RLJqDl0gSR/Hhg0ZNU8LeHibW+e8n56UZ9xR1t0Rfer05kNCkfwCEXBaS5O9uBaN0GIhWlPqpRXl8G5AVoFdPwDxkqFpSa1C5myL7nCvUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 0743D60470; Fri, 13 Mar 2026 00:10:21 +0100 (CET)
Date: Fri, 13 Mar 2026 00:10:23 +0100
From: Florian Westphal <fw@strlen.de>
To: Prasanna Panchamukhi <panchamukhi@arista.com>
Cc: netfilter-devel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	netdev@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH net-next] netfilter: conntrack: expose
 gc_scan_interval_max via sysctl
Message-ID: <abNH3xxxAU7U4zz5@strlen.de>
References: <20260311194058.13860-1-panchamukhi@arista.com>
 <abKzWIhVz_SeiSOa@strlen.de>
 <CACqWiXD2_O32K4NhmNBZrAUG7U9-N93LTFjJHG6Tq=4vuafNuA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACqWiXD2_O32K4NhmNBZrAUG7U9-N93LTFjJHG6Tq=4vuafNuA@mail.gmail.com>

Prasanna Panchamukhi <panchamukhi@arista.com> wrote:
> Our primary goal is to cap the maximum time taken by the GC to clean
> up expired entries. We rely on user-space notifications to clean up
> these entries from the hardware, so ensuring a predictable upper bound
> is important for our use case.

Sure, but why can't we try to give a better default behavior?

while true; conntrack -L >/dev/null;done

basically does what you want already (but in a dumb way).

> Regarding the adaptive strategy, we are using this sysctl to address
> environments where the current average-based calculation delays the
> cleanup of short-lived entries.

Yes, and I did propose to adapt the existing strategy to provide more
timely notifications.
