Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18E811C6FF6
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Jul 2025 13:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751980980; cv=none; b=l5jUfvuk4MQvMND37B7nU5zIQrNbvhiH1IJ4Lnfo14gy88KMc8/lu9TU2RbhCQQ41HLFWjh3cWYc66qu5/5a+nCGhjs8combuYza0DBrO9yJ+RTwQUSrssvmr8MoUduVVtfRwug0RXS5hcVXBiapybUJpMRv1xR1hbTUvXAnIn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751980980; c=relaxed/simple;
	bh=LBNkGSiNhIDv0/gWPOzpOFvM5wN9hjpEYNW3p9920sw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a2jvN6lddNPpG0h/TOaXugXL+l4QY8yXVBRYJ/im7G6B0POxwFLOwt+PX34iDfS7d66CGiJ1+eG4oIDixjVi6l+dFcSulG6DDX+XazWLpiWm+HhDP9Pj4IJWVe0CvpY/rRe9T7DvileCxmvO8f6fd+b9SlBb7nOboJW3p6rPQxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 1B87160FA9; Tue,  8 Jul 2025 15:22:57 +0200 (CEST)
Date: Tue, 8 Jul 2025 15:22:56 +0200
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nf-next PATCH 2/2] netfilter: nfnetlink hook: Dump flowtable
 info
Message-ID: <aG0bsM2jqiWHqwep@strlen.de>
References: <20250708130402.16291-1-phil@nwl.cc>
 <20250708130402.16291-2-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250708130402.16291-2-phil@nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> Introduce NFNL_HOOK_TYPE_NFT_FLOWTABLE to distinguish flowtable hooks
> from base chain ones. Nested attributes are shared with the old NFTABLES
> hook info type since they fit apart from their misleading name.

Reviewed-by: Florian Westphal <fw@strlen.de>
