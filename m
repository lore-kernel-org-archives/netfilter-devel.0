From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft 3/3] src: add nft_ctx_netlink_init()
Date: Fri, 1 Sep 2017 14:28:48 +0200
Message-ID: <20170901122848.GB951@breakpoint.cc>
References: <1504260847-5408-1-git-send-email-pablo@netfilter.org>
 <1504260847-5408-3-git-send-email-pablo@netfilter.org>
 <20170901101733.GA5539@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, phil@nwl.cc, eric@regit.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:45574 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751777AbdIAMbh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Sep 2017 08:31:37 -0400
Content-Disposition: inline
In-Reply-To: <20170901101733.GA5539@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Fri, Sep 01, 2017 at 12:14:07PM +0200, Pablo Neira Ayuso wrote:
> > Add these two new functions to set up netlink sockets in the global
> > context structure.
> 
> We can alternatively call this nft_ctx_netlink_auto() if prefer.

I think its good as-is.

I also agree with not exposing libmnl anywhere in the api.

