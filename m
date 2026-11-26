Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795691411;
	b=dT1htpKkcGL+xGrTsiy0zcfZaDfI6vC7mVWNLBo8pJBA9beJbjhvjUhYA4MA0YxK45qr
	 x23r3nS2KtIrrNB/wGGpDF/Xit8m4SEzu5MzO1sAzAS83m+CoObpYwYBtiJiS1kRgRZjl
	 DZCvhnWNhlx7A2ARZWx58t+cMuMb4vqU8dU2aAnSFsD4kvJZnfJSb0HyGqXikSBybTWeZ
	 06oJik5kpsZ5BNo7ZEoTWdb5I780QNOarRc4sZ6hmDS6NcMKwjAvJNjyBxTf74U/cvMP6
	 HkrT2qsa5hd6xup3wSjpVEgIQWqU9lEKCpRchOvEHoFPqRqHcv9T3hP2LfL8Zl9tTQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795691411;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=XrlvbvUtWGrgjIrfZnmq9pqZFdssQM1zA8Zz/H0TqGE=;
	b=5qjoGYOo3nN5mWYLI9MGDvwTf65A5PrYo3XwUsq6HQH0lnYfQkJNqw0RKrgXQZnvdStb
	 LGy299QI/mdTJEzBa0Wk6X5d+ZXRPv05laSDl3fqFnClz44xp13OjRUKth7kblsU9uFSV
	 r4ZNy7kFfvObWAoOBNL7XRV8wU8mbzrBP/e0fCasb6wJPjEmf1N3pbc5EQunuomLDa5Kr
	 yvJ0BH+BJQPZJD1m+hlFw0Q/yRQsTXQJqi3CjW5h3+Uq5AHXa/RpcdCxDw406soFYKWD1
	 6RWdIKOHwOrqa3S/dDaduvxI3Prl04m4DKX180pdzpZbnWfDjLtsJcuJLeOYKNh/8zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=h+rusEt0;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id CF301606A31C;
	Thu, 26 Nov 2026 11:10:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CF301606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=h+rusEt0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795691408;
	bh=XrlvbvUtWGrgjIrfZnmq9pqZFdssQM1zA8Zz/H0TqGE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=h+rusEt0UP3uR0jv+ejap0jCujYotA2F1mTCfsDNaAvuunplluWI9UurGKjoycRLP
	 3ZRI9wLeFdXR8ueM7epi7dlzII2VODGk8kqgbYoo0MDIr33dWGGd5iVSlZlodtpzNg
	 uSFH5QbnFeDh3dy36RGkCFL0moTfRnbUrls5+4Ys24mCvZLKzYy1cFLA+SwTsgyoPM
	 3xdkEb/GfHxhACq5JSQ6Z0RY6OqgiNl7OdD7AcRNNPSJrczGyYwGpXk7+XxeOb3DfA
	 e2vqF0wn7c8Pe6lns6AcYTaJwI/eVK/8X9qvz45VjsaDCR84WqhdGPiX9D4KH0g04K
	 wP2qZi4dSx0UA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 4CE216007A;
	Thu, 26 Nov 2026 12:10:08 +0100 (CET)
Date: Thu, 26 Nov 2026 12:10:06 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Paolo Abeni <pabeni@redhat.com>, netfilter-devel@vger.kernel.org,
	davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
	edumazet@kernel.org, horms@kernel.org, ja@ssi.bg
Subject: Re: [PATCH net-next,v2 00/15] Netfilter updates for net-next
Message-ID: <awgTju-m6SIP0Rjt@chamomile>
References: <20261123135726.3940688-1-pablo@netfilter.org>
 <8e69f35e-73fb-4558-910b-45f5e723c64a@redhat.com>
 <awWSHujeBmMMOonS@chamomile>
 <f0a3c071-0142-4c62-b74b-ffff8121c8d9@redhat.com>
 <awgOALX8V2RXY-uH@chamomile>
 <awgQzu0CiaMHAzzw@strlen.de>
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
In-Reply-To: <awgQzu0CiaMHAzzw@strlen.de>

On Thu, Nov 26, 2026 at 11:58:22AM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > My plan is to keep the ipset rhashtable in place, I think some of the
> > relevant comments in the reports can be addressed by follow up
> > patches.
> 
> They fail the new test case I posted a few hours ago
> (passes with net:main / old code).
> 
> Its yet another corner case not written down anywhere
> or tested so far.
> 
> I can post a delta later as followup if you prefer.

Yes, I think delta follow up describing the corner case scenario
should be just fine.

Thanks.
