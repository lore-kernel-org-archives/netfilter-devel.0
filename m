From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH nft] src: fix compile error due to _UNTIL renamed to
 _MODULUS in libnftnl
Date: Mon, 12 Sep 2016 17:58:52 +0800
Message-ID: <CAML_gOe4jyy9+XTEsi5itzzF_c-CqujM7JsWwMHdgocxbdt80Q@mail.gmail.com>
References: <1473582957-52218-1-git-send-email-zlpnobody@163.com> <20160912094919.GA5013@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: Liping Zhang <zlpnobody@163.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Laura Garcia <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f52.google.com ([209.85.213.52]:36474 "EHLO
        mail-vk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757735AbcILJ6x (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Sep 2016 05:58:53 -0400
Received: by mail-vk0-f52.google.com with SMTP id m62so72039289vkd.3
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2016 02:58:53 -0700 (PDT)
In-Reply-To: <20160912094919.GA5013@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2016-09-12 17:49 GMT+08:00 Laura Garcia <nevola@gmail.com>:
> On Sun, Sep 11, 2016 at 04:35:57PM +0800, Liping Zhang wrote:
>> From: Liping Zhang <liping.zhang@spreadtrum.com>
>>
>> In the latest libnftnl, NFTNL_EXPR_NG_UNTIL was renamed to
>> NFTNL_EXPR_NG_MODULUS, so compile error happened:
>>   netlink_linearize.c: In function =E2=80=98netlink_gen_numgen=E2=80=99:
>>   netlink_linearize.c:184:26: error: =E2=80=98NFTNL_EXPR_NG_UNTIL=E2=80=
=99 undeclared
>>   (first use in this function)
>>
>
> In order to complete the renaming, NFTA_NG_UNTIL should be changed to
> NFTA_NG_MODULUS as well.
>

Yes, I missed it. Although NFTA_NG_XXX is not used in nftables, but I think=
 it's
better to do this in one single patch.
