From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: have r->cost != 0 case work
Date: Wed, 26 Sep 2012 01:27:39 +0200
Message-ID: <20120925232739.GB12349@1984>
References: <alpine.LNX.2.01.1209221003280.3512@nerf07.vanv.qr>
 <1348302412-2811-1-git-send-email-jengelh@inai.de>
 <20120925143915.GA9091@1984>
 <alpine.LNX.2.01.1209251648570.12652@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net,
	jrobinson@infoblox.com
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38395 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732Ab2IYX1s (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Sep 2012 19:27:48 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1209251648570.12652@nerf07.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Sep 25, 2012 at 04:52:32PM +0200, Jan Engelhardt wrote:
> On Tuesday 2012-09-25 16:39, Pablo Neira Ayuso wrote:
> >On Sat, Sep 22, 2012 at 10:26:52AM +0200, Jan Engelhardt wrote:
> >> Commit v2.6.19-rc1~1272^2~41 tells us that r->cost != 0 can happen when
> >> a running state is saved to userspace and then reinstated from there.
> >> 
> >> Make sure that priv is initialized with some values when that happens.
> >
> >Just to clarify: With this patch, we go back to the situation in which
> >the state is reset on unrelated rule updates, right?
> 
> Before this patch, when userspace updated a rule, random things 
> would happen on matching due to use of uninitialized memory.

I know that ;-)

> Now, the values are initialized, and implies that the credit is reset on 
> table update.

This is what I wanted to confirm. Thanks Jan.

I'll pass this to David. Let's see if we can get this into 3.6-rc.
