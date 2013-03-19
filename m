From: Holger Eitzenberger <holger@eitzenberger.org>
Subject: Re: [PATCH RFC 1/3] NFQUEUE: introduce CPU fanout
Date: Tue, 19 Mar 2013 21:17:12 +0100
Message-ID: <20130319201712.GD13505@imap.eitzenberger.org>
References: <20130319141442.150005875@eitzenberger.org>
 <20130319141605.158831637@eitzenberger.org>
 <20130319195607.GL7938@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:52603 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933105Ab3CSURV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Mar 2013 16:17:21 -0400
Content-Disposition: inline
In-Reply-To: <20130319195607.GL7938@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> > +struct xt_NFQ_info_v3 {
> > +	__u16 queuenum;
> > +	__u16 queues_total;
> > +	__u16 bypass;
> > +	__u16 flags;
> > +#define NFQ_FLAG_CPU_FANOUT		0x01 /* use current CPU (no hashing) */
> > +};
> 
> minor nit:
> 'bypass' could be folded into 'flags' via a '#define NFQ_FLAG_BYPASS'.

Yes, but I still need the new revision.  Thanks.

