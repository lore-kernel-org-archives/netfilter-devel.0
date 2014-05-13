From: Florian Westphal <fw@strlen.de>
Subject: Re: conntrackd, internal cache keeps filling up
Date: Tue, 13 May 2014 14:04:00 +0200
Message-ID: <20140513120400.GA22929@breakpoint.cc>
References: <20140505104058.GA30297@finrod>
 <20140509113129.GA8031@localhost>
 <20140510061743.GA32197@finrod>
 <20140512163538.GA13344@localhost>
 <20140513114535.GA9209@finrod>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Martin Kraus <lists_mk@wujiman.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:58354 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753709AbaEMMEF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 May 2014 08:04:05 -0400
Content-Disposition: inline
In-Reply-To: <20140513114535.GA9209@finrod>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Martin Kraus <lists_mk@wujiman.net> wrote:
> On Mon, May 12, 2014 at 06:35:38PM +0200, Pablo Neira Ayuso wrote:
> > > current kernel is 3.13.7. 
> > > 
> > > we already hit a bug in the official 3.2 kernel packaged with wheezy where 
> > > our scan for heartbleed vulnerability would cause conntrackd to kernel panic
> > > the router.
> > 
> > Please, provide more information on how to reproduce the problem that
> > you're noticing. Thank you.
> 
> regarding the kernel panic on 3.2 a colleague of mine was using nmap with it's
> heartbleed plugin
> 
> nmap --script ssl-heartbleed -sT -oX logfile.log 10.0.0.0/20
> 
> http://nmap.org/nsedoc/scripts/ssl-heartbleed.html
> 
> it took about 30 minutes to trigger the problem.
[..]

>         NetlinkEventsReliable On

known broken until at least Linux 3.6, see f.e.

5b423f6a40a0327f9d40bc8b97ce9be266f74368
("netfilter: nf_conntrack: fix racy timer handling with reliable events")
