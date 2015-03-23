From: Laurent Bercot <ska-devel@skarnet.org>
Subject: Re: [PATCH libnftnl] src: restore static array with expression operations
Date: Mon, 23 Mar 2015 15:58:07 +0100
Message-ID: <551029FF.2070300@skarnet.org>
References: <1427111052-5510-1-git-send-email-pablo@netfilter.org> <20150323114411.GH603@acer.localdomain> <20150323123400.GA6511@salvia> <20150323130805.GN603@acer.localdomain> <5510135A.9020809@skarnet.org> <20150323133306.GW603@acer.localdomain> <551016FD.1020909@skarnet.org> <20150323135432.GX603@acer.localdomain> <551020D6.2080502@skarnet.org> <20150323145011.GC603@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.tech.numericable.fr ([82.216.111.38]:35356 "EHLO
	smtp2.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499AbbCWO6G (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Mar 2015 10:58:06 -0400
In-Reply-To: <20150323145011.GC603@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 23/03/2015 15:50, Patrick McHardy wrote:
> I would be surprised if the alternative provides a much smaller
> binary. Basically everything is referenced through the registered
> structures and functions called from there. I don't think it
> makes any difference.

  It's the case for now, but it might not be in the future. Else,
why keep libnftnl as a separate package from nftables?


> Well, we would like to keep the callbacks. We can continue to
> look for a different solution. But either way you will have
> tons of potentially unused functions in there since the library
> resolves a lot of things at runtime.

  I understand that, and don't mind the current 600k that much.
I am opposed to linking with --whole-archive on principle, but
I'll take any other solution that suits you. Any *clean* solution,
I mean. ;)

-- 
  Laurent

