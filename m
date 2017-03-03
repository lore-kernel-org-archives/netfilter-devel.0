From: Gao Feng <fgao@ikuai8.com>
Subject: Re: [PATCH nf 1/1] netfilter: nat_masquerade: Check oom when invoke nfct_nat
Date: Fri, 3 Mar 2017 17:53:41 +0800
Message-ID: <CA+6hz4qchPKCAa2JnHtUAxVwsLH_N5t2ehHQQQnDmO1PZow3dw@mail.gmail.com>
References: <1488506332-21265-1-git-send-email-fgao@ikuai8.com> <20170303093041.GA1461@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbg65.qq.com ([103.7.28.233]:14205 "EHLO smtpbg65.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751506AbdCCJ56 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Mar 2017 04:57:58 -0500
Received: from mail-ua0-f181.google.com (unknown [209.85.217.181])
        by esmtp4.qq.com (ESMTP) with SMTP id 0
        for <netfilter-devel@vger.kernel.org>; Fri, 03 Mar 2017 17:53:42 +0800 (CST)
Received: by mail-ua0-f181.google.com with SMTP id 72so108780247uaf.3
        for <netfilter-devel@vger.kernel.org>; Fri, 03 Mar 2017 01:53:43 -0800 (PST)
In-Reply-To: <20170303093041.GA1461@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On Fri, Mar 3, 2017 at 5:30 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Fri, Mar 03, 2017 at 09:58:52AM +0800, fgao@ikuai8.com wrote:
>> From: Gao Feng <fgao@ikuai8.com>
>>
>> When memory is exhausted, nf_ct_nat_ext_add may return NULL. Then
>> nf_nat_ipv4_fn and nf_nat_ipv6_fn would return NF_ACCEPT in this
>> case.
>> So we need add the NULL check when invoke nfct_nat in these two
>> functions.
>>
>> Signed-off-by: Gao Feng <fgao@ikuai8.com>
>> ---
>>  net/ipv4/netfilter/nf_nat_masquerade_ipv4.c | 2 ++
>>  net/ipv6/netfilter/nf_nat_masquerade_ipv6.c | 6 +++++-
>>  2 files changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/net/ipv4/netfilter/nf_nat_masquerade_ipv4.c b/net/ipv4/netfilter/nf_nat_masquerade_ipv4.c
>> index ea91058..353ca0c 100644
>> --- a/net/ipv4/netfilter/nf_nat_masquerade_ipv4.c
>> +++ b/net/ipv4/netfilter/nf_nat_masquerade_ipv4.c
>> @@ -38,6 +38,8 @@
>>
>>       ct = nf_ct_get(skb, &ctinfo);
>>       nat = nfct_nat(ct);
>> +     if (!nat)
>> +             return NF_ACCEPT;
>
> The masquerade target is only called from the nat table. If you look
> at nf_nat_ipv4_fn(), that is called whenever the packet enters a nat
> table, you can indeed check that nfct_nat() must be already there by
> when we call masquerade.
>
> So this is entirely unnecessary.

Thanks your answer.
I should find the masquerade only is called nat table.
And the nf_nat_ipv4_fn function should make sure the nat is valid .

Thanks again.

Regards
Feng


