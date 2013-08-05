From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH -next] netfilter: tproxy: fix build with IP6_NF_IPTABLES=n
Date: Mon, 5 Aug 2013 13:05:11 +0200
Message-ID: <20130805110511.GA7836@localhost>
References: <51fd4909.9l/Oq5RafYHkZm62%fengguang.wu@intel.com>
 <1375609049-28517-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kbuild-all@01.org,
	fengguang.wu@intel.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38276 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754413Ab3HELFq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Aug 2013 07:05:46 -0400
Content-Disposition: inline
In-Reply-To: <1375609049-28517-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Aug 04, 2013 at 11:37:29AM +0200, Florian Westphal wrote:
> after commit 93742cf8af9dd3b053242b273040aa35fcbf93b3
> (netfilter: tproxy: remove nf_tproxy_core.h)
> CONFIG_IPV6=y
> CONFIG_IP6_NF_IPTABLES=n
> gives us:
> 
> net/netfilter/xt_TPROXY.c: In function 'nf_tproxy_get_sock_v6':
> net/netfilter/xt_TPROXY.c:178:4: error: implicit declaration of function 'inet6_lookup_listener'

Applied, thanks Florian.
