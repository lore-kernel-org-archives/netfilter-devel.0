From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: Re: [conntrack-tools PATCH 4/4] conntrackd: introduce RequestResync option
Date: Wed, 26 Apr 2017 13:32:38 +0200
Message-ID: <CAOkSjBj3wqnCVMAfMek3NKbgbo35EjMQ842gOzgOpmH=qBu=6g@mail.gmail.com>
References: <149270928083.1751.9498250834672625764.stgit@nfdev2.cica.es>
 <149270929676.1751.18425946182083865800.stgit@nfdev2.cica.es>
 <20170425113732.GB5355@salvia> <CAOkSjBiYGg76HichZbLkmyHyHTV3OPu3H7BqSE1ZJki0gh7pxA@mail.gmail.com>
 <20170425131843.GB1050@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:33053 "EHLO
        mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1948566AbdDZLdB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Apr 2017 07:33:01 -0400
Received: by mail-oi0-f50.google.com with SMTP id y11so172760838oie.0
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Apr 2017 04:33:01 -0700 (PDT)
Received: from mail-oi0-f47.google.com (mail-oi0-f47.google.com. [209.85.218.47])
        by smtp.gmail.com with ESMTPSA id s193sm10818670oie.21.2017.04.26.04.32.58
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Apr 2017 04:32:58 -0700 (PDT)
Received: by mail-oi0-f47.google.com with SMTP id w12so92921672oiw.3
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Apr 2017 04:32:58 -0700 (PDT)
In-Reply-To: <20170425131843.GB1050@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 25 April 2017 at 15:18, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>>
>> Yes. The timer based approach is... timer based (async).
>>
>> It doesn't fit in an environment where you need to sync events as soon
>> as they happen.
>
> IIRC the timer based works like this:
>
> 1) If event occurs, sync message is send.
> 2) After some time, we send a message to tell the other peer the entry
>    is still there.
> 3) If no message is received, then the entry expires.
>

the ALARM mode requires to commit the external cache instead of the
conns being directly injected into the kernel.

I think the new RequestResync method (or whatever other alternative)
provides a good tradeoff
between methods and increases general usefulness of conntrackd.
