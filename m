Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24107245019
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Oct 2025 11:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761305627; cv=none; b=Kd+H1RVYNDTZ24cbOEUcaEMXZJzT5twdDrb+gmf4lnzutrtgreWM6UdzKUHSejlhWZGMBIsSDkWVZdYCNParJNCpUXUhOcHm3xT+V77fTNBDaf118SAyKRcYBAFSSsdO1QM9vT9g1Rh4iPf0VMYMFNSazkRVZ+0OreTIsxayvr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761305627; c=relaxed/simple;
	bh=oK8cRdnM/9dyhR0VwMeEW3ThnypOl/sE/7JD6T65NUA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gl/FmRq1FUqoQPuQRYoUF5kz311NP5rQoqAqRrY2RFxysBXxHUXwMo2mp9elgsN6gQ0OQsHOD03h7QPVCmnzXFg1h9S5pAqvtpbXILsRV0Ddu734wnKMXDQjXY3J+pCamDQP0/Sehw6q+8yLkxzfT10BY2lu/TFTs0wh4scYr9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 147FE602CC; Fri, 24 Oct 2025 13:33:43 +0200 (CEST)
Date: Fri, 24 Oct 2025 13:33:42 +0200
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	louis.t42@caramail.com
Subject: Re: [PATCH nf] netfilter: nft_connlimit: fix stale read of
 connection count
Message-ID: <aPtkFjOiFXA6vfzB@strlen.de>
References: <20251023232037.3777-1-fmancera@suse.de>
 <6b0de8f3-d03a-4f12-b2f8-c87aeeef4847@suse.de>
 <aPtctiRlb9Pg9sNQ@strlen.de>
 <33d6f2aa-2c10-4727-b78d-0fefc64b2d35@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33d6f2aa-2c10-4727-b78d-0fefc64b2d35@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> If this is only supposed to be checked for SYN packets, that is, a new 
> connection is started.. a simple fix could be to check whether this is a 
> SYN packet or not, break if it isn't. Similar to what is done on 
> synproxy eval function. What do you think?

It should work for any protocol, not just SYN.

But we can't change it now to just check NEW, we would have to provide
same result as without it (just without the potential double-add).
