From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] Netfilter/IPVS updates for stable 3.4 onwards
Date: Mon, 15 Oct 2012 16:22:52 -0700
Message-ID: <20121015232252.GC2118@kroah.com>
References: <1349950658-12548-1-git-send-email-pablo@netfilter.org>
 <20121011.182040.1246599647719150296.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:33688 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751798Ab2JOXWy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Oct 2012 19:22:54 -0400
Content-Disposition: inline
In-Reply-To: <20121011.182040.1246599647719150296.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 11, 2012 at 06:20:40PM -0400, David Miller wrote:
> From: pablo@netfilter.org
> Date: Thu, 11 Oct 2012 12:17:35 +0200
> 
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
> > a73f89a netfilter: ipset: timeout fixing bug broke SET target special timeout value [REQUIRES 127f559 netfilter: ipset: fix timeout value overflow bug]
> > 
> > Please, cherry-pick them. Thanks!
> 
> ACK

I've applied all 3 to the 3.4.y tree, and the first 2 to the 3.0.y tree.

thanks,

greg k-h
