From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: Re: [conntrack-tools PATCH 4/4] conntrackd: introduce RequestResync option
Date: Tue, 25 Apr 2017 14:46:52 +0200
Message-ID: <CAOkSjBiYGg76HichZbLkmyHyHTV3OPu3H7BqSE1ZJki0gh7pxA@mail.gmail.com>
References: <149270928083.1751.9498250834672625764.stgit@nfdev2.cica.es>
 <149270929676.1751.18425946182083865800.stgit@nfdev2.cica.es> <20170425113732.GB5355@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:32786 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S945251AbdDYMrO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Apr 2017 08:47:14 -0400
Received: by mail-oi0-f66.google.com with SMTP id w12so6096972oiw.0
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Apr 2017 05:47:14 -0700 (PDT)
Received: from mail-oi0-f50.google.com (mail-oi0-f50.google.com. [209.85.218.50])
        by smtp.gmail.com with ESMTPSA id j51sm9370450otc.47.2017.04.25.05.47.13
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Apr 2017 05:47:13 -0700 (PDT)
Received: by mail-oi0-f50.google.com with SMTP id w12so57761466oiw.3
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Apr 2017 05:47:13 -0700 (PDT)
In-Reply-To: <20170425113732.GB5355@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 25 April 2017 at 13:37, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Apr 20, 2017 at 07:28:16PM +0200, Arturo Borrero Gonzalez wrote:
>> In some environments where both nodes of a cluster share all the conntracks,
>> after an initial or manual resync, the conntrack information diverges from
>> node to node.
>>
>> I have observed that this is not due to syncronization problems, given the
>> link between the nodes is very stable and stats show no issues.
>> So, this could be due to every node of the cluster seing slighly different
>> traffic and flow updates, perhaps different tiemouts being applied to
>> the conntracks in every node.
>> A manual resync (using conntrackd -n) resolves these issues inmediately.
>>
>> This new configuration option tells conntrackd to request a resync
>> with the other node, similar to what could happen manually using
>> the 'conntrackd -n' command.
>>
>> By now this option is only valid in NOTRACK sync mode.
>>
>> Example configuration:
>>
>> [...]
>> Sync {
>>         Mode NOTRACK {
>>                 DisableInternalCache on
>>                 DisableExternalCache on
>>                 RequestResync 30
>
> This looks very similar to the timer based approach that it is already
> there. Did you give it a try?
>

Yes. The timer based approach is... timer based (async).

It doesn't fit in an environment where you need to sync events as soon
as they happen.

> This approach doesn't solve nicely the case where you have an entry
> with a large timeout that got out of sync.

My idea is to be able to automatically force-sync nodes every 2 o 3
minutes (in my case).
Users may choose a different time of course. What do you have in mind
for your case in concrete?
