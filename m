From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH -nf v7] netfilter: nftables: add connlabel set support
Date: Thu, 5 May 2016 16:43:52 +0200
Message-ID: <20160505144352.GA25359@salvia>
References: <1461664793-22342-1-git-send-email-fw@strlen.de>
 <20160505115432.GA10879@salvia>
 <20160505135122.GA12977@breakpoint.cc>
 <20160505142830.GA16173@salvia>
 <20160505143543.GB12977@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40037 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757362AbcEEOn6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 May 2016 10:43:58 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 887FEC2B31
	for <netfilter-devel@vger.kernel.org>; Thu,  5 May 2016 16:43:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 7915B1B3008
	for <netfilter-devel@vger.kernel.org>; Thu,  5 May 2016 16:43:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E34A11B306A
	for <netfilter-devel@vger.kernel.org>; Thu,  5 May 2016 16:43:53 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160505143543.GB12977@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, May 05, 2016 at 04:35:43PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > OK, then I'm going to simplify this to make it look like:
> > 
> > +#ifdef CONFIG_NF_CONNTRACK_LABELS
> > +       case NFT_CT_LABELS:
> > +               nf_connlabels_replace(ct,
> > +                                     &regs->data[priv->sreg],
> > +                                     &regs->data[priv->sreg],
> > +                                     NF_CT_LABELS_MAX_SIZE / sizeof(u32));
> > +               break;
> > +#endif
> 
> I'm OK with this.

OK, pushed it out. Thanks for reviewing.
