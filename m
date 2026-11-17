Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794920836;
	b=3CxUASKvEOBAOurC6qkcdJiWcK2bp8XChQX/UU3MpybIOZYSClDEIhcex5a6uyH5BzA5
	 zdiEK/guKogM9p9ElBVEq6BY1B7CLn7D+9HMpwATfWrFETgUNh+OszWfbecDgUegT+XCO
	 benAM92h4ihttbZ1ADbeijN0k3iGyDZhuM2iRdHkAiLdv60L/Okvclp7L2OdFjbJXZtw7
	 eOJFHb4HYhNhDICApkVNeQq1f3oq7m+3HVljXnuYsGMbn+lfGi7ek1CqwyC2Kg+Oe3ShL
	 AJC9awPr9bAowj2smoDZ2AMo6G9g6+GumPZ6DVp7zA5YJVtNxJlrLkr4b6TsVe0SUOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794920836;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=VTvJ8fbm85HVfJBXziSqvjffZDc8MVssUmhYbctDJqg=;
	b=Czcr+O5tHr49OCp4VJ1A9MoLt2JMQ4B83cE8SAIQLukUDMFuKgz6XM1PWPrv0DyjiNlj
	 0i6ptFRbaltAOX+8IvEhE8K/zhlJqaLzLsN76Zohi+IijL3Et78Eylu5uQ0UeeCHbhBhI
	 t0me3igBzYPV/KEsYjiSqU3c5ScwCVfTuYKDeN4KZ1isp6UQcPb8NkluRN0XSBdqP65WR
	 9KAxa3h7mwSOhmgmhBbsXM4SEw2S6/93uHl+K1tq5snvI/Q1iaZwCYmg/0uu1slwdUX6n
	 mTy/ZchfoW4JhqEHX4E5urqgzBvFYAQEszs+E0R34MbVVv50M/G31psa3aznjxGIp5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=ZKa+Q8ZP;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 67C7760A262D;
	Tue, 17 Nov 2026 13:07:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 67C7760A262D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=ZKa+Q8ZP
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794920833;
	bh=VTvJ8fbm85HVfJBXziSqvjffZDc8MVssUmhYbctDJqg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZKa+Q8ZPx/fRC7mdKXVGA3p0z3nXTnk8dSedZQdXYzDwsvI1ih2q6DrfrfM0Gr1HS
	 Mfyq/cMpym76A1fZYAIAExJCOzhMvTtVMBIhc13XPlz/qG8i4ktuyRslQI9Vl1bYTH
	 smxg84WMIhqbOi43CEvSvxGQlRaA7ZJ5r6eiX05yOD7h/7pAObH0+sVGBGFphth5YF
	 Dgj07RcTA2ENAo5FJjFOtHS22lXICsp2B6dPGAIXA4L9WcOw9MqmsQKydaV8p4z2RY
	 9QUcwcbrNA+QXYvqAZU2hyQRYncH1TTOoGq8ucIjvsGoV4Xpyw58c8UKRjT7al73hV
	 wEFWTG+iNpLDA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id CCC5660058;
	Tue, 17 Nov 2026 14:07:13 +0100 (CET)
Date: Tue, 17 Nov 2026 14:07:11 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Leonard Lausen <leonard@lausen.nl>
Cc: netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>, Shuah Khan <shuah@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v4 0/2] ipv6: Honor suppress_prefixlength in
 fib6_lookup()
Message-ID: <avxRfzsnke7VJq_w@chamomile>
References: <20261117110813.9894-2-leonard@lausen.nl>
 <avxPFYfEirXzTup8@chamomile>
 <94f4ea0e-c1bf-467c-94be-b65963410d30@lausen.nl>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <94f4ea0e-c1bf-467c-94be-b65963410d30@lausen.nl>

On Tue, Nov 17, 2026 at 02:01:24PM +0100, Leonard Lausen wrote:
> Am 17.11.26 um 13:56 schrieb Pablo Neira Ayuso:
> > On Tue, Nov 17, 2026 at 11:08:10AM +0000, Leonard Lausen wrote:
> > > This revision removes the cached-exception patch and its PMTU test, as
> > > requested. The series fixes the nftables regression introduced by
> > > 1c32b24c234b and leaves dst-based prefix suppression unchanged.
> > 
> > Is this a LLM finding? Or a real issue in production?
> 
> This is a real issue. Without the fix, Wireguard VPN does not work with
> IPv6_rpfilter=strict firewalld setting (default setting). See
> https://github.com/firewalld/firewalld/issues/1600

OK.

As Paolo suggests you explore fixing this from nft_fib itself,
please keep this link in the cover letter.

Thanks.
