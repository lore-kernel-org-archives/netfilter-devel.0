Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB591547E0;
	Wed,  4 Sep 2024 10:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725444224; cv=none; b=ujJSKtxNjntQmyTLHQw0huGVFB9DwviJlwaPd87jSyEw9hFglvvdWxqukTFZ4QTeqCfFd351zGicY1AqA4RkFI68PNsKfNG1dbFmdtOFpUN5rrCcSvspOUja/ep0JpilU09BjPtNqU7Czcd3xeikuzwGzPlEORqqiAKVVjcYCjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725444224; c=relaxed/simple;
	bh=VfB6sMFvr5qJgPI3jUA01v0L9nWutHdL5B3uB7bI+kM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XsDW7YilAEwKIGcUtzwMhrCE+bh8SKXIhgj1NwVVmmBikl68ydoccTRQccK3/skF5e40FikqX2WZMra7I1kScwNgNGFYdc4defNc4VYN5Z0fpqMNdUigcF8jjC0CM8/0z/WKD9AcsKWy1g7VMltYWddhJeNwcmFJOTRmVkZi/xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=52868 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1slmrG-00BvHA-T2; Wed, 04 Sep 2024 12:03:28 +0200
Date: Wed, 4 Sep 2024 12:03:25 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Hongbo Li <lihongbo22@huawei.com>
Cc: davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, jmaloy@redhat.com,
	ying.xue@windriver.com, kadlec@netfilter.org, horms@kernel.org,
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next v2 3/5] net/netfilter: make use of the helper
 macro LIST_HEAD()
Message-ID: <ZtgwbaDkfCsKCuEj@calendula>
References: <20240904093243.3345012-1-lihongbo22@huawei.com>
 <20240904093243.3345012-4-lihongbo22@huawei.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240904093243.3345012-4-lihongbo22@huawei.com>
X-Spam-Score: -1.9 (-)

On Wed, Sep 04, 2024 at 05:32:41PM +0800, Hongbo Li wrote:
> list_head can be initialized automatically with LIST_HEAD()
> instead of calling INIT_LIST_HEAD(). Here we can simplify
> the code.
> 
> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>
