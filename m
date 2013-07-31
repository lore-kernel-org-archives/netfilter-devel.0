From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/7] netfilter: tproxy: remove nf_tproxy_core, keep tw sk
 assigned to skb
Date: Wed, 31 Jul 2013 18:57:02 +0200
Message-ID: <20130731165702.GC25900@localhost>
References: <1375105316-13216-1-git-send-email-fw@strlen.de>
 <1375105316-13216-4-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51455 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757067Ab3GaQ5H (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Jul 2013 12:57:07 -0400
Content-Disposition: inline
In-Reply-To: <1375105316-13216-4-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jul 29, 2013 at 03:41:52PM +0200, Florian Westphal wrote:
> The module was "permanent", due to the special tproxy skb->destructor.
> Nowadays we have tcp early demux and its sock_edemux destructor in
> networking core which can be used instead.
> 
> Thanks to early demux changes the input path now also handles
> "skb->sk is tw socket" correctly, so this no longer needs the special
> handling introduced with commit d503b30bd648b3cb4e5f50b65d27e389960cc6d9
> (netfilter: tproxy: do not assign timewait sockets to skb->sk).
> 
> Thus:
> - move assign_sock function to where its needed
> - don't prevent timewait sockets from being assigned to the skb
> - remove nf_tproxy_core.

Applied, thanks Florian
