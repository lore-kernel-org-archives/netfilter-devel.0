From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH -stable] netfilter: nft_rbtree: fix locking
Date: Wed, 1 Jul 2015 13:38:46 +0200
Message-ID: <20150701113846.GA18976@salvia>
References: <1431802251-4781-1-git-send-email-pablo@netfilter.org>
 <1431802251-4781-7-git-send-email-pablo@netfilter.org>
 <20150629230053.GC19806@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stable@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42316 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752859AbbGALdR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Jul 2015 07:33:17 -0400
Content-Disposition: inline
In-Reply-To: <20150629230053.GC19806@kroah.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 29, 2015 at 04:00:53PM -0700, Greg KH wrote:
> On Sat, May 16, 2015 at 08:50:51PM +0200, Pablo Neira Ayuso wrote:
> > From: Patrick McHardy <kaber@trash.net>
> > 
> > [ upstream commit 16c45eda96038aae848b6cfd42e2bf4b5e80f365 ]
> > 
> > Fix a race condition and unnecessary locking:
> > 
> > * the root rb_node must only be accessed under the lock in nft_rbtree_lookup()
> > * the lock is not needed in lookup functions in netlink context
> > 
> > Cc: <stable@vger.kernel.org> # 3.18.x
> > Cc: <stable@vger.kernel.org> # 3.19.x
> > Signed-off-by: Patrick McHardy <kaber@trash.net>
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> >  net/netfilter/nft_rbtree.c |    6 ++----
> >  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> Also 4.0, right?  This showed up in Linus's tree in 4.1-rc1.

Yes please. thanks!
