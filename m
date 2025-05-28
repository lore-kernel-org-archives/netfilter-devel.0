Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A3B279333;
	Wed, 28 May 2025 11:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748430367; cv=none; b=Qu8jbn9rRYIwnELtubcy4ChFoLhRLG7UNrUG+01SlIX43C4Q5dD0Jk8QT53MW99M+7itkUC+05/s9WrjhrBJrVP1DqukS+k23QJK37pO7a2QuXFjoUwgykwrchK9BDKv5W570AHy7Q3jK3Op+83JLU19PMFbsJGsCcDmdwHiqTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748430367; c=relaxed/simple;
	bh=5y80+x3iUCwLAxbapML1K3XJfVTMdgL4C5wV/L1Fa5M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UFQ2O2xTdh84zKiJy19obSMm+P8XLOJRuaI/a7tOzJkkXuffUAwbzGZURzmJ10/AFLazoxl2+zwbjHBjpPEs5oSuye54dYxtYr5+JgOr1R+NifshspP50PPhbVmV3FkUzYlm82bPJ3eUx0J/EIqa4DpRUKn5YYHIYSNNOjtpYrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 86FD4603E3; Wed, 28 May 2025 13:06:02 +0200 (CEST)
Date: Wed, 28 May 2025 13:05:24 +0200
From: Florian Westphal <fw@strlen.de>
To: Lance Yang <ioworker0@gmail.com>
Cc: pablo@netfilter.org, coreteam@netfilter.org, davem@davemloft.net,
	edumazet@google.com, horms@kernel.org, kadlec@netfilter.org,
	kuba@kernel.org, linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org, pabeni@redhat.com, zi.li@linux.dev,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v2 1/1] netfilter: load nf_log_syslog on enabling
 nf_conntrack_log_invalid
Message-ID: <aDbt9Iw8G6A-tV9R@strlen.de>
References: <20250526085902.36467-1-lance.yang@linux.dev>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250526085902.36467-1-lance.yang@linux.dev>

Lance Yang <ioworker0@gmail.com> wrote:
> From: Lance Yang <lance.yang@linux.dev>
> 
> When no logger is registered, nf_conntrack_log_invalid fails to log invalid
> packets, leaving users unaware of actual invalid traffic. Improve this by
> loading nf_log_syslog, similar to how 'iptables -I FORWARD 1 -m conntrack
> --ctstate INVALID -j LOG' triggers it.

Acked-by: Florian Westphal <fw@strlen.de>
