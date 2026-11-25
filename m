Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=156.67.10.101
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795641065;
	b=Tmk0NrG87v1NBQLmg7Q+dcrBcCt17gleiTDsbmroe31TJUC6+/PAfEtxusctFU7ECjb8
	 sfZXktff1W1aTI2TO6FmH9OY0JCUt4V4MRheDpIlPOlC7Bsj+b7hASBB+oTknjRh486JL
	 41d6nA/gmiaLIWNMiiy/aK+VGOjl+0iRyhhHdhVti2lK4njmXNaKcdEiT3kaLEmJ1OKLO
	 LVeMXUWiq3v8D7a5B8X0SPoGnIrDYhSQQXf/7K979IouVEZ9PifwKD5j1dGbw689TfzEi
	 6Sv0nd1s5rvZIfi/rnZA7q5K1+Fba2tI6PLj9GgXopeJ3tE/IM1Q5KX1t/2OZE7INKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795641065;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=2TMaY06QCdoxAv25NeIIrFHhhOR306YESTNsCHEfZAw=;
	b=0L69gE3C/aW67zaFG8QpfVhI4RgN/jWHSYZd+BVV6nUVGdcGcw01M+pmTCKeOV86aFlJ
	 tYDgB7OYyDGQ/s939LrIgZGwvfa6urr1G3aWtSwGwCU/yplfQxLXKp7NFAqpYZ6GgszLo
	 oAImsE410EbKyEaFK9TlFtePLHPShow3gRgJnlAaEy0ebxRSCEzoIYFqQK72kuihTubLA
	 oEQBF3CR+mRes68MB1YWIbRd099zs+8QPmpoz28DH+OpDP8Yj/aU/GpaJSlEp4M1uR4ii
	 fXrLr79UfgfLrRZhJorYVZJow2afAcBC+BAxX31PV5CG568fPkFM7nzgbT0kcy9hkHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lunn.ch;
	spf=pass smtp.mailfrom=lunn.ch;
	dkim=pass header.d=lunn.ch header.i=@lunn.ch header.a=rsa-sha256 header.s=20171124 header.b=5Zs8BuVC;
	arc=none smtp.remote-ip=156.67.10.101
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E403B606A321;
	Wed, 25 Nov 2026 21:11:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E403B606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lunn.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.a=rsa-sha256 header.s=20171124 header.b=5Zs8BuVC
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=2TMaY06QCdoxAv25NeIIrFHhhOR306YESTNsCHEfZAw=; b=5Zs8BuVC/5OjpGsjRwXsgtqpYr
	6z4DN5q6hY+dVWrN9y2aODEWFZESULHf4TEME9L2UzyryQ04F/91PGJU80rQerwRjS4Gag35OsJfy
	8Ad+D7BIsqGh979V7kJmSvDiW3IPI20V+8ADCN+IngsRwGCx+gV338I/HMvVCCWGe08k=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1xWKG0-001R9X-9M; Wed, 25 Nov 2026 22:10:24 +0100
Date: Wed, 25 Nov 2026 22:10:24 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: filipp.dunsky@gmail.com
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
	Andrew Lunn <andrew+netdev@lunn.ch>,
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
Message-ID: <7252b836-e375-4550-90c9-b0e3ab7fbb6d@lunn.ch>
References: <20261125-almondplus-offload-rfc-v1-0-703175c6340c@gmail.com>
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
In-Reply-To: <20261125-almondplus-offload-rfc-v1-0-703175c6340c@gmail.com>

On Wed, Nov 25, 2026 at 11:50:28PM +0300, Fil Dunsky via B4 Relay wrote:
> This RFC connects the CS7542 forwarding engine to nftables hardware
> flowtables on Securifi Almond+. It is separate from the CPU Ethernet
> bring-up series. The main questions are the flowtable context interface,
> QCA four-byte CPU framing, and conservative hardware resource lifetime.

This is v2? Please include a version number in the subject line.

Please also list what changed relative to v1.

> - Is dsa-tag-protocol the right selection interface for this parser need?
> - What hardware drain evidence is needed before safely replacing different
>   result records or clearing the sticky HIT bitmap?

Is this a DSA switch?

DSA implies that there is a conduit interface which is used to pass
frames to a port of the switch. My first look at this driver did not
suggest that. It looked like there where a bunch of DMA channels, not
a full network interface?

I will look at the code again, but you should decide this quickly, the
different between a pure switchdev driver and a DSA driver is quite
big.

	Andrew
