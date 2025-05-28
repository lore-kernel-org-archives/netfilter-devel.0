Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A6B28689A
	for <netfilter-devel@vger.kernel.org>; Wed, 28 May 2025 13:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748438456; cv=none; b=MOFpgK0d6tK5MchH5+/jlEXJ0/UteEwghDAVzZs3Bfh2WVa7sXBGWVslpI6kRMeVCbW04RJFCOcazDA6BWaoin4NSP8bR3m+8rdYA3rxXXYWJYt81Saxs9Gy0PecaoKX75pMm7HYIKWiiMHHfH8ss8xzKN1RL992R5rAKsfcn0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748438456; c=relaxed/simple;
	bh=ZZ6BUqhzdFjK4rOezjSdqZEgCEltLYODWfbAg2x2IKQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bnbwLwx0NRmO+JdieBkOXwPboRoqTkgla1h6F3FIharz92a8OctlzNGBHlqXyYs/gUvMup69Od986rKKf4O9VxruDeJ8/LSXdgmSi4iv6GyvENMVOvSUYHkisQcXyyZd8j64ctleSNynKMiGdZtsc4r0/mTXtPUxjA3ZcwpDcq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 319276042D; Wed, 28 May 2025 15:20:52 +0200 (CEST)
Date: Wed, 28 May 2025 15:20:14 +0200
From: Florian Westphal <fw@strlen.de>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: pablo@netfilter.org, kadlec@netfilter.org,
	David Miller <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Subject: Re: [BUG REPORT] netfilter: DNS/SNAT Issue in Kubernetes Environment
Message-ID: <aDcNjpqOKNonzrT-@strlen.de>
References: <CALOAHbBj9_TBOQUEX-4CFK_AHp0v6mRETfCw6uWQ0zYB1sBczQ@mail.gmail.com>
 <aDbyDiOBa3_MwsE4@strlen.de>
 <CALOAHbAeVhLAe3o3UL8UOJrCRbRP8mqYZy37CYNHYFa3zss6Zg@mail.gmail.com>
 <aDb-G3_W6Ep19Zjp@strlen.de>
 <CALOAHbCYhYCLt7zJfdmSUWk_jpWXudLokXvQTGSJt_g4WALGsw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALOAHbCYhYCLt7zJfdmSUWk_jpWXudLokXvQTGSJt_g4WALGsw@mail.gmail.com>

Yafang Shao <laoar.shao@gmail.com> wrote:
> After applying commit d8f84a9bc7c4, only one entry remains:
> $ cat /proc/net/nf_conntrack| grep 10.242.249.78
> ipv4     2 udp      17 106 src=10.242.249.78 dst=169.254.1.2
> sport=34616 dport=53 src=127.0.0.1 dst=10.242.249.78 sport=53
> dport=34616 [ASSURED] mark=0 zone=0 use=2

Makes sense to me, thats what would be expected, at least from ct state, no?
(I inderstand that things are not working as expected from DNS pov).

> After the additional custom hack, the entries now show two records:
> $ cat /proc/net/nf_conntrack| grep 10.242.249.78
> ipv4     2 udp      17 27 src=169.254.1.2 dst=10.242.249.78 sport=53
> dport=46858 [UNREPLIED] src=10.242.249.78 dst=169.254.1.2 sport=46858
> dport=53 mark=0 zone=0 use=2
> ipv4     2 udp      17 27 src=10.242.249.78 dst=169.254.1.2
> sport=46858 dport=53 src=127.0.0.1 dst=10.242.249.78 sport=53
> dport=46858 mark=0 zone=0 use=2

That makes no sense to me whatsoever.

The second entry looks correct/as expected:
10.242.249.78 -> 169.254.1.2  46858 -> 53    DNATed to 127.0.0.1:53  10.242.249.78:46858

... so we would expect replies coming from 127.0.0.1:53.

But the other entry makes no sense to me.

src=169.254.1.2   dst=10.242.249.78  sport=53 dport=46858 [UNREPLIED] src=10.242.249.78 dst=169.254.1.2 sport=46858 dport=53 mark=0 zone=0 use=2

This means conntrack saw a packet, not matching any existing entry for this:
169.254.1.2:53 -> 10.242.249.78:46858

... and that makes no sense to me.
The reply should be coming from 127.0.0.1:53.

I suspect stack refuses to send a packet from 127.0.0.1 to foreign/nonlocal address?

As far as conntrack is concerned, the origin 169.254.1.2:53 is a new flow.

We do expect this:
127.0.0.1:53 -> 10.242.249.78:46858, which would be classified as matching response to the
existing entry.

Do you have any load balancing, bridging etc. going on that would result in cloned
packets leaving the system, where one is going out unmodified?

Is route_localnet sysctl enabled? I have never tried such lo stunts myself.
