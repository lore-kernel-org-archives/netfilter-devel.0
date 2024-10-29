Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64AA21D63F9
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Oct 2024 17:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730221638; cv=none; b=pV7I48vu/t2C6NtYbdWc0KJ/FuV0PlNBPxyCTkFxBqFP9MfXLg9yvq+yn4+YLIR6CNhVIK5woT85aFx9IAAAzfh7F9yNsO3SFRCG84ZQYOk+sYoGVoMVUp8SU/tqMGvqH8QYENsd/NgIeS1+56fEKyH6ECPBPp07yTOqhmEQ2ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730221638; c=relaxed/simple;
	bh=mxTx4EePBebUku8qvYbvhhfN6GlBXsmj7R7v8YbO1ts=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WCVc5Ak8m6JxdMROzKv5Drs9igwRdRC8zIOoh2DT+qeVXIsYe8a+8BNRPWs8CJPiZvHx8RZSmMVSKILauphnQiOrcxu9WE2dNL3qhLRVsc6Flm8EPaipZMLBZoY8C2Sbzwku/D8+UfPA0sqna1kZGvHB6O87I7Bfo439UNhSp04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=WHZHVuRD; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="WHZHVuRD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ZoeCiwkwE3IvOHNshSU8rlFX2JbsipBrmu06fTewhB0=; b=WHZHVuRDTQ+mQPLfKr2R2zOC12
	aQBYuIEjWodHROmfRyrpp6Mgmmdc5HSKO0Z7OQsLwNtPc6RcSx7pwjwDKfiInxwBZYFKg0Dk5bv1n
	QWZ/DfaiIEUP4uY1IiXxfjyMHQSA05QX7lJFJCbp5idIBik6S0QD1kqseo947edkYxifQDt5DADgd
	yj3Dtt+jlceOmGSErH2JS4rBghmj9XJsGzir/fXApuoN5NH2QGIyoqWyZqPHqHa8BeYLIM+X6pC8C
	d14TdfNoHYfxKPUsyKesMLycdsoJDxpWmi02THNf3PW7lHSZhep6Kk9Qyf8ue3wMF6GzDf1UqgfJm
	OqN5+P1g==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t5pgW-000000003MZ-0or7;
	Tue, 29 Oct 2024 18:07:12 +0100
Date: Tue, 29 Oct 2024 18:07:12 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Jan Engelhardt <ej@inai.de>
Subject: Re: [libnftnl PATCH] Use SPDX License Identifiers in headers
Message-ID: <ZyEWQKApZc4Xoanf@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Jan Engelhardt <ej@inai.de>
References: <20241023200658.24205-1-phil@nwl.cc>
 <ZyAVA6uzi-OUBtcO@calendula>
 <ZyDPYf83FmbqkOe8@orbyte.nwl.cc>
 <ZyDz96q1UmCypXpf@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZyDz96q1UmCypXpf@calendula>

On Tue, Oct 29, 2024 at 03:40:55PM +0100, Pablo Neira Ayuso wrote:
> On Tue, Oct 29, 2024 at 01:04:49PM +0100, Phil Sutter wrote:
> > On Mon, Oct 28, 2024 at 11:49:39PM +0100, Pablo Neira Ayuso wrote:
> > > On Wed, Oct 23, 2024 at 10:06:57PM +0200, Phil Sutter wrote:
> > > > diff --git a/examples/nft-chain-add.c b/examples/nft-chain-add.c
> > > > index 13be982324180..fc2e939dae8b4 100644
> > > > --- a/examples/nft-chain-add.c
> > > > +++ b/examples/nft-chain-add.c
> > > > @@ -1,10 +1,7 @@
> > > 
> > > Maybe more intuitive to place
> > > 
> > > +/* SPDX-License-Identifier: GPL-2.0-or-later */
> > > 
> > > in the first line of this file? This is what was done in iproute2.
> > 
> > Fine with me! I just semi-automatically replaced the license text block
> > by this specifier and didn't care about its position. A quick check of
> > how things are done in linux.git shows it's not entirely consistent
> > there: When Thomas Gleixner did an equivalent to my patch in commit
> > 0fdebc5ec2ca ("treewide: Replace GPLv2 boilerplate/reference with SPDX -
> > gpl-2.0_56.RULE (part 1)"), he used double-slash comments, while Greg
> > Kroah-Hartman chose to use multi-line comments in commit b24413180f56
> > ("License cleanup: add SPDX GPL-2.0 license identifier to files with no
> > license"). Is this random or am I missing a detail?
> 
> What I learnt in my crash course about license compliance is that this
> SPDX stuff is for robots that parse source code. I suspect placing
> this in the first line saves time parsing files for them.

Sounds reasonable. I was merely wondering about the different comment
styles, but I guess it won't matter since any robot has to expect both
styles anyway.

> For a human standpoint, to quickly look at the first line of each file
> via script, then ... head -1 $file | sort | uniq -c.

Speaking of each file, do we care about libnftnl's header files?

> > BTW: Jan suggested to also (introd)use SPDX-FileCopyrightText label, but
> > spdx.dev explicitly states: "Therefore, you should not remove or modify
> > existing copyright notices in files when adding an SPDX ID."[1] What's
> > your opinion about it?
> 
> No idea, I hate legal stuff, really. I saw a room full of people
> taking about SPDX.

"I have seen things you people wouldn't believe ..." :D

> Being pragmatic, I would do what I see people do around with this, and
> they are just turning license text into SPDX license labels.

ACK.

> And getting back to the original topic, we only have to agree where to
> place the SPDX license line for libnftnl. I don't have a strong
> opinion on this, if you like your approach, that is fine by me.

Line 1 is fine with me! I'll submit a v2.

Thanks, Phil
