From: "Gao Feng" <gfree.wind@foxmail.com>
Subject: RE: [PATCH nf-next 1/1] netfilter: ctlink: Return error directly when create expect without help
Date: Fri, 7 Apr 2017 06:19:07 +0800
Message-ID: <001801d2af23$cf669b50$6e33d1f0$@foxmail.com>
References: <1490665972-10967-1-git-send-email-gfree.wind@foxmail.com> <20170406195529.GA6653@salvia>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>, "'Gao Feng'" <fgao@ikuai8.com>
To: "'Pablo Neira Ayuso'" <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbgau1.qq.com ([54.206.16.166]:58609 "EHLO smtpbgau1.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752226AbdDFWTM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Apr 2017 18:19:12 -0400
In-Reply-To: <20170406195529.GA6653@salvia>
Content-Language: zh-cn
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

> -----Original Message-----
> From: Pablo Neira Ayuso [mailto:pablo@netfilter.org]
> Sent: Friday, April 7, 2017 3:55 AM
> To: gfree.wind@foxmail.com
> Cc: netfilter-devel@vger.kernel.org; Gao Feng <fgao@ikuai8.com>
> Subject: Re: [PATCH nf-next 1/1] netfilter: ctlink: Return error directly
when
> create expect without help
> 
> On Tue, Mar 28, 2017 at 09:52:52AM +0800, gfree.wind@foxmail.com wrote:
> > From: Gao Feng <fgao@ikuai8.com>
> >
> > The expect check func "__nf_ct_expect_check" asks the master_help is
> > necessary. So it is unnecessary to go ahead in ctnetlink_alloc_expect
> > when there is no help.
> >
> > Actually the commit bc01befdcf3e ("netfilter: ctnetlink: add support
> > for user-space expectation helpers") permits ctlink create one expect
> > even though there is no master help. But the latter commit
> > 3d058d7bc2c5
> > ("netfilter: rework user-space expectation helper support") disables
> > it again.
> 
> Probably reject this upfront if no nfct_help(ct) is there.
> 
> See patch attached.
Yes, it is better.
Would you apply this patch which you attached directly, or need I send
another v2 update?

Best Regards
Feng



