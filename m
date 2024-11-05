Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E29BF216204
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Nov 2024 23:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730848656; cv=none; b=QeBa29dqj7C1ohL1x+5cmkIP7SeroZ7JOiWqFsCBEEq3Y2BQ3Lzd4XDjohEV3EBcJBJlzwWX68Wrnl8jJcFZme3zuCMND1gGd+juf/6sM1nRz8Vh9oL1vwkVzW1cmFkeD0vj9EtJskoOjBwrsh4pdTbul2In96UIMleDSN4MrwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730848656; c=relaxed/simple;
	bh=7Jy4ZaxlXj1hd+/etvFJGk5HvXOo3di0xCoUrW21LBg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pL/8aby/rM/+KhizoAepkygvY4uJnxBLfrE1f7JxIc0fPeTFLHRMVAA5C/HK21MMD7yRbO0ndOU07M6dAeaBzUug8WZV/3eiQkbYHmlY3x7D1NocB4afV4zDHHel2h2avVP6ZRltl69QDmOOTvXI5G7UeNR1ydXLQkRIup93OCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=VK6MubuB; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="VK6MubuB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=szb4gem0CTgtAEO8hM1b6FjlLZz1RdzsrZYsIOy/7yY=; b=VK6MubuBmRWZyODWbluM9a4N+g
	QlHfJL5YNLSP5FopLEs+RuqMg5hyDmbFajtQdrOqIFTZUZit0zfpJ5oFGRJIMyog2P74qUlFl+7Ao
	OcBhlEMINcj9xkqPLmIqJ1oJFyey8nP3rHgHAY35ozj+zWIj/P5JJd07sqabS2BJAKoRhgPf0vTBg
	BdSPeqft4zZEp+8czmyGfg5d4EM5OF3EWqN8ON1D/7XaEFf7X+W5pO2mrWO5nirdFObaq+7vueQQG
	eoeTsw6N/K5ovCI87YQQjIt4JyucFaW8Pgj9m1R0J695MlIjNc8pdeC1usS/ZKK0NJXz+to9AbqF2
	O06qf0BQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t8Snl-000000005XA-04Ma;
	Wed, 06 Nov 2024 00:17:33 +0100
Date: Wed, 6 Nov 2024 00:17:32 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [conntrack-tools PATCH] src: Eliminate warnings with
 -Wcalloc-transposed-args
Message-ID: <ZyqnjF-rGIfSCrte@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20241105215450.6122-1-phil@nwl.cc>
 <Zyqlyj0FKU7XeUD5@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zyqlyj0FKU7XeUD5@calendula>

On Wed, Nov 06, 2024 at 12:10:02AM +0100, Pablo Neira Ayuso wrote:
> On Tue, Nov 05, 2024 at 10:54:50PM +0100, Phil Sutter wrote:
> > calloc() expects the number of elements in the first parameter, not the
> > second. Swap them and while at it drop one pointless cast (the function
> > returns a void pointer anyway).
> 
> BTW, will you add
> 
> -Wcalloc-transposed-args
> 
> to Makefile.am?

The gcc-14.2.1_p20240921 here seems to have this enabled by default. I
did not pass any special configure or make options.

Cheers, Phil
