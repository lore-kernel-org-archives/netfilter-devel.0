From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: have r->cost != 0 case work
Date: Wed, 26 Sep 2012 16:47:53 +0200
Message-ID: <20120926144753.GA11513@1984>
References: <alpine.LNX.2.01.1209221003280.3512@nerf07.vanv.qr>
 <1348302412-2811-1-git-send-email-jengelh@inai.de>
 <20120925143915.GA9091@1984>
 <alpine.LNX.2.01.1209251648570.12652@nerf07.vanv.qr>
 <20120925232739.GB12349@1984>
 <alpine.LNX.2.01.1209261526520.6984@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net,
	jrobinson@infoblox.com
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47013 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752879Ab2IZOr7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Sep 2012 10:47:59 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1209261526520.6984@nerf07.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Sep 26, 2012 at 03:28:27PM +0200, Jan Engelhardt wrote:
> 
> On Wednesday 2012-09-26 01:27, Pablo Neira Ayuso wrote:
> >
> >> Now, the values are initialized, and implies that the credit is reset on 
> >> table update.
> >
> >This is what I wanted to confirm. Thanks Jan.
> >
> >I'll pass this to David. Let's see if we can get this into 3.6-rc.
> 
> This would even be -stable material.

Yes. Likely that we missed 3.6-rc7, so David may pass this to -stable
himself.

I have a long queue of things to pass to -stable. My plan is to spend
time on getting things into it now that the merge window will be
closed.
