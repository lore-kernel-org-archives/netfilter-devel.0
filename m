Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28E315E90
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Jul 2025 12:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752670150; cv=none; b=MIhMSHXNVowVJFKPclFiouqB0J8SVD8vjAZG3B3BhmmnlMLsQPseGE9Yaitx4gFa8JZQzZZSJ4pbrpHxaOyVNPQIYNMntZwd+A5ozqQQGngLRQS2vLLKzuuGQxX4O1VgmPbHsPdoZnQuRJL00KXk2EeCcXVaqQtygV5gGHQxrmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752670150; c=relaxed/simple;
	bh=AdVsfYlZjN6ldQD8EA8/pwHlA0z7Yly2djD3Tj3+chA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VaU4pMYnfJ/a5BedI7PmcTU8jitxdjANjfY14MaGRtmsiuDOU3cRJB0nZ5EwsgsX63rzCw1U8YVXzc8igFVKFBCZlk557FL0oMMMTIpKKTpTox00lSDOcl/yGq/AZ0dZBODwpH5m3BSjRkSgaBfwquXhJIxEudmw0bSe/8BSLgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 581B9604EE; Wed, 16 Jul 2025 14:49:05 +0200 (CEST)
Date: Wed, 16 Jul 2025 14:49:04 +0200
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v3 1/4] mnl: Call mnl_attr_nest_end() just once
Message-ID: <aHefwHoC5Uapg5bJ@strlen.de>
References: <20250716124020.5447-1-phil@nwl.cc>
 <20250716124020.5447-2-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250716124020.5447-2-phil@nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> Calling the function after each added nested attribute is harmless but
> pointless.

Thanks, feel free to push it out.

Reviewed-by: Florian Westphal <fw@strlen.de>
