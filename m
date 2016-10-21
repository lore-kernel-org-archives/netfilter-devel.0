From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH v2 nf-next 5/5] netfilter: nft: rt nexthop for inet family
Date: Fri, 21 Oct 2016 20:42:42 +0800
Message-ID: <CAML_gOfoAg4-uzQAqRx926p7YWj_kk1ZFqe-NQtXA73Par01PQ@mail.gmail.com>
References: <1476902043.1161.14.camel@cohaesio.com> <1476902504.1161.24.camel@cohaesio.com>
 <CAML_gOdd7=XOk+5csafW2zUjzTqzqufSp7L=3CpS8FBf6r+9nA@mail.gmail.com>
 <1476966980.1161.52.camel@cohaesio.com> <CAML_gOd9JSCHWQqnGN8FqdhghFHqCgDX_TiXgdpYnegROArmpQ@mail.gmail.com>
 <1476971559.1161.58.camel@cohaesio.com> <CAML_gOcPkygs4P95MAEDJJFRMvchKgONN-VFg45pso+Oc0B_GQ@mail.gmail.com>
 <1477023411.1161.83.camel@cohaesio.com> <CAML_gOfD0z7DTScvCOgMSqDZNdMB3TZ35pgRpikSFqdq_GRX5A@mail.gmail.com>
 <1477038412.1053.13.camel@cohaesio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "pablo@netfilter.org" <pablo@netfilter.org>
To: "Anders K. Pedersen | Cohaesio" <akp@cohaesio.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f54.google.com ([209.85.213.54]:35836 "EHLO
        mail-vk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755094AbcJUMmo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Oct 2016 08:42:44 -0400
Received: by mail-vk0-f54.google.com with SMTP id q126so115383656vkd.2
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Oct 2016 05:42:44 -0700 (PDT)
In-Reply-To: <1477038412.1053.13.camel@cohaesio.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Anders,

2016-10-21 16:26 GMT+08:00 Anders K. Pedersen | Cohaesio <akp@cohaesio.com>:
[...]
> I had a look at it. This construct is used for NFT_CT_SRC and
> NFT_CT_DST, where the init function just returns the IPv6 length for
> the inet family. But I'm not sure how this can work for userspace, and
> at least for current nftables there are problems:
>
> # nft flush ruleset
> # nft add table inet filter
> # nft add chain inet filter input
> # nft add rule inet filter input ether type ip flow table acct \{ ct original saddr timeout 600s counter \}
> # nft list ruleset
> Killed
> # nft list flow tables
> Killed

I guess there's a bug in nft utility, same problem exists in ip/ip6 family.

In init routine, nft_validate_register_store was used to ensure
that we will not do overflow operation.

>
> The latter two commands are killed by the OOM killer after a few
> seconds. Same thing happens for 'ether type ip6', while it works fine
> with 'ip saddr' or 'rt ip nexthop' in stead of 'ct original saddr'.
>
> Regards,
> Anders
