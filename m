From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf 1/2] netfilter: nft_set_bitmap: fetch the element key
 based on the set->klen
Date: Mon, 13 Mar 2017 13:29:19 +0100
Message-ID: <20170313122919.GA6165@salvia>
References: <1488729773-48343-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55112 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752205AbdCMM3c (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Mar 2017 08:29:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BF8D1196641
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Mar 2017 13:29:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A5940DA854
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Mar 2017 13:29:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0177CBAC39
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Mar 2017 13:29:19 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1488729773-48343-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 06, 2017 at 12:02:52AM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> Currently we just assume the element key as a u32 integer, regardless of
> the set key length.
> 
> This is incorrect, for example, the tcp port number is only 16 bits.
> So when we use the nft_payload expr to get the tcp dport and store
> it to dreg, the dport will be stored at 0~15 bits, and 16~31 bits
> will be padded with zero.
> 
> So the reg->data[dreg] will be looked like as below:
>   0          15           31
>   +-+-+-+-+-+-+-+-+-+-+-+-+
>   | tcp dport |      0    |
>   +-+-+-+-+-+-+-+-+-+-+-+-+
> But for these big-endian systems, if we treate this register as a u32
> integer, the element key will be larger than 65535, so the following
> lookup in bitmap set will cause out of bound access.
> 
> Another issue is that if we add element with comments in bitmap
> set(although the comments will be ignored eventually), the element will
> vanish strangely. Because we treate the element key as a u32 integer, so
> the comments will become the part of the element key, then the element
> key will also be larger than 65535 and out of bound access will happen:
>   # nft add element t s { 1 comment test }
> 
> Since set->klen is 1 or 2, it's fine to treate the element key as a u8 or
> u16 integer.

Applied this one, thanks Liping.

I just sent a couple of a patch to fix element comments with bitmaps,
this is also implicitly fixing the leak that you aimed to fix with 2/2.
