From: "Gao Feng" <gfree.wind@foxmail.com>
Subject: RE: [PATCH nf v2] netfilter: cttimeout: Fix one possible use-after-free issue
Date: Fri, 14 Apr 2017 10:13:53 +0800
Message-ID: <001d01d2b4c4$c3e1f1c0$4ba5d540$@foxmail.com>
References: <1492132420-70400-1-git-send-email-gfree.wind@foxmail.com> <20170414012826.GA30669@salvia>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>
To: "'Pablo Neira Ayuso'" <pablo@netfilter.org>,
        <gfree.wind@foxmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbgbr2.qq.com ([54.207.22.56]:46706 "EHLO smtpbgbr2.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751438AbdDNCN6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Apr 2017 22:13:58 -0400
In-Reply-To: <20170414012826.GA30669@salvia>
Content-Language: zh-cn
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> From: Pablo Neira Ayuso [mailto:pablo@netfilter.org]
> On Fri, Apr 14, 2017 at 09:13:40AM +0800, gfree.wind@foxmail.com wrote:
> > From: Gao Feng <fgao@ikuai8.com>
> >
> > The function ctnl_untimeout is used to untimeout every conntrack which
> > is using the timeout. But it is necessary to add one barrier
> > synchronize_rcu because of racing. Maybe one conntrack has already
> > owned this timeout, but it is not inserted into unconfirmed list or
> > the hash list, when ctnl_untimeout untimeout the conntracks
> >
> > Let me describe it with a call path
> > CPU1				CPU2
> > alloc new conn
> > add timeout ext
> > 				ctnl_timeout_try_del
> > 				untimeout all conns in list
> > 				kfree_rcu.
> > conn is confirmed.
> 
> Then this confirmed conn gets a timeout_ext->timeout == NULL since
> ctnl_untimeout() is called first.

The new conn gets the timeout_ext->timeout before ctnl_untimeout, when add
the timeout ext.
Then ctnl_untimeout happens before the new conn is inserted into unconfirmed
list.
It could not reset the timeout pointer of new conn to NULL.
Maybe I should add the "insert unconfirm list" in the call path.

I could not understand why the conn gets one NULL pointer, not invalid
pointer in this case.

Regards
Feng




