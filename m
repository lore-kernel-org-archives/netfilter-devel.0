From: Greg KH <greg@kroah.com>
Subject: Re: [-stable-3.8.y 1/9] ipvs: ip_vs_sip_fill_param() BUG: bad check
 of return value
Date: Thu, 9 May 2013 13:38:26 -0700
Message-ID: <20130509203826.GA28362@kroah.com>
References: <1367881528-15524-1-git-send-email-pablo@netfilter.org>
 <20130508223642.GA6305@kroah.com>
 <20130508235302.GA15397@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, stable@vger.kernel.org,
	davem@davemloft.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60509 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754213Ab3EIUi2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 May 2013 16:38:28 -0400
Content-Disposition: inline
In-Reply-To: <20130508235302.GA15397@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, May 09, 2013 at 01:53:02AM +0200, Pablo Neira Ayuso wrote:
> On Wed, May 08, 2013 at 03:36:42PM -0700, Greg KH wrote:
> [...]
> > This should also go into other stable kernel releases as well, right?
> 
> Yes, that's a good idea. I was going to send you specific batches per
> branch though.

Ok, you can still do that, no objection from me.

thanks,

greg k-h
