From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC] [PATCH 4/4] netfilter: Enable fail-open
Date: Mon, 7 May 2012 11:04:51 +0200
Message-ID: <20120507090451.GB27650@1984>
References: <20120507060338.19528.29403.sendpatchset@localhost.localdomain>
 <20120507060422.19528.20723.sendpatchset@localhost.localdomain>
 <20120507075647.GA5015@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Krishna Kumar <krkumar2@in.ibm.com>,
	netfilter-devel@vger.kernel.org, svajipay@in.ibm.com,
	vivk@us.ibm.com, sri@us.ibm.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33823 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755939Ab2EGJE6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 May 2012 05:04:58 -0400
Content-Disposition: inline
In-Reply-To: <20120507075647.GA5015@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, May 07, 2012 at 09:56:47AM +0200, Florian Westphal wrote:
> Krishna Kumar <krkumar2@in.ibm.com> wrote:
> > Define xt_NFQ_info_v3 to get fail-open argument from iptables. Also
> > enable FAIL_OPEN.
> > 
> > Signed-off-by: Krishna Kumar <krkumar2@in.ibm.com>
> > diff -ruNp org/include/linux/netfilter/xt_NFQUEUE.h new/include/linux/netfilter/xt_NFQUEUE.h
> > --- org/include/linux/netfilter/xt_NFQUEUE.h	2012-05-07 10:17:28.117870787 +0530
> > +++ new/include/linux/netfilter/xt_NFQUEUE.h	2012-05-07 09:20:53.783813702 +0530
> > @@ -26,4 +26,11 @@ struct xt_NFQ_info_v2 {
> >  	__u16 bypass;
> >  };
> >  
> > +struct xt_NFQ_info_v3 {
> > +	__u16 queuenum;
> > +	__u16 queues_total;
> > +	__u16 bypass;
> > +	__u16 fail_open;
> > +};
> 
> Minor nit:
> 
> This shouldn't be necessary; bypass is always 0 or 1.
> You could just rename it to "options" or something
> like that.  Would also mean that you could have the v2 target
> revision use the same target callback as v3 (since struct layout would
> be the same).

Yes, something like "flags" can make it.

Where flag (1 << 0) is bypass to ensure backward compatibility.
