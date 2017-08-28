From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] evaluate: convert expr_rt byteorder when evaluating
 statment arg
Date: Mon, 28 Aug 2017 17:55:38 +0200
Message-ID: <20170828155538.GA788@salvia>
References: <20170828150534.12375-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:37850 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751435AbdH1P4C (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Aug 2017 11:56:02 -0400
Content-Disposition: inline
In-Reply-To: <20170828150534.12375-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 28, 2017 at 05:05:34PM +0200, Florian Westphal wrote:
> expr_rt might write data in host byte order, so make sure to
> convert if needed.
> 
> This makes 'tcp option maxseg size rt mtu' actually work, right now such rules
> are no-ops because nft_exthdr never increases the mss.
> 
> While at it, extend the example to not bother testing non-syn packets.
> 
> Reported-by: Matteo Croce <technoboy85@gmail.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
