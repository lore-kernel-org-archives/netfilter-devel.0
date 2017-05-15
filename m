From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] ebtables: arpreply: Add the standard target sanity
 check
Date: Mon, 15 May 2017 18:56:59 +0200
Message-ID: <20170515165659.GA4254@salvia>
References: <1494582250-120912-1-git-send-email-gfree.wind@vip.163.com>
 <20170515165602.GA4018@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kadlec@blackhole.kfki.hu, fw@strlen.de,
        netfilter-devel@vger.kernel.org
To: gfree.wind@vip.163.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:54678 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932514AbdEOQ5E (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 May 2017 12:57:04 -0400
Content-Disposition: inline
In-Reply-To: <20170515165602.GA4018@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, May 15, 2017 at 06:56:02PM +0200, Pablo Neira Ayuso wrote:
> On Fri, May 12, 2017 at 05:44:10PM +0800, gfree.wind@vip.163.com wrote:
> > From: Gao Feng <gfree.wind@vip.163.com>
> > 
> > The info->target is from userspace and it would be used directly.
> > So we need to add the sanity check to make sure it is a valid standard
> > target, although the ebtables tool has already checked it. Kernel need
> > to check anything from userspace.
> > 
> > If the target was set as an evil value, it would break the ebtables
> > and cause a panic. Because the non-standard target is treated as one
> > offset.
> > 
> > Signed-off-by: Gao Feng <gfree.wind@vip.163.com>
> > ---
> >  net/bridge/netfilter/ebt_arpreply.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/net/bridge/netfilter/ebt_arpreply.c b/net/bridge/netfilter/ebt_arpreply.c
> > index 5929309..c4886d9 100644
> > --- a/net/bridge/netfilter/ebt_arpreply.c
> > +++ b/net/bridge/netfilter/ebt_arpreply.c
> > @@ -68,6 +68,9 @@ static int ebt_arpreply_tg_check(const struct xt_tgchk_param *par)
> >  	if (e->ethproto != htons(ETH_P_ARP) ||
> >  	    e->invflags & EBT_IPROTO)
> >  		return -EINVAL;
> > +	if (INVALID_TARGET)
> 
> Please, add:
> 
> static inline bool ebt_invalid_target(int target)
> {
>         return (target < -NUM_STANDARD_TARGETS || target >= 0);
> }
> 
> and use it in this fix.
> 
> So we can get rid of this obscure INVALID_TARGET macro.

Once this propagates to nf-next.git, you can send a follow up patch to
use this new function from more spots, so we can kill INVALID_TARGET
for good.
