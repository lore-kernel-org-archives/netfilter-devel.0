Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C702133400;
	Wed, 24 Jan 2024 19:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706123922; cv=none; b=alfXD2gK1u/OpLvR9OqRVTRTnTFol6Bff9aHX1Y65RCUp/qBKi/kM+km/2k5LNR69t4QoYFqefYzg7ihHPQx7OLRzgqIlJBA/DyDhRKf10VsL68165cAEkWq8dQ/bc09esalnKvOnSbMoolfv8mpmYeemxJbI2mwr1kPyEmp+Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706123922; c=relaxed/simple;
	bh=gJo5BjnJ8quuHR4+44UUuirjs2CgMZZTpR5OEFlg4zU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EIQqjwNMzpWwdpWwCD8LrwV//e4Z+Zd6MkWMIMsYkbVdu0xqXrhlaIzdMZ5wElDJvjmc9hQ62CAxTxWW+H/T7lXk6OOsePB84/O6w77Ck0ZLswqBVavdDis+aQAmvgdqoUyunJlEwaK7llRBea4rPHjCGu9AMlPEBKLaRJs0Evg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.41.52] (port=50392 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rSilg-006m1A-01; Wed, 24 Jan 2024 20:18:38 +0100
Date: Wed, 24 Jan 2024 20:18:35 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Matthieu Baerts <matttbe@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
	coreteam@netfilter.org, netdev-driver-reviewers@vger.kernel.org,
	Hangbin Liu <liuhangbin@gmail.com>, netfilter-devel@vger.kernel.org
Subject: Re: [netfilter-core] [ANN] net-next is OPEN
Message-ID: <ZbFiixyMFpQnxzCH@calendula>
References: <20240122091612.3f1a3e3d@kernel.org>
 <Za98C_rCH8iO_yaK@Laptop-X1>
 <20240123072010.7be8fb83@kernel.org>
 <d0e28c67-51ad-4da1-a6df-7ebdbd45cd2b@kernel.org>
 <65b133e83f53e_225ba129414@willemb.c.googlers.com.notmuch>
 <20240124082255.7c8f7c55@kernel.org>
 <20240124090123.32672a5b@kernel.org>
 <26616300-dc28-47d1-88bb-1c7247d1699d@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <26616300-dc28-47d1-88bb-1c7247d1699d@kernel.org>
X-Spam-Score: -1.9 (-)

On Wed, Jan 24, 2024 at 06:35:14PM +0000, Matthieu Baerts wrote:
> Hello,
> 
> 24 Jan 2024 17:01:24 Jakub Kicinski <kuba@kernel.org>:
> 
> > On Wed, 24 Jan 2024 08:22:55 -0800 Jakub Kicinski wrote:
> >>> Going through the failing ksft-net series on
> >>> https://netdev.bots.linux.dev/status.html, all the tests I'm
> >>> responsible seem to be passing. 
> >>
> >> Here's a more handy link filtered down to failures (clicking on
> >> the test counts links here):
> >>
> >> https://netdev.bots.linux.dev/contest.html?branch=net-next-2024-01-24--15-00&executor=vmksft-net-mp&pass=0
> >>
> >> I have been attributing the udpg[rs]o and timestamp tests to you,
> >> but I haven't actually checked.. are they not yours? :)
> >
> > Ah, BTW, a major source of failures seems to be that iptables is
> > mapping to nftables on the executor. And either nftables doesn't
> > support the functionality the tests expect or we're missing configs :(
> > E.g. the TTL module.
> 
> I don't know if it is the same issue, but for MPTCP, we use
> 'iptables-legacy' if available.
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=0c4cd3f86a400

I'd suggest you do the other way around, first check if iptables-nft
is available, otherwise fall back to iptables-nft

commit refers to 5.15 already have iptables-nft support, it should
work out of the box.
