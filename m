From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] netlink_linearize: fix wrong comparison in
 netlink_gen_flagcmp()
Date: Mon, 17 Feb 2014 11:16:44 +0100
Message-ID: <20140217101644.GA3971@localhost>
References: <1392590522-4170-1-git-send-email-pablo@netfilter.org>
 <20140216224331.GA23262@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50909 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751206AbaBQKQy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Feb 2014 05:16:54 -0500
Content-Disposition: inline
In-Reply-To: <20140216224331.GA23262@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Feb 16, 2014 at 10:43:32PM +0000, Patrick McHardy wrote:
> On Sun, Feb 16, 2014 at 11:42:02PM +0100, Pablo Neira Ayuso wrote:
> >  nft add rule filter input ct state established,related counter drop
> > 
> > is not matching here due to a wrong comparison in the rule:
> > 
> >  ip filter input 20 19
> >    [ ct load state => reg 1 ]
> >    [ bitwise reg 1 = (reg=1 & 0x00000006 ) ^ 0x00000000 ]
> >    [ cmp neq reg 1 0x00000006 ] <----- this has to be zero
> >    [ counter pkts 0 bytes 0 ]
> >    [ immediate reg 0 drop ]
> > 
> > There's a line that generates the value from the right-hand
> > expression which was not in the original code. This bug was
> > introduced in aae836a ("src: use libnftables").
> 
> I already pushed that patch two or three hours ago.

Thanks Patrick. I noticed this when testing state established,related.
Please, send your patches to nf-devel next time, I would have noticed
and saved that time.
