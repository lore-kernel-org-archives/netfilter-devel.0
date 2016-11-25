From: Gao Feng <fgao@ikuai8.com>
Subject: Re: [PATCH net-next 1/1] netfilter: xt_multiport: Fix wrong unmatch
 result with multiple ports
Date: Fri, 25 Nov 2016 12:19:47 +0800
Message-ID: <CA+6hz4p6BXKoDCj6ct_4E3_7e5T0Kx2Yk=nX3u=KQg-YgvdtoQ@mail.gmail.com>
References: <1480046337-9521-1-git-send-email-fgao@ikuai8.com> <1480047115.8455.531.camel@edumazet-glaptop3.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbg65.qq.com ([103.7.28.233]:41950 "EHLO smtpbg65.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751543AbcKYET4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Nov 2016 23:19:56 -0500
Received: from mail-vk0-f45.google.com (unknown [209.85.213.45])
        by esmtp4.qq.com (ESMTP) with SMTP id 0
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Nov 2016 12:19:48 +0800 (CST)
Received: by mail-vk0-f45.google.com with SMTP id x186so36373922vkd.1
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2016 20:19:49 -0800 (PST)
In-Reply-To: <1480047115.8455.531.camel@edumazet-glaptop3.roam.corp.google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Nov 25, 2016 at 12:11 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On Fri, 2016-11-25 at 11:58 +0800, fgao@ikuai8.com wrote:
>> From: Gao Feng <fgao@ikuai8.com>
>>
>> I lost one test case in the commit for xt_multiport.
>> For example, the rule is "-m multiport --dports 22,80,443".
>> When first port is unmatched and the second is matched, the curent codes
>> could not return the right result.
>> It would return false directly when the first port is unmatched.
>>
>> Fixes: dd2602d00f80 ("netfilter: xt_multiport: Use switch case instead
>> of multiple condition checks")
>>
>> Signed-off-by: Gao Feng <fgao@ikuai8.com>
>
> Note that the Fixes: tag should immediately precede your
> 'Signed-off-by:'
>
> No empty new line between the two tags.

OK, I get it and will send another update.

Regards
Feng

>
> Thanks.
>
>


