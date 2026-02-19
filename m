Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CABAD341AC7;
	Thu, 19 Feb 2026 15:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771513882; cv=none; b=NGR2kHrel34baghsp9vn81Pi3yVDk+ZW1ukbJfmHUtpMsj1J60Q2Wv6uJ/OxkPrGFDnuEuJWwe+TsXzEPfihWwtICqlUc6EO2xb8dB4EC5IFGQgs86XK79FqW1c/VGS04T3T6gxTzz3pUgBuqb+53EPJtPFUzHJMpAjRIsS/NBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771513882; c=relaxed/simple;
	bh=AaxuMe/wbr8zu4fW7tQYMdRqwwj2KbDM6WvVshEybXg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ebiaaHPo7AAPvPCzqj56UzPvO6uSEMq6ksRTdoNvjv7+vyktSfXYC7P6UzmAkrW38BzBGQTpnA/HvPrP5hfOQpjGFpGFDDhEr+7Ua4qGoeus8IHT1hjzqjGdO1Ui4Nger94ZuoTT3J5kco4vr9Xv/Rs9+pOQsJaRrgwtcvfyHYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id CB6E6602F8; Thu, 19 Feb 2026 16:11:12 +0100 (CET)
Date: Thu, 19 Feb 2026 16:11:09 +0100
From: Florian Westphal <fw@strlen.de>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, netfilter-devel@vger.kernel.org,
	pablo@netfilter.org
Subject: Re: [TEST] nft_queue / test_udp_gro_ct flakes
Message-ID: <aZcoDclA37Pk3UJp@strlen.de>
References: <20260206153048.17570-1-fw@strlen.de>
 <20260206153048.17570-4-fw@strlen.de>
 <20260218184114.0b405b72@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260218184114.0b405b72@kernel.org>

Jakub Kicinski <kuba@kernel.org> wrote:
> On Fri,  6 Feb 2026 16:30:40 +0100 Florian Westphal wrote:
> > Without the preceding patch, this fails with:
> > 
> > FAIL: test_udp_gro_ct: Expected udp conntrack entry
> > FAIL: test_udp_gro_ct: Expected software segmentation to occur, had 10 and 0
> 
> Hi Florian!
> 
> This test case is a bit flaky for us on debug kernels:
> 
> https://netdev.bots.linux.dev/contest.html?pass=0&test=nft-queue-sh
> 
> It's 3rd flakiest of all netdev selftests at this point.

Ouch.  Sorry about this, I will look at this asap.
