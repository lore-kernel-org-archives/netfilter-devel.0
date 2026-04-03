Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB6038945C
	for <netfilter-devel@vger.kernel.org>; Fri,  3 Apr 2026 10:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775213568; cv=none; b=AHw7ggcvvKV5GthGKLmQRkbE5dqbeHmn9i8EQH1Y+d7kZbnmAwrns6p2iNMbRzB7DD7mVMFerVqeZvksfcDU8CMot7NYwUrvLboEnhX96626HAPWaAe6YyjyS8BvoGiF1l5BbJYy1mpwytU5YFlGirlwyMDwdlklK/CZU4CTx7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775213568; c=relaxed/simple;
	bh=m0G6xa3bfIyVMT7lcPKM4qnl1DbC241wHbwQuIAfVVc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lQc+Uxa2MaayLPvJr6fSDxO2xKcl4ukoxjybLIv6SYFVTryjD7jWKwOOx7rwlLAmJBhm3vMAtpQVcqy4v+mX5TWCDucjyhnJqp6UMnd0vhQiUoSW816zm6oyhm0KjGwSFnlp2Clmq5ELFv0lsx/wda9E5IjDKSsNZxwpORLtak0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=KjpBI4zP; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="KjpBI4zP"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id BF21460253;
	Fri,  3 Apr 2026 12:52:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1775213557;
	bh=zYR4BUOcNc8ZojQxdXgK80lPXOY8nVvDjgUoMaY3jEc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KjpBI4zPkJ4BPTZ6bGtQNJNr8f+L8sfvo9J+c4y0epaqdDPi1XQkT5gGKy8WQcIdE
	 kMoRWHdSaj8AOttV+df7efvggrmu9Xcq2bto5ie/QwWR1gODWgSU565Mnl2rq2bmfs
	 ICYU1TjMuqYxRqNQrbOySlRGw4K3wxsuLZZj7xf1bIeZf5J4GE1UdTeyOteWRrroQW
	 b6FECb1llEKs4p7x/78/a1kVgFDXG6pmqmDBXbs+6U2+2Pun2Km7XWXNaZXxgavY2P
	 6OBxJWf+qXBO60iC1vE0yz+ooiAWoVSywFgzti5VCaAH67rwmnN0fiJWkueqD/Cp1s
	 ixHTVimOMOHJA==
Date: Fri, 3 Apr 2026 12:52:34 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] arptables: Warn when ignoring '-p' option
Message-ID: <ac-b8tqhhnYTSlKT@lemonverbena>
References: <20260402145216.32228-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260402145216.32228-1-phil@nwl.cc>

On Thu, Apr 02, 2026 at 04:52:16PM +0200, Phil Sutter wrote:
> Legacy arptables has been silently ignoring this flag (plus mandatory
> argument) since day 1. Retain compatibility to that behaviour but inform
> users that a part of their rule does nothing.
> 
> Since arp is the only family which didn't provide a proto_parse
> callback, implement one for the sole purpose of printing the warning. As
> a side-effect, caller no longer has to check callback's existence.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
