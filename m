From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [Kernel Bug 86261] Ipset add/restore slowed to a crawl in kernel
 3.17 (and 3.17.1)
Date: Sun, 26 Oct 2014 21:48:51 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1410262145100.1717@blackhole.kfki.hu>
References: <5446AB11.1000807@redhat.com> <544C01B6.3050603@norring.dk> <alpine.DEB.2.10.1410261755280.528@blackhole.kfki.hu> <20141026201149.GA16147@casper.infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Kim N <spam1@norring.dk>, Daniel Borkmann <dborkman@redhat.com>,
	netfilter-devel@vger.kernel.org
To: Thomas Graf <tgraf@suug.ch>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:56805 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609AbaJZUsP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 26 Oct 2014 16:48:15 -0400
In-Reply-To: <20141026201149.GA16147@casper.infradead.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, 26 Oct 2014, Thomas Graf wrote:

> On 10/26/14 at 06:12pm, Jozsef Kadlecsik wrote:
> > 
> > According to my tests the slowdown in ipset (netlink) is caused by the 
> > patch:
> > 
> > commit e341694e3eb57fcda9f1adc7bfea42fe080d8d7a
> > Author: Thomas Graf <tgraf@suug.ch>
> > Date:   Sat Aug 2 11:47:45 2014 +0200
> > 
> >     netlink: Convert netlink_lookup() to use RCU protected hash table
> >     
> > Running the test provided in the report below in a KVM guest, the times 
> > spent in adding ~430 entries, saving, then restoring those
> 
> Thanks for tracking this down. I would assume that the following fix
> addresses the ipset regression as well:
> 
> commit 78fd1d0ab072d4d9b5f0b7c14a1516665170b565
> Author: Thomas Graf <tgraf@suug.ch>
> Date:   Tue Oct 21 22:05:38 2014 +0200
> 
>     netlink: Re-add locking to netlink_lookup() and seq walker
> 
>     The synchronize_rcu() in netlink_release() introduces unacceptable
>     latency. Reintroduce minimal lookup so we can drop the
>     synchronize_rcu() until socket destruction has been RCUfied.
> 
>     Cc: David S. Miller <davem@davemloft.net>
>     Cc: Eric Dumazet <eric.dumazet@gmail.com>
>     Reported-by: Steinar H. Gunderson <sgunderson@bigfoot.com>
>     Reported-and-tested-by: Heiko Carstens <heiko.carstens@de.ibm.com>
>     Signed-off-by: Thomas Graf <tgraf@suug.ch>
>     Signed-off-by: David S. Miller <davem@davemloft.net>

I'm going to test it tomorrow and report back to you the results. Thanks 
for the fast reply!

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
