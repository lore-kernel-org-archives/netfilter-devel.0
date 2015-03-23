From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH libnftnl] src: restore static array with expression
 operations
Date: Mon, 23 Mar 2015 13:54:33 +0000
Message-ID: <20150323135432.GX603@acer.localdomain>
References: <1427111052-5510-1-git-send-email-pablo@netfilter.org>
 <20150323114411.GH603@acer.localdomain>
 <20150323123400.GA6511@salvia>
 <20150323130805.GN603@acer.localdomain>
 <5510135A.9020809@skarnet.org>
 <20150323133306.GW603@acer.localdomain>
 <551016FD.1020909@skarnet.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Laurent Bercot <ska-devel@skarnet.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61991 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079AbbCWNyh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Mar 2015 09:54:37 -0400
Content-Disposition: inline
In-Reply-To: <551016FD.1020909@skarnet.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 23.03, Laurent Bercot wrote:
> 
>  Here is the first mail I sent to netfilter@.
>  The whole thread can be read at
>  http://comments.gmane.org/gmane.comp.security.firewalls.netfilter.general/47842


Thanks. Seems the reason is that the linker will discard unused
symbols and from its' perspective the contructors are unused.

I tried experimenting with __attribute__((used)) but it doesn't
help.

What does work is using

-Wl,--whole-archive libnftnl.a -Wl,--no-whole-archive

Not sure if we want to take this path, but it seems acceptable to
me.
