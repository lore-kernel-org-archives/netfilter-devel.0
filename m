Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA8231A57A;
	Fri, 29 Aug 2025 13:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756473540; cv=none; b=s80QojXcDUzE+Z4zOO9Fj2TQ3iQgy5BakmsFxo9n0dUyhnDfZBUnylKoaht+lKwTqmXDhmAAzXoD7rGod3dkgZShtLTO77hFjg7UWTmMcuVEvXO9RrFN0K5QjNVR7cE0h4ono/hm/6oBSHv1yAMm20oQ0chDwb18wmjLHsxkXmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756473540; c=relaxed/simple;
	bh=ecnb4FXWwJy0BSupbXD/ijXUW/vPp+1DsNwsGnyzIYI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r+h3+p3OwAh3RZjluJ93GwG6s/ryq/GycAVw9ns6LRjpXiXa+wzrqAhpxX5BiQehPJJQ6C3NYN/ygZgurt9Y1N9bHbZdWQwIMTcnMMzCS1sS4E5U0BO8n2dQH3RgzmJ83+jkuLgi4HhWrc9z6vUFQIy4xmQkTM4onaviV1K6zbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=aPkz+K97; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="aPkz+K97"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=k4lpNv2+01AGP9coY/f4uasfH/RuIkvIDmKe6FHuBbU=; b=aPkz+K978XNpOVgmLycdy9VMyU
	JQbGiYtWdCqzfCCKH3He7S4elAn6DB8Hb23ZfgFcnFGY5FlpBQ6MOmiAnINCAWJY/bI/b+yfN7Gyl
	OvUwDWii6Lsro5j+b4sjPWuQGhilOzbR2ycb3Lb48N6uBzgW5M5rDFqOJ0UFCoC1JJmdLHgIyFmXy
	Yzl50PTnedNp0PKy4vDFwhEJliYksUKAYNnZkf237UH/lFEs3xn5aShywm2eqt4thXXZGHw06QwqS
	kmUg5ND4W8y4nkegHD7KwW9gSYzNv6NKHV7kLzibiSefKKkHG6sokmqnxDsJZRa8MYItoKbUtJzFU
	Dis6GpBA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1urz03-000000000eS-0FW0;
	Fri, 29 Aug 2025 15:18:39 +0200
Date: Fri, 29 Aug 2025 15:18:38 +0200
From: Phil Sutter <phil@nwl.cc>
To: Miaoqian Lin <linmq006@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Joshua Hunt <johunt@akamai.com>,
	Vishwanath Pai <vpai@akamai.com>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: xt_hashlimit: fix inconsistent return type in
 hashlimit_mt_*
Message-ID: <aLGorl9XCTlla880@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Miaoqian Lin <linmq006@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Joshua Hunt <johunt@akamai.com>,
	Vishwanath Pai <vpai@akamai.com>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20250829125132.2026448-1-linmq006@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250829125132.2026448-1-linmq006@gmail.com>

On Fri, Aug 29, 2025 at 08:51:31PM +0800, Miaoqian Lin wrote:
> The hashlimit_mt_v1() and hashlimit_mt_v2() functions return the
> cfg_copy() error code (-EINVAL) instead of false when configuration
> copying fails. Since these functions are declared to return bool,
> -EINVAL is interpreted as true, which is misleading.
> 
> Fixes: 11d5f15723c9 ("netfilter: xt_hashlimit: Create revision 2 to support higher pps rates")
> Fixes: bea74641e378 ("netfilter: xt_hashlimit: add rate match mode")
> Signed-off-by: Miaoqian Lin <linmq006@gmail.com>

Reviewed-by: Phil Sutter <phil@nwl.cc>
