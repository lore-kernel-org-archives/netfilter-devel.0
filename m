From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 5/7] netfilter: connlimit: use keyed locks
Date: Sun, 9 Mar 2014 19:31:35 +0100
Message-ID: <20140309183135.GB14012@breakpoint.cc>
References: <1394199435-14395-1-git-send-email-fw@strlen.de>
 <1394199435-14395-6-git-send-email-fw@strlen.de>
 <alpine.LSU.2.11.1403091809110.10040@nerf08.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:51221 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751304AbaCISbh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Mar 2014 14:31:37 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1403091809110.10040@nerf08.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt <jengelh@inai.de> wrote:
> On Friday 2014-03-07 14:37, Florian Westphal wrote:
> > 
> >+#define CONNLIMIT_SLOTS	256 /* power-of-two */
> >+#define CONNLIMIT_LOCK_SLOTS	32 /* power-of-two */
> 
> It's clear that 256 and 32 are powers of two. Or did you intend to
> write "these should be a power of two"? Which would then raise the
> question if they really need to be a power of two.

Right, the intent was to avoid mod instruction.

> 	BUILD_BUG_ON(CONNLIMIT_SLOTS % CONNLIMIT_LOCK_SLOTS != 0);

I like it.  Will change, thanks for suggesting this.
