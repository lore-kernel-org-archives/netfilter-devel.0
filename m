From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 1/2] Introduce notification chain for routing changes
Date: Wed, 14 Nov 2012 08:57:21 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1211140855280.4404@blackhole.kfki.hu>
References: <1352837857-22087-1-git-send-email-kadlec@blackhole.kfki.hu> <1352837857-22087-2-git-send-email-kadlec@blackhole.kfki.hu> <20121113.171515.552672146557270042.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:59917 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239Ab2KNH5X (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:57:23 -0500
In-Reply-To: <20121113.171515.552672146557270042.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 13 Nov 2012, David Miller wrote:

> From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> Date: Tue, 13 Nov 2012 21:17:36 +0100
> 
> > 
> > Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> > ---
> >  include/linux/inetdevice.h |    2 ++
> >  include/linux/netdevice.h  |    1 +
> >  net/ipv4/fib_trie.c        |   18 ++++++++++++++++++
> >  3 files changed, 21 insertions(+), 0 deletions(-)
> 
> A change like this needs to be reviewed on netdev, not
> netfilter-devel

Yes, of course. I just wanted to put together a possible real solution 
which we could discuss further.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
