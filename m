Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4AF31D5ACD
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Sep 2024 18:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727288282; cv=none; b=jDNHmpsrdqaDnFrOt8+kKYwkdVm3T8gNRnPHpFd4gBTZsWaq1xZFP8/VYYS0rKe5Y509GMX5CxwicwxuLApLfr+qXdVccmEVEmFaRSmgcoHlJ2PeWq2/g52P+cQ8SLgxpfkXac87FastbcD+LquDjCzlk6PAVMnfjxEo7kQR1Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727288282; c=relaxed/simple;
	bh=uleYC3dh68zUHYxM5abp2FTy0Pw75DFfWrFN+jhf6xU=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l4WAiDMfNJFHfTP/ocn5Nvnm1JydXLWLU/Bx+nqM1PLrT6YRMDodkOE5k/D2xb/V+NcOUANi9EpIeUdpUQPeUVGlUVbcyA+dhPrNTJXn8W8BQgeq5tHWP5nbQtliECDgkgNHxsPCxzcvektlMbHBWpBQT0r/mhgZWGYKhfRBnpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1stWaK-0006NJ-LG; Wed, 25 Sep 2024 20:17:56 +0200
Date: Wed, 25 Sep 2024 20:17:56 +0200
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>
Subject: Re: [nf-next PATCH v4 15/16] netfilter: nf_tables: Add notications
 for hook changes
Message-ID: <20240925181756.GA24466@breakpoint.cc>
References: <20240920202347.28616-1-phil@nwl.cc>
 <20240920202347.28616-16-phil@nwl.cc>
 <20240921091034.GA5023@breakpoint.cc>
 <ZvRHmHn6wllDFukN@orbyte.nwl.cc>
 <20240925175154.GA22440@breakpoint.cc>
 <ZvRTYZRufYyMD6kC@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZvRTYZRufYyMD6kC@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)

Phil Sutter <phil@nwl.cc> wrote:
> We could get rid of the nc->call != NULL check by assigning such stub in
> nfnetlink_subsys_register(). OK, technically it would just move the NULL
> check. Without such stunts, nfnetlink_rcv_msg() would have to remain
> as-is to cover for future users with holes, right?

I think we should leave it as-is, I thought this was the first use
of NULL .call but as you found thats not the case.
