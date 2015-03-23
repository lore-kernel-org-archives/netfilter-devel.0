From: Laurent Bercot <ska-devel@skarnet.org>
Subject: Re: [PATCH libnftnl] src: restore static array with expression operations
Date: Mon, 23 Mar 2015 15:19:02 +0100
Message-ID: <551020D6.2080502@skarnet.org>
References: <1427111052-5510-1-git-send-email-pablo@netfilter.org> <20150323114411.GH603@acer.localdomain> <20150323123400.GA6511@salvia> <20150323130805.GN603@acer.localdomain> <5510135A.9020809@skarnet.org> <20150323133306.GW603@acer.localdomain> <551016FD.1020909@skarnet.org> <20150323135432.GX603@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.tech.numericable.fr ([82.216.111.37]:45117 "EHLO
	smtp1.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182AbbCWOTA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Mar 2015 10:19:00 -0400
In-Reply-To: <20150323135432.GX603@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 23/03/2015 14:54, Patrick McHardy wrote:
> What does work is using
>
> -Wl,--whole-archive libnftnl.a -Wl,--no-whole-archive
>
> Not sure if we want to take this path, but it seems acceptable to
> me.

  I'm sorry, but that is not acceptable to me : it defeats
the purpose of static archives, and forces nft, and every
subsequent program using libnftnl, to include in its binary
every possible optional feature you may want to add to libnftnl.

  As a low-level networking utility, nft has its place on
embedded devices (which is my current case). The statically
linked binary for x86_64 (with musl) is already more than 600 kB,
stripped: that is huge. It's more than my whole busybox binary.
And that is with XML and JSON support entirely disabled.

  Risking further growth in an uncontrollable way just to use a
gcc-specific feature - which also prevents compiling it with
clang/llvm - doesn't sound like the right solution.

  As a user, Pablo's patch looks like a good fix to me.

-- 
  Laurent

