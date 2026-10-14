Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB09421A17;
	Wed, 14 Oct 2026 11:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791977526; cv=none; b=ATWOHSe9IJhLWz7EkFvBpp2DnHKYI7QuJBcgNDCcd8BoJBcIGlWaRBm9f+L/lJPY3aUM/88mUTUeE/CT7r4Vys2224BiGsXwl1yRQuqOsY+tNYxycXcCvSzvvJARz2UTI72T+VrkmC83IrvoRGkeegBKB3pZ7P9lq8IiG3KwBvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791977526; c=relaxed/simple;
	bh=+Rd5k+d13nleyW2dzkgfnCGEXri5yUU/WTAwy2Lxk2M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iV/SYwwxc6XgTQPe46tM6dXo5zYJtSaXrQCF0M8uH9sWoFGjhZ0XDLx/hm8+7p0CnexE/jAq+Dx/DJ2Va3Pea1yVrYnNwrVzpP2AEG6sa6rMhJ+ewQ1C2zoBWPlKoZjQTXEYDo7jKCdqTvt4pOyIJIm+VDJN3KFM3Ublj1e5SWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=d+1Lb6fi; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="d+1Lb6fi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1791977520;
	bh=aLvuCbFsYXaoGkViCDmKwfxKvrW9hK/F/IhTbSlZYgM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d+1Lb6firUfBIBI+Pn4XWTV90icvi78FD2kJofvAzpttSrPjknK6Y3bD5oj9uocey
	 4UMTBVl0+svG+1DqLWwQ7pkibdqmvqwn8B8yBzHXszpobTzMgfY08i8kUfjvZJuzUR
	 aYN3I9rSKjLEiz9s6VYbRcmT9Eyc5kYvK+BfHWL3aiyO4gZu5ECjWiGFp7dENLt/q3
	 LOURBrzGbwHJpFrOgH3x5CCD5bHHDHRVuPE5J5rQBIA3QMqPJjNDJf9lpdXR9srTk6
	 C5C/AkhNUQwjrDMPr55NUavduigOsbbWDUFRX0h+a86r6SPjS0VX68KAsV797lUj7C
	 wf9ZiUOOaT+Cg==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 9E58060052;
	Wed, 14 Oct 2026 13:32:00 +0200 (CEST)
Date: Wed, 14 Oct 2026 13:31:57 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	edumazet@kernel.org, horms@kernel.org, ja@ssi.bg,
	lorenzo@kernel.org
Subject: Re: [PATCH net-next 00/15] Netfilter/IPVS updates for net-next
Message-ID: <as9oLQv_bFIl5Q9Q@chamomile>
References: <20261011215953.1334630-1-pablo@netfilter.org>
 <as66prsWCk1qlQpm@chamomile>
 <as9dKnQPk5xy92M8@strlen.de>
 <as9mQmF9Owtv9r36@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <as9mQmF9Owtv9r36@strlen.de>

On Wed, Oct 14, 2026 at 01:23:46PM +0200, Florian Westphal wrote:
> Florian Westphal <fw@strlen.de> wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > sashiko reports:
> > > 
> > > "If an IPv4 packet from an AF_INET socket is encapsulated by an IPv6 tunnel,
> > > the tunnel preserves the AF_INET socket in skb->sk while transmitting the
> > > outer IPv6 packet on the LOCAL_OUT path."
> > > 
> > > This sounds like an unrelated issue, I don't know yet how that can
> > > happen TBH.
> > 
> > I'm stupid and I don't understand why this would be a regression.
> > 
> > This change makes things stricter, so it doesn't enable anything that
> > wasn't allowed before, how does this add a new crash regression? :-(
> 
> Please toss this patch. Lets ignore this problem.

I really think LLM is just getting confused, because the series
contains flowtable support for IPv4-over-IPv6 and vice-versa.

Then, the LLM tries to find the same pattern in the patches coming in
this PR batch !:-D
