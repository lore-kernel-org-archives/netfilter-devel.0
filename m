From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH] set: add helper to get the first set_elem
Date: Tue, 15 Apr 2014 10:11:24 +0200
Message-ID: <20140415081124.GA3675@localhost>
References: <20140415075842.18544.32525.stgit@nfdev.cica.es>
 <20140415080432.GA15759@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59543 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917AbaDOILs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Apr 2014 04:11:48 -0400
Content-Disposition: inline
In-Reply-To: <20140415080432.GA15759@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Apr 15, 2014 at 10:04:32AM +0200, Patrick McHardy wrote:
> On Tue, Apr 15, 2014 at 09:58:42AM +0200, Arturo Borrero Gonzalez wrote:
> > Add a helper that returns a pointer to the first set_elem in a given set.
> > 
> > This function is useful in situations where you know the set only have one
> > element (ie, event reporting from the kernel).
> 
> That doesn't seem right to me. As I said in my review of the notification
> patch, userspace *must* be prepared for multiple elements being reported
> at once since it is very likely that we will change the kernel side in
> the future for efficiency reasons.

I see. Arturo, you have to consider that the set may have more than
one element in the event from userspace, even if currently we only
have one single element. So use the set iterator to print all the
elements in the set instead.
