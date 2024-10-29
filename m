Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 088BC206071
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Oct 2024 14:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730212868; cv=none; b=KYnlbbf19Haiv1kizDGkfcUX6obg2bTBYg8TUcLJyPImSbjlmy2+EuoAuEw8hLiVjUU7ufBxJfDdzSDjlAWEmnJQ28mD+r0DwuRxtX1yQCApBDMEatdThN4e0Ntt55nDSJWp4OHwSC3TfofHp1VSw9gpRixX6eDjCdFdOs9E4i4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730212868; c=relaxed/simple;
	bh=zlEhPIx4w0c5lqqHjqEmurQluTMA2e+6tn6mVUyJp/A=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YcgoFC+PAaPGPLoQsCrYIe5ifbfhf1OUYtRbn6hasgTFL0ZGS5clV52AA27dOSU94ud+f+yyds4bUTTj1/tne3U/572JMI2XLRNGj1MJ6KXhs/oDiqnKHMhatnpv76Lx4kkg1MjmbrfZ4ztHsUCPIRU7Z7sznpVp+U3Dd/rvoVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=46766 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t5nOy-007VPo-PA; Tue, 29 Oct 2024 15:40:59 +0100
Date: Tue, 29 Oct 2024 15:40:55 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
	Jan Engelhardt <ej@inai.de>
Subject: Re: [libnftnl PATCH] Use SPDX License Identifiers in headers
Message-ID: <ZyDz96q1UmCypXpf@calendula>
References: <20241023200658.24205-1-phil@nwl.cc>
 <ZyAVA6uzi-OUBtcO@calendula>
 <ZyDPYf83FmbqkOe8@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZyDPYf83FmbqkOe8@orbyte.nwl.cc>
X-Spam-Score: -1.9 (-)

On Tue, Oct 29, 2024 at 01:04:49PM +0100, Phil Sutter wrote:
> On Mon, Oct 28, 2024 at 11:49:39PM +0100, Pablo Neira Ayuso wrote:
> > On Wed, Oct 23, 2024 at 10:06:57PM +0200, Phil Sutter wrote:
> > > diff --git a/examples/nft-chain-add.c b/examples/nft-chain-add.c
> > > index 13be982324180..fc2e939dae8b4 100644
> > > --- a/examples/nft-chain-add.c
> > > +++ b/examples/nft-chain-add.c
> > > @@ -1,10 +1,7 @@
> > 
> > Maybe more intuitive to place
> > 
> > +/* SPDX-License-Identifier: GPL-2.0-or-later */
> > 
> > in the first line of this file? This is what was done in iproute2.
> 
> Fine with me! I just semi-automatically replaced the license text block
> by this specifier and didn't care about its position. A quick check of
> how things are done in linux.git shows it's not entirely consistent
> there: When Thomas Gleixner did an equivalent to my patch in commit
> 0fdebc5ec2ca ("treewide: Replace GPLv2 boilerplate/reference with SPDX -
> gpl-2.0_56.RULE (part 1)"), he used double-slash comments, while Greg
> Kroah-Hartman chose to use multi-line comments in commit b24413180f56
> ("License cleanup: add SPDX GPL-2.0 license identifier to files with no
> license"). Is this random or am I missing a detail?

What I learnt in my crash course about license compliance is that this
SPDX stuff is for robots that parse source code. I suspect placing
this in the first line saves time parsing files for them.

For a human standpoint, to quickly look at the first line of each file
via script, then ... head -1 $file | sort | uniq -c.

> BTW: Jan suggested to also (introd)use SPDX-FileCopyrightText label, but
> spdx.dev explicitly states: "Therefore, you should not remove or modify
> existing copyright notices in files when adding an SPDX ID."[1] What's
> your opinion about it?

No idea, I hate legal stuff, really. I saw a room full of people
taking about SPDX.

Being pragmatic, I would do what I see people do around with this, and
they are just turning license text into SPDX license labels.

And getting back to the original topic, we only have to agree where to
place the SPDX license line for libnftnl. I don't have a strong
opinion on this, if you like your approach, that is fine by me.
