Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BECE124C078;
	Thu,  3 Apr 2025 10:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743676454; cv=none; b=Wgf5e/zMD4P8XdgIJGrDF43ihroFVcGoW/4zW74qrzcuqOo45cvN9rMmtGO6FPvCcxkoVV9CzUxf0evFgCGJEQOidt1kVkM6PhvYMyvWBFNz6Wt/CkyBqBYN53ONFRhESeaFtyq5wNClJelQVWeN2/0yh3UyaaeNNKnW9wyFxpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743676454; c=relaxed/simple;
	bh=DPP8W/HPHLG7lvmuqYhxkh58vK8aF2b0xrPooCFLdV4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fD4OJFY824qySoO3aX8BbzGQZnra3bs4/Da/vCJ1R9eXdz8oXDVzvwfmZbkylA+7V85VrPu8ui7frVBcGmrjjAjlmtDY2CwhgdEaTV/ygVjnsMoxhVm8/i0F2kQAawt+ukUpxs8CPUX6rndbNK91sQVBioX9UlQeBoCRb6VN91g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=TlsREyhO; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=SKbK6iIX; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="TlsREyhO";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="SKbK6iIX"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 711C8603AB; Thu,  3 Apr 2025 12:34:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743676448;
	bh=54NhJIekLwHmn1Es2Bw5aVFGwhGAXAW0gICFaHMQsDk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TlsREyhOtN/USPa6s0UzDtONgWJokZEigkFmw/Qq/xb9alpo0ZLXBnrr/jm2lQDEc
	 vmufUfdOLHfw5HNSXu/L3p4LSsShMPiPRokETNpmtFsG/OW3BpLBqx1U1E8x7ZGtSi
	 gxoeLgffZgGYWxWajhseRpT6mm8bifGdzP8l4FtzEvdez0H21szruS0azNn6QY3DNA
	 Uytgn5yQatieyIzJC7QoDg7RdX//+4AdkrirEJdMj2RuuHrtqoSYg6R+hyWKIu1jcN
	 BNu2cR4bH0c8WcfrCeoj5GEECXSK1luFgAXgRlVFGWpDiL+nsKjekBRHJuaygmPvXJ
	 VDS0fmAMtToSw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 5B784602E2;
	Thu,  3 Apr 2025 12:34:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743676446;
	bh=54NhJIekLwHmn1Es2Bw5aVFGwhGAXAW0gICFaHMQsDk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SKbK6iIXVF9nxjOE891B5Cy8IhmvVIDtYrdWX/hqxzjvhsOPfhnH3QGmZIUYCpnNQ
	 uCyhykUBHgxb4r+oO84vGNRcNdfvfcFPGUlMnYThzMg0Ka5K7nDS63jHXBv8YjF54a
	 z8oPGhl/lJThJthSeBEANgwp/rg7YEBBBWdYGOQRrlmuCY+6jI2ZAQPGHfsj/ZuMyy
	 ZURosXQogV1GTBuJzSevyw2bLxpRohRhJ7qpY6gBt87QuklWr3sweVGOm8IHL5Q9w2
	 /q2JlU+JmcEslPXAC+f7pz/2o5oSaoumBC0ky/ue5k95S3sDy3DeGlgb7BezR7dF79
	 44GR5LgSlJWLQ==
Date: Thu, 3 Apr 2025 12:34:04 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Lin Ma <linma@zju.edu.cn>
Cc: kadlec@netfilter.org, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
	lucien.xin@gmail.com, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH net] netfilter: nft_tunnel: fix geneve_opt type confusion
 addition
Message-ID: <Z-5kHCndEfGIWlBo@calendula>
References: <20250402170026.9696-1-linma@zju.edu.cn>
 <Z-2NkQkl18OSJJuG@calendula>
 <Z-2e1xaxEw3DSZjd@calendula>
 <860826b.13e51.195f93f43fb.Coremail.linma@zju.edu.cn>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <860826b.13e51.195f93f43fb.Coremail.linma@zju.edu.cn>

On Thu, Apr 03, 2025 at 09:23:47AM +0800, Lin Ma wrote:
> Hi Pablo,
> 
> > > 
> > > Patch LGTM, I can take it through nf.git, I am preparing a pull
> > > request now.
> > 
> > Actually, this chunk is missing in this patch:
> > 
> 
> Nice catch, so this confusion pointer addition leads to an out-of-bounds
> read either.
> 
> Sent a new patch to include this spot.

I will take care of this patch through nf.git.

I am going to make a few more tests, I will get back to you.
