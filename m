From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH next 3/3] netfilter: hashlimit: byte-based limit mode
Date: Wed, 9 May 2012 13:25:30 +0200
Message-ID: <20120509112530.GC23062@1984>
References: <1336423905-23919-1-git-send-email-fw@strlen.de>
 <1336423905-23919-3-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59313 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194Ab2EILZd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 May 2012 07:25:33 -0400
Content-Disposition: inline
In-Reply-To: <1336423905-23919-3-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, May 07, 2012 at 10:51:45PM +0200, Florian Westphal wrote:
> can be used e.g. for ingress traffic policing or
> to detect when a host/port consumes more bandwidth than expected.
> 
> This is done by optionally making cost to mean
> "cost per 16-byte-chunk-of-data" instead of "cost per packet".
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Applied, thanks.
