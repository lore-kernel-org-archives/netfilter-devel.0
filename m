From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH next] netfilter: xt_hashlimit: use _ALL macro to reject
 unknown flag bits
Date: Mon, 14 May 2012 10:23:40 +0200
Message-ID: <20120514082340.GA9577@1984>
References: <1336723914-3074-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38788 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754447Ab2ENIXm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 May 2012 04:23:42 -0400
Content-Disposition: inline
In-Reply-To: <1336723914-3074-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, May 11, 2012 at 10:11:54AM +0200, Florian Westphal wrote:
> David Miller says:
>      The canonical way to validate if the set bits are in a valid
>      range is to have a "_ALL" macro, and test:
>      if (val & ~XT_HASHLIMIT_ALL)
>          goto err;"
> 
> make it so.

Applied, thanks Florian.
