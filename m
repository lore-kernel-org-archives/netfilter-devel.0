From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3] nfnetlink_queue: add security context information
Date: Wed, 27 May 2015 14:49:57 +0200
Message-ID: <20150527124957.GA19819@salvia>
References: <5562F661.5000503@samsung.com>
 <20150525131319.GA3529@salvia>
 <55634935.4020100@samsung.com>
 <20150525205210.GG3629@breakpoint.cc>
 <55646731.9040803@samsung.com>
 <20150526130623.GD7817@breakpoint.cc>
 <5565A4D2.70701@samsung.com>
 <5565A6AA.90908@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	=?utf-8?B?UmFmYcWC?= Krypa <r.krypa@samsung.com>
To: Roman Kubiak <r.kubiak@samsung.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44298 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795AbbE0Mo4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 May 2015 08:44:56 -0400
Content-Disposition: inline
In-Reply-To: <5565A6AA.90908@samsung.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, May 27, 2015 at 01:12:42PM +0200, Roman Kubiak wrote:
> I think i forgot to mention one important thing the function:
> security_sk_getsecid is not in the kernel yet, i posted a patch to
> add it on the linux-security-module mailing list:
> http://marc.info/?t=143254934900006&r=1&w=2

You shouldn't split the patches between several lists, they are
interdependent and without that context it is normal that people don't
understand your intentions.

So please send the full patchset, Cc'ing the relevant lists so we can
get feedback from both the netfilter and the linux-security
communities.

BTW, another minor nitpick below:

> > diff --git a/net/netfilter/nfnetlink_queue_core.c b/net/netfilter/nfnetlink_queue_core.c
> > index 0b98c74..ae4f520 100644
> > --- a/net/netfilter/nfnetlink_queue_core.c
> > +++ b/net/netfilter/nfnetlink_queue_core.c
> > @@ -278,6 +278,24 @@ nla_put_failure:
> >  	return -1;
> >  }
> >  
> > +static u32 nfqnl_get_sk_secctx(struct sock *sk, char **secdata)
> > +{
> > +	u32 secid = 0;
> > +	u32 seclen = 0;

Merge these two variable declarations in one line.

Thanks.
