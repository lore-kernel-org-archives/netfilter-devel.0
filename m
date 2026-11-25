Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=156.67.10.101
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795641363;
	b=0bph/5rQmC8yOpRXBIALeZMkoEkQYv/UR6d380b02G3eprarO8HVqR+jx7t5mWXMeHNK
	 S6Y4AG3ZcHp5GyrcKlUqQnQANcmSM7u/gkL8yTWADWpu+7vkKcA5z3cA0+82gEuUS3wqC
	 vP6kQeQcuB/3KWeh7gw3n9Ra9VHSzs4RyGQp/BX4ZhzSlsT1xLvskn0EVw1Zxc1wOJhB3
	 8Gvb3rrchCWUf/UkC8UmRoUicoeCkotnqobYUBOInHEZBD88JzH9gG3JnkTcWSlzs7k2L
	 AQxjhkmS/kHZ2/YKFR505WmZc/9HxZj32Co6FepWP8/4XwvgZoQlM36pXNIk6Cybupw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795641363;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=2BEKaTve0j9tQYjMUbUV4dUCu3Ld1ARa8Kk+N3aaIok=;
	b=x5lqHcXavPuiHZsqgs6nuQdt5bEj+uQrqtLjpuCVdqFe3dVqj39qVQyI764rORikWkaB
	 cO4FiJT5XxZGGbODX8fMrx0xuXxNnLYz+AqTTid4LIcdxeVQ6zKsxEdcwj8QLEV6U9QNk
	 Jh78Gvbi5OG1EvBhDWBBp92P3mmiAcSQNr2qzX8f6F/VUpkY+fkqsYCYzjdwrO+Fl6G8c
	 T5tsGFbIgbacnhtbFZF2h07Y1rxWex5QO/31ZQWhsZbnoZ2OWU/w5YWR/J8NC6V0riUE0
	 4v/Zcn898Cxn4Uj0rW4SZs2bEnhZMC0tzxZEOCyWVUb/mAkJSVFBH3Ijkhv6UdbhM0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lunn.ch;
	spf=pass smtp.mailfrom=lunn.ch;
	dkim=pass header.d=lunn.ch header.i=@lunn.ch header.a=rsa-sha256 header.s=20171124 header.b="xlOX/SZg";
	arc=none smtp.remote-ip=156.67.10.101
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F53606A321;
	Wed, 25 Nov 2026 21:16:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 41F53606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lunn.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.a=rsa-sha256 header.s=20171124 header.b=xlOX/SZg
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=2BEKaTve0j9tQYjMUbUV4dUCu3Ld1ARa8Kk+N3aaIok=; b=xlOX/SZgDWek5IKkVtKOCVCqfP
	tZ+D943IqZYWTMtiUO04zSMB4/rp2vZZbpQx8eGpDdWilQmUJfF6xGAOdD6cZ4dikHRhNkUA1nazK
	BJp3w08UjmyPyRrUdugzfHcGEqutw6Cc5BERYyFaARElq4LeUPP2oH/2DIOjhwdRiGRw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1xWKLA-001RD5-O1; Wed, 25 Nov 2026 22:15:44 +0100
Date: Wed, 25 Nov 2026 22:15:44 +0100
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
Subject: Re: [PATCH RFC net-next 2/7] net: dsa: add a QCA four-byte CPU tagger
Message-ID: <71917772-9db5-4ed7-8c23-c0ca6574a64d@lunn.ch>
References: <20261125-almondplus-offload-rfc-v1-0-703175c6340c@gmail.com>
 <20261125-almondplus-offload-rfc-v1-2-703175c6340c@gmail.com>
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
In-Reply-To: <20261125-almondplus-offload-rfc-v1-2-703175c6340c@gmail.com>

>  #define dsa_lags_foreach_id(_id, _dst)				\
>  	for ((_id) = 1; (_id) <= (_dst)->lags_len; (_id)++)	\
>  		if ((_dst)->lags[(_id) - 1])
> -
>  #define dsa_lag_foreach_port(_dp, _dst, _lag)			\
>  	list_for_each_entry((_dp), &(_dst)->ports, list)	\
>  		if (dsa_port_offloads_lag((_dp), (_lag)))
> -
>  #define dsa_hsr_foreach_port(_dp, _ds, _hsr)			\
>  	list_for_each_entry((_dp), &(_ds)->dst->ports, list)	\
>  		if ((_dp)->ds == (_ds) && (_dp)->hsr_dev == (_hsr))
> -
>  static inline struct dsa_lag *dsa_lag_by_id(struct dsa_switch_tree *dst,
>  					    unsigned int id)

Did you review your own patches?

	Andrew
