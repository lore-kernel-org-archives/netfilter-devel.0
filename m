Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D95D59B71
	for <netfilter-devel@vger.kernel.org>; Sun, 15 Sep 2024 22:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726438404; cv=none; b=BFGdClK/0JvQf74nN402H+Sg5CnhFRLYUa6ZDWUVXyi4kLbSjDHr9I4LxaY6SRYYpL8BebdDsnGedPvPNQ71Q1adr51YHYMVVctmtXWY+0WEOaGGkI7zjLQTWay9QwurbCAPuJyiWaWzWt7hhzxxF+JyMV78cFJbG5FPOW86/ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726438404; c=relaxed/simple;
	bh=pZWKJ/NIoU4LpKecY/2j1iD1xwyszCDaRVhc4Yk6whE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bh62iP69YYSvwoqZGsfHiBqQZuGBVz64HraD9oZ6RqHjTgYXjapK2WZNxuSZLStCebTWPZ1FmfEqpgus4RdCmmfeNdGg1fY8RyXP7PChb5wmMyyUySOQaonJd5NJ+AXlUDsPlli4rbcyzT8yX2As2nA8BFpZmwzrgSvlq7m+KOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=56756 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1spxUS-00ENB9-Jb; Mon, 16 Sep 2024 00:13:10 +0200
Date: Mon, 16 Sep 2024 00:13:07 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Jan Engelhardt <jengelh@inai.de>
Subject: Re: [iptables RFC PATCH 8/8] nft: Support compat extensions in rule
 userdata
Message-ID: <Zudb80USN6GGG05T@calendula>
References: <20240731222703.22741-1-phil@nwl.cc>
 <20240731222703.22741-9-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240731222703.22741-9-phil@nwl.cc>
X-Spam-Score: -1.7 (-)

Hi Phil,

I have no better idea to cope with this forward compatibility
requirements.

On Thu, Aug 01, 2024 at 12:27:03AM +0200, Phil Sutter wrote:
> Add a mechanism providing forward compatibility for the current and
> future versions of iptables-nft (and all other nft-variants) by
> annotating nftnl rules with the extensions they were created for.
>
> Upon nftnl rule parsing failure, warn about the situation and perform a
> second attempt loading the respective compat extensions instead of the
> native expressions which replace them.

OK, so this is last resort to interpret the rule.

> The foundational assumption is that libxtables extensions are stable
> and thus the VM code created on their behalf does not need to be.

OK, this requires xtables API becomes frozen forever.

> Since nftnl rule userdata attributes are restricted to 255 bytes, the
> implementation focusses on low memory consumption. Therefore, extensions
> which remain in the rule as compat expressions are not also added to
> userdata. In turn, extensions in userdata are annotated by start and end
> expression number they are replacing. Also, the actual payload is
> zipped using zlib.

Binary layout is better than storing text in the userdata area.

Is this zlib approach sufficient to cope with ebtables among
extension? Maybe that one is excluded because it is using the set
infrastructure since the beginning.

I guess you already checked for worst case to make sure compression
always allows to make things fit into 255 bytes?

Thanks.
