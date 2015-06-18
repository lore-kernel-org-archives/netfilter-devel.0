From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH -next] netfilter: xtables: fix warnings on 32bit platforms
Date: Thu, 18 Jun 2015 21:09:50 +0200
Message-ID: <20150618190950.GA14008@salvia>
References: <1434578308-31818-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53212 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756009AbbFRTEc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Jun 2015 15:04:32 -0400
Content-Disposition: inline
In-Reply-To: <1434578308-31818-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 17, 2015 at 11:58:28PM +0200, Florian Westphal wrote:
> On 32bit archs gcc complains due to cast from void* to u64.
> Add intermediate casts to long to silence these warnings.
> 
> include/linux/netfilter/x_tables.h:376:10: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
> include/linux/netfilter/x_tables.h:384:15: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
> include/linux/netfilter/x_tables.h:391:23: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
> include/linux/netfilter/x_tables.h:400:22: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]

Applied, thanks.
