Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9EA234CCE;
	Sun, 18 Oct 2026 01:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792286426; cv=none; b=kwBOUVVehF7o2K1Hvrxe4vnQODB9GFRUvGahMwrwjiuIRa1RaktyHzEhiK+OgRHiaMXjl7l4gSbHVloFH3iOqmEOQBMcnFQJVFEWqCsPx+B44VTrwifidySY9BCToD7+aYFIvlHcymruhxRqS31qWBoDXipy/c6WiYyscEhCgzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792286426; c=relaxed/simple;
	bh=mY1P0C+ZpSJp8pVEhOOdML2MsO2NfvIMDVYolEPNPQ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=novRdD7y389LE5U+8+33p3BUEhnwihUpeCkWin/9dL7k3oadKjJK2VDKbF5xW5tjFR9Pw8/CDL3Z/x31GNJJL/yr+3JRSfwORZOcgjHVJun9RlukYRrsmc+EIj1iMH9GHNiOFqEmSRum4q8WjnvS1t3tSaSxz2/6t+S+OJkW79o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=eVKDtClx; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="eVKDtClx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792286423;
	bh=GPoZaT6YsFzDPssQXPZRfja4iU6/mCrpYh+ETz23LlU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eVKDtClxNI+UxFUlyhtu5+DKCH3P3/iIEw+JgPI1FI+ntlnYs6eeBAjRJBV09Scgu
	 ehqXTuEFKINI5KTGS3mXp2SJId5bQyLd+zcOEqj6ilxBuklOmPQk6PdR58foNmKTfH
	 3mOUzTVcz45XWsehQhXkivRd/sNuF8AltF22qKH4mxIDhtXdEMVzk+Xo8rQ1SVwTsb
	 iTD8sKp5U23eWcbHaMfD3xtKqjYLcUv9Ei0Ak9SWK9QLo2rk1PK8Zqgt7Z4ZRyF4Rp
	 Zfua3H6+4aHyg+4S3R3Uw7RofBoOFVwH46hBupGVXIp5w8Udn8EvNYniJZeWKHanEi
	 uBfjavrDwgPzw==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 1CC1960052;
	Sun, 18 Oct 2026 03:20:23 +0200 (CEST)
Date: Sun, 18 Oct 2026 03:20:20 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netdev-bot+sinfo@kernel.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net-next 01/15] netfilter: disable br_netfilter in user
 namespaces
Message-ID: <atQe1GProMqSRp7O@chamomile>
References: <20261018005638.1776148-1-pablo@netfilter.org>
 <20261018005638.1776148-2-pablo@netfilter.org>
 <179228539733.3290.12913693558354504063@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <179228539733.3290.12913693558354504063@kernel.org>

Hi,

On Sun, Oct 18, 2026 at 01:03:17AM +0000, netdev-bot+sinfo@kernel.org wrote:
> Hi!
> 
> This is an automated message. This series looks like a fix, but its
> commit messages seem to be missing some information:
> 
>  - How the issue was discovered, e.g. hit in production, hit during
>    development, syzbot report, manual code inspection, LLM or static
>    analysis tool scan.
>
>  - Whether the issue was actually triggered, or is only theoretical
>    (e.g. found by code inspection). If it was triggered please include
>    the symptoms, like the stack trace or error messages.

Yes, this contains some low priority fixes as well as enhancements:

1) For the br_netfilter patch, existing limitations are known and
   issues keep popping from time to time, let's prepare for deprecation.

2) Found by Jakub in NIPA.

3) For the IPVS sync message overflow: found via manual code
   inspection. It is theoretical for modern kernels - the description
   notes it "can only happen in very old 2.6 kernels," so it was not
   triggered in any current production or test environment.

4 and 5) unclear if it was found in production, but it comes from
   third party software developer with realistic use-cases.

6) For the conntrack gc worker UaF: found via manual code inspection.
   It is described as "unlikely," so it is theoretical - not
   observed as a triggered crash or stack trace.

7) For the nf_tables chain types UaF on module removal: found via
   manual code inspection. The race window (module removal while RCU
   readers are active) makes it theoretical in practice; no stack trace
   or production report is referenced.

8 and 9) Simplify nft_exthdr tcp option parsing.

10) fixes a conntrack_vrf.sh selftest which has been seen to be
   reporting bogus issues.

11) was found via LLM that I am aware of.

12) is preparation work from Lorenzo Bianconi towards adding
    IPv4-over-IPv6 and vice-versa. 

This answer to this email has been assisted by LLM.

> Please do not repost the series just to address the above. Instead,
> reply to this email with the missing information, so that reviewers
> can take it into account. If the series needs another revision for
> other reasons, please include the information in the commit messages
> then.
> 
> The evaluation is done by an LLM so it may be wrong, if you think
> that is the case please reply and explain.
