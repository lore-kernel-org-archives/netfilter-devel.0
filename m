Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15FC51DE885;
	Mon,  6 Jan 2025 14:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.67.10.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736172952; cv=none; b=ejkxIJIjoz9V/Cz6m+QPtgfjEEX4Ef7Mu/F4IB64qxfA+/JMAlYLQ2WTkI3MyEgCoClN1q5eZ2BWkkT2Q1VGQrhv5fI6Y42Ko/SPuo1m276Xc+hKZ5nYw3V09c04kvR6BrDx/xV/IluGfDOzASVUowR5dM1U2vNgrsdUmt5aQ3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736172952; c=relaxed/simple;
	bh=1FjjP0bW/UQZd0RuHqLeStFI+Cs7l18Bi3pp/tCNl2w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=taGUr6pDb0N2tjiz7uAhVmY2d76aRhwBRtTf+Fda+aUusC2eGj6kvO+tPMxq9/kRyIifT4noNXPmzxVPqIQYmB32vi7ZAfTy00WLozuzEcCqyg1Pdak1IMYLAXDLfpRP8Lr0kxla/70NGuJDWJp1Qt1DdE7P3zh2YKoEetr6aYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch; spf=pass smtp.mailfrom=lunn.ch; dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b=Hs76hF17; arc=none smtp.client-ip=156.67.10.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lunn.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b="Hs76hF17"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=6ItshHd6UkbfmdlN/GoUSfhvYwIylT3xUoNk+/Xxfk8=; b=Hs76hF17l+LQ6aJf5r8TWwDi6Y
	Wzwv3AcY2H3Rzpcj6LImN2BefFYyzOkQgyzMzUxE8QrVhRH3ZfnAMGh0x5K4WCPRu5/QLABXx11sg
	cvRsdgGfzvg/3ksnxjqknlyVWZ3qr6WST3ukc9f+PmktNoI/9nclBdPJuVWsxxBjGVQU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1tUntA-001tce-Hs; Mon, 06 Jan 2025 15:15:28 +0100
Date: Mon, 6 Jan 2025 15:15:28 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: =?utf-8?B?U3rFkWtl?= Benjamin <egyszeregy@freemail.hu>
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>, lorenzo@kernel.org,
	daniel@iogearbox.net, leitao@debian.org, amiculas@cisco.com,
	kadlec@netfilter.org, David Miller <davem@davemloft.net>,
	dsahern@kernel.org, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, horms@kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v6 1/3] netfilter: x_tables: Merge xt_*.h and ipt_*.h
 files which has same name.
Message-ID: <c885e386-4a7a-4139-95b6-6411aa8b6b8e@lunn.ch>
References: <20250105231900.6222-1-egyszeregy@freemail.hu>
 <20250105231900.6222-2-egyszeregy@freemail.hu>
 <8f20c793-7985-72b2-6420-fd2fd27fe69c@blackhole.kfki.hu>
 <33196cbc-2763-48d5-9e26-7295cd70b2c4@freemail.hu>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33196cbc-2763-48d5-9e26-7295cd70b2c4@freemail.hu>

> First suggestion was to split it 2 parts, it is done, i split in 3 parts, it
> was more then needed. Your idea will lead to split it about to 20 patch
> parts, then the next problem from you could be "there are to many small
> singel patches, please reduce it".

You are missing some meaning in what i said. I said it needed to be
split into two patchsets. A patchset is a collection of patches. I
would like to see one set of patches doing the merge, and a second set
of patches doing the case insensitive changes.

Within those patch sets, you should have lots of little patches, each
of which is simple to review, has a good commit messages, and it
obviously correct.

You are unlikely to get feedback saying the patches are too
small. There is however a limit of 15 patches in a patch set. If you
actually needed 20 patches, then you break it up into two patch sets.

> If you like to see it in a human readable format you can found the full diff
> and the separted patches also in this link:
> https://github.com/torvalds/linux/compare/master...Livius90:linux:uapi

Patches are human readable, especially when they are small, and have a
good commit message. Spend a little bit of time reading patches from
people like Russell King, Oleksij Rempel, just to pick two names at
random.

> Please start to use any modern reviewing tool in 2025 and you can solve your
> problem. In GitHub history view i can see easly what was moved from where to
> where in 1-3 mouse clicking, eg.: click to xt_DSCP.h then click to xt_dscp.h
> and you can see everything nicely. So it is ready for reviewing, please sit
> down and start work on it as a maintainer, It's your turn now.

I use gitlab for the day job. It is missing some really basic features
which i think make it unsuitable for the Linux role of "Reviewer". It
also is really slow to use and does not scale to the volume of patches
you see on netdev. With some re-engineering, it might be possible to
fix these issues, but so far, i've not seen it happen.

Part of the issues here is, Linux is short of Maintainers/Reviews,
given the number of developers. So the processes are set up to make
the Maintainers/Reviews roles more efficient, pushing as much work as
possible to developers which there are plenty off. Tools like
gitlab/github don't really make the Maintainers/Reviews roles
efficient, so don't work too well for Linux.

	Andrew
