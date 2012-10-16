From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] Netfilter/IPVS updates for stable 3.4 onwards
Date: Tue, 16 Oct 2012 09:31:41 -0700
Message-ID: <20121016163141.GA4777@kroah.com>
References: <1349950658-12548-1-git-send-email-pablo@netfilter.org>
 <20121015231857.GA2118@kroah.com>
 <20121016090429.GA15577@1984>
 <20121016143834.GA6490@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stable@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62512 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755145Ab2JPQbq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Oct 2012 12:31:46 -0400
Received: by mail-pa0-f46.google.com with SMTP id hz1so6075839pad.19
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Oct 2012 09:31:45 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20121016143834.GA6490@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Oct 16, 2012 at 04:38:34PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Oct 16, 2012 at 11:04:29AM +0200, Pablo Neira Ayuso wrote:
> > On Mon, Oct 15, 2012 at 04:18:57PM -0700, Greg KH wrote:
> > > On Thu, Oct 11, 2012 at 12:17:35PM +0200, pablo@netfilter.org wrote:
> > > > From: Pablo Neira Ayuso <pablo@netfilter.org>
> > > > 
> > > > Hi!
> > > > 
> > > > The following patchset contain fixes for stable 3.4 onwards.
> > > > 
> > > > The selected three patches are:
> > > > 
> > > > 283283c ipvs: fix oops in ip_vs_dst_event on rmmod
> > > > 66b6aaf netfilter: nf_conntrack: fix racy timer handling with reliable events
> > > 
> > > Where did this git commit id come from?  It's really
> > > 5b423f6a40a0327f9d40bc8b97ce9be266f74368 in Linus's tree.
> > 
> > Indeed, really sorry for the bogus commit id. I don't know how that
> > commit id has slipped through.
> 
> Should I resubmit or will you pick it?

I already picked it up and you should have the email saying it was
applied in your inbox, right?

thanks,

greg k-h
