Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65DD26A1AC;
	Thu,  7 Aug 2025 18:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754591073; cv=none; b=CXJf+1AM0dKQJ3JCh82RciXlhP/lNsB72ES1PMJ8vVyO+C0dks+MTbUScstlGKeym09t2VxPNk9z4pfVZg2EqJmUTAZeZUVQIvy9hoA2r+PMD8ppm8ao0dVMStPitiM8VhHF5IXy0ejVkTCsbV2/Y5L+290uGK4WsJV9UbuVOpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754591073; c=relaxed/simple;
	bh=LXMAPbrN5NVfNDCYtRYu6JJQvWpPQIof0gf3ZC5gFd4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AZQ8JkJoyCFq61/WuGf01R3t0oTn64ExNvyYVF9eHPMcTs0VnkIPauIVaJb23avAGzgBAhjN/2jaOpaH9r4XYjbrZlSADyt1M6FTJWy9c52aftlexkL9iK4okdXkXzh/FTf9ARleRvRsCdP6oUKWrGcheSqIf0xL9UBuIMahRCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DcK7Ts88; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DcK7Ts88"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C903FC4CEEB;
	Thu,  7 Aug 2025 18:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754591072;
	bh=LXMAPbrN5NVfNDCYtRYu6JJQvWpPQIof0gf3ZC5gFd4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DcK7Ts88Rl1IA9y/W/4VxddOCqR9isjygpYRiBAnFgpOMAoxTOc4+YEwRSN9oiy7s
	 cEpW28+ZqE2MkE9B0rKxxumIFDaBhY4mYwOzA/ZUQ1UxNfF7e8tJRzO0qvM/6kjkNT
	 0IGdOQLt4dtPV/JBaSzqx31YyXb+cno1i+4v8yJkvXDJ7+dz1C3LmMflXM2M1zYr11
	 4cuGpYLc9+nlfI7FjJDADhiny0vK8IoiV4IIutYQvKbH2hKvKxq5YF11ZR5/TsycRz
	 EuBF7OfhMq5ZVmtRStjLlc9ndQ+o8LTQKtHATFm4YzBo9lhG/yjm54gX9CtpMV8QX3
	 txeM5aV5/aaDQ==
Date: Thu, 7 Aug 2025 19:24:28 +0100
From: Simon Horman <horms@kernel.org>
To: Eric Dumazet <edumazet@google.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	fw@strlen.de
Subject: Re: [PATCH net 1/7] MAINTAINERS: resurrect my netfilter maintainer
 entry
Message-ID: <20250807182428.GN61519@horms.kernel.org>
References: <20250807112948.1400523-1-pablo@netfilter.org>
 <20250807112948.1400523-2-pablo@netfilter.org>
 <CANn89iL1=5ykpHXZtp0_J-oUbd7pJQTDL__JDaJR-JbiQDkCPQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANn89iL1=5ykpHXZtp0_J-oUbd7pJQTDL__JDaJR-JbiQDkCPQ@mail.gmail.com>

On Thu, Aug 07, 2025 at 04:35:52AM -0700, Eric Dumazet wrote:
> On Thu, Aug 7, 2025 at 4:29 AM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >
> > From: Florian Westphal <fw@strlen.de>
> >
> > This reverts commit b5048d27872a9734d142540ea23c3e897e47e05c.
> > Its been more than a year, hope my motivation lasts a bit longer than
> > last time :-)
> >
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> Oh very nice, welcome back Florian !

Yes, very nice indeed. Welcome back Florian !
