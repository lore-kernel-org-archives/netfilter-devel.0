Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164507E589;
	Wed, 24 Jan 2024 17:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706115685; cv=none; b=PS3QTcUwXv/QvhxMXBsM2DyK5GCAM4JKDSk+NU9/96tinRyW/UBCWvapLvoCbgC7z3GgfRQr5EVME2ZfxSJ7Z4r4OiLTDB8sepZwlcBFzbgIR9CQNn7Nbb2U2153KXnVQTCJE8SfD9DvA0lRHroSErHbZC5SPPkGjSB68Vf76KQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706115685; c=relaxed/simple;
	bh=6VY/Zf4sMyOznMSFwVIz2PEwQU7sh+Fa5l2fguJTrJM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BJj06mi+h5Pr9KLv3aIugosr0zlDb69RVUwiM+RQympMkH6YJKVvRmH3A79ksSv6+udaVolxPfmotUO815wdaCh8Kiczc+SgvfjQKQ6yj3cxY5zb6CfH56zJQk15PS4Fu6VpmdegdBJI9DDnIUq2WfqIlt9mhCs0dcx5ucwRwMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JbsRKNcJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JbsRKNcJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F7E9C433C7;
	Wed, 24 Jan 2024 17:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706115684;
	bh=6VY/Zf4sMyOznMSFwVIz2PEwQU7sh+Fa5l2fguJTrJM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=JbsRKNcJ1IdRiHTYUCpDk3IBZBiPMndW7elSbXu+MWVDrKP5p93IUBquPFlTtCqdC
	 Ha/db6dvrW8N0sGtNaf2fkOQDo7vKuRN1kLmJBPTzujC+tknOCsKmeI79Rg4y+K3mo
	 wTZ379+zLi8/wIhfRIR+64OTouLWluPga0u28ehJtmsUEkrlg/YWt0Ik6//lpi5AFs
	 Yqk/eis7C3+Ih/QXOEI908qnXgqvXggh9+7Cz1cb6eJTp2oM/s6IZg4JQS63sFX4eO
	 uSmdwqHyBphV44d4GvPGr28Ik9vAOG3iTD/wJOOcFQBOpVdazfFHntGa2dw/TlHh+U
	 zoA35pnsAtKbw==
Date: Wed, 24 Jan 2024 09:01:23 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: David Ahern <dsahern@kernel.org>, Hangbin Liu <liuhangbin@gmail.com>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "netdev-driver-reviewers@vger.kernel.org"
 <netdev-driver-reviewers@vger.kernel.org>, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org
Subject: Re: [ANN] net-next is OPEN
Message-ID: <20240124090123.32672a5b@kernel.org>
In-Reply-To: <20240124082255.7c8f7c55@kernel.org>
References: <20240122091612.3f1a3e3d@kernel.org>
	<Za98C_rCH8iO_yaK@Laptop-X1>
	<20240123072010.7be8fb83@kernel.org>
	<d0e28c67-51ad-4da1-a6df-7ebdbd45cd2b@kernel.org>
	<65b133e83f53e_225ba129414@willemb.c.googlers.com.notmuch>
	<20240124082255.7c8f7c55@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 24 Jan 2024 08:22:55 -0800 Jakub Kicinski wrote:
> > Going through the failing ksft-net series on
> > https://netdev.bots.linux.dev/status.html, all the tests I'm
> > responsible seem to be passing.  
> 
> Here's a more handy link filtered down to failures (clicking on 
> the test counts links here):
> 
> https://netdev.bots.linux.dev/contest.html?branch=net-next-2024-01-24--15-00&executor=vmksft-net-mp&pass=0
> 
> I have been attributing the udpg[rs]o and timestamp tests to you,
> but I haven't actually checked.. are they not yours? :)

Ah, BTW, a major source of failures seems to be that iptables is
mapping to nftables on the executor. And either nftables doesn't
support the functionality the tests expect or we're missing configs :(
E.g. the TTL module.
