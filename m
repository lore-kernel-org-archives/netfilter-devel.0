From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 7/7] extensions: libip6t_dst: make inversion work
Date: Thu, 19 Feb 2015 14:37:21 +0100
Message-ID: <20150219133721.GB24297@breakpoint.cc>
References: <1424351483-27617-1-git-send-email-fw@strlen.de>
 <1424351483-27617-8-git-send-email-fw@strlen.de>
 <alpine.LSU.2.11.1502191432250.27892@nerf60.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:58529 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752894AbbBSNhW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Feb 2015 08:37:22 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1502191432250.27892@nerf60.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt <jengelh@inai.de> wrote:
> On Thursday 2015-02-19 14:11, Florian Westphal wrote:
> 
> >The inversion flag wasn't set in the match struct.
> 
> The documentation needs to be updated too.
> 
> It reflected what source code did: not supportting the "!" option at 
> all/silently ignoring it.

Interesting, --help does mention it:
dst match options:
[!] --dst-len length            total length of this header

So, whats the desired action?

Given that the kernel already supports it (on kernel side its
a module alias for hop-by-hop match) I'd vote for just also updating
the man page snippet to mention ! as well, since it seems like artifical
restriction.
