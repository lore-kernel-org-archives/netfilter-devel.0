From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH next 2/3] netfilter: hashlimit: move rateinfo
 initialization to helper
Date: Wed, 9 May 2012 13:25:22 +0200
Message-ID: <20120509112522.GB23062@1984>
References: <1336423905-23919-1-git-send-email-fw@strlen.de>
 <1336423905-23919-2-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59279 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758398Ab2EILZY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 May 2012 07:25:24 -0400
Content-Disposition: inline
In-Reply-To: <1336423905-23919-2-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, May 07, 2012 at 10:51:44PM +0200, Florian Westphal wrote:
> followup patch would bloat main match function too much.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Applied, thanks.
