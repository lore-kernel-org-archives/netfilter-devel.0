From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next 1/2] netfilter: kill the fake untracked conntrack
 objects
Date: Sat, 15 Apr 2017 11:43:15 +0200
Message-ID: <20170415094315.GA1707@breakpoint.cc>
References: <20170414183109.25285-1-fw@strlen.de>
 <20170415092131.GA4810@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:56906 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752028AbdDOJoY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 15 Apr 2017 05:44:24 -0400
Content-Disposition: inline
In-Reply-To: <20170415092131.GA4810@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Hi Florian,
> 
> On Fri, Apr 14, 2017 at 08:31:08PM +0200, Florian Westphal wrote:
> [...]
> > resurrect an old patch from Pablo Neira to remove the untracked objects.
> 
> Thanks for doing so :)
> 
> > diff --git a/include/uapi/linux/netfilter/nf_conntrack_common.h b/include/uapi/linux/netfilter/nf_conntrack_common.h
> > index 6a8e33dd4ecb..b4a0a1940118 100644
> > --- a/include/uapi/linux/netfilter/nf_conntrack_common.h
> > +++ b/include/uapi/linux/netfilter/nf_conntrack_common.h
> > @@ -28,12 +28,14 @@ enum ip_conntrack_info {
> >  	/* only for userspace compatibility */
> >  #ifndef __KERNEL__
> >  	IP_CT_NEW_REPLY = IP_CT_NUMBER,
> > +#else
> > +	IP_CT_UNTRACKED = 7,
> 
> This seems to be exposed via nfnetlink_queue conntrack support.

Yet another argument for removing this, its a bug.
(missing !nf_ct_is_untracked() check).

Probably should also check !nf_ct_is_template() there.

> > @@ -94,7 +96,7 @@ enum ip_conntrack_status {
> >  	IPS_TEMPLATE_BIT = 11,
> >  	IPS_TEMPLATE = (1 << IPS_TEMPLATE_BIT),
> >  
> > -	/* Conntrack is a fake untracked entry */
> > +	/* Conntrack is a fake untracked entry.  Obsolete and not used anymore */
> >  	IPS_UNTRACKED_BIT = 12,
> >  	IPS_UNTRACKED = (1 << IPS_UNTRACKED_BIT),
> 
> I wonder if we should just set this via ctnetlink, so the interface
> keeps stable. Even if we don't use this bit anymore. These are also
> exposed via ctnetlink CTA_STATUS.

Not following, sorry (still jetlagged).
ctnetlink_new_conntrack() always places the ct into the hashes, so its
not 'untracked'.

Setting and/or changing IPS_UNTRACKED_BIT via ctnetlink should be
disallowed.

Is that what you meant?

