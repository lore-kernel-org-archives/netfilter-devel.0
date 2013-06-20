From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH -next] Revert "netfilter: tproxy: do not assign timewait
 sockets to skb->sk"
Date: Thu, 20 Jun 2013 12:22:34 +0200
Message-ID: <20130620102234.GA19823@localhost>
References: <1369792719-3945-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44922 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755747Ab3FTKWl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Jun 2013 06:22:41 -0400
Content-Disposition: inline
In-Reply-To: <1369792719-3945-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, May 29, 2013 at 03:58:39AM +0200, Florian Westphal wrote:
> This reverts commit d503b30bd648b3cb4e5f50b65d27e389960cc6d9.
> 
> Nowadays we have early socket demux; all the input code paths
> should handle "skb->sk points to timewait sock" properly.

I'm fine with this but I think that we should have some nf_sock_put
definition somewhere else. Using the tproxy namespace from xt_socket
doesn't seem nice to me.
