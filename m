Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 001731482E6
	for <netfilter-devel@vger.kernel.org>; Tue, 18 Jun 2024 08:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718698315; cv=none; b=SpLmcAwKCjHAufZFTd1avoGA1GEYdVttEfrEywEBIERB5vQCpdvfATCaQo5GAFy7nag9HvZSyU2ML1khFvVy11hfWrzpJXRObfkYAx3eC1qjtmDuVlXCxhbzmhqOI/LKFuO2rqZGkjdjIZFuV8v9DJKXH/q7POgPRPlftKfvLZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718698315; c=relaxed/simple;
	bh=HEt9u1htdppUmUrVWtfByFYfpwT6d4r+SXkE/ql8Doo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BqeVbADSmtcdmss0Wx+zIOnhA62gyAGgrlAvA/pOhcfU2H/XgqWoKNgRIqVYaviUF0v1mb12A54Ghn3isFEEkLyqGU8Vs646ST6WGQ5Z/k/iACjORIzblTZXhdB1We7Wb2s0rsDfKcFtZtqmpOE3Ld2vBGOPsY/FlMepENQhJ2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=50684 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sJTwQ-00D8R8-Th; Tue, 18 Jun 2024 10:11:48 +0200
Date: Tue, 18 Jun 2024 10:11:46 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: let nftables indicate incomplete dissections
Message-ID: <ZnFBQmrX9FgTG8rb@calendula>
References: <20240612075013.GA13354@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240612075013.GA13354@breakpoint.cc>
X-Spam-Score: -1.9 (-)

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

ack, how do you plan to handle this?

> This is mainly needed for container environments, where host environment
> might be using a lot older version than what is used by a specific
> container image.
> 
> Related problem: entity that is using the raw netlink interface, it
> that case libnftnl might be able to parse everything but nft could
> lack the ability to properly print this.

There are two options here:

- Add more raw expressions and dump them, eg. meta@15, where 15 is the type.
  This is more compact. If there is a requirement to allow to restore
  this from older nftables versions, then it might be not enough since
  maybe there is a need for meta@type,somethingelse (as in the ct direction
  case).
- Use a netlink representation as raw expression: meta@1,3,0x0x000000004
  but this requires dumping the whole list of attributes which is chatty.

Or explore a combination of both.

I am telling all this because I suspect maybe this "forward
compatibility" (a.k.a. "old tools support the future") could rise the
bar again and have a requirement to be able to load rulesets that
contains features that old tools don't understand.

> If noone has any objections, I would place this on my todo list and
> start with adding to libnftnl the needed "expression is incomplete"
> marking by extending the .parse callbacks.

Maybe it is worth exploring what I propose above instead of displaying
"expression is incomplete"?
