From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/5] netfilter: nf_nat: fix locking in nf_nat_seq_adjust()
Date: Wed, 31 Jul 2013 19:57:37 +0200
Message-ID: <20130731175737.GA6212@localhost>
References: <1375044851-12471-1-git-send-email-kaber@trash.net>
 <1375044851-12471-4-git-send-email-kaber@trash.net>
 <20130731165523.GD13813@localhost>
 <20130731174943.GA8033@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56975 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351Ab3GaR5n (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Jul 2013 13:57:43 -0400
Content-Disposition: inline
In-Reply-To: <20130731174943.GA8033@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 31, 2013 at 07:51:18PM +0200, Patrick McHardy wrote:
> On Wed, Jul 31, 2013 at 06:55:23PM +0200, Pablo Neira Ayuso wrote:
> > On Sun, Jul 28, 2013 at 10:54:09PM +0200, Patrick McHardy wrote:
> > > nf_nat_seq_adjust() needs to grab nf_nat_setofs_lock to protect against
> > > concurrent changes to the sequence adjustment data.
> > 
> > Applied, thanks.
> > 
> > I have enqueued this to nf so it hits 3.11. I have to wait to take 4/5
> > and 5/5 for a while until this patch hits Linus tree.
> 
> We've had this problem since the beginning of netfilter, so I think
> this can go to -next. So far I haven't seen any bugreports related to
> this, but its clearly wrong.

Fair enough, will enqueue this to -next then.

> A follow up patch will move the entire sequence number adjustment data
> to an extend, so the size increase will only affect the quite rare case
> of connections using a helper.

Great to know, thanks.
