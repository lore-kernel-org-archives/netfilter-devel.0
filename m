Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4BEA17C9
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Jun 2024 07:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718178623; cv=none; b=mHVB5mXsHBZXOuUnBWHVzHQunL4w9X0+nth39WLgFCJ2ULlpBAdZTsnckmnApXsI7r8wT142ntTUXw3WEROwZ/2J8syPC69gQ+LB160gEPnHvU8uAibDc98kh+cyDu0oPiF9Go1ONhlHAs2EdgVT/xfjAd07ar7aRa07JAdUEzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718178623; c=relaxed/simple;
	bh=DVhnrqgOTE1h1j9ExVDVRkMwUvY6JKLgByuYqt8XJxg=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=C6jc8pvE2HAa55Eno0m7hkUdSsPn7m6M2OrbRQBzIvmX/OcnSbESt2ryoE37L8gHy8+EhUZTnjYsX1Cn/zFZGq/OvrspZB9TXCFto+pA77jQlUf2EF7hpAwLnDwWyLq0nnYQNUK+RQsZM9fcZ1ZJtccaY/3yQIUjZt/79mA1zw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sHIkH-0003YR-EH
	for netfilter-devel@vger.kernel.org; Wed, 12 Jun 2024 09:50:13 +0200
Date: Wed, 12 Jun 2024 09:50:13 +0200
From: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Subject: let nftables indicate incomplete dissections
Message-ID: <20240612075013.GA13354@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)

"nft list ruleset" currently omits things it does not understand
and that it cannot represent in any other way.

This includes:
1. expression is unknown
2. expression is known (e.g. "cmp"), but attr contains unexpected value
3. expression is known but there is an unknown netlink attr contained in
the dump

If backend (libnftl) could mark expressions as incomplete (from .parse
callbacks?), it would be then possible for the frontend (nft) to document
this, e.g. by adding something like "# unknown attributes", or similar.

This is mainly needed for container environments, where host environment
might be using a lot older version than what is used by a specific
container image.

Related problem: entity that is using the raw netlink interface, it
that case libnftnl might be able to parse everything but nft could
lack the ability to properly print this.

If noone has any objections, I would place this on my todo list and
start with adding to libnftnl the needed "expression is incomplete"
marking by extending the .parse callbacks.
