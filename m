From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nf_tables: fix missmatch in big-endian
 system
Date: Mon, 13 Mar 2017 13:31:16 +0100
Message-ID: <20170313123116.GA6513@salvia>
References: <1488984858-29290-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57074 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750808AbdCMMbo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Mar 2017 08:31:44 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DA2E31A2086
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Mar 2017 13:31:19 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C86DDDA804
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Mar 2017 13:31:19 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CFD2BBAAA8
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Mar 2017 13:31:16 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1488984858-29290-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 08, 2017 at 10:54:18PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> Currently, there are two different methods to store an u16 integer to
> the u32 data register. For example:
>   u32 *dest = &regs->data[priv->dreg];
>   1. *dest = 0; *(u16 *) dest = val_u16;
>   2. *dest = val_u16;
> 
> For method 1, the u16 value will be stored like this, either in
> big-endian or little-endian system:
>   0          15           31
>   +-+-+-+-+-+-+-+-+-+-+-+-+
>   |   Value   |     0     |
>   +-+-+-+-+-+-+-+-+-+-+-+-+
> 
> For method 2, in little-endian system, the u16 value will be the same
> as listed above. But in big-endian system, the u16 value will be stored
> like this:
>   0          15           31
>   +-+-+-+-+-+-+-+-+-+-+-+-+
>   |     0     |   Value   |
>   +-+-+-+-+-+-+-+-+-+-+-+-+
> 
> So later we use "memcmp(&regs->data[priv->sreg], data, 2);" to do
> compare in nft_cmp, nft_lookup expr ..., method 2 will get the wrong
> result in big-endian system, as 0~15 bits will always be zero.
> 
> For the similar reason, when loading an u16 value from the u32 data
> register, we should use "*(u16 *) sreg;" instead of "(u16)*sreg;",
> the 2nd method will get the wrong value in the big-endian system.
> 
> So introduce some wrapper functions to store/load an u8 or u16
> integer to/from the u32 data register, and use them in the right
> place.

Applied, thanks.
