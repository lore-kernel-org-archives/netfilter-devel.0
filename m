Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C881533033A;
	Mon, 17 Nov 2025 11:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763377377; cv=none; b=mwtjV3xqwgMlccYVnHTOv6ckw4cotieXde1eXmHxlI26MNSjWC/qIJov5/9UyLwTpOaTMen0eYCJjDuKRZULxFYg4J5mJa+Mh9zEzgT8tUkYY9f/QcOVJ/VCVEkOYBUuBQn+u6eLdHwxRCJaYo8Jz24P43L4jnZ7+96rJA9CZM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763377377; c=relaxed/simple;
	bh=uf55DI7mt8cpW8qwSpLbKkU+vOUxm/se2QFByOaarFY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cpch3Y2GoT4o6dfP/hxQrtQxKGpu/8xABfSlFwD2w/DdQcFwhPBaFjyeQb70+9SnBXP210f5A/Cc04AjznYzPF7vEWbrTe48vIx08LeF3mLWHmZJaNU9YCGxYxT1MWM72l1BwHJQ2mqyxv+VHt0sAd6luxggXjma774QIAC9qtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 5C19B604C1; Mon, 17 Nov 2025 12:02:45 +0100 (CET)
Date: Mon, 17 Nov 2025 12:02:45 +0100
From: Florian Westphal <fw@strlen.de>
To: Chenguang Zhao <zhaochenguang@kylinos.cn>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH linux] netfilter: conntrack: Add missing modification
 about data-race around ct->timeout
Message-ID: <aRsA1a-1_NWsYst3@strlen.de>
References: <20251117085632.429735-1-zhaochenguang@kylinos.cn>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251117085632.429735-1-zhaochenguang@kylinos.cn>

Chenguang Zhao <zhaochenguang@kylinos.cn> wrote:
> Add missing modification about data-race around ct->timeout

This could use a bit more verbose explanation.

>  	   weird delay cases. */
> -	ct->timeout += nfct_time_stamp;
> +	WRITE_ONCE(ct->timeout, ct->timeout + nfct_time_stamp);
                                ~~~~~~~~~~~

Shouldn't that be

WRITE_ONCE(ct->timeout, READ_ONCE(ct->timeout) + nfct_time_stamp); ?

Furthermore, patch subject should list either [nf] or [nf-next] to
indicate the tree you want this patch applied to.
