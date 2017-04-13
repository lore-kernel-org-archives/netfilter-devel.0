From: "Gao Feng" <gfree.wind@foxmail.com>
Subject: RE: [PATCH nf 1/1] netfilter: seqadj: Fix possible non-linear data access for TCP header
Date: Fri, 14 Apr 2017 06:17:32 +0800
Message-ID: <001001d2b4a3$bf587500$3e095f00$@foxmail.com>
References: <1491820563-98023-1-git-send-email-gfree.wind@foxmail.com> <20170413213705.GA3430@salvia> <20170413214249.GA3612@salvia> <20170413214459.GA3936@salvia>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>, "'Gao Feng'" <fgao@ikuai8.com>
To: "'Pablo Neira Ayuso'" <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbgbr2.qq.com ([54.207.22.56]:58204 "EHLO smtpbgbr2.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756577AbdDMWRj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Apr 2017 18:17:39 -0400
In-Reply-To: <20170413214459.GA3936@salvia>
Content-Language: zh-cn
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> -----Original Message-----
> From: Pablo Neira Ayuso [mailto:pablo@netfilter.org]
> Sent: Friday, April 14, 2017 5:45 AM
> To: gfree.wind@foxmail.com
> Cc: netfilter-devel@vger.kernel.org; Gao Feng <fgao@ikuai8.com>
> Subject: Re: [PATCH nf 1/1] netfilter: seqadj: Fix possible non-linear
data access
> for TCP header
> 
> On Thu, Apr 13, 2017 at 11:42:49PM +0200, Pablo Neira Ayuso wrote:
> > On Thu, Apr 13, 2017 at 11:37:05PM +0200, Pablo Neira Ayuso wrote:
> > > On Mon, Apr 10, 2017 at 06:36:03PM +0800, gfree.wind@foxmail.com
> wrote:
> > > > From: Gao Feng <fgao@ikuai8.com>
> > > >
> > > > The current call path of nf_ct_tcp_seqadj_set is the following.
> > > >
> > > > nfqnl_recv_verdict->ctnetlink_glue_hook->ctnetlink_glue_seqadj
> > > > ->nf_ct_tcp_seqadj_set.
> > > >
> > > > It couldn't make sure the TCP header is in the linear data part.
> > > > So use the skb_header_pointer instead of the current codes.
> > > >
> > > > BTW, the nf_ct_tcp_seqadj_set is one external function of
> > > > netfilter which works in the network layer, it should not assume
> > > > the transport header is in the linear data.
> > >
> > > Applied.
> > >
> > > I wish you fix your mail client setup, it is a mess. I always have
> > > to figure out which patch is correct in the large bunch.  You have
> > > to be more careful.

Sorry, because I could not login the original gmail account sometimes.
So I have to change the email account, and select one which could support
text email well.

I find that his conversation is mess caused by different account of email
client.
And I tried to correct it with resending the patches.

> >
> > Wait, I'm dropping this.
> >
> > Caller already guarantee that this area has been skb_make_writable via
> > payload mangle, right?
> >
> > Please, have a closer look.

I find it is ok with your tip.
I only traced the call path "
nfnl_ct_hook->ctnetlink_glue_seqadj->nf_ct_tcp_seqadj_set " before.

Best Regards
Feng

> 
> BTW, please stop sending me patches until I review what I have in
patchwork
> from you.



