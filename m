From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH next] netfilter: kill support for per-af queue backends
Date: Mon, 3 Dec 2012 19:23:37 +0100
Message-ID: <20121203182337.GA22238@1984>
References: <1353687741-2604-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43134 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142Ab2LCSXp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Dec 2012 13:23:45 -0500
Content-Disposition: inline
In-Reply-To: <1353687741-2604-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Nov 23, 2012 at 05:22:21PM +0100, Florian Westphal wrote:
> We used to have several queueing backends, but nowadays only
> nfnetlink_queue remains.
> 
> In light of this there doesn't seem to be a good reason to
> support per-af registering -- just hook up nfnetlink_queue on module
> load and remove it on unload.
> 
> This means that the userspace BIND/UNBIND_PF commands are now obsolete;
> the kernel will ignore them.

Applied, thanks Florian.
