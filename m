From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: per network namespace nfacct
Date: Fri, 7 Aug 2015 11:45:31 +0200
Message-ID: <20150807094531.GA5423@salvia>
References: <1438789905-5716-1-git-send-email-aschultz@tpip.net>
 <20150806100713.GA18520@salvia>
 <55C33D46.4080902@tpip.net>
 <20150806134210.GA3379@salvia>
 <55C364CF.6060609@tpip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Andreas Schultz <aschultz@tpip.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44706 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699AbbHGJj1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Aug 2015 05:39:27 -0400
Content-Disposition: inline
In-Reply-To: <55C364CF.6060609@tpip.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Aug 06, 2015 at 03:44:47PM +0200, Andreas Schultz wrote:
> On 08/06/2015 03:42 PM, Pablo Neira Ayuso wrote:
[...]
> >With netns in place, we don't know in what order the __net_exit
> >functions are called, ie. We may still have references to objects from
> >xt_nfacct.
> 
> Exactly my point, only the xt_nfacct object references also takes a
> module reference. We can not release this reference for them. So
> we remove the nfacct object from the list and only free the object
> if xt_nfacct is *NOT* holding a reference.
> 
> If xt_nfacct is holding a reference, it will put that reference together
> with the module reference later.

You're right. This patch is applied, thanks Andreas:

BTW, I have mangled the original subject to:

netfilter: nfacct: per network namespace support

Just for the next time, we prefer this format:

SUBSYS: COMPONENT: description
