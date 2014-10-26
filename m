From: Thomas Graf <tgraf@suug.ch>
Subject: Re: [Kernel Bug 86261] Ipset add/restore slowed to a crawl in kernel
 3.17 (and 3.17.1)
Date: Sun, 26 Oct 2014 20:11:49 +0000
Message-ID: <20141026201149.GA16147@casper.infradead.org>
References: <5446AB11.1000807@redhat.com>
 <544C01B6.3050603@norring.dk>
 <alpine.DEB.2.10.1410261755280.528@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kim N <spam1@norring.dk>, Daniel Borkmann <dborkman@redhat.com>,
	netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:40821 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbaJZULw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 26 Oct 2014 16:11:52 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1410261755280.528@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 10/26/14 at 06:12pm, Jozsef Kadlecsik wrote:
> Hi Thomas,
> 
> According to my tests the slowdown in ipset (netlink) is caused by the 
> patch:
> 
> commit e341694e3eb57fcda9f1adc7bfea42fe080d8d7a
> Author: Thomas Graf <tgraf@suug.ch>
> Date:   Sat Aug 2 11:47:45 2014 +0200
> 
>     netlink: Convert netlink_lookup() to use RCU protected hash table
>     
> Running the test provided in the report below in a KVM guest, the times 
> spent in adding ~430 entries, saving, then restoring those

Hi Jozsef,

Thanks for tracking this down. I would assume that the following fix
addresses the ipset regression as well:

commit 78fd1d0ab072d4d9b5f0b7c14a1516665170b565
Author: Thomas Graf <tgraf@suug.ch>
Date:   Tue Oct 21 22:05:38 2014 +0200

    netlink: Re-add locking to netlink_lookup() and seq walker

    The synchronize_rcu() in netlink_release() introduces unacceptable
    latency. Reintroduce minimal lookup so we can drop the
    synchronize_rcu() until socket destruction has been RCUfied.

    Cc: David S. Miller <davem@davemloft.net>
    Cc: Eric Dumazet <eric.dumazet@gmail.com>
    Reported-by: Steinar H. Gunderson <sgunderson@bigfoot.com>
    Reported-and-tested-by: Heiko Carstens <heiko.carstens@de.ibm.com>
    Signed-off-by: Thomas Graf <tgraf@suug.ch>
    Signed-off-by: David S. Miller <davem@davemloft.net>
