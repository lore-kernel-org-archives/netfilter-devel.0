From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: Re: [nft PATCH 2/2] masquerade: Complain if no prerouting chain exists
Date: Fri, 28 Apr 2017 10:11:51 +0200
Message-ID: <CAOkSjBjtJ0_xymJ_iMuKwxtqArEh_dHs=Tgjo271PnLy4K84ng@mail.gmail.com>
References: <20170427132439.9443-1-phil@nwl.cc> <20170427132439.9443-2-phil@nwl.cc>
 <CAOkSjBjdnywsFENgBLQfQr2aXMTDpU9ztXm_Y4V1==E61hH05g@mail.gmail.com> <20170428080523.GI20805@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:36288 "EHLO
        mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1164170AbdD1IMM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Apr 2017 04:12:12 -0400
Received: by mail-io0-f174.google.com with SMTP id p80so53974974iop.3
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Apr 2017 01:12:12 -0700 (PDT)
Received: from mail-io0-f172.google.com (mail-io0-f172.google.com. [209.85.223.172])
        by smtp.gmail.com with ESMTPSA id y97sm881123ita.17.2017.04.28.01.12.11
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Apr 2017 01:12:11 -0700 (PDT)
Received: by mail-io0-f172.google.com with SMTP id k87so54249537ioi.0
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Apr 2017 01:12:11 -0700 (PDT)
In-Reply-To: <20170428080523.GI20805@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 28 April 2017 at 10:05, Phil Sutter <phil@nwl.cc> wrote:
>>
>> This warning will be printed even in rulesets loaded with '-f'
>> which first creates the masq rule an then the other chain.
>
> Hmm. I tested it with the following config and it works fine:
>
> | table ip nat {
> |       chain post {
> |               type nat hook postrouting priority 0; policy accept;
> |               oifname "veth2" masquerade
> |       }
> |
> |       chain pre {
> |               type nat hook prerouting priority 0; policy accept;
> |       }
> | }
>
> OK, with a config consisting of several 'add' commands, it indeed warns.
>
>> I think is just a matter of documenting *everywhere* that this is the
>> expected behaviour, not a bug.
>
> Yeah, I should indeed have done that first, also because masquerade
> statement is not documented at all yet.
>

The best current documentation is this:

https://wiki.nftables.org/wiki-nftables/index.php/Performing_Network_Address_Translation_(NAT)

It can be improved, though
