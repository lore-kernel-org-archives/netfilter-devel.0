From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH nf 1/2] netfilter: nft_set_bitmap: fetch the element key
 based on the set->klen
Date: Tue, 7 Mar 2017 12:37:56 +0800
Message-ID: <CAML_gOdOe9cA94MFTd3VJjdw_gGpOxL+arG2rePAK9bOuQ=jew@mail.gmail.com>
References: <1488729773-48343-1-git-send-email-zlpnobody@163.com>
 <20170306120119.GA3461@salvia> <CAML_gOedJF8udDAt-=aBAUZAvCKUGWh1RnqdLASn42LfoJGCrA@mail.gmail.com>
 <20170306164259.GA1080@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Liping Zhang <zlpnobody@163.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f193.google.com ([209.85.217.193]:36307 "EHLO
        mail-ua0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753408AbdCGEjz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Mar 2017 23:39:55 -0500
Received: by mail-ua0-f193.google.com with SMTP id y16so19944204uay.3
        for <netfilter-devel@vger.kernel.org>; Mon, 06 Mar 2017 20:37:57 -0800 (PST)
In-Reply-To: <20170306164259.GA1080@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2017-03-07 0:42 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:
[...]
>> static inline void nft_register_store16(u32 *dreg, u16 value)
>> {
>>         *dreg = 0;
>>         *(u16 *)dreg = value;
>> }
>>
>> static inline void nft_register_store8(u32 *dreg, u8 value)
>> {
>>         *dreg = 0;
>>         *(u8 *)dreg = value;
>> }
>
> I think this a good idea, send patches to add this and use them for
> the nf tree, please.

OK. I will have a closer look into these.

Thanks Pablo.

>
>> ...
>>
>> Am I wrong? Or I totally misunderstood this byte-order issue?
>
> This looks correct to me.
>
> Note that:
>
> *dest = 0;
>
> is just there because of concatenations, so we make sure that we zero
> the pad given that register allocation happens at 32-bit level.
>
> Another note: For method 3. __force is there for the sparse checker
> given the different endianness of both sides of the assignment.
