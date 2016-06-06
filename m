From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 07/23] netfilter: x_tables: check standard target size too
Date: Mon, 6 Jun 2016 13:20:47 +0200
Message-ID: <20160606112047.GA3585@salvia>
References: <1461332394-3994-1-git-send-email-pablo@netfilter.org>
 <1461332394-3994-8-git-send-email-pablo@netfilter.org>
 <8760tn5ojb.fsf@linux-m68k.org>
 <20160605220210.GA7827@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Schwab <schwab@linux-m68k.org>,
	netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51279 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297AbcFFLUx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jun 2016 07:20:53 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 349ADEAA6C
	for <netfilter-devel@vger.kernel.org>; Mon,  6 Jun 2016 13:20:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 24CDC1DE74B
	for <netfilter-devel@vger.kernel.org>; Mon,  6 Jun 2016 13:20:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8D8CD1DE74F
	for <netfilter-devel@vger.kernel.org>; Mon,  6 Jun 2016 13:20:49 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160605220210.GA7827@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 06, 2016 at 12:02:10AM +0200, Florian Westphal wrote:
> Andreas Schwab <schwab@linux-m68k.org> wrote:
> > > From: Florian Westphal <fw@strlen.de>
> > >
> > > We have targets and standard targets -- the latter carries a verdict.
> > >
> > > The ip/ip6tables validation functions will access t->verdict for the
> > > standard targets to fetch the jump offset or verdict for chainloop
> > > detection, but this happens before the targets get checked/validated.
> > >
> > > Thus we also need to check for verdict presence here, else t->verdict
> > > can point right after a blob.
> > >
> > > Spotted with UBSAN while testing malformed blobs.
> > 
> > This breaks iptables on PPC32.
> 
> Yes, we got bug report for arm32, I'm sorry about this -- only 32bit
> platform I tested was i686 and that only needs 4byte alignment for u64.
> 
> This fix should help:
> 
> https://git.kernel.org/cgit/linux/kernel/git/pablo/nf.git/commit/?id=7b7eba0f3515fca3296b8881d583f7c1042f5226

Short notice: Will be handing over this in a pull request for David at
some point today.
