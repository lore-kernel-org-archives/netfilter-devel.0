From: "Gao Feng" <gfree.wind@foxmail.com>
Subject: RE: [PATCH nf 1/1] netfilter: cttimeout: Fix one possible use-after-free issue
Date: Fri, 14 Apr 2017 06:35:13 +0800
Message-ID: <001101d2b4a6$37cbce40$a7636ac0$@foxmail.com>
References: <1491476949-92872-1-git-send-email-gfree.wind@foxmail.com> <20170413214756.GA3960@salvia>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>
To: "'Pablo Neira Ayuso'" <pablo@netfilter.org>,
        <gfree.wind@foxmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbg65.qq.com ([103.7.28.233]:49935 "EHLO smtpbg65.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751248AbdDMWfR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Apr 2017 18:35:17 -0400
In-Reply-To: <20170413214756.GA3960@salvia>
Content-Language: zh-cn
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> -----Original Message-----
> From: Pablo Neira Ayuso [mailto:pablo@netfilter.org]
> On Thu, Apr 06, 2017 at 07:09:09PM +0800, gfree.wind@foxmail.com wrote:
> >
> > The function ctnl_untimeout is used to untimeout every conntrack which
> > is using the timeout. But it is necessary to add one barrier
> > synchronize_rcu because of racing. Maybe one conntrack has already
> > owned this timeout, but it is not inserted into unconfirmed list or
> > the hash list, when ctnl_untimeout untimeout the conntracks
> 
> This object is released via kfree_rcu().
> 
> You have to describe better the race scenario.

Let me describe it with a call path
CPU1     			                  CPU2
alloc new conn
add timeout ext
	
ctnl_timeout_try_del
                                   untimeout all conns in list
	
kfree_rcu.
conn is confirmed.

As the show above, when cpu2 untimeout all conns in list, the new conn of
cpu1
is not confirmed. The new conn still owns the timeout pointer. After the
timeout
mem is freed really, it points to one invalid mem.

Regards
Feng




