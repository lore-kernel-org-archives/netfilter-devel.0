Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792570103;
	b=fYIt6HcPIVyjdH0ZpuKDKoH+JW05IV3ifgSQxP2P8SaL6M81U4yb15SAQxvJC7VOAJ5n
	 I7OCehFU7Xl8y5GrwtMqK7NJumkp4T3ewrGPNSIlMaSp9VD31CdL7VbgR5vh7CFQSqXvT
	 8wjWsfCpJheuzK1M4dUOiiDt1LAL/65SuS1fqUZe/z9wL9qyMBIwbTQXtmrfDwChmoVWt
	 MVARichrhx/Gef9BUspSiIVFt4Ky+c6j3K6lGnzmZV3VRIH4Q5w8tE5pKXiQSJ31uc+Y4
	 IUXuEpD2LzDi78Wrrct8eRiqmEaz8pUv9KwnDzVr0IiOQQrKCZs/KtCIWbxe7mIT/mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792570103;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=jRlkVzPhIpWcH/LgEeSy681BizNsmQx4hmGRTx+sp8U=;
	b=N/k0QdIKw/+R1+uxQ+SZl6WIQR3J4QbKGgyqwgsnlC6Is7N2eEAL4Rl3o+k2P1QrSIxz
	 0m0R1Id+A2Q/IpdmcJeImiH0VDH3JDi1Rhg6p6EBvKaDRFiIpR8xZ0zmv+q7ukT9BeWNZ
	 RVG0e4MYB/0wtJsOViN4s8JbA+aLmBnyDh3aJP8vAeMEfSHGJ0yenL1F1SoW7E42HT9jL
	 JyhnD2qMe2ycrdmJFzYYh8tdYIKynkseYC43tI8ywZFru8tyFWT7KjshoBqgIYx4awP8M
	 6Im7Fliq7xmZMnpQb33RVYN1kZEZFifyhutGodYXoJOQXYXCxGDpAPOZDlpemChzzog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=strlen.de;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80362606A319;
	Wed, 21 Oct 2026 08:08:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 80362606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 7380160460; Wed, 21 Oct 2026 10:08:20 +0200 (CEST)
Date: Wed, 21 Oct 2026 10:08:20 +0200
From: Florian Westphal <fw@strlen.de>
To: Julius Bairaktaris <julius@bairaktaris.de>
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org, phil@nwl.cc,
	coreteam@netfilter.org, netdev@vger.kernel.org, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	horms@kernel.org, andrew+netdev@lunn.ch, shuah@kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	nbd@nbd.name
Subject: Re: [PATCH nf-next 2/3] netfilter: flowtable: update upper device
 stats in the fast path
Message-ID: <athy9HUHBPfCBKu6@strlen.de>
References: <atQmpPlfT_DSd9dq@chamomile>
 <20261018025319.1445197-1-julius@bairaktaris.de>
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
In-Reply-To: <20261018025319.1445197-1-julius@bairaktaris.de>

Julius Bairaktaris <julius@bairaktaris.de> wrote:
> On Sun, Oct 18, 2026 at 03:53:40AM +0200, Pablo Neira Ayuso wrote:
> > I mentioned it is a feature that these counters are not bumped,
> > because packets are not passing through this devices in the bypass.
> >
> > This allows users to see what packets follow classic path?

+1

> OpenWrt users report it as a bug. On my router a 268 MB download moved
> 0.15 MB on br-lan, while the port below it counted all of it.

Whats your plan when users report the proposed new behaviour (always
account to the virtual parent device) as a bug?

Conceptually, with flowtable, offloaded packets bypass that device entirely
and therefore should not touch stats of the virtual device.  At least
thats how I'd expect it to behave.
