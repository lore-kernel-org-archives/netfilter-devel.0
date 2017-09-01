From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 3/3] src: add nft_ctx_netlink_init()
Date: Fri, 1 Sep 2017 12:17:33 +0200
Message-ID: <20170901101733.GA5539@salvia>
References: <1504260847-5408-1-git-send-email-pablo@netfilter.org>
 <1504260847-5408-3-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: phil@nwl.cc, eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:47194 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751831AbdIAKR5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Sep 2017 06:17:57 -0400
Content-Disposition: inline
In-Reply-To: <1504260847-5408-3-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Sep 01, 2017 at 12:14:07PM +0200, Pablo Neira Ayuso wrote:
> Add these two new functions to set up netlink sockets in the global
> context structure.

We can alternatively call this nft_ctx_netlink_auto() if prefer.

I'm just trying to skip the type/flag field for nft_ctx_alloc().

Does this look acceptable to you to have this extra API to request
libnftables to deal with IO details too?
