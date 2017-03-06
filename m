From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf 1/2] netfilter: nft_set_bitmap: fetch the element key
 based on the set->klen
Date: Mon, 6 Mar 2017 13:01:19 +0100
Message-ID: <20170306120119.GA3461@salvia>
References: <1488729773-48343-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46646 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753200AbdCFMBf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Mar 2017 07:01:35 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4A7CF19833F
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Mar 2017 13:01:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 386E2DA817
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Mar 2017 13:01:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 640DDDA81F
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Mar 2017 13:01:27 +0100 (CET)
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

Right, the userdata case is not handled properly. And in this case we
have no specific flag at set creation, so element comments may come
without previous notice via set flags.

I think we have to keep a list of dummy nft_set_ext that is only used
in the dump path, we can simplify this logic at the cost of increasing
memory consumption. Another alternative is to keep around a structure
to store only the set element userdata that we need for comments.

Let me think.

Your patches look good to me. Probably we can skip 2/2 if we introduce
the dummy nft_set_ext list, and remove the ->flush field for
nft_set_iter.

Thanks.
