Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E30619259A;
	Sun, 20 Oct 2024 12:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729428684; cv=none; b=QzC52X3evxky5e8nISaye8YR4IaBSCwXNnguBTreY46l1pBrquKD92gbamW/cysgOgCvw/7X/9d8TpJ2pS4PmmY4e1vCkz2kq0YpGSsuOkL4JrtsULELyml8kqqeTmYT8bIm5ysWPSalk2F2m63g4ysetwmh7ci9YY6Jd43iPhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729428684; c=relaxed/simple;
	bh=c/hpHiuA2DnZLM8D/ULsBIPjRDrwFh+KZtRkJrdlpaI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YwUQ7H0Lb9YhmNE2IeEXVqb/lxA1a9Oop1jOJwzH+tbD/+a0K+9Eq702nX8wKrCiB9Bq2lEuDSgzqc+N3AULdQgiJ6aH4ji4pOMkNM33/LOxKeV7djAiw6V9Ai1n1O7epjYRV9IeYQ+S0wuDRO1j9MiI8fVgNotK4qhnmOR21Gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=46922 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t2VOw-006uHD-1g; Sun, 20 Oct 2024 14:51:20 +0200
Date: Sun, 20 Oct 2024 14:51:17 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Krzysztof =?utf-8?Q?Ol=C4=99dzki?= <ole@ans.pl>
Cc: Florian Westphal <fw@strlen.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org,
	netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: 6.6.57-stable regression: "netfilter: xtables: avoid
 NFPROTO_UNSPEC where needed" broke NFLOG on IPv6
Message-ID: <ZxT8xZNJIzCcNKnA@calendula>
References: <8eb81c74-4311-4d87-9c13-be6a99c94e2f@ans.pl>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8eb81c74-4311-4d87-9c13-be6a99c94e2f@ans.pl>
X-Spam-Score: -1.9 (-)

Hi,

On Sat, Oct 19, 2024 at 10:22:01PM -0700, Krzysztof Olędzki wrote:
> Hi,
> 
> After upgrading to 6.6.57 I noticed that my IPv6 firewall config failed to load.
> 
> Quick investigation flagged NFLOG to be the issue:
> 
> # ip6tables -I INPUT -j NFLOG
> Warning: Extension NFLOG revision 0 not supported, missing kernel module?
> ip6tables: No chain/target/match by that name.
> 
> The regression is caused by the following commit:
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?h=linux-6.6.y&id=997f67d813ce0cf5eb3cdb8f124da68141e91b6c

Yes, this is the proposed incremental fix.

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20241020124951.180350-1-pablo@netfilter.org/
