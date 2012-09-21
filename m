From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2] net: netfilter: combine ipt_NETMAP and ip6t_NETMAP
Date: Fri, 21 Sep 2012 12:09:17 +0200
Message-ID: <20120921100917.GA24612@1984>
References: <1347586832-6190-1-git-send-email-jengelh@inai.de>
 <1347586832-6190-2-git-send-email-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, kaber@trash.net,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57505 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757066Ab2IUKJW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Sep 2012 06:09:22 -0400
Content-Disposition: inline
In-Reply-To: <1347586832-6190-2-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Sep 14, 2012 at 03:40:31AM +0200, Jan Engelhardt wrote:
> Combine more modules since the actual code is so small anyway that the
> kmod metadata and the module in its loaded state totally outweighs the
> combined actual code size.
> 
> IP_NF_TARGET_NETMAP becomes a compat option; IP6_NF_TARGET_NETMAP
> is completely eliminated since it has not see a release yet.

Applied, thanks.
