From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH nf] netfilter: xt_CT: fix cthelper module's refcnt leak
Date: Fri, 14 Apr 2017 07:09:58 +0800
Message-ID: <CAML_gOe-gAk0fyhRE9e4chqL7=nEOqc5_cWBO0YvqAAKqZXHSw@mail.gmail.com>
References: <1491622728-55625-1-git-send-email-zlpnobody@163.com> <20170413223056.GA5106@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Liping Zhang <zlpnobody@163.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>, Gao Feng <fgao@ikuai8.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f169.google.com ([209.85.217.169]:36641 "EHLO
        mail-ua0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751657AbdDMXJ7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Apr 2017 19:09:59 -0400
Received: by mail-ua0-f169.google.com with SMTP id a1so40976834uaf.3
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Apr 2017 16:09:59 -0700 (PDT)
In-Reply-To: <20170413223056.GA5106@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

2017-04-14 6:30 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:
>> We should call module_put when the time policy is not found. Otherwise,
>> the related cthelper module cannot be removed anymore.
>>
>> It is easy to reproduce by typing the following command:
>>   # iptables -t raw -A OUTPUT -p tcp -j CT --helper ftp --timeout xxx
>
> Can we fix all leaks in the error path in one single patch for xt_CT?

Right.

> Feng sent me a patch to fix another issue there, so if either you or
> him send me one single patch to fix all xt_CT refcount leaks in one
> go, I'd appreciate.

Feng, since you spotted this issue earlier, can you send a new patch to do this?
With a new patch name: "netfilter: xt_CT: fix refcnt leak on error path".

Also you can add my:
Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
