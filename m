From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH nf-next] netfilter: nf_queue: get rid of dependency on IP6_NF_IPTABLES
Date: Tue, 13 Sep 2016 13:45:38 +0800
Message-ID: <CAML_gOeP3zvNxptZP2vCvu2KsyOri7Okpapv7zKFg_gFPeWGWw@mail.gmail.com>
References: <1473602728-33502-1-git-send-email-zlpnobody@163.com> <20160912175030.GA31089@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Liping Zhang <zlpnobody@163.com>, netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f175.google.com ([209.85.217.175]:36785 "EHLO
        mail-ua0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751198AbcIMFpj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Sep 2016 01:45:39 -0400
Received: by mail-ua0-f175.google.com with SMTP id 31so6292188uao.3
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2016 22:45:39 -0700 (PDT)
In-Reply-To: <20160912175030.GA31089@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2016-09-13 1:50 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> We have nft_queue support for bridge now, but nfqueue_hash() takes a
> pkt->pf parameter expecting NFPROTO_IPV4 or NFPROTO_IPV6.
>
> So nft_queue hashing with bridge is currently broken.

Yes, I will send another patch to do this :)
