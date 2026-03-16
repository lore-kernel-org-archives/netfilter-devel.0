Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A5B621D3E2;
	Mon, 16 Mar 2026 08:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773648102; cv=none; b=qS72d1m0TUaek4AUfUD5Yg8MaaAPFRL8miOr8SI0Qs6LwFDFV3Ce00ss0azLWyg81WzuZ68hJn+wHVi0n6geKo4rPZeJTwSn3wEPyIQvL1CRFI4T0Ly138hnaZ+0f16B5DJduNOSmouLMpF15i8jsUz5eqsirXxOU7j7QDoXtiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773648102; c=relaxed/simple;
	bh=1jhC6Mx4jIspPZxtk01ZS1ny812RNqkQAuKdCrFYDeQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W5Q//PXi6We1upSbE3o4ltJyJuL1fyLWyuAYsDj5XIPrSpbaPQk0XrZpCq4N6XEQMqfg++rPxoH/AMTqCfH0EahiqwlXt4fw6JXovdVZAwqoiZaww6vSJueBg0zRnAaMmMV5BXhj41tFoa1u+ZAu4fps4qTbIXBmQTB9QfESk94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id DD466605C3; Mon, 16 Mar 2026 09:01:27 +0100 (CET)
Date: Mon, 16 Mar 2026 09:01:27 +0100
From: Florian Westphal <fw@strlen.de>
To: Kit Dallege <xaum.io@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-kernel@vger.kernel.org, Claude <noreply@anthropic.com>
Subject: Re: [PATCH 2/3] netfilter: add missing kernel-doc parameters for
 nf_hook()
Message-ID: <abe418p9j1ljge-4@strlen.de>
References: <20260315154619.50964-1-xaum.io@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260315154619.50964-1-xaum.io@gmail.com>

Kit Dallege <xaum.io@gmail.com> wrote:
>  /**
>   *	nf_hook - call a netfilter hook
> + *	@pf:	protocol family (e.g. NFPROTO_IPV4)
> + *	@hook:	hook number (e.g. NF_INET_PRE_ROUTING)
> + *	@net:	network namespace
> + *	@sk:	socket associated with the packet, or NULL
> + *	@skb:	socket buffer holding the packet
> + *	@indev:	input network device, or NULL
> + *	@outdev: output network device, or NULL
> + *	@okfn:	function to call if the hook allows the packet to pass
>   *

I tend towards not applying this, I don't think this adds any value,
the arguments are rather obvious for anyone doing kernel networking
and its not a utility/library function either.
