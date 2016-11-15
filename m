From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH nft 0/3] src: add nft log flags support
Date: Tue, 15 Nov 2016 22:25:28 +0800
Message-ID: <CAML_gOe4x2jNPAyWBLkrw+Law9YaRmSjtG+rZNzB81Az1PCgAA@mail.gmail.com>
References: <1474794421-5365-1-git-send-email-zlpnobody@163.com> <20161114222156.GA28139@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Liping Zhang <zlpnobody@163.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f193.google.com ([209.85.217.193]:34630 "EHLO
        mail-ua0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932406AbcKOOZa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Nov 2016 09:25:30 -0500
Received: by mail-ua0-f193.google.com with SMTP id b35so9051490uaa.1
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Nov 2016 06:25:29 -0800 (PST)
In-Reply-To: <20161114222156.GA28139@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2016-11-15 6:21 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> On Sun, Sep 25, 2016 at 05:06:58PM +0800, Liping Zhang wrote:
>> From: Liping Zhang <liping.zhang@spreadtrum.com>
>>
>> After NF_LOG_XXX is exposed to the userspace, we can set log flags to
>> log more things. The following iptables rule:
>>   # iptables -A OUTPUT -j LOG --log-tcp-sequence --log-tcp-options \
>>   --log-ip-options --log-uid --log-macdecode
>> is equal to the following nft rule:
>>   # nft add rule filter OUTPUT log tcpseq,tcpopt,ipopt,uid,macdecode
>
> Sorry, I wanted to have a closer look at this but time has been
> running up and I didn't manage to get back to this.
>
> So basically, I would like to explore different syntax for this, eg.
>
>         log flags tcp sequence,options
>         log flags ip options
>         log flags skuid
>         log flags ether

Yes, this syntax looks better, I will send V2 later based on your suggestions.

Thanks Pablo.

>
> I think syntax would be larger, but it would look more consistent to
> what we have. Worst case is to get them all set. We can provide a
> compact version for this:
>
>         log flags all
>
> Please, see sketch patch attached for brainstorming.
>
> Would you have a look into this? Thanks and again sorry for not
> getting any sooner on this.
