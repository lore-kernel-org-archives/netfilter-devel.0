From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 1/2] netfilter: kill the fake untracked conntrack
 objects
Date: Sat, 15 Apr 2017 11:47:32 +0200
Message-ID: <20170415094732.GA12119@salvia>
References: <20170414183109.25285-1-fw@strlen.de>
 <20170415092131.GA4810@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39804 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752028AbdDOJri (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 15 Apr 2017 05:47:38 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 42602E04C8
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Apr 2017 11:47:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 323A2DA871
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Apr 2017 11:47:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1111FDA848
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Apr 2017 11:47:31 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170415092131.GA4810@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Apr 15, 2017 at 11:21:31AM +0200, Pablo Neira Ayuso wrote:
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
> 
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

Forget this.

This patch is perfectly fine.

Applied, thanks Florian!
