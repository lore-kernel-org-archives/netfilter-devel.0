Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=156.67.10.101
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795641198;
	b=vfLDURH1rtZvXdQGQ+NCFs0emcdCRsemnzTBYwUyvvGZaE4yadqNQFNUi/y9r4nUYP1q
	 0/O8guKxoFJRarD7PK82QfqpVbcj1kwMWWzypFAaadtg0uc3ggnK34imDMGJpxMaqpapp
	 YytNx8YYMeunBKgSJfyLck/Eqh8u3PalO0HgGHPmmMa/fhDB5BhHpY45gHF8ixymcm+hh
	 5mX9DrcCk5iSJ5wfNC6hLKansu5hvk7/zYrNRHRCeyVE0pYIshrpUHKWXyQuSl0f28+K6
	 cX42RqdxCD5ajiGFLkPthqDh8X/oohcpQUOTazPdqcuFHDWC2BuiIZ97gjE7p5M750w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795641198;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=iGd5SoNcIdPRf+X5W5xhsxkWslmG4vdZNOWfyt5Bu4A=;
	b=1rPvYk76AZgwSUmIYf4AFAIn1g7YOvs3TT5+QUeuandUUp5gnCFsXqm5zKZIQ8c/Lz58
	 ZKi6src9RuPy5+CYzcbGzhnOmR4AohX6RhKAk/Ad63FUJ9YSQfJ3kWnQ2gNQA00Xu2Fer
	 TQ+Ix8znDtKmcK8W3jopJ3FioFIZovsmASRMXkY6kLPTNa5Hgq5vd9S6QzjLqM8KzfyT+
	 mwql+T3lwQukiCQaCHYMf0h2t0cDnFN9B5OGQwuTsIxxABcUoXISN9U5fpNwTCAFg4QnU
	 TBoUwUBSqRmOpHQwrRwObvcFC6CpmoU2KGBpD23gfgoxS7ZzPAPxDgBTcnuFlIXY2xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lunn.ch;
	spf=pass smtp.mailfrom=lunn.ch;
	dkim=pass header.d=lunn.ch header.i=@lunn.ch header.a=rsa-sha256 header.s=20171124 header.b=zAKRTYQ6;
	arc=none smtp.remote-ip=156.67.10.101
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5AC9606A31E;
	Wed, 25 Nov 2026 21:13:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C5AC9606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lunn.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.a=rsa-sha256 header.s=20171124 header.b=zAKRTYQ6
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=iGd5SoNcIdPRf+X5W5xhsxkWslmG4vdZNOWfyt5Bu4A=; b=zAKRTYQ6dAHp1kq+pIly9jqUl+
	mEfRqkks+O56nq3eMEHQc4ydoYu24dc1XcS/SZPd/jR8qtTbDI6QbV3uZG5uOLwn/s6jT1+L7wL+6
	vp0TrImF9NpiAGtTpQggHoMn0A+hGncgB3/nn/bIcLDyIHQSX4Bkger/UkLN9+zvnAsQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1xWKIZ-001RBD-5P; Wed, 25 Nov 2026 22:13:03 +0100
Date: Wed, 25 Nov 2026 22:13:03 +0100
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
Subject: Re: [PATCH RFC net-next 5/7] net: dsa: qca8k: select the four-byte
 format before port activation
Message-ID: <7feee622-0c4f-4c7c-a473-02e0bb5cbf10@lunn.ch>
References: <20261125-almondplus-offload-rfc-v1-0-703175c6340c@gmail.com>
 <20261125-almondplus-offload-rfc-v1-5-703175c6340c@gmail.com>
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
In-Reply-To: <20261125-almondplus-offload-rfc-v1-5-703175c6340c@gmail.com>

On Wed, Nov 25, 2026 at 11:50:33PM +0300, Fil Dunsky via B4 Relay wrote:
> From: Fil Dunsky <filipp.dunsky@gmail.com>
> 
> Select the requested format from the CPU ports before DSA chooses its
> tagger. Stop packet actors and verify the switch header state before
> opening user ports. Use MDIO for management and preserve both conduit
> MTUs.

Confused. What has the QCA driver got to do with this?

I think it is time for a big picture architecture email.

  Andrew
