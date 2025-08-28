Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C36E30CD97
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Aug 2025 23:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756424797; cv=none; b=Kmkeq57kbeX/99Mxp6Qti3pboEXfzWV02SiuUGAfolC3JI5/agF9SU/I/+xE6iWS1l9xWJNucUKGOijcIDFWdg0EKmOsIJ01TvFi75oDTGkc4syonMz5Ql7N6pBXsSnv0UQLGvMQj0f11G+rw9TJyaXcbHdPF+uUYR4oG3h/dJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756424797; c=relaxed/simple;
	bh=Osu1cUKsijgMT4IvVpPnbbvV4Ly3vfcAYQtaHOePkhI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ns+Pt2PwV9MU5RyCSZu0tNH6SimKFuOgzjg4OoqBbP1EaE8dbRpsjX4k/KyYyyaDyRtO0IvoT+I782KR/ogSRgpnPZd28aayry+1ekiVfsa1sV5TCNmkpC/QhQpZvHx4l6UeQtZ5fluyE3ENqM+HkNPbbbljDvKBxAOuZXSgQU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 9C16460555; Fri, 29 Aug 2025 01:46:32 +0200 (CEST)
Date: Fri, 29 Aug 2025 01:46:32 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Sven Auhagen <Sven.Auhagen@belden.com>
Subject: Re: [PATCH nf-next v2 1/2] netfilter: nf_tables: allow iter
 callbacks to sleep
Message-ID: <aLDqWArd2zByoICJ@strlen.de>
References: <20250822081542.27261-1-fw@strlen.de>
 <20250822081542.27261-2-fw@strlen.de>
 <aLBn8Q3hgcqCvk4D@calendula>
 <aLBxa0V0b5QbTZzC@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLBxa0V0b5QbTZzC@strlen.de>

Florian Westphal <fw@strlen.de> wrote:
> > Not causing any harm, but is iter->count useful for this
> > NFT_ITER_UPDATE variant?
> >
> > I think iter->count is only used for netlink dumps, to resume from the
> > last netlink message.
> 
> Yes. Should I just remove the above or also add a WARN_ON_ONCE(iter->skip) ...

FTR, I removed the iterator and placed the WARN_ON_ONCE

> > > +	switch (iter->type) {
> > > +	case NFT_ITER_UPDATE:

here, then pushed this to nf-next:testing.
