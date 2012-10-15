From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 3/3] netfilter: ipset: timeout fixing bug broke SET
 target special timeout value
Date: Mon, 15 Oct 2012 16:27:50 -0700
Message-ID: <20121015232750.GA32665@kroah.com>
References: <1349950658-12548-1-git-send-email-pablo@netfilter.org>
 <1349950658-12548-4-git-send-email-pablo@netfilter.org>
 <20121015232225.GB2118@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stable@vger.kernel.org, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:34417 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754Ab2JOX1x (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Oct 2012 19:27:53 -0400
Received: by mail-da0-f46.google.com with SMTP id n41so2839917dak.19
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Oct 2012 16:27:53 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20121015232225.GB2118@kroah.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Oct 15, 2012 at 04:22:25PM -0700, Greg KH wrote:
> On Thu, Oct 11, 2012 at 12:17:38PM +0200, pablo@netfilter.org wrote:
> > From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> > 
> > The patch "127f559 netfilter: ipset: fix timeout value overflow bug"
> > broke the SET target when no timeout was specified.
> > 
> > Reported-by: Jean-Philippe Menil <jean-philippe.menil@univ-nantes.fr>
> > Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> > 
> > This patch requires:
> > 
> > commit 127f559127f5175e4bec3dab725a34845d956591
> > Author: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> > Date:   Mon May 7 02:35:44 2012 +0000
> > 
> >     netfilter: ipset: fix timeout value overflow bug
> >     
> >     Large timeout parameters could result wrong timeout values due to
> >     an overflow at msec to jiffies conversion (reported by Andreas Herz)
> 
> This patch doesn't apply to the 3.0.y series, care to provide a
> backport, and a backported version of the original patch above that
> needs it?

Oh wait, should I apply the 3.0.y specific patches first?  I'll go do
that and see if these two then apply here...

thanks,

greg k-h
