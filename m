From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 1/3] src: move nf_sock into nft_ctx structure
Date: Fri, 1 Sep 2017 19:50:52 +0200
Message-ID: <20170901175052.GA2777@salvia>
References: <1504260847-5408-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, phil@nwl.cc
To: eric@regit.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:50697 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752206AbdIARvQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Sep 2017 13:51:16 -0400
Content-Disposition: inline
In-Reply-To: <1504260847-5408-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Sep 01, 2017 at 12:14:05PM +0200, Pablo Neira Ayuso wrote:
> The idea is to provide a simplistic API for non-netlink wise people.
> Add a field in struct nft_ctx to store the socket.
> 
> The advanced API that we're planning will just simply leave this unset,
> since netlink IO will be exposed.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> @Eric: Still pending the specific interface to print. As I said, I would prefer
>        functions with stricting typing. I think after this you have the simple
>        API that you need.

I have just pushed out this. Just follow up with patches in case you
propose to change anything. I just wanted to make sure we don't have
to rebase again.
