From: "Gao Feng" <gfree.wind@foxmail.com>
Subject: RE: [PATCH nf v3 2/2] netfilter: helper: Fix possible panic caused by invoking expectfn unloaded
Date: Tue, 21 Mar 2017 22:20:59 +0800
Message-ID: <005001d2a24e$5cffea30$16ffbe90$@foxmail.com>
References: <cover.1490060879.git.fgao@ikuai8.com> <b30c3340a5b543d5544ced6aae5c7d585d423328.1490060879.git.fgao@ikuai8.com> <20170321141329.GA12171@salvia>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>, <gfree_wind@126.com>
To: "'Pablo Neira Ayuso'" <pablo@netfilter.org>, <fgao@ikuai8.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbg323.qq.com ([14.17.32.33]:57592 "EHLO smtpbg323.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932968AbdCUOdH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Mar 2017 10:33:07 -0400
In-Reply-To: <20170321141329.GA12171@salvia>
Content-Language: zh-cn
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

> -----Original Message-----
> From: netfilter-devel-owner@vger.kernel.org
> [mailto:netfilter-devel-owner@vger.kernel.org] On Behalf Of Pablo Neira
Ayuso
> Sent: Tuesday, March 21, 2017 10:13 PM
> To: fgao@ikuai8.com
> Cc: netfilter-devel@vger.kernel.org; gfree_wind@126.com
> Subject: Re: [PATCH nf v3 2/2] netfilter: helper: Fix possible panic
caused by
> invoking expectfn unloaded
> 
> On Tue, Mar 21, 2017 at 02:06:26PM +0800, fgao@ikuai8.com wrote:
> > From: Gao Feng <fgao@ikuai8.com>
> >
> > Because the conntrack NAT module could be rmmod anytime, so we should
> > really leave things in clean state if such thing happens and make sure
> > we don't leave any packet running over code that will be gone after
> > the removal.
> >
> > We only removed the expectations when unregister conntrack helper
before.
> > Actually it is necessary too when remove the nat helper.
> 
> We still need something like this, right?
Yes, we need to remove expect when remove helper and nat_helper.

> 
> diff --git a/net/netfilter/nf_nat_sip.c b/net/netfilter/nf_nat_sip.c index
> 791fac4fd745..38f1ed5219e4 100644
> --- a/net/netfilter/nf_nat_sip.c
> +++ b/net/netfilter/nf_nat_sip.c
> @@ -377,6 +377,7 @@ static unsigned int nf_nat_sip_expect(struct sk_buff
> *skb, unsigned int protoff,
>         exp->saved_proto.udp.port = exp->tuple.dst.u.udp.port;
>         exp->dir = !dir;
>         exp->expectfn = nf_nat_sip_expected;
> +       exp->nat_module = THIS_MODULE;
> 
>         for (; port != 0; port++) {
>                 int ret;
> 
> So if the user invokes:
> 
>         rmmod nf_nat_sip
> 
> we can get rid of this expectation from nf_ct_flush_expect().

Oh, I missed the data path, only covered the ctlink codes.
I would update the patch again.

Best Regards
Feng

> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel"
in the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html



