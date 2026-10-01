Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F01B44AA1DD;
	Thu,  1 Oct 2026 08:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790844286; cv=none; b=kXYHTXbhNiawHfu817PNTVGWWtScRQrHWMSAi7Rz5Aces0Ov3jlnAnswJxpFvUAw0Yu3ofPbj0z1OBbcrnh35UM22Dpx1x09C8KBcD7ynW6n+oNr0ZbeWqPnceSiHh0M6YmyfbIY1Z9ylhxseY2HzoX2Vpra7UK2Z+SfbVqwllQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790844286; c=relaxed/simple;
	bh=cBr/62atPqhADdLLGwzGNHtIkcNfZ47+3KwfShqzONg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X4IEHRnrd6PU2c02Z1FRacoS9VVUGRfiA9hVskM36pWHoiY/eIPOAX8HXUPbSWGOZoeq8/9quABht3Gv7V1ksefsdGqriFfYqVOUWHwoJ/QIEmMtoZwZGtxkmYExCg8iS27rnH0VXJkHLkn/nABMnw6MELVEIjNttLT9yzbCLZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=mBrw14Fs; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="mBrw14Fs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1790844274;
	bh=uY/9yCeS7VG/jhYKRUs1M9aE6dvd1iSUp659VfCk9nw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mBrw14FsnwCPJfAKN66e20TfbA32Rg9xGxlL+ZVOj3H7T49xLp8tDrwcfB4VX4BP3
	 O0+rt9JaYlCDXvG1mts78JXbrgDKxC8fzu+Tq0vV8f7PCB8qyTue3+zSTUl8VhTzrn
	 RT9OJdgddB/dZUIKLHqWJK8a5AwRLCaHcnLOnHlpPFwywg16VR2j/fdx+oSOZeKoT7
	 NSQxp/tMlR0z8kfUBTpTxFEtA+4JGvG+h57s+Yo+IfTSPE/rlylv0JVg3O+kVvJNVw
	 3snUipL3fSSo24Vu+mEsBgCnBYO+4VJPfjy4Bez1mXJRy4ZpwXKXNOOhomwLD4xE1t
	 pOgtyUL3z8DGA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id C718F60076;
	Thu,  1 Oct 2026 10:44:34 +0200 (CEST)
Date: Thu, 1 Oct 2026 10:44:31 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Subham Pal <subhampal789@gmail.com>
Cc: fw@strlen.de, phil@nwl.cc, kaber@trash.net, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	horms@kernel.org, netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH net 0/2] netfilter: nf_conntrack_h323: fixes for NAT
 bypass and ASN.1 decode
Message-ID: <ar4db-oTyeSGTpCy@chamomile>
References: <CAHeizqHDqx3ue1=0QL92ef+6C63Ur+v1Z=d93smgdD5zTj_-Pw@mail.gmail.com>
 <arORyXjxvZUoEAIw@chamomile>
 <CAHeizqF--yGMCLGBEv9f7Gs=dmbZO6+DwSh7KZjpDgbNonCotA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHeizqF--yGMCLGBEv9f7Gs=dmbZO6+DwSh7KZjpDgbNonCotA@mail.gmail.com>

Hi,

On Wed, Sep 23, 2026 at 04:16:48PM +0530, Subham Pal wrote:
> On Wed, Sep 23, 2026 at 2:16 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > I understand these are correctness fixes.
> > Do you have a reproducer/PoC? Do you tests for this?
> 
> Hi Pablo,
> 
> Both issues were found while testing a netfilter based linux
> firewall with communicating devices from multiple vendors
> (Panasonic, PeopleLink, YeaLink and Plycom).

We will need a reproducer here without requiring such hardware.

> 1. For patch 1 (NAT expectation bypass)
> - Environment & Setup
>   Linux firewall performing NAT between internal and external
>   network segment with Panasonic, PeopleLink, YeaLink
>   and Polycom endpoints.
> - Observation
>   Call setup failing due to missing conntrack expectation from
>   initial Q.931.
> 
> 2. For patch 2 (Failed ASN.1 parsing)
> - Environment & Setup
>   The same setup but this problem happened particularly with
>   Panasonic endpoint.
> - Observation
>   Panasonic endpoint advertises sequence extension with missing
>   optional fields during call setup. Due to misaligned check for presence
>   of field, I was getting H323_ERROR_BOUND error in dmesg.
