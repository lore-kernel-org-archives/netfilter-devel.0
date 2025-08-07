Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5502A1CF;
	Thu,  7 Aug 2025 11:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754567174; cv=none; b=DtpYi6vtsj7eUSXxu5cPhdGn3LEp3gXdYpeu5H6puyeQlW+H2OzinHLWMsXNM/SWiCwdh6ItDgvYZAnRu+r95/F50vXTe327+psKvci9yVlxzlXQZhi20gMeK5WiTkyi4Y2fFxhdWT+YTUy4R13JcogDDX/CKoadhp4uaBRbXSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754567174; c=relaxed/simple;
	bh=mwYrZV/IoM4HuihubZtAE5WDLaSLeGNDk96ecT6GIdM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LjGjo12fBDWgAF072w3NoHNBSgsGphUZllZ5guasULiBye3ygrUhk00Qu0mASQl9MUD0fN9nIaplkntNbF53uJwxHdeAIDSL+cgrv48LvcjWOLLawwWwgJE3UMZSsUaKVZb4PpeNal59y4CSgTHt1cNz/DWQ/9E3R7stunaV5K4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=WCuhathf; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ELhtcEVk; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="WCuhathf";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ELhtcEVk"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 0AFAB60A7B; Thu,  7 Aug 2025 13:46:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1754567170;
	bh=FQwuf+Fg9SL3HJPvHw31ESbPcgr7KJh5rsV2ZKv1aEU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WCuhathfMBDgeO1VF6eF0oA1DIMsljNkjz/uXn5prylomgAZR8tYDcdRZ+RjsqrXs
	 0Y14KjSKj1wypWrdWdwReJ5uXpV8LaLQlaQQ1OZClQRTsi+eKzp2wKAZ1WZ/twgz5e
	 vn5p7mESIfNnsoXG29LcI6LYJ0RLBq/D3ZlLoevMnSw69HZdf6XWbG3xeG/Qz6FEJx
	 9wXn7fwJdXmcs74Fq7En0urFeGQF7F183xPOvwEfD+7HI7HJdmK7sYbS+QZF7xsjsH
	 gaO+YVe39LRsWX8ZqLFLO791RF27Pt/Dg5DE0oC+4GYJ46frEg/FV5ysXGfh4Rqzdn
	 jHpuZF5T6Ac0Q==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 98EAA60A7B;
	Thu,  7 Aug 2025 13:46:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1754567167;
	bh=FQwuf+Fg9SL3HJPvHw31ESbPcgr7KJh5rsV2ZKv1aEU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ELhtcEVkUnZON5RgMcg1aiu1Nz6FGfKZDcUieXAJSx6pmHvrY/KWqP+TVLq4xCnFW
	 A8bzmda6bpPRSWfp7xkZgfStBTpb4/2NFUEh7zIzyNYdM0et+NmnZoY2/lEsqapMXr
	 NvKVNoPDONKaPy+9bGJt8b8VcXro50zUABLRQj8Aubh47F4o7azAiPVsZ7oOBbjrXP
	 dmeLi8QMXK8Sb5emoz40nW+9itQMz9wp6Lk1JkwL7x0QUDOZaSIE+iDa7FEgXHmEvU
	 e1E8X3cZwDzF/QyELlqm1Nh9vd0BCvHBbg1ANtedZyc+DTHYNcnmGcIGDAeNlS3kP3
	 WFsQfiGAXAoYg==
Date: Thu, 7 Aug 2025 13:46:05 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, fw@strlen.de, horms@kernel.org,
	Aishwarya Rambhadran <Aishwarya.Rambhadran@arm.com>
Subject: Re: [PATCH net-next 06/19] netfilter: Exclude LEGACY TABLES on
 PREEMPT_RT.
Message-ID: <aJSR_cFHvqtmGb-B@calendula>
References: <20250725170340.21327-1-pablo@netfilter.org>
 <20250725170340.21327-7-pablo@netfilter.org>
 <81bdc56d-a3da-4fc4-b2d0-2561b4d96723@arm.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <81bdc56d-a3da-4fc4-b2d0-2561b4d96723@arm.com>

Hi Ryan,

On Tue, Aug 05, 2025 at 04:43:06PM +0100, Ryan Roberts wrote:
[...]
> > +config NETFILTER_XTABLES_LEGACY
> > +	bool "Netfilter legacy tables support"
> > +	depends on !PREEMPT_RT
> > +	help
> > +	  Say Y here if you still require support for legacy tables. This is
> > +	  required by the legacy tools (iptables-legacy) and is not needed if
> > +	  you use iptables over nftables (iptables-nft).
> > +	  Legacy support is not limited to IP, it also includes EBTABLES and
> > +	  ARPTABLES.
> > +
> 
> This has caused some minor pain for me using Docker on Ubuntu 22.04, which I
> guess is still using iptables-legacy. I've had to debug why Docker has stopped
> working and eventually ended here. Explcitly enabling NETFILTER_XTABLES_LEGACY
> solved the problem.

I apologize for the inconvenience. Using iptables-nft should fix it,
if you encounter any issue with iptables-nft in Ubuntu 22.04, it
should be straight forward to compile lastest iptables version, given
you compile your own kernels for such distro version.

> I thought I'd try my luck at convincing you to default this to enabled for
> !PREEMPT_RT to save others from such issues?

Not so easy as removing PREEMPT_RT dependency, x_tables need to be
fixed in order to support it, last time we discussed this there was a
way to address it by making the counters more unreliable in turn.

No objections if anyone wants to fix x_tables to make it work with
PREEMPT_RT from my side.
