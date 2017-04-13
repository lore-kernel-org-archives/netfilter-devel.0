From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf 1/1] netfilter: cttimeout: Fix one possible
 use-after-free issue
Date: Fri, 14 Apr 2017 00:44:00 +0200
Message-ID: <20170413224400.GA5350@salvia>
References: <1491476949-92872-1-git-send-email-gfree.wind@foxmail.com>
 <20170413214756.GA3960@salvia>
 <001101d2b4a6$37cbce40$a7636ac0$@foxmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Gao Feng <gfree.wind@foxmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51324 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750735AbdDMWoX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Apr 2017 18:44:23 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E1E53BA716
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 00:44:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2AB7CDA725
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 00:44:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 74721DA725
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 00:44:19 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <001101d2b4a6$37cbce40$a7636ac0$@foxmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 14, 2017 at 06:35:13AM +0800, Gao Feng wrote:
> > -----Original Message-----
> > From: Pablo Neira Ayuso [mailto:pablo@netfilter.org]
> > On Thu, Apr 06, 2017 at 07:09:09PM +0800, gfree.wind@foxmail.com wrote:
> > >
> > > The function ctnl_untimeout is used to untimeout every conntrack which
> > > is using the timeout. But it is necessary to add one barrier
> > > synchronize_rcu because of racing. Maybe one conntrack has already
> > > owned this timeout, but it is not inserted into unconfirmed list or
> > > the hash list, when ctnl_untimeout untimeout the conntracks
> > 
> > This object is released via kfree_rcu().
> > 
> > You have to describe better the race scenario.
> 
> Let me describe it with a call path
> CPU1     			                  CPU2
> alloc new conn
> add timeout ext
> 	
> ctnl_timeout_try_del
>                                    untimeout all conns in list
> 	
> kfree_rcu.
> conn is confirmed.
> 
> As the show above, when cpu2 untimeout all conns in list, the new conn of
> cpu1
> is not confirmed. The new conn still owns the timeout pointer. After the
> timeout
> mem is freed really, it points to one invalid mem.

You add this to your patch description and resubmit.

Please, send me one patch or two maximum at a time. Until I don't
apply one, you don't send me a new one.
