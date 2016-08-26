From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH nf] netfilter: nft_meta: improve the validity check of
 pkttype set expr
Date: Fri, 26 Aug 2016 08:24:08 +0800
Message-ID: <CAML_gOcx2U9sU_48SvPx0R600txZhvuyNRS1eBE334Bb3RpOYg@mail.gmail.com>
References: <1471877876-52486-1-git-send-email-zlpnobody@163.com> <20160825111021.GE5242@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Liping Zhang <zlpnobody@163.com>, netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f181.google.com ([209.85.217.181]:36160 "EHLO
        mail-ua0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751316AbcHZAZO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Aug 2016 20:25:14 -0400
Received: by mail-ua0-f181.google.com with SMTP id m60so72123762uam.3
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Aug 2016 17:24:09 -0700 (PDT)
In-Reply-To: <20160825111021.GE5242@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2016-08-25 19:10 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> Actually, it would be good to allow mangling this pkttype from
> prerouting ip and ip6 too, so we can emulate the 'cluster match' very
> easily.
>
> Now we have a hash expression in place, which is what was missing to
> support this.
>
> So, once your fix shows up in the nf-next tree, I'd appreciate if you
> can follow up with a patch to allow the use of this from there.

OK. I will follow up on this.
Thanks.
