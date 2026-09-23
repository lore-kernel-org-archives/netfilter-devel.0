Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D513D903E;
	Wed, 23 Sep 2026 08:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790153177; cv=none; b=n8SrRA24De2LgLywUxFSsDOsDEKO0UCJ0S1TbBwWcB+oZwTXYYEsk+v+i0ubRqwpNzD5r8fwio16ESLC4eJPgT4tysN+5cQb1qTwHyMgd84MJGU7kOYNfqyM/fY/lfSjjRjqy0C+RXWi2j1fWmLXDmts7JfMHp3g02tPwrpfTAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790153177; c=relaxed/simple;
	bh=wSVnXaqSFIhkKcAJGfcVPGFYiIzsQhyG5P2eUKmnujI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EL20YiWbGMXDnch9NfmvzHbE0Ayk/+UCNAFMvQ26gceUdeCT0a6eWgLgOVEMe20/zHDLukggRoZ54EBV+Iox0sVq5Pl6oVE8P4oa9FvpJ7lRbGtR6+K5bMfEvkF/rEJf/nZc6mZhBw+TdiEaLM3MOXKtA5lVExSkjllgmoWkuq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=aeNCMCeZ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="aeNCMCeZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1790153164;
	bh=JKSw0elemDZeIAkFmZGXuEl3qArMvKWn8KHaNnpVc8U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aeNCMCeZwu5W4DHiEYXkd3kwMAvCTylphp5+hgYq+OUrniEsluP99tTeQ8euNxbX3
	 GE1ZjBK2La04QyNtCNLMpmAhNG8QXB7YhjYbwbGMV21no6Glp+Yj1fHKwCuHbwLCRS
	 IYu9jjwL2+9cd5FftCaZZCV3Y6uMbU5Qco1659rNSmTWFHPXAPR2/UackXtO4O6For
	 IAKqXrUSaJCv0u+5g3doH80ynnysM9A1Iimw5pPiUDN1BlrFHlxbvXNJIyQHJ2L86K
	 KUd3i5O0BAlz1ecNu9Efrp8LG1VlnxtwPp4+THLE2HZLIdJQkCSLucudpegoc8YOyv
	 ZX+FUtJmky3kQ==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 0287660056;
	Wed, 23 Sep 2026 10:46:03 +0200 (CEST)
Date: Wed, 23 Sep 2026 10:46:01 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Subham Pal <subhampal789@gmail.com>
Cc: fw@strlen.de, phil@nwl.cc, kaber@trash.net, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	horms@kernel.org, netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH net 0/2] netfilter: nf_conntrack_h323: fixes for NAT
 bypass and ASN.1 decode
Message-ID: <arORyXjxvZUoEAIw@chamomile>
References: <CAHeizqHDqx3ue1=0QL92ef+6C63Ur+v1Z=d93smgdD5zTj_-Pw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHeizqHDqx3ue1=0QL92ef+6C63Ur+v1Z=d93smgdD5zTj_-Pw@mail.gmail.com>

Hi,

On Wed, Sep 23, 2026 at 09:50:22AM +0530, Subham Pal wrote:
> This series resolves two separate issues in the Netfilter H.323 helper:
> 
> 1. Overly restrictive tuple comparisons across expectation helpers
>    (expect_h245, expect_rtp_rtcp, expect_t120, expect_callforwarding)
>    that bypass NAT payload mangling under DNAT, hairpin routing, and
>    reverse/reply traffic directions.
> 2. An ASN.1 PER decoding bug in decode_seq() where absent extension fields
>    are processed before verifying their presence in the extension bitmap,
>    leading to packet bitstream desynchronization or premature aborts.

I understand these are correctness fixes.

Do you have a reproducer/PoC? Do you tests for this?

> Subham Pal (2):
>   netfilter: nf_conntrack_h323: do not bypass NAT helpers when tuple
>     source matches reply destination
>   netfilter: nf_conntrack_h323: check extension bitmap before decoding
>     components
> 
>  net/netfilter/nf_conntrack_h323_asn1.c |  6 +++---
>  net/netfilter/nf_conntrack_h323_main.c | 24 ++++++------------------
>  2 files changed, 9 insertions(+), 21 deletions(-)
