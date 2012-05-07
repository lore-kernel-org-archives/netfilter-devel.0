From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/2] ipset related bugfixes
Date: Mon, 7 May 2012 21:13:17 +0200
Message-ID: <20120507191317.GA4175@1984>
References: <1336394145-10078-1-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48418 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757572Ab2EGTNU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 May 2012 15:13:20 -0400
Content-Disposition: inline
In-Reply-To: <1336394145-10078-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, May 07, 2012 at 02:35:43PM +0200, Jozsef Kadlecsik wrote:
> Hi Pablo,
> 
> Please apply the next two bugfixes and push forward for kernel inclusion.
> The patches can be pulled from git://blackhole.kfki.hu/git/net. Thanks!

I overlooked that you provide a tree to pull. Sorry. I have manually
applied them.

> Best regards,
> Jozsef
> 
> Jozsef Kadlecsik (2):
>   netfilter: ipset: Fix timeout value overflow bug
>   netfilter: ipset: Fix hash size checking in kernel

Thanks Jozsef, I'll pass them to 3.4-rc6
