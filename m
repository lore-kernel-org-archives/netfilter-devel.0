From: Feng Gao <gfree.wind@gmail.com>
Subject: Re: [PATCH nf-next v2 1/1] netfilter: nf_tables: Eliminate duplicated
 codes in nf_tables_table_enable
Date: Fri, 20 Jan 2017 20:30:39 +0800
Message-ID: <CA+6hz4pd8N3e9vgvLZSqgG4d1c+Y0fgK_O+PeAUZZeY1vV+Btg@mail.gmail.com>
References: <1484824690-46965-1-git-send-email-fgao@ikuai8.com>
 <CA+6hz4pH1uoyZjJ2-cTv78u1_fLuwALA1SdoDZH90Ch6KtigQw@mail.gmail.com> <CAML_gOeZUdDALymX9wnv8P6peNzZ=RRGH1wNutOSzk8VQU1Zdg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Liping Zhang <zlpnobody@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f53.google.com ([209.85.213.53]:35571 "EHLO
        mail-vk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751905AbdATMak (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Jan 2017 07:30:40 -0500
Received: by mail-vk0-f53.google.com with SMTP id x75so50384707vke.2
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Jan 2017 04:30:40 -0800 (PST)
In-Reply-To: <CAML_gOeZUdDALymX9wnv8P6peNzZ=RRGH1wNutOSzk8VQU1Zdg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Liping,

On Fri, Jan 20, 2017 at 6:57 PM, Liping Zhang <zlpnobody@gmail.com> wrote:
> 2017-01-20 15:42 GMT+08:00 Feng Gao <gfree.wind@gmail.com>:
> [...]
>> In v2 patch, I copied your recommend codes "if (cnt && --cnt == 0)".
>> Today I think it is not right to use "--cnt", it should use "cnt--".
>> Because when the cnt is 1, the "--cnt" would break directly.
>> So I send the v3 patch.
>
> But this "if (cnt && cnt-- == 0) break;" check condition seems still incorrect,
> when the cnt is 1, next round cnt will become 0, so we will fail to break the
> loop ...

Thanks your catch.
So we should keep the "(cnt && --cnt == 0)", with
_nf_tables_table_disable(net, afi, table, i+1) in the error handler of
nf_tables_table_enable.

Do you think if "i+1" is a little werid?

Regards
Feng
