From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH nf] netfilter: nf_tables: fix inconsistent element
 expiration calculation
Date: Mon, 21 Nov 2016 18:06:16 +0800
Message-ID: <CAML_gOekCNzYvrgtZrxw_jSoFMu7voY9V5s68LOFwX1x3aBERw@mail.gmail.com>
References: <1479659927.10079.3.camel@cohaesio.com> <CAML_gOfNuXeeUeqNMET39pawDLGf5_vs3gy84J=2SxuS4gbp9Q@mail.gmail.com>
 <1479718671.17099.3.camel@cohaesio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "pablo@netfilter.org" <pablo@netfilter.org>
To: "Anders K. Pedersen | Cohaesio" <akp@cohaesio.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f171.google.com ([209.85.217.171]:35647 "EHLO
        mail-ua0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751264AbcKUKGS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Nov 2016 05:06:18 -0500
Received: by mail-ua0-f171.google.com with SMTP id 12so222097692uas.2
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Nov 2016 02:06:18 -0800 (PST)
In-Reply-To: <1479718671.17099.3.camel@cohaesio.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Anders,

2016-11-21 16:57 GMT+08:00 Anders K. Pedersen | Cohaesio <akp@cohaesio.com>:
[...]
>> nla[NFTA_SET_TIMEOUT] should be kept indent consistent with
>> be64_to_cpu.
>> You can add some spaces after tab.
>
> The indentation is deliberate, because I don't want to give the
> impression that nla[] is an argument to the be64_to_cpu() function.
>
> I looked through the file to see how similar indentation issues was
> handled elsewhere. There seems to be a preference for just exceeding
> the 80 character per line limit (I found lines up to 107 characters),
> but I did find one place (case NFT_GOTO in nf_tables_check_loops())
> that use the same style as I do here.

Yes, after a closer look, I also find that it's not easy to deal with the
indentation in this case. And sorry for not realizing this issue at the
first glance.

So everything is fine.

Thanks

>
> So I could switch to just using long lines, if that is preferred, and
> just ignore the checkpatch.pl warning about it. The longest new line
> would be 99 characters, which is less than what already exists in the
> file.
