Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2AF3EC826;
	Fri, 31 Jul 2026 11:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785496313; cv=none; b=H6NThRiVLGQIbxp5nV7K6Rlc44G2n/Ed6CS+K3ZbmVJy4zlRBy7rpXsx+q2Nx1pWhb4om/TcK3t08etOkc2okBPMQ7kauLwMh1F3dXzu5Bt8zVpeU/MqxH5z+D42HTObJQ1bFfxrLMNjMXO9RNOzTV9kKbCD7xd+ycGmb58ZrU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785496313; c=relaxed/simple;
	bh=Auw2P0J9+emhjgiiwoxp7bzIqz2++g6QOcuoL1lveAo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QNJzHxi4iwXZh1bZeXI/LVzqu6Bkv1r++EOGIHNGR2JJ7NpcdzTpj6ZO+XrF1R3rK84zkhHBaqYO6Qq8tBJbjcMNxZAdVxNu6yn3vSJ8JFZaI9utVCUyuPGZVvTE2E6/7t9uF3M7biWc8Fce3N7tNR0i2kpAtN+/ZGNx5AncqM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=piReGj0a; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="piReGj0a"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id B2C6D60191;
	Fri, 31 Jul 2026 13:11:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785496306;
	bh=9U9FfvI2ryf0CWlknOk41GaM3NtEl+Zgx72Bzv9RWLY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=piReGj0atUe7Mt3GRrZYOlQjoK84c50uRsQjw9SUikvkVhwotsJrFWb2pHKAnc5x0
	 4hoBR2123XGJIUhg+W5WC6/WIgPzBdpwunwCMeAMZsX7W9tDO606tOYKAaI78ov5y4
	 Z2zx/nF5I4ckTbrb7JWVH1Hvf/x3x6cDsjVxiEWEsOC1CQyM4aUp5g2Lw2rANHu0Eu
	 r3Scg7ZK7wNBFUGukROFChR87EA2bYhKCZbJjMAH6iL/i+b3bVBDUQa+bGHZGpFfym
	 USxpBhxBfiyqN8NRds8e7LVPLU+IN0h45CHMEozv9W4U4j6JSXQEumGUF2X2YRblvf
	 1tWSKsZQBR9sw==
Date: Fri, 31 Jul 2026 13:11:43 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Zhixing Chen <running910@gmail.com>
Cc: Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH nf v3] netfilter: ip6tables: set hotdrop for malformed
 extension header matches
Message-ID: <amyC7_3bbwJpXIPd@chamomile>
References: <20260724110111.18783-1-running910@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260724110111.18783-1-running910@gmail.com>

On Fri, Jul 24, 2026 at 07:01:11PM +0800, Zhixing Chen wrote:
> The hbh, srh and ipv6header matches have paths that return false for
> malformed IPv6 extension header packets without setting hotdrop.
> 
> For hbh, strict option parsing stops when the option type or length field
> cannot be read, or when advancing to the next requested option would
> exceed the available header data. Mark these packets for hotdrop instead
> of treating them as a rule mismatch.
> 
> For srh, keep a missing SRH as a normal mismatch, but set hotdrop when
> header lookup fails for other reasons, when the SRH fixed header is not
> present, when the advertised SRH length exceeds the available skb data,
> when segments_left exceeds first_segment, when the SID list implied by
> first_segment exceeds the advertised SRH length, or when SID selector
> reads fail.
> 
> For ipv6header, set hotdrop when the advertised extension header length
> exceeds the available skb data.
> 
> Returning false treats the packet as a rule mismatch. Set hotdrop for
> these malformed packets so they cannot bypass rules intended to drop
> packets with these IPv6 extension headers.

This patch should target nf-next, it does not fix any real crash.

There are also issues in this patch to be addressed, see:

https://sashiko.dev/#/patchset/20260724110111.18783-1-running910%40gmail.com
