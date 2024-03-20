Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A78CB21100
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Mar 2024 20:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710967487; cv=none; b=ceFvqGbX4whTe+9Wpoh79vvuCP//y3mgyuLzeKunBT11aXVMC1/8mCRPE1sdM4rFjPGVB6WwjLzLPTgqVvTLRg0ZcS63B9JqTSP+YSNlREXzr9E3cWXZ/6wxGL8EXIlltRrKnuA5weBUADewdUAzi6FLWxBsumQW7b59iDpVZYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710967487; c=relaxed/simple;
	bh=cngqR+6sI0lfQWnZWgJvDlPApcizpskoiiUx+hF6wl8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=epAI/RM0gderKaZ2T68gUdy6C67NPYFG0oTCvlzrie6WS0pEMjOsLHwYvkj+Nc31q8GabPTTh1XxxQLzvP0e3aSXMQz/VnY7N5694y2EILsUiKjEkr3KeTWX2foAmTNx0LXjmVMgAQw8O9WRwr4apvYsvaQZW1E4Qjl70x41Zfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=B6I2zqzy; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="B6I2zqzy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=eXBD23RKlZkhn1MbbvkoozFl7O06pcElqrgsxKP8mg8=; b=B6I2zqzyvV2d4OH0T4eW2hsoUO
	i1Z2PFOwe8e/GctKlwh2rjto24J9mrSos0QbBLQtl6GRlNd3xIvhPf4K93896IPl3ouEnvd1vo4wJ
	SU8taYxNH7Ls/0x+JLHQFhMoHYDCmi2rm/B3Oqyd408lDDWcBmkVEnEz14oyEqlBILegQz+LIhGqu
	f5Zh2M0JPvX09JtaADYh8hK9YHEL0i/QSDYgoEa0KsPkS3KUB1A05Ows9lg896uvJiR0U+8406DJf
	DJFGU1Rlg1BvX76KLrNYjz0ftNQHeRnCywkmUUgUW9cwHewv1hjcUnlInjPOqGEjab6mGJnQ+SSgP
	wnptoTTg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rn2nh-000000007hU-2Iwp;
	Wed, 20 Mar 2024 21:44:41 +0100
Date: Wed, 20 Mar 2024 21:44:41 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] json: Accept more than two operands in binary
 expressions
Message-ID: <ZftKuZIJ_Bnd5dBg@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20240320145806.4167-1-phil@nwl.cc>
 <ZfsaHoVscFBO73ib@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZfsaHoVscFBO73ib@calendula>

On Wed, Mar 20, 2024 at 06:17:18PM +0100, Pablo Neira Ayuso wrote:
> On Wed, Mar 20, 2024 at 03:58:06PM +0100, Phil Sutter wrote:
> > The most common use case is ORing flags like
> > 
> > | syn | ack | rst
> > 
> > but nft seems to be fine with less intuitive stuff like
> > 
> > | meta mark set ip dscp << 2 << 3
> 
> This is equivalent to:
> 
>   meta mark set ip dscp << 5
> 
> userspace is lacking the code to simplify this, just like it does for:
> 
>   meta mark set ip dscp | 0x8 | 0xf0
> 
> results in:
> 
>   meta mark set ip dscp | 0xf8

You're right, of course. Simplifying the input is a different task
though, I merely made sure that JSON input/output matches what regular
syntax supports as well.

Input optimization should happen in eval phase (or so) anyway and thus
independent of where input was parsed from.

Cheers, Phil
