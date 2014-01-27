From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH RESEND v2 1/1] netfilter: xtables: add quota support to
 nfacct
Date: Mon, 27 Jan 2014 17:44:20 +0100
Message-ID: <20140127164420.GA8666@localhost>
References: <1390766673-21444-1-git-send-email-mathieu.poirier@linaro.org>
 <1390766673-21444-2-git-send-email-mathieu.poirier@linaro.org>
 <20140126230231.GA29022@breakpoint.cc>
 <CANLsYkxaBuQz2-Bos+mE1YYXY9AbXX6HxLEGO9xgYGnKU9RXGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, kaber <kaber@trash.net>,
	kadlec <kadlec@blackhole.kfki.hu>,
	netfilter-devel@vger.kernel.org,
	John Stultz <john.stultz@linaro.org>
To: Mathieu Poirier <mathieu.poirier@linaro.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50003 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753810AbaA0Qoa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 27 Jan 2014 11:44:30 -0500
Content-Disposition: inline
In-Reply-To: <CANLsYkxaBuQz2-Bos+mE1YYXY9AbXX6HxLEGO9xgYGnKU9RXGA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 27, 2014 at 08:35:38AM -0700, Mathieu Poirier wrote:
> On 26 January 2014 16:02, Florian Westphal <fw@strlen.de> wrote:
> > mathieu.poirier@linaro.org <mathieu.poirier@linaro.org> wrote:
> >
> > [ removed netfilter@ from CC ]
> >
> >> Adding packet and byte quota support.  Once a quota has been
> >> reached a noticifaction is sent to user space that includes
> >> the name of the accounting object along with the current byte
> >> and packet count.
> >>
> >> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> >> diff --git a/include/uapi/linux/netfilter/xt_nfacct.h b/include/uapi/linux/netfilter/xt_nfacct.h
> >> index 3e19c8a..d38104f 100644
> >> --- a/include/uapi/linux/netfilter/xt_nfacct.h
> >> +++ b/include/uapi/linux/netfilter/xt_nfacct.h
> >> @@ -3,11 +3,25 @@
> >>
> >> +struct xt_nfacct_match_info_v1 {
> >> +     char            name[NFACCT_NAME_MAX];
> >> +     struct nf_acct  *nfacct;
> >> +
> >> +     __u32 flags;
> >> +     __aligned_u64 quota;
> >> +     struct nf_acct_quota    *priv;
> >> +};
> >
> > I think that pointers should be aligned to 8-byte boundary, else
> > this can cause issues with 32-bit-userspace-on-64-bit-kernel.
> 
> Something like  "struct nf_acct_quota    *priv __attribute__((aligned(8)));" ?

If you follow this approach yes. I told you already:

http://permalink.gmane.org/gmane.comp.security.firewalls.netfilter.devel/50191

but for whatever reason this was ignored, so please make an effort to
address all comments.

Thank you.
