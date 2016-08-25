From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v4] netfilter: nf_tables: Ensure init attributes are
 within the bounds
Date: Thu, 25 Aug 2016 13:29:36 +0200
Message-ID: <20160825112936.GA11823@salvia>
References: <20160818160623.GA25544@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59990 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757635AbcHYL3p (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Aug 2016 07:29:45 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2CAE2FB45D
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Aug 2016 13:29:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6B5AD100A7E
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Aug 2016 13:29:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3BB0A1150B2
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Aug 2016 13:29:40 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160818160623.GA25544@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Laura,

On Thu, Aug 18, 2016 at 06:06:26PM +0200, Laura Garcia Liebana wrote:
> Check for overflow of u8 fields from u32 netlink attributes and maximum
> values.

After a closer look, this lack of validation seems more widespread
than I initially expected.

Look, other enums like:

enum nft_set_policies {
        NFT_SET_POL_PERFORMANCE,
        NFT_SET_POL_MEMORY,
};

that has no _MAX definition are suspect, actually looking at
net/netfilter/nf_tables_api.c more specifically at
nft_select_set_ops() you'll notice that the switch there doesn't seem
to reject anything over NFT_SET_POL_MEMORY.

So I would review net/netfilter/nf_tables_api.c too.

BTW, I think it is a good idea to add something like:

	err = nft_parse_u8(ntohl(nla_get_be32(tb[NFTA_BITWISE_LEN]),
                           &priv->len);
        if (err < 0)
                return err;

that we can consistently use all over the code, instead of open
coding:

        len = ...
        if (len > U8_MAX)
                return -ERANGE;

> Refer to 4da449ae1df

Please, use this format instead to refer to patches:

4da449a ("netfilter: nft_exthdr: Add size check on u8 nft_exthdr attributes")

Thanks!
