Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D0030C605;
	Thu, 28 Aug 2025 12:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756384410; cv=none; b=W2BsodVRac/wODIVRWvPwVXiQ8OZt8Gr/mVAzZUB52+N7Gc/bwDpbeG25EM7Tt14fJqGcLPD+Wzc04DoNZDLya4zwiRWMCXs6NxBktPax6qaLgDBG/tOiH6pd5MvjVtsqZ3FMBbd4drAe6rY7ssP/s0qubKQYLguPwMr2jbVcEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756384410; c=relaxed/simple;
	bh=ewmH9xcyPl+paA/pkAXt2p+G0NnKbaPnTZQwPIAMbjM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kj1KsuUcfAKxxikmB89sbFc17o6SE8TobJWIdZuxFVUUMxilumMsvyA0bTfGMPsRf1/x7Y6ooteLMmGxPAxN0la0W/njvZswbf9pZs1MFpF7LrBB5QqfVFFnOAAUTA805OihMki4dee/DfRR6IOlEEIiiamBFjb861PkXt/MX6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=HV/mEyaQ; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=M1vLYh6p; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="HV/mEyaQ";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="M1vLYh6p"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id A625860642; Thu, 28 Aug 2025 14:33:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756384406;
	bh=GzFAeyreM3Oxmb7oa93qBzx78opS9F1JOE4cszPO2Ro=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HV/mEyaQoP3ch4+0UMlBRa5Tuwi0ZXq6jJEBULkUNAOJsHG93+rYTCk2cyC8eaNh4
	 gVYSiB7bVmd27ezkr2P4YyA0My8jeMHnsG4k/ATuDV0fBWjxTRf+MRoTI5wynV29KG
	 MW3wZVsmV5DA7wsBzTC1Dbo94S7fX+PKje6r1vkyg/C81zXFEgZKv79gs4YHSlTYIG
	 puhd04dZXMWUy5dDlWEOHea/dmEePO5J8cyz5izq0MSd4PGiUFzUVrK+HBoqbFyIHY
	 4PPCZYJ+Bmfeen6LKFnHPmW3OsZllvlzXk0UO4wcZMd/ZH2LDajRxIo6eaP/JltWo8
	 +kkXHLbjJq6iA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 74C5F60634;
	Thu, 28 Aug 2025 14:33:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756384405;
	bh=GzFAeyreM3Oxmb7oa93qBzx78opS9F1JOE4cszPO2Ro=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M1vLYh6p5CusOyPyATE5C3pgK9c0SWkdsfE6TqTEn5E2jWSFngEDCVr/UQXO0esAO
	 kG1GBE41TiIx+l3Sn9q+EhsPyfBwViMtTotZUYp5fT4/dXwM9E3jplbjB2BxQYFH4d
	 LrUwwdVNaC0TddMdh59wGIHstlBs/Z/+LO92//xHgTvSp2Ifu+FZbhrqrcqzwwX4XQ
	 DOMVgP8PoaOwVIwWv6DxtzL1deDR9s7+j9BAYA6PJM7MPgk9c9HpRQOYwPLOhvbGV5
	 3eXpNihPiAPgdLtKgi0oY/g+HWFxJtNE8reASM6bnRTb12g6g0klGVG/PwXOC6Y2lJ
	 TayeJy/EQLywA==
Date: Thu, 28 Aug 2025 14:33:22 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Fabian =?utf-8?B?QmzDpHNl?= <fabian@blaese.de>, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	"Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH v3] icmp: fix icmp_ndo_send address translation for reply
 direction
Message-ID: <aLBMktniIkqsfWQY@calendula>
References: <20250825203826.3231093-1-fabian@blaese.de>
 <20250828091435.161962-1-fabian@blaese.de>
 <aLBE2Ee7pUBzUupH@calendula>
 <aLBIeS4_x7dbrL-j@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aLBIeS4_x7dbrL-j@strlen.de>

On Thu, Aug 28, 2025 at 02:15:53PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Thu, Aug 28, 2025 at 11:14:35AM +0200, Fabian Bläse wrote:
> > > The icmp_ndo_send function was originally introduced to ensure proper
> > > rate limiting when icmp_send is called by a network device driver,
> > > where the packet's source address may have already been transformed
> > > by SNAT.
> > > 
> > > However, the original implementation only considers the
> > > IP_CT_DIR_ORIGINAL direction for SNAT and always replaced the packet's
> > > source address with that of the original-direction tuple. This causes
> > > two problems:
> > > 
> > > 1. For SNAT:
> > >    Reply-direction packets were incorrectly translated using the source
> > >    address of the CT original direction, even though no translation is
> > >    required.
> > > 
> > > 2. For DNAT:
> > >    Reply-direction packets were not handled at all. In DNAT, the original
> > >    direction's destination is translated. Therefore, in the reply
> > >    direction the source address must be set to the reply-direction
> > >    source, so rate limiting works as intended.
> > > 
> > > Fix this by using the connection direction to select the correct tuple
> > > for source address translation, and adjust the pre-checks to handle
> > > reply-direction packets in case of DNAT.
> > > 
> > > Additionally, wrap the `ct->status` access in READ_ONCE(). This avoids
> > > possible KCSAN reports about concurrent updates to `ct->status`.
> > 
> > I think such concurrent update cannot not happen, NAT bits are only
> > set for the first packet of a connection, which sets up the nat
> > configuration, so READ_ONCE() can go away.
> 
> Yes, the NAT bits stay in place but not other flags in ->status, e.g.
> DYING, ASSURED, etc.
> 
> So I believe its needed, concurrent update of ->status is possible and
> KCSAN would warn.  Other spots either use READ_ONCE or use test_bit().

There are a more checks for ct->status & NAT_MASK in the tree that I
can see, if you are correct, then maybe a new helper function to check
for NAT_MASK is needed.

Anyway, as for this patch, READ_ONCE should not harm.
