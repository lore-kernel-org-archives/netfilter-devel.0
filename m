Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 946A81AA795
	for <netfilter-devel@vger.kernel.org>; Thu, 15 May 2025 06:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747289066; cv=none; b=eG3TQMivCFcgTk7VXlfG8sLsVqd/QQyx/PmGcwH4JXIyBy5fO5DfUhKeIJI5eLrpiMbX3/09fYmu+WFIavWvwc4v2j4PtKxBhoI1fte2cY8oX1YhqOGPZTF0iecOIYVebOPCPpy3GpU/0TP2aQOsD/aUz0ax2vqzw4J1khj7aVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747289066; c=relaxed/simple;
	bh=j2GyL+yinUC6uGgazEvMbABQUYeFEo4h09EAu4aDct8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u2mgx+9VQZHMfbeFNJttKjFiZSPB+mgjdR9cMXUYtwkh6CZouX83eEkhQpfCGQ2cjmtFQHqmdnKnO9CySDKiDzPdjjSOXnlVPojxvXq9oEO9OzTvcRcGf3INsNbAexK3DDhh4n6AD0alFuGBZkItzIgXDxKzdgLOZKA3Ml6ey2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 6355F60045; Thu, 15 May 2025 08:04:21 +0200 (CEST)
Date: Thu, 15 May 2025 08:03:13 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next,v1 0/6] revisiting nf_tables ruleset validation
Message-ID: <aCWDoXLJCYIy14oF@strlen.de>
References: <20250514214216.828862-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250514214216.828862-1-pablo@netfilter.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Pablo Neira Ayuso (6):
>   netfilter: nf_tables: honor EINTR in ruleset validation from commit/abort path

Do this via nf.git?

>   netfilter: nf_tables: honor validation state in preparation phase
>   netfilter: nf_tables: add infrastructure for chain validation on updates
>   netfilter: nf_tables: add new binding infrastructure
>   netfilter: nf_tables: use new binding infrastructure
>   netfilter: nf_tables: add support for validating incremental ruleset updates
> 
>  include/net/netfilter/nf_tables.h |  52 +-
>  net/netfilter/nf_tables_api.c     | 800 ++++++++++++++++++++++++++++--
>  net/netfilter/nft_immediate.c     |  25 +-
>  3 files changed, 844 insertions(+), 33 deletions(-)

This is a lot of new code but no explanation as to why is given.

Does this fix bugs with the existing scheme?

Or is this an optimization? If so, how big is the speedup?
