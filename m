From: "Gao Feng" <gfree.wind@foxmail.com>
Subject: RE: [PATCH nf 1/1] netfilter: expect: Make sure the max_expected limit is effective
Date: Fri, 24 Mar 2017 21:12:21 +0800
Message-ID: <000c01d2a4a0$45b777e0$d12667a0$@foxmail.com>
References: <1490319517-47760-1-git-send-email-gfree.wind@foxmail.com> <20170324114325.GA2397@salvia>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>
To: "'Pablo Neira Ayuso'" <pablo@netfilter.org>,
        <gfree.wind@foxmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbg298.qq.com ([184.105.67.102]:54551 "EHLO smtpbg298.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751477AbdCXNTd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Mar 2017 09:19:33 -0400
In-Reply-To: <20170324114325.GA2397@salvia>
Content-Language: zh-cn
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

> -----Original Message-----
> From: Pablo Neira Ayuso [mailto:pablo@netfilter.org]
> Sent: Friday, March 24, 2017 7:43 PM
> To: gfree.wind@foxmail.com
> Cc: netfilter-devel@vger.kernel.org; Gao Feng <fgao@ikuai8.com>
> Subject: Re: [PATCH nf 1/1] netfilter: expect: Make sure the max_expected
limit
> is effective
> 
> On Fri, Mar 24, 2017 at 09:38:37AM +0800, gfree.wind@foxmail.com wrote:
> > From: Gao Feng <fgao@ikuai8.com>
> >
> > Because the type of expecting, the member of nf_conn_help, is u8, it
> > would overflow after reach U8_MAX(255). So it doesn't work when we
> > configure the max_expected exceeds 255 with expect policy.
> >
> > Now add the check for max_expected. Return the -EINVAL when it exceeds
> > the limit.
> >
> > Signed-off-by: Gao Feng <fgao@ikuai8.com>
> > ---
> >  include/net/netfilter/nf_conntrack_expect.h | 1 +
> >  net/netfilter/nf_conntrack_helper.c         | 3 +++
> >  net/netfilter/nfnetlink_cthelper.c          | 4 ++++
> >  3 files changed, 8 insertions(+)
> >
> > diff --git a/include/net/netfilter/nf_conntrack_expect.h
> > b/include/net/netfilter/nf_conntrack_expect.h
> > index 5ed33ea..aa36a31 100644
> > --- a/include/net/netfilter/nf_conntrack_expect.h
> > +++ b/include/net/netfilter/nf_conntrack_expect.h
> > @@ -71,6 +71,7 @@ struct nf_conntrack_expect_policy {  };
> >
> >  #define NF_CT_EXPECT_CLASS_DEFAULT	0
> > +#define NF_CT_EXPECT_MAX_CNT		U8_MAX
> 
> use NF_CT_EXPECT_MAX. We will expose this to userspace at some point now
> that we have infrastructure to configure helpers from nft (Florian's work
> already in nf-next) so use 255 instead of U8_MAX is fine.
> 
> >  int nf_conntrack_expect_pernet_init(struct net *net);  void
> > nf_conntrack_expect_pernet_fini(struct net *net); diff --git
> > a/net/netfilter/nf_conntrack_helper.c
> > b/net/netfilter/nf_conntrack_helper.c
> > index 6dc44d9..752a977 100644
> > --- a/net/netfilter/nf_conntrack_helper.c
> > +++ b/net/netfilter/nf_conntrack_helper.c
> > @@ -385,6 +385,9 @@ int nf_conntrack_helper_register(struct
> nf_conntrack_helper *me)
> >  	BUG_ON(me->expect_class_max >= NF_CT_MAX_EXPECT_CLASSES);
> >  	BUG_ON(strlen(me->name) > NF_CT_HELPER_NAME_LEN - 1);
> >
> > +	if (me->expect_policy->max_expected > NF_CT_EXPECT_MAX_CNT)
> > +		return -EINVAL;
> 
> I swear this is also exposed through modparams, right? So this patch may
be
> missing something.

I thought it could be covered by nf_conntrack_helper_register, it would
return error when modparam specifies one invalid max_expected.
So I didn't check the modparam before.

Now I think you are right. It is clear to report one error by checking the
modparam.
I would send the v2 patch.
There is only one case. This is the nf_conntrack_irc.c.

Best Regards
Feng


