From: Tugrul Erdogan <h.tugrul.erdogan@gmail.com>
Subject: Re: CPU load on queued_spin_lock_slowpath
Date: Wed, 7 Feb 2018 19:36:27 +0300
Message-ID: <CA+whn7RKgKBYCtNXa+1WxJAXSKKRp_m-2D1_mbbwouYGJGzKtQ@mail.gmail.com>
References: <CA+whn7Qkg9ZJ-owuukfoA4+RHP26mBQG0oGoBCCtwL9oAs6MxQ@mail.gmail.com>
 <20180206121021.hn4nx64yqof7wpwt@salvia> <CALOK-Of3KWseVUACGt2NDY_+Z6xkg4QLJokor7nesJav0Fgw9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Fran Fitzpatrick <francis.x.fitzpatrick@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qk0-f180.google.com ([209.85.220.180]:39041 "EHLO
        mail-qk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754166AbeBGQg2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Feb 2018 11:36:28 -0500
Received: by mail-qk0-f180.google.com with SMTP id d72so1855916qkc.6
        for <netfilter-devel@vger.kernel.org>; Wed, 07 Feb 2018 08:36:28 -0800 (PST)
In-Reply-To: <CALOK-Of3KWseVUACGt2NDY_+Z6xkg4QLJokor7nesJav0Fgw9g@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thanks for your advices. I will try to create the erroneous situation
by triggering icmp error for existing connection and try non-tcp patch
and kernel upgrade respectively. I will report the results at mail
list.

> On Tue, Feb 6, 2018, 7:10 AM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>>
>> On Tue, Feb 06, 2018 at 10:56:20AM +0300, Tugrul Erdogan wrote:
>> > Hi All,
>> >
>> > My server had a locking problem with the logs located below. I can not
>> > reproduce this erroneous situation again but I think that there is an
>> > active vulnerability at my server because of this error.
>> >
>> > My server's kernel version is v4.6.4.
>>
>> Probably this helps you?
>>
>> commit 49f817d793d1bcc11d721881aac037b996feef5c
>> Author: Lin Zhang <xiaolou4617@gmail.com>
>> Date:   Fri Oct 6 00:44:03 2017 +0800
>>
>>     netfilter: SYNPROXY: skip non-tcp packet in {ipv4, ipv6}_synproxy_hook
>>
>> 4.6.4 is rather old, BTW.
>> --
>> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
