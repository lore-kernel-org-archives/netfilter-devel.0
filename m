Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7540B53365
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Nov 2024 22:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730844109; cv=none; b=G/p3LH6oA5BRE3CJ8bQ13TZ3iwEtgN5sblqFLIeAIpb7PB43Yz76VuyM6ZRIDUAUs0kwq2Qx0lVDMm5R9RV6SlYJZyufRWJsG5BGjEEGwtU101fLzBxEG7ekk+MgvDMVKnqv3dq6ilwihvdbQC/Je9F1km7GIYStIfhWKsr3+lM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730844109; c=relaxed/simple;
	bh=rsNpeTO16lMIvC0IXHw+LGBtIeqMcNj0jyO34Na+yvw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gvsVoakcjD7G/jzfljX8dLczV1LU6oFUZoYIUhpydWk4Hy8IEPrAomJ0I287Teem+d3h6w5R70MY1sV4QIPmrLyF6ESyfUPJ/+Hahzc0le5MeFOLyCNcjDTJOdWwhaS1SLR1Kj7Pe7116nLQ/Yezv++uSN0ld6exeSK0KpOMpCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1t8RcN-0004fK-SI; Tue, 05 Nov 2024 23:01:43 +0100
Date: Tue, 5 Nov 2024 23:01:43 +0100
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [conntrack-tools PATCH] conntrack: Fix for ENOENT in
 mnl_nfct_delete_cb()
Message-ID: <20241105220143.GB10152@breakpoint.cc>
References: <20241105213310.24726-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241105213310.24726-1-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)

Phil Sutter <phil@nwl.cc> wrote:
> Align behaviour with that of mnl_nfct_update_cb(): Just free the
> nf_conntrack object and return. Do not increment counter variable, and
> certainly do not try to print an uninitialized buffer.

Reviewed-by: Florian Westphal <fw@strlen.de>
