Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5CAD27E066;
	Wed, 24 Sep 2025 22:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758754278; cv=none; b=OeoAxb1g+1PC3icPJhZ51DZerxtIUysYXaE+YMjn9lmBV1Ax36Q/hV2zdzbiylHY1LMqcJUb5JX98H0abowXWdA9ACh/rypDlKBQbIbtivJnYY92FozBWjm8wF3IqBanMnwE8OtyUjdPv6Gl3aq03ZV8zUcSUnta1uOg7IbJSEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758754278; c=relaxed/simple;
	bh=h83iygs2s9Ldl3h7B7pFWbWQJHVrhWeWQeGcW05NHaE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qTDQEJnJ/ZhwUlF8fnaHor9jf8aZ3+wu0L0P2MRB7GS18SvjHXKmYPu373OJHSelIxtNJmt2BamzLFfptt0i3HSXEQgVv/yuIPeeuCfAZNVV2TMjHvyz/5FqZicwzHL4gMSFTj6LHLxbCImbJ8NA6kE12EbrkrIy0XINNRbg4NI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=LvTaCmAj; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=DOI+ZmiX; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="LvTaCmAj";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="DOI+ZmiX"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 1E82360279; Thu, 25 Sep 2025 00:51:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1758754273;
	bh=9wVF5HzDtmu1OxUD7YMD/AGvt/7TIpkUXfx7yqLSTbc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LvTaCmAjq+XGwhNuFsAfAv7lWiQ6oG2RXVnEyXkyZFg5/ZzGs/p+9dHqSLbYDe8W3
	 Jh8W7lZmc/cjp3KQ0wuI6lOmZZeXlpf2nNP66MffMQtqHn7UdYTQzZz6akuteE3xk3
	 OnZURmegY3v49GsdfhOmSpYEu9Yl1vXIh92yNNu9AA5UEuqEZ+3gRsyzieS/xMja96
	 3mFF3nof5Vrlejd0jnpYwyccDP+k5RPmMEbx9wPq8rvaKiKsj47g2fV0q26BJyuTlJ
	 X/NyIHOZhGXzfEmfZZYH7eB4JkrSe9avi4xszWk+Br6EWjSn8qE2+ZfvAN7N/aADFn
	 OnByCDX6OnY+A==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D72BF60262;
	Thu, 25 Sep 2025 00:51:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1758754269;
	bh=9wVF5HzDtmu1OxUD7YMD/AGvt/7TIpkUXfx7yqLSTbc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DOI+ZmiXU3AkYTL0/N3fDBqzp70sfzB1ct7EQFd+i7h6tZrmN8D4kyDd0NlgbqESh
	 6uLXMijdd9xW8CdWfmN3UupoXwDDebrQ/7Xstu1eXta2+WTgYT7gt27GTHbJRuqxIF
	 KN/jEKI5ps5Eb2CMVNufIPJktFqR3h5lkKE7dn5x6EqYqQYSCuBuazD0oIMWQpAibG
	 SvQhTtk/Blvtv9IhLV5wD/M2ftmg0VX4bWxYN++uFj/5WlDiw3FHIPb0zVjTONYbBp
	 Lizek8QtZ0jYOHxE6rgXlpUSxzqY0LXu9+m9zQwVo7EmJgvl1ffEL+fTwL3xRca+o1
	 dWxG0YXogPJfg==
Date: Thu, 25 Sep 2025 00:51:07 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Elad Yifee <eladwf@gmail.com>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next RFC] netfilter: flowtable: add CT metadata
 action for nft flowtables
Message-ID: <aNR12z5OQzsC0yKl@calendula>
References: <20250912163043.329233-1-eladwf@gmail.com>
 <CA+SN3sp6ZidPXhZnP0E4KQyt95pp_-M9h2MMwLozObp9JH-8LQ@mail.gmail.com>
 <aMnnKsqCGw5JFVrD@calendula>
 <CA+SN3srpbVBK10-PtOcikSphYDRf1WwWjS0d+R76-qCouAV2rQ@mail.gmail.com>
 <aMpuwRiqBtG7ps30@calendula>
 <CA+SN3spZ7Q4zqpgiDbdE5T7pb8PWceUf5bGH+oHLEz6XhT9H+g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+SN3spZ7Q4zqpgiDbdE5T7pb8PWceUf5bGH+oHLEz6XhT9H+g@mail.gmail.com>

On Wed, Sep 17, 2025 at 08:33:49PM +0300, Elad Yifee wrote:
> On Wed, Sep 17, 2025 at 11:18 AM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Just to make sure we are on the same page: Software plane has to match
> > the capabilities of the hardware offload plan, new features must work
> > first in the software plane, then extend the hardware offload plane to
> > support it.
> 
> Thanks - I see what you meant now.
> 
> This isn’t a new feature that needs to be implemented in software
> first. We’re not introducing new user semantics, matches, or actions
> in nft/TC. no datapath changes (including the flowtable software
> offload fast path). The change only surfaces existing CT state
> (mark/labels/dir) as FLOW_ACTION_CT_METADATA at the hardware offload
> boundary so drivers can use it for per-flow QoS, or simply ignore it.
>
> When a flow stays in software, behavior remains exactly as today,
> software QoS continues to use existing tools (nft/TC setting
> skb->priority/mark, qdiscs, etc.). There’s no SW-HW mismatch
> introduced here.

You have to show me there is no mismatch.

This is exposing the current ct mark/label to your hardware, the
flowtable infrastructure (the software representation) makes no use of
this information from the flowtable datapath, can you explain how you
plan to use this?

Thanks.
