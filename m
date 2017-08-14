From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] src: rule: Remove variable cache_initialized.
Date: Mon, 14 Aug 2017 11:28:44 +0200
Message-ID: <20170814092844.GA7908@salvia>
References: <20170813043018.13190-1-rvarsha016@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Varsha Rao <rvarsha016@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:45483 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752381AbdHNJ3I (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Aug 2017 05:29:08 -0400
Content-Disposition: inline
In-Reply-To: <20170813043018.13190-1-rvarsha016@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Aug 13, 2017 at 10:00:18AM +0530, Varsha Rao wrote:
> Pass variable cache_initialized and structure list_head as members of
> structure nft_cache.

Applied, thanks.

I have renamed this patch title to: "src: introduce struct nft_cache"

For the record: This supersedes my previous patch:

http://patchwork.ozlabs.org/patch/800141/

Thanks.
