From: "Gao Feng" <gfree.wind@foxmail.com>
Subject: RE: [PATCH nf-next 1/1] netfilter: Use bool type instead of int as the return value of nf_conntrack_tuple_taken and nf_nat_used_tuple
Date: Mon, 27 Mar 2017 20:50:24 +0800
Message-ID: <000901d2a6f8$b402ac60$1c080520$@foxmail.com>
References: <1488860935-525-1-git-send-email-fgao@ikuai8.com> <20170327122443.GA25192@salvia>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>, <gfree.wind@gmail.com>
To: "'Pablo Neira Ayuso'" <pablo@netfilter.org>, <fgao@ikuai8.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbg302.qq.com ([184.105.206.27]:51425 "EHLO smtpbg302.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752145AbdC0Mug (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Mar 2017 08:50:36 -0400
In-Reply-To: <20170327122443.GA25192@salvia>
Content-Language: zh-cn
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> -----Original Message-----
> From: netfilter-devel-owner@vger.kernel.org
> [mailto:netfilter-devel-owner@vger.kernel.org] On Behalf Of Pablo Neira
Ayuso
> Sent: Monday, March 27, 2017 8:25 PM
> To: fgao@ikuai8.com
> Cc: netfilter-devel@vger.kernel.org; gfree.wind@gmail.com
> Subject: Re: [PATCH nf-next 1/1] netfilter: Use bool type instead of int
as the
> return value of nf_conntrack_tuple_taken and nf_nat_used_tuple
> 
> On Tue, Mar 07, 2017 at 12:28:55PM +0800, fgao@ikuai8.com wrote:
> > From: Gao Feng <fgao@ikuai8.com>
> >
> > These two functions return 1/0 as true or false, so it could use bool
> > type directly instead of int.
> 
> Too long patch subject.
Ok, I would make it shorter.
> 
> > Signed-off-by: Gao Feng <fgao@ikuai8.com>
> > ---
> >  include/net/netfilter/nf_conntrack.h | 2 +-
> >  include/net/netfilter/nf_nat.h       | 2 +-
> >  net/netfilter/nf_conntrack_core.c    | 6 +++---
> >  net/netfilter/nf_nat_core.c          | 2 +-
> >  4 files changed, 6 insertions(+), 6 deletions(-)
> >
> > diff --git a/include/net/netfilter/nf_conntrack.h
> > b/include/net/netfilter/nf_conntrack.h
> > index f540f9a..32a0394 100644
> > --- a/include/net/netfilter/nf_conntrack.h
> > +++ b/include/net/netfilter/nf_conntrack.h
> > @@ -160,7 +160,7 @@ void nf_conntrack_alter_reply(struct nf_conn *ct,
> >
> >  /* Is this tuple taken? (ignoring any belonging to the given
> >     conntrack). */
> > -int nf_conntrack_tuple_taken(const struct nf_conntrack_tuple *tuple,
> > +bool nf_conntrack_tuple_taken(const struct nf_conntrack_tuple *tuple,
> >  			     const struct nf_conn *ignored_conntrack);
> 
> Did you audit callers if they handle this type change accordingly? I don't
see
> any description about this on your patch.
I will add the caller description in the update patch.

Regards
Feng
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel"
in the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html

