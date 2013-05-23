From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/3] netfilter: {ipt,ebt}_ULOG: rise warning on
 deprecation
Date: Thu, 23 May 2013 13:09:48 +0200
Message-ID: <20130523110948.GD22553@localhost>
References: <1369298557-5351-1-git-send-email-pablo@netfilter.org>
 <1369298557-5351-3-git-send-email-pablo@netfilter.org>
 <519DDA60.9050505@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Gao feng <gaofeng@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53084 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758123Ab3EWLJy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 May 2013 07:09:54 -0400
Content-Disposition: inline
In-Reply-To: <519DDA60.9050505@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, May 23, 2013 at 04:59:12PM +0800, Gao feng wrote:
> On 05/23/2013 04:42 PM, Pablo Neira Ayuso wrote:
> > This target has been superseded by NFLOG. Spot a warning
> > so we prepare removal in a couple of years.
> > 
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> >  include/net/netns/x_tables.h    |    6 ++++++
> >  net/bridge/netfilter/ebt_ulog.c |    6 ++++++
> >  net/ipv4/netfilter/Kconfig      |    2 +-
> >  net/ipv4/netfilter/ipt_ULOG.c   |    6 ++++++
> >  4 files changed, 19 insertions(+), 1 deletion(-)
> > 
> > diff --git a/include/net/netns/x_tables.h b/include/net/netns/x_tables.h
> > index c24060e..02fe40f 100644
> > --- a/include/net/netns/x_tables.h
> > +++ b/include/net/netns/x_tables.h
> > @@ -15,5 +15,11 @@ struct netns_xt {
> >  	struct ebt_table *frame_filter;
> >  	struct ebt_table *frame_nat;
> >  #endif
> > +#if IS_ENABLED(CONFIG_IP_NF_TARGET_ULOG)
> > +	bool ulog_warn_deprecated;
> > +#endif
> > +#if IS_ENABLED(CONFIG_BRIDGE_EBT_ULOG)
> > +	bool ebt_ulog_warn_deprecated;
> > +#endif
> >  };
> >  #endif
> > diff --git a/net/bridge/netfilter/ebt_ulog.c b/net/bridge/netfilter/ebt_ulog.c
> > index fc1905c..bfc40c7 100644
> > --- a/net/bridge/netfilter/ebt_ulog.c
> > +++ b/net/bridge/netfilter/ebt_ulog.c
> > @@ -267,6 +267,12 @@ static int ebt_ulog_tg_check(const struct xt_tgchk_param *par)
> >  {
> >  	struct ebt_ulog_info *uloginfo = par->targinfo;
> >  
> > +	if (!par->net->nf.ebt_ulog_warn_deprecated) {
> 
> par->net->xt.ebt_ulog_warn_deprecated?

Fixed and applied, thanks.
