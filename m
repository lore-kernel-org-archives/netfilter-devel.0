From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3] extensions: libxt_statistic: Add translation to nft
Date: Wed, 2 Mar 2016 16:56:57 +0100
Message-ID: <20160302155657.GA6299@salvia>
References: <20160301204042.GA15382@sonyv>
 <20160302114611.GA3008@salvia>
 <20160302121033.GA4348@breakpoint.cc>
 <alpine.LSU.2.20.1603021409540.15745@nerf40.vanv.qr>
 <20160302145016.GF4348@breakpoint.cc>
 <20160302151724.GB5844@salvia>
 <20160302152946.GH4348@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Engelhardt <jengelh@inai.de>,
	Laura Garcia Liebana <nevola@gmail.com>,
	netfilter-devel@vger.kernel.org, shivanib134@gmail.com,
	outreachy-kernel@googlegroups.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:32970 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977AbcCBP5D (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Mar 2016 10:57:03 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 9E48FE666E
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2016 16:57:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8E85BDA38A
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2016 16:57:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8562EDA383
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2016 16:56:59 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160302152946.GH4348@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 02, 2016 at 04:29:46PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > In all this thread you talk all the time on probability semantics,
> > however the selector name is 'random'.
> > 
> > Why don't you rename this to 'meta probability' instead?
> > 
> > No changes in the semantics then, just use:
> > 
> >         meta probability 0.1
> > 
> > and when expressing the opposite:
> > 
> >         meta probability 0.9
> 
> I have no preferences one way or another, i'd
> be fine with using probability for this.
> 
> In future you might want to allow something like
> 
> nft add rule filter input meta mark set meta random

Right.

> or
> nft add rule filter input queue num meta random

Yes, this reminds me we have to fix nft_queue so it also accepts a
sreg as input. It's not very flexible and we cannot use maps with it.

> Perhaps we should use probability for now and later
> alias is to random for these cases?

+1 to using meta probability for this.
