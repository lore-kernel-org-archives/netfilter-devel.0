Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98523C10A4;
	Tue,  9 Jun 2026 22:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781045536; cv=none; b=HSfsuwhOxoJMT2k/XFi9iH2sBgXPvQiNx7SHazV1lQppxzjPxFblqe5lftH4aTZYF1WQlIoGrGrJjLq1T9eOEM3McPYpj+bLwfjqmJGHjUBsrm80yCf7lGz4IgkmLZ3GXcoKforwN3Y64wzDy8MkJqh/p45rWMbcVoNKv8eM2nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781045536; c=relaxed/simple;
	bh=YLsaHjd1rWOshoAo+//q/TpaZ07U+v08ELDqsnDSTYQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Hp1IOycZo+V1Cotix1itlczuKC2sd5TCpjM1S8SM5/Y0Y6OhvVGEIw0afhld1i2NGdWUThC4bymIIiupbrgPOgQs3FLTeeswE0p8d+tvYYo2HYNRHxdGoWkiBCdkSgbgELglQvlu2EXXwb3E+pNl823rKsjj0y+OkSUTtX7gzyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PsA0T/fe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PsA0T/fe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40CB11F00893;
	Tue,  9 Jun 2026 22:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781045535;
	bh=I6ynbvwQwmu34CpxE9zvuOA/dRWUzH2k8my28foU7PU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=PsA0T/fecv25vRAw6UD8xB4+K4GMBGeNR7GLqTX9IXuoC0ikM1XlenfvUVLOcWH3s
	 Tn5ISkqALu3Y6JekGayNQewRca3BF7U6bViWd8LFv0XcKMZ4j+hIvs7JV/ro8Bmb4Q
	 zM9KlaHgVsbCPuxZhD38UUuuziZxGQhTBJP7C6GtBggGKFTjnoaPPDrW+TLbPq28/U
	 CwDnYs1HC9zZdb6vomPsjoabBUUptUy82Gl3DGfRH6Af0MzNWzj7JZ0WlegKo9wwu0
	 Rog/7ORHEEFROaNZJUaIDNE4RmxtgbBynlAcYs9DwEtQkm3Oa6aR+QvTqGtdHRq1x6
	 YeYzSt3xdetHA==
Date: Tue, 9 Jun 2026 15:52:14 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next] net: dummy: add phony ndo_setup_tc stub
Message-ID: <20260609155214.59f02742@kernel.org>
In-Reply-To: <aiiS2igkkIvGLtpM@strlen.de>
References: <20260609142813.9197-1-fw@strlen.de>
	<20260609151517.186b1cac@kernel.org>
	<aiiS2igkkIvGLtpM@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 10 Jun 2026 00:25:30 +0200 Florian Westphal wrote:
> Jakub Kicinski <kuba@kernel.org> wrote:
> > On Tue,  9 Jun 2026 16:28:09 +0200 Florian Westphal wrote:  
> > > Unlike netdevsim, dummy is a data sink so no capabilities (e.g.
> > > u32-style matcher, vport device redirects, PPPoE header push/pop etc).
> > > have to be implemented.  
> > 
> > If no "peer" is configured netdevsim is also a data sink.  
> 
> Yes, but you can configure peers.  And then this fake offload stub
> is a liar.
> 
> I would expect that offloads for netdevsim actually work, i.e.
> that a shaper shapes, that ets offload does delay packets and
> in case of flowtable that it will move skbs from one vport to
> another (if that was requested).
> 
> > We added netdevsim because dummy and veth started accumulating
> > "features" which were clearly just for test harnesses. Would be
> > great if we could stay the course and put whatever changes you
> > need in netdevsim, even if it requires some hacks.  
> 
> Is a lot more work.  I don't have time ATM to implement a u32-style
> packet matcher or a fake software flowtable.

There are no real requirements on how netdevsim behaves. The only
requirement is that there's an in-tree test that uses whatever
functionality is being added. So you can implement the features
to whatever depth you need for your current testing.

> > Is there anything fundamentally blocking the use of netdevsim?
> > Or is it just convenience (since netdevsim is a bit of a PITA
> > to create and establish the name of)?  
> 
> I played with netdevsim, aside from the above (i.e., I don't expect
> netdevsim to say 'offloaded' and then ignore all the offloaded
> commands...) the worst part is the naming and the behaviour when
> creating new devices while in a network namespace.  Test is spawned via
> 'unshare -n' -- I did not find a way to really extract the new device name
> reliably except via 'ip link'.

Yes :( we have some helpers in 
tools/testing/selftests/drivers/net/netdevsim/ethtool-common.sh
among other places but libraries are a PITA in ksft as well.

> I think thats solveable, so yes, I could make netdevsim lie instead.
> 
> But I don't think its the right thing to do.
> 
> If you disagree and think that this is fine I can retarget this to
> netdevsim, no problem.

Yes, I'd prefer netdevsim. If nothing else it lets us discard 
"security reports" by saying that nobody should have netdevsim 
loaded on a production system.
