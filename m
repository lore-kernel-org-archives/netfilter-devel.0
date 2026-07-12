Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8197A5474F
	for <netfilter-devel@vger.kernel.org>; Sun, 12 Jul 2026 08:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783843701; cv=none; b=qm9dBCE/ANd9KsViZmsKWTVnFDABegSQndYy1PmyI4bazVulPTIEgdmjQBRZPRTckd9Yllc7bBDZ6ePqUQubRaFSKk43fN4NXg2GLbEaTZTIkaGzMdT4sETZ86vCj9cM2RJV4IMHcrOquncghwjSksTE7uzOj9N/paq6MWZPR50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783843701; c=relaxed/simple;
	bh=wwz6LpEdl/gi7npHGsHFpQvj8XDH7dwVa2ol0JJMGFs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VBZ1GcliVy63pabI+qZ5XqkNjxOLZirzj1LtdbXc11hi3VxoHa4AasMMuat/CcBIMK6AWjf296AWu/35VRsHwkCZoZ2RXnpo3re+OBbI1LIZGQWIpAAQaJsMweEABRURcclu42E396gTPYm+DBp2Kmo01TLtiFqSthFK0fiXPBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 24A1B60388; Sun, 12 Jul 2026 10:08:17 +0200 (CEST)
Date: Sun, 12 Jul 2026 10:08:16 +0200
From: Florian Westphal <fw@strlen.de>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Jaeyeong Lee <iostreampy@proton.me>, netfilter-devel@vger.kernel.org,
	pablo@netfilter.org, phil@nwl.cc
Subject: Re: [PATCH nf] netfilter: nf_nat: do not reuse an unexpected
 expectation on RTCP clash
Message-ID: <alNLcE1qJ5fwBO0N@strlen.de>
References: <aQrSf6maL27cH2V4V9ELFdSqdtCWQ-B5iZr8fjR2Wz7zAJ7L32oW50bdrePoTMnJ4CRjDrns-jNMNFHGWNUxYe3UcV91AK99Ilncjab2uDk=@proton.me>
 <2026071134-turkey-detonator-0d87@gregkh>
 <178377968720.33756.12204817361601593230@proton.me>
 <alJva5_-K55ouKGh@strlen.de>
 <2026071235-geometric-snowdrift-bb4c@gregkh>
 <alNE4AO9H0HGLc34@strlen.de>
 <2026071249-contented-gallantly-2927@gregkh>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026071249-contented-gallantly-2927@gregkh>

Greg KH <gregkh@linuxfoundation.org> wrote:
> > This is no different than the WARNs on list corruption or refcount
> > under/overflows.
> 
> True, but adding new ones is not a good idea, and removing the existing
> ones is a good idea.

We're fucked, then.  Can we at least use DEBUG_NET_WARN or something
like that so at least fizzers can give us hints about bugs?!

> > Would you propose to remove those?  I hope not, they help catch bugs.
> 
> Bugs that userspace can trigger?  If so, then properly catch them by
> testing and handling the issue.

Aka "Don't write buggy code".  Should have thought of that.

> If userspace can never trigger it, then
> it's not really needed as the code is never going to trigger.

It causes memory corruption and evidently triggers.

With "silently catch error" and no WARN there will be rare,
intermittent connectivity issues.

We are NOT in a syscall, there is no process to return
a meaningful error code to.

With WARN at least there is some chance that someone will report
it so underlying root cause gets fixed.

EOD from my side, have iot your way, silent ignore it is.
