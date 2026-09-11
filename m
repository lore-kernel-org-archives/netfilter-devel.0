Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9143359E35D
	for <netfilter-devel@vger.kernel.org>; Fri, 11 Sep 2026 20:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789159116; cv=none; b=FoxDv3d2mKbpKJMw2gcf1YWPtiPAMDW2rdtMEzeLA5ClNydNjHIeyk/r//ifQTHeyNwJsRq2rT9JA2M9BG7jYKqtvtN3L5Fq1iUtE1GyZtyK2HGz2P46WF9sYV2y/Byl5mqS8z+4hu2gb1BGfq+lUJs3n3VInOh++NRKeCqZHb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789159116; c=relaxed/simple;
	bh=371B4JTJK78gh5bMicjCBlrA2hpXL4zr/ZEtzKWchxI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T6O16YYFYhvxq3j4YyfUYbaTE7Qc10hiYWYKsxgHl2iGu0KkWNlP0BiM8Tu6kH5hHuCjPVYDC2gHV6SKN/c1qd9MGeciZBUDp23XPBom9mttyKK5siOdA58LgWEtra9WDHMnxzOa7kbTv89Mf4ZFBYydfWuM9pEWayKXFiBEVMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 1745460388; Fri, 11 Sep 2026 22:38:32 +0200 (CEST)
Date: Fri, 11 Sep 2026 22:38:26 +0200
From: Florian Westphal <fw@strlen.de>
To: Avinash Duduskar <avinash.duduskar@gmail.com>
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Kamil Kwiek <kamil.kwiek@gmail.com>
Subject: Re: [PATCH nft] src: release scope symbols by reference count
Message-ID: <aqRmwk4OsSajKBrt@strlen.de>
References: <20260911192009.2472193-1-avinash.duduskar@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260911192009.2472193-1-avinash.duduskar@gmail.com>

Avinash Duduskar <avinash.duduskar@gmail.com> wrote:
> nft -f aborts when a define in table or chain scope takes its value from
> another variable:
> 
>   define outer = 111

Applied, thanks.
