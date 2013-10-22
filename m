From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/3] net: sched: Use dev_net() instead of the direct
 access to ->nd_net
Date: Tue, 22 Oct 2013 10:23:39 +0200
Message-ID: <20131022082339.GB20742@localhost>
References: <1382089317-24311-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1382089317-24311-3-git-send-email-kadlec@blackhole.kfki.hu>
 <1382093049.3284.10.camel@edumazet-glaptop.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55062 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753422Ab3JVIXq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Oct 2013 04:23:46 -0400
Content-Disposition: inline
In-Reply-To: <1382093049.3284.10.camel@edumazet-glaptop.roam.corp.google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 18, 2013 at 03:44:09AM -0700, Eric Dumazet wrote:
> On Fri, 2013-10-18 at 11:41 +0200, Jozsef Kadlecsik wrote:
> > We have to use dev_net() instead of the direct access to ->nd_net,
> > otherwise compilation fails if NET_NS is not enabled. Reported by
> > the kbuild test robot.
> > 
> > Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> > ---
> 
> It seems Stephen took care of this :
> 
> http://patchwork.ozlabs.org/patch/284049/

Thanks Eric, I have skipped this one.
