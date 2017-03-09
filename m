From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH nf] netfilter: nf_tables: fix missmatch in big-endian system
Date: Thu, 9 Mar 2017 20:46:20 +0800
Message-ID: <CAML_gOddzk4GV0DDaqEM+egkmXv-pm+X9GQDV6vcxW83MCpfQQ@mail.gmail.com>
References: <1488984858-29290-1-git-send-email-zlpnobody@163.com> <CAOkSjBhyOiSw1ucabBrsrjdpmBLgbej6=_9NUuKsfri5YmZUqw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Liping Zhang <zlpnobody@163.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f178.google.com ([209.85.217.178]:35869 "EHLO
        mail-ua0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750770AbdCIMqW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Mar 2017 07:46:22 -0500
Received: by mail-ua0-f178.google.com with SMTP id 72so77286566uaf.3
        for <netfilter-devel@vger.kernel.org>; Thu, 09 Mar 2017 04:46:21 -0800 (PST)
In-Reply-To: <CAOkSjBhyOiSw1ucabBrsrjdpmBLgbej6=_9NUuKsfri5YmZUqw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2017-03-09 18:36 GMT+08:00 Arturo Borrero Gonzalez <arturo@debian.org>:
> On 8 March 2017 at 15:54, Liping Zhang <zlpnobody@163.com> wrote:
>>
>> +/* Store/load an u16 or u8 integer to/from the u32 data register.
>> + *
>> + * Note, when using concatenations, register allocation happens at 32-bit
>> + * level. So for store instruction, pad the rest part with zero to avoid
>> + * garbage values.
>> + */
>> +
>> +static inline void nft_reg_store16(u32 *dreg, u16 val)
>> +{
>> +       *dreg = 0;
>> +       *(u16 *)dreg = val;
>> +}
>> +
>> +static inline void nft_reg_store8(u32 *dreg, u8 val)
>> +{
>> +       *dreg = 0;
>> +       *(u8 *)dreg = val;
>> +}
>> +
>
> Any chance the compiler detects the double assignment and removes the first one?

This will never happen, since these two assignment statements are not identical.
Remove the first one will cause the wrong result.

But if you write:
     *dreg = 0;
     *dreg = val;
Then the compiler will likely to optimize the above codes to just one line:
     *dreg = val;
