Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 495AC37996B
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Apr 2026 17:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776707732; cv=none; b=GVpk74wXhN8RX0HiLUs3vdfR+7GpKb6xtVeEiLnWgPNyRjTph8/JaanRQ7uGD5kCz/ySyvV6oiWqanXEtNekJXazLCr08vzflxxNN+lD3V8iAIjG3flDJ2k+lggzZLswPwDmhJgxxBPfYqxVIWzZ5p1VzyioVaHhDsPbH1Oa4jE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776707732; c=relaxed/simple;
	bh=Ov4raWtZkR9mHDcUlzBI8qgAyMkPv6QtNwSU5x5r1QE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lK7AYpq59AwZX6A31/nUtUBQUn3vZTuGQhMMG/hnuBqh5G2f4UXMO2OfWFUxH9v1c2ObdfQDJr08QDk1od0YkiOBXvfhDrErlMy/Kyv2yRzWkwKajrAuBqxfzxoDgJSmvbvVpXvCF5hSgU2pa8K82t6FdBe53aLOCVPA3HuczKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 49D53601F4; Mon, 20 Apr 2026 19:55:28 +0200 (CEST)
Date: Mon, 20 Apr 2026 19:55:22 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nft_compat: run checkentry() from .validate
Message-ID: <aeZoiqyPFP0NJkz9@strlen.de>
References: <20260420174227.13087-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260420174227.13087-1-pablo@netfilter.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Several matches and one target check that the hook is correct from
> checkentry(), however, the basechain is only available from
> nft_table_validate().
> 
> This patch calls checkentry() for matches and targets from the
> nft_compat expression .validate path for the following matches/target:

I worry that this is fragile.  Not all ->checkentry callbacks are pure.
Some create /proc entries or bump reference counts.


> +		if (!strcmp(target->name, "TCPMSS")) {

This is missing "SET".
