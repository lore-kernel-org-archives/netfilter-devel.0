Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F212813A863;
	Mon, 16 Sep 2024 09:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726480385; cv=none; b=G3Lybe8MEYiMjSJlm4Cq86vCi/Of9zljqRHAWSvq8doEcK+1ltQPh6nIovI4r/DApGxB1iGtG0/HQpYBNzE70vclHfGdj/3cd3atzEXlRTtb0nhXWFtVa0H9bkwPsS1s06QAzytyibB4bCUj0gGz8chVC/ivG3UUIPm6fZTZjLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726480385; c=relaxed/simple;
	bh=Y0wEGA/CDTJ9bQYXykDNZV2VklFOjcmqGNqmmUYxrxE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mA3rK9Rb9s8tI5bTekb3zGppE/QJYmA917yXXE4p0HeW5imv5UQiVdZpswT2CUblFAQ5CX6c2R9TGkFLkw5GPUOkL6cUxEtjjvvjvCLk1E3YJOJvccz66QkBoo4WxLY8o28LBclvo2G6w1j84vy4gAQoikk7HB6l1kZBvLCHy5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FBVpgO24; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FBVpgO24"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 004D6C4CEC4;
	Mon, 16 Sep 2024 09:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726480384;
	bh=Y0wEGA/CDTJ9bQYXykDNZV2VklFOjcmqGNqmmUYxrxE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FBVpgO24Jw0W7UijYP9XiQi6LcBD8000hE6krlw6QC/jeC5oFhu8w+3pt0VmZeDzA
	 9KrBwLFvegudgVk07Dzoc4SNOpKLwb2ZBrUNvFduvF1M0xBNS1d4keSxHUmIwr/kWS
	 nyqfc2SA/iLmf3KoiER8jjb4z9oP2mmCmCKBWbKNDdhxrd7Y6+nB54NuxkAkB/vkBo
	 GqpTckxLUTaPGfAbrNSiL7iLz6GuleVGxmSb0X1+TSPe/gAqY0dhTcyqB1cqmulEdG
	 94u2OKZDTBM8R86C3q8jZUbX2NkDZ/yOaMnHl1IjoKl0ygGnDrUI0ZUYsrFIUYg3QT
	 CTM5uaBjvKlMQ==
Date: Mon, 16 Sep 2024 10:52:58 +0100
From: Simon Horman <horms@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>
Subject: Re: [PATCH net v1 1/1] netfilter: nf_reject: Fix build error when
 CONFIG_BRIDGE_NETFILTER=n
Message-ID: <20240916095258.GG167971@kernel.org>
References: <20240906145513.567781-1-andriy.shevchenko@linux.intel.com>
 <20240907134837.GP2097826@kernel.org>
 <ZudP-mkhquCJJPXv@calendula>
 <20240916073201.GF167971@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240916073201.GF167971@kernel.org>

On Mon, Sep 16, 2024 at 08:32:01AM +0100, Simon Horman wrote:
> On Sun, Sep 15, 2024 at 11:22:02PM +0200, Pablo Neira Ayuso wrote:
> > Hi Simon,
> > 
> > This proposed update to address this compile time warning LGTM.
> > 
> > Would you submit it?
> 
> Hi Pablo,
> 
> Yes, it is on my todo list for today.
> Sorry for not getting to it sooner.
> 
> I plan to post a patch for this to nf-next.
> But let me know if you prefer a patch for nf, net,
> or some other course of action.

Patch posted here:
- [PATCH nf-next] netfilter: nf_reject: Fix build warning when CONFIG_BRIDGE_NETFILTER=n
  https://lore.kernel.org/netfilter-devel/20240916-nf-reject-v1-1-24b6dd651c83@kernel.org/
