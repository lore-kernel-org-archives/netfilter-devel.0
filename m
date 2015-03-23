From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH libnftnl] src: restore static array with expression
 operations
Date: Mon, 23 Mar 2015 14:50:11 +0000
Message-ID: <20150323145011.GC603@acer.localdomain>
References: <1427111052-5510-1-git-send-email-pablo@netfilter.org>
 <20150323114411.GH603@acer.localdomain>
 <20150323123400.GA6511@salvia>
 <20150323130805.GN603@acer.localdomain>
 <5510135A.9020809@skarnet.org>
 <20150323133306.GW603@acer.localdomain>
 <551016FD.1020909@skarnet.org>
 <20150323135432.GX603@acer.localdomain>
 <551020D6.2080502@skarnet.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Laurent Bercot <ska-devel@skarnet.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62397 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263AbbCWOuQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Mar 2015 10:50:16 -0400
Content-Disposition: inline
In-Reply-To: <551020D6.2080502@skarnet.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 23.03, Laurent Bercot wrote:
> On 23/03/2015 14:54, Patrick McHardy wrote:
> >What does work is using
> >
> >-Wl,--whole-archive libnftnl.a -Wl,--no-whole-archive
> >
> >Not sure if we want to take this path, but it seems acceptable to
> >me.
> 
>  I'm sorry, but that is not acceptable to me : it defeats
> the purpose of static archives, and forces nft, and every
> subsequent program using libnftnl, to include in its binary
> every possible optional feature you may want to add to libnftnl.
> 
>  As a low-level networking utility, nft has its place on
> embedded devices (which is my current case). The statically
> linked binary for x86_64 (with musl) is already more than 600 kB,
> stripped: that is huge. It's more than my whole busybox binary.
> And that is with XML and JSON support entirely disabled.

I would be surprised if the alternative provides a much smaller
binary. Basically everything is referenced through the registered
structures and functions called from there. I don't think it
makes any difference.

>  Risking further growth in an uncontrollable way just to use a
> gcc-specific feature - which also prevents compiling it with
> clang/llvm - doesn't sound like the right solution.
> 
>  As a user, Pablo's patch looks like a good fix to me.

Well, we would like to keep the callbacks. We can continue to
look for a different solution. But either way you will have
tons of potentially unused functions in there since the library
resolves a lot of things at runtime.
