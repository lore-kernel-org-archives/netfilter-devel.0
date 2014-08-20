From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH] Rename xfree() to libnftnl_xfree() to avoid
 symbol naming conflict
Date: Wed, 20 Aug 2014 15:22:13 +0200
Message-ID: <20140820132213.GA7106@salvia>
References: <1408196389-15559-1-git-send-email-thomas.petazzoni@free-electrons.com>
 <20140819220236.GA7136@salvia>
 <alpine.LSU.2.11.1408201459330.23974@nerf08.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49644 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703AbaHTNVk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Aug 2014 09:21:40 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1408201459330.23974@nerf08.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 20, 2014 at 03:00:18PM +0200, Jan Engelhardt wrote:
> On Wednesday 2014-08-20 00:02, Pablo Neira Ayuso wrote:
> 
> >On Sat, Aug 16, 2014 at 03:39:49PM +0200, Thomas Petazzoni wrote:
> >> [...] the xfree() symbols of libnftnl
> >> becomes visible to the outside world, causing a conflict with the
> >> xfree() symbol defined by nftables.
> >> 
> >> To solve this, this patch renames the libnftnl xfree() function to
> >> libnftnl_xfree().
> >
> >Would this small patch solve your problem too?
> >
> >[non-inline attachment]
> 
> It would, but why add the redundant cast?

free() makes gcc spot a warning when called with const objects.
