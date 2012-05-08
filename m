From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] libxt_hashlimit: add support for byte-based operation
Date: Tue, 8 May 2012 16:21:34 +0200
Message-ID: <20120508142134.GH5015@breakpoint.cc>
References: <1336483012-12169-1-git-send-email-fw@strlen.de>
 <alpine.LNX.2.01.1205081523540.6920@frira.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:52349 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755881Ab2EHOVf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 May 2012 10:21:35 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1205081523540.6920@frira.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt <jengelh@inai.de> wrote:
> On Tuesday 2012-05-08 15:16, Florian Westphal wrote:
> 
> > I've re-used the existing options. For example,
> > --hashlimit-mode srcip,dstip,srcport,dstport --hashlimit\-above 512kb/s would
> > match when the flow exceeded 512kbytes per second.
> >
> > Similarily, the --hashlimit-burst parameter now either a number (packetcount)
> > number, or a "byte" suffix, e.g. "--hashlimit-burst 1mb".
> >
> > If you believe that we should introduce new options instead, please
> > let me know and I'll re-spin the patch.
> 
> libxt_rateest also deals with rate suffixes, so it would seem to be 
> worthwhile to investigate a new option type.

Good point, it would indeed be nice to avoid code duplication.
I'll look into it, thanks for pointing this out.
