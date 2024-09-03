Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F80922F11;
	Tue,  3 Sep 2024 16:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725380085; cv=none; b=Vd3dE+XQ8OVFgFg8HMTQjhjF92iO5BmSNw5Xvu+rvR1JiBE+4IXV3+aJRrkczUsg9JZr2nSGkXBzo2253xmrkNdZFNxJVaiBZSYI7xTAFZoHUzczjEZEMiQYvDNTjQc/nyU03Ko1lpMv3CXBsOiEfunHb2xZq9i3bsC3y1Pjzc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725380085; c=relaxed/simple;
	bh=fra330hp3FioeSWf/FHHOBBmVKVljAd1+6iYODU0Qzc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gUWxTk8qs9muqt6CYh08BeI9vWvmLQuj8LK//0J0/u8axrWF51xn3StqzpZz78NEux0sGBdPd57ab4I6trWsuG2oEwTioMtfC8XhCiFnG0M0iB3/WEDM9dzXWKGDJS/Wt7wsAyvxsBn8APYe5DaON9efVG0lbT7bjK93Jx3hbr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=56396 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1slWAt-00AieQ-9V; Tue, 03 Sep 2024 18:14:37 +0200
Date: Tue, 3 Sep 2024 18:14:34 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Uros Bizjak <ubizjak@gmail.com>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH v2 0/2] netfilter: nf_tables: Fix percpu address space
 issues in nf_tables_api.c
Message-ID: <Ztc16pw4r3Tf_U7h@calendula>
References: <20240829154739.16691-1-ubizjak@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240829154739.16691-1-ubizjak@gmail.com>
X-Spam-Score: -1.8 (-)

Hi,

On Thu, Aug 29, 2024 at 05:29:30PM +0200, Uros Bizjak wrote:
> Use {ERR_PTR,IS_ERR,PTR_ERR}_PCPU() macros when crossing between generic
> and percpu address spaces and add __percpu annotation to *stats pointer
> to fix percpu address space issues.

IIRC, you submitted patch 1/2 in this series to the mm tree.

Let us know if this patch gets upstreamed via MM tree (if mm
maintainers are fine with it) or maybe MM maintainers prefer an
alternative path for this.

Thanks.

> NOTE: The patch depends on a patch that introduces *_PCPU() macros [1]
> that is on the way to mainline through the mm tree. For convience, the
> patch is included in this patch series, so CI tester is able to test
> the second patch without compile failures.
> 
> [1] https://lore.kernel.org/lkml/20240818210235.33481-1-ubizjak@gmail.com/
> 
> The netfilter patch obsoletes patch [2].
> 
> [2] https://patchwork.ozlabs.org/project/netfilter-devel/patch/20240806102808.804619-1-ubizjak@gmail.com/
> 
> Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> 
> Uros Bizjak (2):
>   err.h: Add ERR_PTR_PCPU(), PTR_ERR_PCPU() and IS_ERR_PCPU() macros
>   netfilter: nf_tables: Fix percpu address space issues in
>     nf_tables_api.c
> 
>  include/linux/err.h           |  9 +++++++++
>  net/netfilter/nf_tables_api.c | 16 ++++++++--------
>  2 files changed, 17 insertions(+), 8 deletions(-)
> 
> -- 
> 2.42.0
> 
