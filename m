From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 1/3] src: add tcp options set support
Date: Tue, 22 Aug 2017 18:16:15 +0200
Message-ID: <20170822161615.GA11814@salvia>
References: <20170822135141.10785-1-fw@strlen.de>
 <20170822135141.10785-2-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:38175 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750962AbdHVQQq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Aug 2017 12:16:46 -0400
Content-Disposition: inline
In-Reply-To: <20170822135141.10785-2-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 22, 2017 at 03:51:39PM +0200, Florian Westphal wrote:
> This adds support for tcp mss mangling:
> 
> nft add rule filter input tcp option maxseg size 1200
> 
> Its also possible to change other tcp option fields, but
> maxseg is one of the more useful ones to change.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
