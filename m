From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 5/7] netfilter: ebtables: add CONFIG_COMPAT support
Date: Fri, 5 Feb 2010 14:52:26 +0100
Message-ID: <20100205135226.GA21611@Chamillionaire.breakpoint.cc>
References: <1265334195-28120-1-git-send-email-fw@strlen.de>
 <1265334195-28120-6-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:54747 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932444Ab0BENw1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Feb 2010 08:52:27 -0500
Received: id: fw by Chamillionaire.breakpoint.cc with local
	(easymta 1.00 BETA 1)
	id 1NdObi-0006A2-GY
	for netfilter-devel@vger.kernel.org; Fri, 05 Feb 2010 14:52:26 +0100
Content-Disposition: inline
In-Reply-To: <1265334195-28120-6-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal <fw@strlen.de> wrote:
> remaining problem:
> 
> The ebtables userland makefile has:
> ifeq ($(shell uname -m),sparc64)
> 	CFLAGS+=-DEBT_MIN_ALIGN=8 -DKERNEL_64_USERSPACE_32
> endif
> 
> struct ebt_replace, ebt_entry_match etc. then contain userland-side
> padding -- this means, if this is actually used in production --
> that even if we are called from a 32 bit userland, the structures
> may already be in the right format.
> 
> One possible solution would be to try to handle compat_* calls via
> the native handler and then fall back to the compat one if it fails,
> but it will cause kernel warnings like:
> kernel msg: ebtables bug: please report to author: Wrong size
> 
> Thus this is not done here.
> 
> I am not sure if this "userland-padding" is widely used; it looks
> incomplete (eg. I couldn't find any
> userland-padding for match/target structures; and some (eg. mark)
> do need special handling).

Just for the record:

Jan Engelhardt was so kind to try "-j mark" with the 32bit
sparc ebtables userland and reported that it is not working.

So I am not sure if I should bother with supporting the "already padded"
userland scenario, as it won't work in some cases anyway.
