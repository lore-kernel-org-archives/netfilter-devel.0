Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE8116DCE1;
	Wed, 23 Apr 2025 21:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745442128; cv=none; b=F4rhYwbyfDyjuOi1eZ1t1yxDKhCKqWl1GAJ8+/mfvbYl7VncTO6gjqmLpR+Hj6CDDxEUl4+J9vU/3R3p5QVrqppxgSfzDbvF5oCfbaYsAJPNUL7SDHqvDvaK1HERnOY2abyC54tEo4fJiiiYFXumHBD92zp0RA6YADxZUAaw9qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745442128; c=relaxed/simple;
	bh=m0NRbO5nY7qHPSrRaqy1oF54g1J1IPbxCrbifZ3F7bc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OCt36C6r8wczThxlTXaHlT22ofM4Q8pXDDmlQaZZyikfdGOCQIERd8bcIbLo+voRrh1e40EYmyu+gOyQQZyMWRahYCAX9TCOQnTObX8JYeHvpGtrp05F9zqfNZpgkazNLjKB5QrnZ41OVrUw/XFTQ8g4R9a/XNQkWZr0kkSomCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=BAd1EBng; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=S5KYAfqt; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="BAd1EBng";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="S5KYAfqt"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 786596068D; Wed, 23 Apr 2025 23:02:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1745442123;
	bh=U6mHiAVlBrKayEMdAqUBFkPkm2rVLSbO0qLr9kMNgmM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BAd1EBngZjTFQdXKG1mf0e99IJBFfdIc7mZOQuN/oDBM/NvlycNPM6jyiBQTo26Xg
	 wilGFglqoLQPfIiKlYY/2wj5fNIhMWPLfNnb4UX9I3xN0SlWS/Ol44wdjhnzR93r6T
	 qnCmvasMvnn7tIgSZm5dxuQ5VHFQr0lbdrP3Fc9owxr0oyDFbl/Lv9yfgs5p5gJqgM
	 C+ck43aK1i2+hGYXZ//Tey5OxtgedgbNsz4+dB0w6HyB6hONGB33AXQmNqOtGNvVoQ
	 h940jpKV4sTEGPytL4dL1IfeWqg7hUUx9FoJlF/3ln0vQyvthbe9efUU2oW8jVEe/x
	 6hPFyidGMzUeQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 69D8F60614;
	Wed, 23 Apr 2025 23:02:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1745442121;
	bh=U6mHiAVlBrKayEMdAqUBFkPkm2rVLSbO0qLr9kMNgmM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=S5KYAfqtPU8EUYyvJMOUG9jp4ByyabH4zD8mBcMtXaradeIkxbtDQJrB7sw/lpPbt
	 pkKIQexK6HfbRu8wFMuTXeCaz+bBLfjPiQB652dS57mBuTafC0s7E3Z+coG+5Lyxqi
	 fUQZNzI5HkKhvWu0VikBbsMBME/wpKi3j2PFOw+RCn2WQ34u0SJodFTxFQmMyCvorY
	 U37f8sAGTuDl34N43jCDwYo8CW5kom02XLsJL1tcM6LKugJB2tA9vJk5gEVk6ArCNd
	 axKCpHvB1eRs/FkPn/nazFQO0wEsBQbuFx4zp+XDoIP2fr4lKbvqYMM0j1x43K4h3B
	 EtoObU34J3MLQ==
Date: Wed, 23 Apr 2025 23:01:58 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org,
	davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com,
	edumazet@google.com, horms@kernel.org
Subject: Re: [PATCH net-next 4/7] netfilter: Exclude LEGACY TABLES on
 PREEMPT_RT.
Message-ID: <aAlVRq-ol-3jj1ml@calendula>
References: <20250422202327.271536-1-pablo@netfilter.org>
 <20250422202327.271536-5-pablo@netfilter.org>
 <20250423070002.3dde704e@kernel.org>
 <20250423140654.GD7371@breakpoint.cc>
 <20250423144914.GA7214@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250423144914.GA7214@breakpoint.cc>

Hi Florian,

On Wed, Apr 23, 2025 at 04:49:14PM +0200, Florian Westphal wrote:
> Florian Westphal <fw@strlen.de> wrote:
> > I can have a look, likely there needs to a a patch before this one
> > that adds a few explicit CONFIG_ entries rather than replying on
> > implicit =y|m.
> 
> Pablo, whats the test suite expectation?
> 
> The netfilter tests pass when iptables is iptables-nft, but not
> when iptables is iptables-legacy.
> 
> I can either patch them and replace iptables with iptables-nft
> everywhere or I an update config so that iptables-legacy works too.
> 
> Unless you feel different, I will go with b) and add the needed
> legacy config options.

b) is fine with me.

> net tests are a different issue, they fail regardless of iptables-nft or
> legacy, looking at that now.

Thanks.
