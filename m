From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: linux-next: manual merge of the netfilter-next tree with the net tree
Date: Fri, 30 Sep 2016 14:04:48 +0800
Message-ID: <CAML_gOcJ6G54Vmcp5mHDdekaL=WzXXJDDLJ8JdW-0JOWZ+yhkA@mail.gmail.com>
References: <20160913101250.0ffee30f@canb.auug.org.au> <20160929112014.4293728d@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f193.google.com ([209.85.217.193]:35709 "EHLO
        mail-ua0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934757AbcI3GFI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 30 Sep 2016 02:05:08 -0400
Received: by mail-ua0-f193.google.com with SMTP id 100so3233514uaj.2
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Sep 2016 23:05:08 -0700 (PDT)
In-Reply-To: <20160929112014.4293728d@canb.auug.org.au>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[ remove other unrelated dev groups ]

Hi pablo,

2016-09-29 9:20 GMT+08:00 Stephen Rothwell <sfr@canb.auug.org.au>:
> Hi all,
>
> On Tue, 13 Sep 2016 10:12:50 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>
>> Today's linux-next merge of the netfilter-next tree got a conflict in:
>>
>>   net/netfilter/nf_tables_netdev.c
>>
>> between commit:
>>
>>   c73c24849011 ("netfilter: nf_tables_netdev: remove redundant ip_hdr assignment")
>>
>> from the net tree and commit:
>>
>>   ddc8b6027ad0 ("netfilter: introduce nft_set_pktinfo_{ipv4, ipv6}_validate()")
>>
>>  include/net/netfilter/nf_tables_ipv4.h | 1 -
>>  1 file changed, 1 deletion(-)
>>
>> diff --git a/include/net/netfilter/nf_tables_ipv4.h b/include/net/netfilter/nf_tables_ipv4.h
>> index 968f00b82fb5..25e33aee91e7 100644
>> --- a/include/net/netfilter/nf_tables_ipv4.h
>> +++ b/include/net/netfilter/nf_tables_ipv4.h
>> @@ -33,7 +33,6 @@ __nft_set_pktinfo_ipv4_validate(struct nft_pktinfo *pkt,
>>       if (!iph)
>>               return -1;
>>
>> -     iph = ip_hdr(skb);
>>       if (iph->ihl < 5 || iph->version != 4)
>>               return -1;
>>
>> --
>> 2.8.1
>
> The above merge fix patch is now needed when the net-next tree is
> merged with Linus' tree.
>

I think this merge conflict was fixed in your nf-next tree by
commit f20fbc0717f9.

But this redundant statement "iph = ip_hdr(skb);" should be
removed, we already use skb_header_pointer to get ip header
pointer before.

See function __nft_set_pktinfo_ipv4_validate():
{
    struct iphdr *iph, _iph;
    u32 len, thoff;

    iph = skb_header_pointer(skb, ....);
    ^^^^^^^^^^^^^^^^^^^^^^^^^
    if (!iph)
         return -1;

     iph = ip_hdr(skb);
     ^^^^^^^^^^^^^^^^^
     if (iph->ihl < 5 || iph->version != 4)
     ....

> --
> Cheers,
> Stephen Rothwell
