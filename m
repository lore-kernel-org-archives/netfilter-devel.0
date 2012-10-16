From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] Netfilter/IPVS updates for stable 3.4 onwards
Date: Tue, 16 Oct 2012 11:04:29 +0200
Message-ID: <20121016090429.GA15577@1984>
References: <1349950658-12548-1-git-send-email-pablo@netfilter.org>
 <20121015231857.GA2118@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stable@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55359 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752377Ab2JPJEm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Oct 2012 05:04:42 -0400
Content-Disposition: inline
In-Reply-To: <20121015231857.GA2118@kroah.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Oct 15, 2012 at 04:18:57PM -0700, Greg KH wrote:
> On Thu, Oct 11, 2012 at 12:17:35PM +0200, pablo@netfilter.org wrote:
> > From: Pablo Neira Ayuso <pablo@netfilter.org>
> > 
> > Hi!
> > 
> > The following patchset contain fixes for stable 3.4 onwards.
> > 
> > The selected three patches are:
> > 
> > 283283c ipvs: fix oops in ip_vs_dst_event on rmmod
> > 66b6aaf netfilter: nf_conntrack: fix racy timer handling with reliable events
> 
> Where did this git commit id come from?  It's really
> 5b423f6a40a0327f9d40bc8b97ce9be266f74368 in Linus's tree.

Indeed, really sorry for the bogus commit id. I don't know how that
commit id has slipped through.

Thanks.
