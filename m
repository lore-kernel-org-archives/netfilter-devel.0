Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236AF133408;
	Wed, 24 Jan 2024 19:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706123815; cv=none; b=KQpWhW1vSEJRyD7keo6l8xwqR5i+nmgC6jBiV7p6OVcanuobv6zSoP21tJDoLlFyqDiN76WcMjNQnWUclGI81lyQMX/8lsJH3GpGqT7kwrnIPv9ucZwUm3/lih1DeQEuZiQibfphAvn4nzWgGAs0m9LxrN2sihPbCsaLFhPESFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706123815; c=relaxed/simple;
	bh=qd0OEY3WwW5vXkOq3Q4fKpufgOr2HkyC6jTO2bWiHSs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qmhjAX4gZbs+s8GgNp7UQ7oCPvBrrgQkCQXHwX1mPdBfiWfdlwk14H6Wk5vElC0DUx+zE6p8RIX50s5wqANGv9uEo2d6LcqeXYl7WATvvlQDAG0OBbfLGN77m48NJCPgPFuWI/tFJlm3yegTbo9c2q/3Nx82aWCrtDak3GAm3tU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.41.52] (port=50382 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rSijp-006lvY-4W; Wed, 24 Jan 2024 20:16:43 +0100
Date: Wed, 24 Jan 2024 20:16:39 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	David Ahern <dsahern@kernel.org>, coreteam@netfilter.org,
	"netdev-driver-reviewers@vger.kernel.org" <netdev-driver-reviewers@vger.kernel.org>,
	Hangbin Liu <liuhangbin@gmail.com>, netfilter-devel@vger.kernel.org
Subject: Re: [netfilter-core] [ANN] net-next is OPEN
Message-ID: <ZbFiF2HzyWHAyH00@calendula>
References: <20240122091612.3f1a3e3d@kernel.org>
 <Za98C_rCH8iO_yaK@Laptop-X1>
 <20240123072010.7be8fb83@kernel.org>
 <d0e28c67-51ad-4da1-a6df-7ebdbd45cd2b@kernel.org>
 <65b133e83f53e_225ba129414@willemb.c.googlers.com.notmuch>
 <20240124082255.7c8f7c55@kernel.org>
 <20240124090123.32672a5b@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240124090123.32672a5b@kernel.org>
X-Spam-Score: -1.9 (-)

On Wed, Jan 24, 2024 at 09:01:23AM -0800, Jakub Kicinski wrote:
> On Wed, 24 Jan 2024 08:22:55 -0800 Jakub Kicinski wrote:
> > > Going through the failing ksft-net series on
> > > https://netdev.bots.linux.dev/status.html, all the tests I'm
> > > responsible seem to be passing.  
> > 
> > Here's a more handy link filtered down to failures (clicking on 
> > the test counts links here):
> > 
> > https://netdev.bots.linux.dev/contest.html?branch=net-next-2024-01-24--15-00&executor=vmksft-net-mp&pass=0
> > 
> > I have been attributing the udpg[rs]o and timestamp tests to you,
> > but I haven't actually checked.. are they not yours? :)
> 
> Ah, BTW, a major source of failures seems to be that iptables is
> mapping to nftables on the executor. And either nftables doesn't
> support the functionality the tests expect or we're missing configs :(
> E.g. the TTL module.

I could only find in the listing above this:

https://netdev-2.bots.linux.dev/vmksft-net-mp/results/435141/37-ip-defrag-sh/stdout

which shows:

 ip6tables v1.8.8 (nf_tables): Couldn't load match `conntrack':No such file or directory

which seems like setup is broken, ie. it could not find libxt_conntrack.so

What is the issue?
