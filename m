From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] netlink_delink_delinearize: don't store dependency
 unless relop checks is eq check
Date: Mon, 15 May 2017 19:05:12 +0200
Message-ID: <20170515170512.GA4339@salvia>
References: <20170509153711.26130-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:54786 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756081AbdEORFR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 May 2017 13:05:17 -0400
Content-Disposition: inline
In-Reply-To: <20170509153711.26130-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 09, 2017 at 05:37:11PM +0200, Florian Westphal wrote:
> 'ip protocol ne 6' is not a dependency for nexthdr protocol, and must
> not be stored as such.
> 
> Fixes: 0b858391781ba308 ("src: annotate follow up dependency just after killing another")
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
