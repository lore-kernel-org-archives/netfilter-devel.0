Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 291D6361656;
	Wed, 26 Aug 2026 16:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787762554; cv=none; b=fbAh4UO8xoPObDYTBlrQ9XvnAeCWMtiNRfDPf5ZM+sUWWHSlJZu2MpDrGzftuh2r5EGfqtQKE+PuGfTHfV4FILOAJvcK+Lo8edi7Vg1Rr+51/ddLEU2LeisQTho+kHwkWMda4SeGg73cfSj7uilF807EWI/Q5Y+9mpwCilZ0p28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787762554; c=relaxed/simple;
	bh=fg868J4uDWFS21uMCvxgr4OunoSVURs0RnHrOmzESnk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P+UkochPrwjc4sNoE+FROOk84mnjPS+USjX+JDYgfQ7b2NqvZgga6AtYhdY8bGEk9S8k2DDIQh8ne09bNEWrp+tv4SyPNpSw2WyN5JJiN5lM10iSYVb7OLOZY+2Mel37Rv1dQ60sRwSp2asv/TBMEwgSy+VREFqYSCM8zvSqATk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 14F2D6033B; Wed, 26 Aug 2026 18:42:17 +0200 (CEST)
Date: Wed, 26 Aug 2026 18:42:16 +0200
From: Florian Westphal <fw@strlen.de>
To: Ilya Maximets <i.maximets@ovn.org>
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Romain Bellan <romain.bellan@wifirst.fr>,
	Florent Fourcot <florent.fourcot@wifirst.fr>,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH nf] net: netfilter: report NLM_F_DUMP_FILTERED when all
 is filtered out
Message-ID: <ao8XYCjgS6OoEo9y@strlen.de>
References: <20260825152725.3678225-1-i.maximets@ovn.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260825152725.3678225-1-i.maximets@ovn.org>

Ilya Maximets <i.maximets@ovn.org> wrote:
> NLM_F_DUMP_FILTERED is only set on data elements in the conntrack dump.
> But when everything is filtered out it is confusing for the user space,
> since the flag is not reported anymore and it looks like the table was
> empty, which may or may not be the case.
> 
> 'answer_flags' were introduced precisely for this use case, and the
> conntrack dump should set the flag in there in case the filtering was
> applied.
> 
> This is important, for example, to be able to tell if the filters are
> supported or not by the kernel without modifying the kernel state.
> 
> With the proper reporting of NLM_F_DUMP_FILTERED on NLMSG_DONE, an
> application in user space can just try and dump with an arbitrary
> filter without worrying that there could be no matching entry.  The
> reported flag will signal that the filtering was applied and therefore
> supported.
> 
> Fixes: cb8aa9a3affb ("netfilter: ctnetlink: add kernel side filtering for dump")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ilya Maximets <i.maximets@ovn.org>

Reviewed-by: Florian Westphal <fw@strlen.de>

FWIW this also passes libnetfilter_conntrack and conntrack userspace tests.
