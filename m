Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7543B1741F8;
	Wed, 28 Aug 2024 14:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724856684; cv=none; b=Rrv0aHJzX0amgH8epphmc+2UjY+qFfHpIS01hz/Ei9Hm4wVpFwkXbRuPvlZNjcrAekJo54xmm0AI2ruhYv0+y0ePjv+wExTN3wjKzQDF2EtRUqVtCSdmyKYuHcjaFUcem7Ar8kJmA1oDisvz55mMZr9AQXsdl3Xpq8OxVa1GQwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724856684; c=relaxed/simple;
	bh=VH2Ski7TedU7wSmRk3uDw/EkSFkyqw+5pz78wvTsVzc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JyjLD9ZIHr4vhFLAqstcPE5VHPtcoxuV6TBkGP5Z4ZfJnRFH+TyTFAI8rlaUc/U3+1dO/wck2oKzMZwAjFrt9NYFo/6B5qGkSK6knW/4btoHCXGdTzkjQZzvX6bV62VcJXDEQsBdIP/EUEeG7QZIncNV2vy1mqmRoy+l0ojswUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=35458 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sjK0v-001c7h-Av; Wed, 28 Aug 2024 16:51:16 +0200
Date: Wed, 28 Aug 2024 16:51:12 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: kadlec@netfilter.org, roopa@nvidia.com, razor@blackwall.org,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, dsahern@kernel.org, krzk@kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	bridge@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next 4/5] netfilter: iptables: Use kmemdup_array()
 instead of kmemdup() for multiple allocation
Message-ID: <Zs85YCq6TAYIjhNS@calendula>
References: <20240828071004.1245213-1-ruanjinjie@huawei.com>
 <20240828071004.1245213-5-ruanjinjie@huawei.com>
 <Zs7i4PSQQEI0tHN6@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Zs7i4PSQQEI0tHN6@calendula>
X-Spam-Score: -1.9 (-)

On Wed, Aug 28, 2024 at 10:42:12AM +0200, Pablo Neira Ayuso wrote:
> On Wed, Aug 28, 2024 at 03:10:03PM +0800, Jinjie Ruan wrote:
> > Let the kmemdup_array() take care about multiplication and possible
> > overflows.
> 
> No patch for net/ipv6/netfilter/ip6_tables.c?
> 
> We have yet another code copy & paste there.
> 
> BTW, could you collapse all these patches for netfilter in one single
> patch?

BTW, someone else seems to have made the same patch:

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20240826034136.1791485-1-yanzhen@vivo.com/

it is already sitting in the queue.
