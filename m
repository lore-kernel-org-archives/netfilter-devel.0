Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD4B40C03
	for <netfilter-devel@vger.kernel.org>; Tue, 25 Feb 2025 18:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740509170; cv=none; b=uICPtxQmZ7ak/4aV1mpMApayuvZkQkOBghNOyRmRB3QBtf4Vc6nl3GSLE1OkyvRCTyHonZXKoPJW7h6wstINWnkEX875+Q53XtnHXi2ff/OO+FvkdYpEcbtuyxr0iBGumQsftqkXnyMmdE1ezKJlHCQJYgHOIvxV1tFr8M/1lGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740509170; c=relaxed/simple;
	bh=d4l8rs0scs9mSrx6T6tVdGNdP7CzbifaM4hDSW58TpA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ktO8LJShSvgpnQhUI8aTud99k5IG2ADJc4lbj43JRfks73V0FMrbcDTJspHqa2ZoEAg4SC+EC3/zNCRVgmzMl34J7lbh9DfDd3HBO5Z/c568thKPci8dlfmTvked56rpdlmeSXWgk3HcccccYj5O+UYW7FLLYgdho1Tsa6xJzCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tmzwK-0007My-Su; Tue, 25 Feb 2025 19:45:56 +0100
Date: Tue, 25 Feb 2025 19:45:56 +0100
From: Florian Westphal <fw@strlen.de>
To: Xiao Liang <shaw.leon@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] fib: Change data type of fib oifname to "ifname"
Message-ID: <20250225184556.GA27804@breakpoint.cc>
References: <20250225100220.18931-1-shaw.leon@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250225100220.18931-1-shaw.leon@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Xiao Liang <shaw.leon@gmail.com> wrote:
> Change data type of fib oifname from "string" to "ifname", so that it
> can be matched against a set of ifnames:
> 
>     set x {
>             type ifname
>     }
>     chain y {
>             fib saddr oifname @x drop
>     }

Applied, thanks!
