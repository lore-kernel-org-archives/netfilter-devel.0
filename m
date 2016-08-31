From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH iptables 2/3] extensions: libip[6]t_SNAT/DNAT: use the new
 nft syntax when do xlate
Date: Wed, 31 Aug 2016 08:32:50 +0800
Message-ID: <CAML_gOdXC0J-sFxVeFnL0pcQuGUUu13PY96dqjv6vaAqssvZsw@mail.gmail.com>
References: <1472374248-21912-1-git-send-email-zlpnobody@163.com>
 <1472374248-21912-2-git-send-email-zlpnobody@163.com> <20160830095925.GB20699@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Liping Zhang <zlpnobody@163.com>, netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f193.google.com ([209.85.217.193]:35737 "EHLO
        mail-ua0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751302AbcHaAdK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Aug 2016 20:33:10 -0400
Received: by mail-ua0-f193.google.com with SMTP id 2so2593571uax.2
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Aug 2016 17:32:51 -0700 (PDT)
In-Reply-To: <20160830095925.GB20699@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2016-08-30 17:59 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:

> BTW, if you have some spare cycles, it would be great to use the
> square brackets in the translation output too I think.
>
> # ip6tables-translate -t nat -A PREROUTING -p tcp -j DNAT --to-destination [abcd::1]:30
> nft add rule ip6 nat PREROUTING meta l4proto tcp counter dnat abcd::1 :30

OK. I will send another patch later.
Thanks
