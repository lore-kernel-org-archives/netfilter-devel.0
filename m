Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=156.67.10.101
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795644670;
	b=Solrdu0TDqx++mgGwLFzaRk1+7hgnp8VbIAj3nOy/Rua9Ey5muMumurN9WRZmRG9hk4A
	 /uiHopBKLM+OQ83KoYcCWV9fGSrbIoNt1aEKlQe8lR6EshFZk23HrIsLae74BHoeGsGAh
	 MpqaE0hIwigH9c3WAkCVxiW/9ThdP22mpWIiIhJhq6/ifGA5jXLqVVfsyBx8Isz9kXJYx
	 9w0efIJBH20y/b0SoWu8Q5apY6qe3SBKvJXcO3vvW5yR3V3tS/pd68cxjLbRGZGMvHNHp
	 YNQu3b+ZAownM5pnhL4quxltmsP4JDAMV5KMB4Y4bJqyW1pR1FPTH3DRk7lx3PD/LOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795644670;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=dbm1Ef+uitQ2LBt7Exj1+18hYcllnIQWCtcGXjjgdas=;
	b=zH9YNTRC3IogDW34RIFdvLg/cFFeYgE3yzc3MhvYr73OfArp23AYmT/lgkXVpBArdf4Z
	 HEe2gavpPdUzt1VBsvUBKM8bi/WvXSC9RWIgHxmDZZqzUkJehLmBDSVsLRk50c2BF8kiY
	 fHY2ue3FSdWWuLtcx1xbS+nyGnLxXPJXIvPjbA0w7Yv042ja/KApAhCR+Lkngwb1glcoX
	 YQfGImFq3S1uSu4wikJKiu7qynZc/Kt6egSFqhbWVkdy2NEtiNAulRcqcbFwjfkdpCJxH
	 GFXftyQxsoeQOnXnpGr8VdQAXBjbPBn5XIXk2Pjcy1Fq6EO/3dCLQTboFlnBTUM/u8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lunn.ch;
	spf=pass smtp.mailfrom=lunn.ch;
	dkim=pass header.d=lunn.ch header.i=@lunn.ch header.a=rsa-sha256 header.s=20171124 header.b=g0TvsH75;
	arc=none smtp.remote-ip=156.67.10.101
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D3FE606A323;
	Wed, 25 Nov 2026 22:11:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6D3FE606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lunn.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.a=rsa-sha256 header.s=20171124 header.b=g0TvsH75
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=dbm1Ef+uitQ2LBt7Exj1+18hYcllnIQWCtcGXjjgdas=; b=g0TvsH75io6D2rjeMbiqJT3nhj
	Fohp4Bf/fw24XeVl+aTtSQnnNXv6GkGzMxO1GR3Khppada1xBd51AEX4PkPJtK0+8yx5PGBPT9h1B
	qKYlx4kOLe34CGjmsr+GMcH4pNHXCcd6aMD1gdg6Gvng87+piaD6mpMyxoexv4TZQtU4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1xWLCW-001RjL-T9; Wed, 25 Nov 2026 23:10:52 +0100
Date: Wed, 25 Nov 2026 23:10:52 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Fil Dunsky <filipp.dunsky@gmail.com>
Cc: Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	Hans Ulli Kroll <ulli.kroll@googlemail.com>,
	Linus Walleij <linusw@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, netdev@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH RFC net-next 0/7] net: cortina: CS7542 wired IPv4
 hardware flowtable offload
Message-ID: <5e9d9808-3917-4706-889d-ae1c360155e3@lunn.ch>
References: <20261125-almondplus-offload-rfc-v1-0-703175c6340c@gmail.com>
 <7252b836-e375-4550-90c9-b0e3ab7fbb6d@lunn.ch>
 <179564372798.5.10006827612276789857@gmail.com>
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
In-Reply-To: <179564372798.5.10006827612276789857@gmail.com>

On Thu, Nov 26, 2026 at 12:55:27AM +0300, Fil Dunsky wrote:
> Hi Andrew,
> 
> This is the first standalone offload RFC, v1. The prerequisite CPU-only
> Ethernet series is v2; this RFC does not replace that series.

Ah.

One patchset at a time please. Get the basic Ethernet support working
first. Then start on the next topic.

       Andrew
