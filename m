Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC4DE12BE98;
	Wed, 24 Jan 2024 18:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706121320; cv=none; b=oar2/c0TYHR7fE788YkHlbpTDQHh9e3OPvV4Yv69gafSBkumJbdW/vPLHbTRDaCd6nxS3RWe9CpOhr30USEWH+iIiPhf59L4iB9sg0/683jSc0bndGnnQh1Ruoe4HHVDm+eE76vUKlz6MStmtCQKxjYv33e0Md6tJQ4pqvELfTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706121320; c=relaxed/simple;
	bh=0Fv05bzEh595wyAQk5sMjts2dhpJbVR+BEsKCiWLVrw=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=oQ+b8mmH8o61ZQsYsZZ9Hl4hxb4/CV24XoWcqvEMicK6PefZHRwbR7uJkzRruy8nf4vojU6xp6yowNvj2vUFJUJsPZTrRy2NVhwLYDI3WPn1cC3fmeH7W+Xl+NTAYxkaaXzVfST18MhJCnmMcIPAxk8drapz0Qd61mL6TojqtXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bzmWw/nO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bzmWw/nO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 825FEC433F1;
	Wed, 24 Jan 2024 18:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706121320;
	bh=0Fv05bzEh595wyAQk5sMjts2dhpJbVR+BEsKCiWLVrw=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=bzmWw/nOprsPG3x6BweUoAQZIZyvMy1b6IDxpUI0riQqwawhA+mFLzQzOUkmW6zdq
	 O+Jz3NnWzD1gh7vUWp01OVG/ZBT2p8NRmAxDVWoO/AnK0SX0Dz/vE8UyuzIFLwSxA0
	 2JqzMUh3V2NLj91cDTQM0KxNXCIBfYwDchu3YP0MSjcQcdRs18gJPjTuf/58Y6FOcr
	 YjJnOhbRiNOWT/ppGiOMztLwHa5VCqtdh8Mad6QZrpWBtCmNLQmIgkFrDDSCLzky1M
	 8rXOuCZ8aRTynStKOUo9eofpzTLavIrIE46XiS2uRf4zbDLPQuhyGwcbdm52gxGQX5
	 golxt5h5d2AFA==
Date: Wed, 24 Jan 2024 18:35:14 +0000 (GMT)
From: Matthieu Baerts <matttbe@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	David Ahern <dsahern@kernel.org>, Hangbin Liu <liuhangbin@gmail.com>,
	netdev@vger.kernel.org, netdev-driver-reviewers@vger.kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Message-ID: <26616300-dc28-47d1-88bb-1c7247d1699d@kernel.org>
In-Reply-To: <20240124090123.32672a5b@kernel.org>
References: <20240122091612.3f1a3e3d@kernel.org> <Za98C_rCH8iO_yaK@Laptop-X1> <20240123072010.7be8fb83@kernel.org> <d0e28c67-51ad-4da1-a6df-7ebdbd45cd2b@kernel.org> <65b133e83f53e_225ba129414@willemb.c.googlers.com.notmuch> <20240124082255.7c8f7c55@kernel.org> <20240124090123.32672a5b@kernel.org>
Subject: Re: [ANN] net-next is OPEN
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Correlation-ID: <26616300-dc28-47d1-88bb-1c7247d1699d@kernel.org>

Hello,

24 Jan 2024 17:01:24 Jakub Kicinski <kuba@kernel.org>:

> On Wed, 24 Jan 2024 08:22:55 -0800 Jakub Kicinski wrote:
>>> Going through the failing ksft-net series on
>>> https://netdev.bots.linux.dev/status.html, all the tests I'm
>>> responsible seem to be passing.=C2=A0
>>
>> Here's a more handy link filtered down to failures (clicking on
>> the test counts links here):
>>
>> https://netdev.bots.linux.dev/contest.html?branch=3Dnet-next-2024-01-24-=
-15-00&executor=3Dvmksft-net-mp&pass=3D0
>>
>> I have been attributing the udpg[rs]o and timestamp tests to you,
>> but I haven't actually checked.. are they not yours? :)
>
> Ah, BTW, a major source of failures seems to be that iptables is
> mapping to nftables on the executor. And either nftables doesn't
> support the functionality the tests expect or we're missing configs :(
> E.g. the TTL module.

I don't know if it is the same issue, but for MPTCP, we use
'iptables-legacy' if available.

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=
=3D0c4cd3f86a400

Cheers,
Matt
