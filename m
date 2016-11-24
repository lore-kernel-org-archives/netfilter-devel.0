From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: nf_tables: validate maximum value of
 u32 netlink hash attribute
Date: Thu, 24 Nov 2016 14:43:17 +0100
Message-ID: <20161124134317.GA32280@salvia>
References: <20161114213331.GA13743@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59626 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965587AbcKXNnY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Nov 2016 08:43:24 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B9A112519B1
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2016 14:43:21 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8DC6FDA848
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2016 14:43:21 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E7680DA3AC
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2016 14:43:18 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20161114213331.GA13743@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 14, 2016 at 10:33:34PM +0100, Laura Garcia Liebana wrote:
> Use the function nft_parse_u32_check() to fetch the value and validate
> the u32 attribute into the hash len u8 field.
> 
> This patch revisits 4da449ae1df9 ("netfilter: nft_exthdr: Add size check
> on u8 nft_exthdr attributes").

Applied, thanks.

Please, always target your fixes to nf.

New features go to nf-next.

Regarding patch title, in second place we usually specify to what
component this is targeted to, so I would suggest:

  netfilter: nft_hash: validate maximum value of u32 netlink hash attribute

so git log --oneline quickly tells us this is targetd to nft_hash.

I have also added this tag which is useful for -stable maintainers:

Fixes: cb1b69b0b15b ("netfilter: nf_tables: add hash expression")

Thanks Laura!
