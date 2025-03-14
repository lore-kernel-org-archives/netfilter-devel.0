Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B6561FF613;
	Fri, 14 Mar 2025 12:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741955886; cv=none; b=SBhIWwR/oJNhDIvwcWh/LkpbqEiGrUENxe5P9Ntw00hr9a+4Ppl4oU7qax25mWoBVhaq6lKIEVfCfOTMD1kxdeo9PQRD5gxvk4YwKC2namDFkLTXk45UOE1HJa6B1HL9Oe50Ny7Aj1TH0kKSnhUL8jEU4CxlKXUDveq4nqK+2Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741955886; c=relaxed/simple;
	bh=p9mM05uTuuSxp/itWQ1aYr7D/Kek2qjOInkizONDbWo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QxIVw0mOjzlndXMK6hNiB5WuueZ2lIsdmInqjKIh9Bq3Tt7wn7zjJLim7AYDc4iQdr6R+ruN3JQUyS2RgOKNKvQ35xJFb3mvNyY/hBfyWUNcZePZ4VB5NoJtpDak7imQfLwVHlG8U6cHkjYsqCS6ahcPPOtnSznz/HfqxkRB7Do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=KOe75BT5; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=GSRWPm72; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="KOe75BT5";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="GSRWPm72"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 30568603C7; Fri, 14 Mar 2025 13:37:52 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741955872;
	bh=rPmJhpBheVqSUhPhE5IrqXg0aOCdmG4JQWmir+xGcw0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KOe75BT5fdnVHqcLuHnE+/zbg0SqDkpt1vfmqUe9yn1VV6HS8oANUox2ECks/ogIY
	 EeLVs1iaZfaFreMKCYahqzFQX6UgjLAZf2QfbWhtfEDUXQBt8hE3ir6e3Xh6BHGjIw
	 ChuJ1sV/aHOMZvjZvfmxgfW53YS1rPIdOZOnF5YVPpsvOlVZR5xyFVZh4Olt2gNTKF
	 gE09asYyfShSEwkMudB9qoX4KPV7wsRRTxn/QPiBDLlG1uXVAAeZEjr+2VO9u+rmP3
	 QpuagjteSJVQj35cv33ria3JWbJbntOyQKoF+sDIr1CXVS0dN8PBmF26uGX05XoQ5P
	 xqgrOCHGtAykg==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 94C35603BE;
	Fri, 14 Mar 2025 13:37:46 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741955866;
	bh=rPmJhpBheVqSUhPhE5IrqXg0aOCdmG4JQWmir+xGcw0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GSRWPm72uFyqXTyUIJzzcpsMAUkh40VOnAyEcDD7VyG9eADghYPABLGJQdrSQUmwp
	 ADzLKsqM/OgNyItHC69MGJkQMY9vFkOIUWclF/hPBeKglTj3RXqIqewOnLmq+PRo5T
	 wjdPi1wutXLVs+jy6NHGkOQEk4SHS/ftJBZporkZBy527X5e0XMXYM6LO/tD+9fKvu
	 F8vQ+5giSRhYXullElHg/Tqy98titObJDDwX9UcKwlJBqw8xzb4xomAVpVz7rskQ7K
	 C+YlaTlzzdrM+cysMJNyirwtjrLw3dDIGKi0pAraMhKV0pHJ70SUuYzFCESM0rIWNj
	 MBwY2wueKzqNQ==
Date: Fri, 14 Mar 2025 13:37:43 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Eric Woudstra <ericwouds@gmail.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Roopa Prabhu <roopa@nvidia.com>, Ivan Vecera <ivecera@redhat.com>,
	Jiri Pirko <jiri@resnulli.us>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Simon Horman <horms@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Andrew Lunn <andrew+netdev@lunn.ch>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, bridge@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org, linux-hardening@vger.kernel.org,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Ahmed Zaki <ahmed.zaki@intel.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	Frank Wunderlich <frank-w@public-files.de>,
	Daniel Golle <daniel@makrotopia.org>
Subject: Re: [PATCH v9 nf 00/15] bridge-fastpath and related improvements
Message-ID: <Z9QjF5LhavodVA4Y@calendula>
References: <20250305102949.16370-1-ericwouds@gmail.com>
 <897ade0e-a4d0-47d0-8bf7-e5888ef45a61@gmail.com>
 <Z9DKxOnxr1fSv0On@calendula>
 <58cbe875-80e7-4a44-950b-b836b97f3259@gmail.com>
 <Z9IUrL0IHTKQMUvC@calendula>
 <02b97708-1214-4fa4-a011-70388cff8f79@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <02b97708-1214-4fa4-a011-70388cff8f79@gmail.com>

On Thu, Mar 13, 2025 at 07:01:38PM +0100, Eric Woudstra wrote:
> 
> 
> On 3/13/25 12:11 AM, Pablo Neira Ayuso wrote:
> 
> >> What do you suggest?
> > 
> > Probably I can collect 4/15 and 5/15 from this series to be included
> > in the next pull request, let me take a look. But it would be good to
> > have tests for these two patches.
> > 
> 
> These are not most important to bridge-fastpath, but it gives extra
> possibilities. How about concentrating first on patch 2/15 (with 1/15
> removing a warning and 3/15 cleaning up), adding nf_flow_encap_push()
> for xmit direct? It is a vital patch for the bridge-fastpath.

I see cleanup patch 3/15 is a consequence of 2/15, let me take a look.

> Anyway, I will look into writing selftests for conntrack-bridge setup,
> including various vlan setups. This will take me some time, which I
> do not have in abundance, so for that I do not know if I get it done
> before the merge window.

There is tools/testing/selftests/net/netfilter/nft_flowtable.sh that
can possibly be extended to improve coverage.

Thanks.
