Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795536313;
	b=vteSDSBbCRvLHbabfKXbiOx/PPctf9SUY6O1M6xHe4tzCaKbat+Tg1CAca8kW2MHuC70
	 FojY42ksOR+SDgoMLw8AJgIyhTBnis9TLePkJ9sclGMKKP2PNAZCy5mdeiINrawSaY19g
	 LH59DOlLxA5/AJPGzPVQZZkTiBpJaS7he+cAHpFssBdWWUOdn7V5KbfDScvFx8mlcTMb4
	 42OaUN7/tdPW2G9qxMTIb4a9+EH7+HDb+jFZFxDfis6dXzudLtKOrcOohxM22UHExCNR1
	 ZQ58sytM84+WekLWMsw+lzav3BmDNnLsiTDvnPMYOvFLRWV0wGnfprOUnTnvLHpWnvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795536313;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=emrl0duYDcaphXy/RQaekN2dxqyj1y98jLOwzTCOw4E=;
	b=mzW76hpUGk0UWeFSQCzMtIR5fTdpB+UDvvEn6nn8kkRhyZtJ1w4MajwMv2rFvpO8S2VP
	 JDsuW95LDTZYy9tZ/kSCzYnQPKiK8qWx8jADSOh/jj5LHSsC4ZrZs8oly4ia3vmLYjutv
	 dVf1nV1Og23L50N9hkxmZeZyZJQ86bVePTU2BX+K5OSJwU9ZfH0qv6LPmhRh0Oxp9Peys
	 b65lszfMFpLGlIcVy+1tWdlwidW8x0O1YeQjHciA3h7ObHyYl9X49eQJDMXUtKt8e1K3M
	 YlWQCiQBdck1iUbwzubXMA1TuSV9yOQX/tepf+iDtUQ3p+eNOz0HkFzh+KwGS/0/uHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=strlen.de;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB3AA606A31E;
	Tue, 24 Nov 2026 16:05:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EB3AA606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id DCF89602C0; Tue, 24 Nov 2026 17:05:09 +0100 (CET)
Date: Tue, 24 Nov 2026 17:04:51 +0100
From: Florian Westphal <fw@strlen.de>
To: Paolo Abeni <pabeni@redhat.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, edumazet@kernel.org,
	horms@kernel.org, ja@ssi.bg
Subject: Re: [PATCH net-next,v2 00/15] Netfilter updates for net-next
Message-ID: <awW1o1GghW3k_zOh@strlen.de>
References: <20261123135726.3940688-1-pablo@netfilter.org>
 <8e69f35e-73fb-4558-910b-45f5e723c64a@redhat.com>
 <awWEtyMI_-VEreFq@strlen.de>
 <e7a9c532-d063-4eb4-bbcb-39b4ef80a51a@redhat.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e7a9c532-d063-4eb4-bbcb-39b4ef80a51a@redhat.com>

Paolo Abeni <pabeni@redhat.com> wrote:
> The only delta I can see is that patches landing on netdev currently get
> clashiko review, which could (or could be not) a positive thing.
> 
> But in the long term we should have hopefully clashiko-like reviews
> everywhere.

I hope not, but its likely you are right.  Given I am dumb, I now
have 10+ AI "reviews" to sift through.

The only thing that clashiko does is to induce ever increasing suicidal
thoughts in me. This is unfortunately not a joke.  I am burning out
quickly and at this rate I will quit kernel development permanently
in may 2027.

Most of "my" patches are LLM generated, at least originally.

And they went through 20+ AI reviews with GML-5.3, sonnet5, and Opus 4.6
(thats how old this is originally).

And STILL the patches are shit.  And instead of actually doing
imrpovements I now need to first read thorugh walls of text to see
what is actually reasonable and what not.

@Pablo: resend without my patches, there is no way I can
send new versions anytime soon.
