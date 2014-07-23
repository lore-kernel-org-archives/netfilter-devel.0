From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: netfilter: remnants of ulog targets
Date: Wed, 23 Jul 2014 11:39:49 +0200
Message-ID: <20140723093949.GA3754@salvia>
References: <1406107694.12441.8.camel@x220>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Paul Bolle <pebolle@tiscali.nl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43125 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757568AbaGWJjs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jul 2014 05:39:48 -0400
Content-Disposition: inline
In-Reply-To: <1406107694.12441.8.camel@x220>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 23, 2014 at 11:28:14AM +0200, Paul Bolle wrote:
> Pablo,
> 
> Your commit 7200135bc1e6 ("netfilter: kill ulog targets") landed in
> today's linux-next (ie, next-20140723). It removes two Kconfig symbols:
> IP_NF_TARGET_ULOG and BRIDGE_EBT_ULOG.
> 
> It left a few references to the related macros untouched:
>     $ git grep -n -e IP_NF_TARGET_ULOG -e BRIDGE_EBT_ULOG next-20140723 | grep -v defconf
>     next-20140723:include/net/netns/x_tables.h:18:#if IS_ENABLED(CONFIG_IP_NF_TARGET_ULOG)
>     next-20140723:include/net/netns/x_tables.h:21:#if IS_ENABLED(CONFIG_BRIDGE_EBT_ULOG)
>     next-20140723:net/bridge/netfilter/Makefile:39:obj-$(CONFIG_BRIDGE_EBT_ULOG) += ebt_ulog.o
>     next-20140723:net/ipv4/netfilter/Makefile:60:obj-$(CONFIG_IP_NF_TARGET_ULOG) += ipt_ULOG.o
> 
> Is the trivial patch to clean up these remnants of the ulog targets
> queued somewhere? If not, should I submit it?

Yes, you can send me a patch to kill that dead code. Thanks.
