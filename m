From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf-next PATCH] netfilter: nf_tables: exthdr: Add support for
 existence check
Date: Mon, 6 Feb 2017 14:08:53 +0100
Message-ID: <20170206130853.GA14826@salvia>
References: <20170117215126.13356-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56972 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751163AbdBFNJI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Feb 2017 08:09:08 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4BFEE180180
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Feb 2017 14:09:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3C4DFDA725
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Feb 2017 14:09:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0D1D0DA729
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Feb 2017 14:09:03 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170117215126.13356-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 17, 2017 at 10:51:26PM +0100, Phil Sutter wrote:
> If NFT_EXTHDR_F_PRESENT is set, exthdr will not copy any header field
> data into *dest, but instead set it to 1 if the header is found and 0
> otherwise.

Applied this one, thanks Phil.

I have fixed this here, via sparse (make C=2):

net/netfilter/nft_exthdr.c:90:24: warning: cast to restricted __be32

> @@ -80,6 +87,7 @@ static int nft_exthdr_init(const struct nft_ctx *ctx,
>  	priv->offset = offset;
>  	priv->len    = len;
>  	priv->dreg   = nft_parse_register(tb[NFTA_EXTHDR_DREG]);
> +	priv->flags  = ntohl(nla_get_u32(tb[NFTA_EXTHDR_FLAGS]));

This needed to be nla_get_be32(). No problem, I fixed this here.
