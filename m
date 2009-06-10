From: Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: RFC: conntrack: use mod_timer_pending()
Date: Wed, 10 Jun 2009 07:51:33 -0700
Message-ID: <20090610075133.2dd04e7d@nehalam>
References: <4A2FAFB4.1050100@trash.net>
	<4A2FAFF6.50909@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Martin Josefsson <gandalf@netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.vyatta.com ([76.74.103.46]:52254 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756766AbZFJOvg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jun 2009 10:51:36 -0400
In-Reply-To: <4A2FAFF6.50909@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 10 Jun 2009 15:07:02 +0200
Patrick McHardy <kaber@trash.net> wrote:

> Patrick McHardy wrote:
> > This patch changes conntrack to use the new mod_timer_pending()
> > function, which only rearms the timer if it was still active.
> > This allows to only grab the lock in __nf_ct_refresh_acct when
> > accounting is used.
> > 
> > Anyone seing anything wrong with this?
> 
> >  		if (acct) {
> > +			spin_lock_bh(&nf_conntrack_lock);
> >  			acct[CTINFO2DIR(ctinfo)].packets++;
> >  			acct[CTINFO2DIR(ctinfo)].bytes +=
> >  				skb->len - skb_network_offset(skb);
> > +			spin_unlock_bh(&nf_conntrack_lock);
> >  		}
> 
> In fact, we could additionally change it to use the per-conntrack lock.

That is what the conntrack RCU patch did.
