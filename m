Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 171321D54B
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Jun 2024 13:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718197363; cv=none; b=seE2cSlvdC98Fo/EjJNryIOh2ZGEAGTJGJQjz9xSaib9tGFZf9WB/hTNW/OecNT7RoIACv2sB9dZqWxwH4C67UlxAjy7lb+JQU+FRQhCuUFcRCSMduUlz8rKyKYx2P3xfEbHuiSIPYqYoU0Vs43EInrfSDncs5x1CzaMsLrPl7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718197363; c=relaxed/simple;
	bh=rxq5++mwv4kKN+rjhzDQCBuhAB7f/ZQ+rEJCQZFjAiU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ngqsGRxgRrLYG1+GTWccjh1z3YtmF6X2PEeiDtvSWG6AGEWqLVAmkmGZYDeyy628EqLcqBXGi/XpLIJXNzfmEVpsJr1GTcjYvmAh19CHUC4TYwOwvP4Svyy2shPrdSuU3/keO46YJIaaLwOtAlPBkq+5yUe+sUQzTYWgv2oUJvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=bX8LT8wd; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="bX8LT8wd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=UfzwmBvT/MG1aCdAwjY1H71WKTCrrqAst1P8//5DWc8=; b=bX8LT8wdv90zwO9lTXPdu2Tlzl
	W1NXHKQTJ086IRdZcGdDm0SjvL8TXdwDa1oxVVI9z4b0bQHLjeIWGWZc+HXNsmRqe1eg87fHXDT+u
	0R4SFiuQEkckTlTXunPSAkvrr1gXkJORygr1aq8pdf7PB3W5klqgYWh7/k873v09F9KrpkadJgwpc
	qS8G7mlRVyfJPqBws9++nHllq80B5KKB0TEMxPHjzfsvheOTIN2EdjOHk4lfwQqE1L5i8be8jYTeB
	RX8rret3ec9ZG1bIjk+Ci5ZfvvaSCmM04EI9OF3gf7br0jZQNAKiXsccbppoUNaay2wlpvARa4HjH
	lOiEpGtg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sHNcc-000000006tD-428i;
	Wed, 12 Jun 2024 15:02:38 +0200
Date: Wed, 12 Jun 2024 15:02:38 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: let nftables indicate incomplete dissections
Message-ID: <ZmmcbldzDBlnFhzL@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20240612075013.GA13354@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240612075013.GA13354@breakpoint.cc>

Hi!

On Wed, Jun 12, 2024 at 09:50:13AM +0200, Florian Westphal wrote:
> "nft list ruleset" currently omits things it does not understand
> and that it cannot represent in any other way.
> 
> This includes:
> 1. expression is unknown
> 2. expression is known (e.g. "cmp"), but attr contains unexpected value
> 3. expression is known but there is an unknown netlink attr contained in
> the dump
> 
> If backend (libnftl) could mark expressions as incomplete (from .parse
> callbacks?), it would be then possible for the frontend (nft) to document
> this, e.g. by adding something like "# unknown attributes", or similar.
> 
> This is mainly needed for container environments, where host environment
> might be using a lot older version than what is used by a specific
> container image.

ACK, we'll certainly end up in a similar situation as with iptables-nft
so doing nothing is not an option.

> Related problem: entity that is using the raw netlink interface, it
> that case libnftnl might be able to parse everything but nft could
> lack the ability to properly print this.
> 
> If noone has any objections, I would place this on my todo list and
> start with adding to libnftnl the needed "expression is incomplete"
> marking by extending the .parse callbacks.

The JSON interface prefixes dumps by a metainfo object which holds nft
version number and a schema version (still "1"). Introducing a similar
"bytecode versioning" cached in and dumped by kernel space might be a
quick way to enable a current nft tool to detect a bytecode from the
future, assuming that we'll also take care and increment that version
when things change. 

OTOH, considering compatibility (or testing for it somehow) of a given
bytecode change may be much more tedious than a practical approach of
trying to parse and using a defined exit when failing.

Cheers, Phil
