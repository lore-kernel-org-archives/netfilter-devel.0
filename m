Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61528196C7C
	for <netfilter-devel@vger.kernel.org>; Mon,  6 Oct 2025 17:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759770180; cv=none; b=AuHudDTlWywckiiFSBhYeEVWXgNX9axZKqfavQlivjEJFIlXYXF26iGSZJN4+uV39Xwa60W9IwuZ4DbjopdfgB5e7+/pSKB57PHVFVPQU5ckMFgUZnbQKaiDFxNN12HN64nv7IUPPWbyMOqljATgtrKT5a6FJYWPz6BpuV2y9/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759770180; c=relaxed/simple;
	bh=YW4U8KAVl6dpq/RWZEI+sRTb+aQRVXMEwaNUrjkl9Ls=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N7kTLC1eE0S/L7zwCpsrRZuw6WVtiMW/ZbENYHyKPtlWIvjXFihY9EXn7Fche9ziG9PIYxSFB+kwkea2aaAXBQq+uESyRvzjYD60xEVD3iaaABY+QtCTl4+T6/HHL0LGl91RQmy59og7s+bG6CZWWL3blyjY+dMqxSOrYcl3P+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id AA1CF619F5; Mon,  6 Oct 2025 19:02:48 +0200 (CEST)
Date: Mon, 6 Oct 2025 19:02:48 +0200
From: Florian Westphal <fw@strlen.de>
To: Nikolaos Gkarlis <nickgarlis@gmail.com>
Cc: Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next 0/6] netfilter: fixes for net-next
Message-ID: <aOP2K2wu51JtWiv9@strlen.de>
References: <20250924140654.10210-1-fw@strlen.de>
 <aNRwvW4KV1Wmly0y@calendula>
 <9a19b12e-d838-485d-8c12-73a3b39f1af2@suse.de>
 <CA+jwDR=zBZQYUu_GrhGpsyFLG8TvhMF4rp2Vh1CgxYQwBZO8Rg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+jwDR=zBZQYUu_GrhGpsyFLG8TvhMF4rp2Vh1CgxYQwBZO8Rg@mail.gmail.com>

Nikolaos Gkarlis <nickgarlis@gmail.com> wrote:
> I was wondering whether it would be possible to submit a backport of
> Fernando's fix to the affected LTS releases, if that is not already
> planned.

09efbac953f6 ("netfilter: nfnetlink: reset nlh pointer during batch replay")
has all needed tags to get picked up by -stable team.

It applies cleanly all the way back to 6.12.y.  Earlioer
maintained releases are not affected.

