Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13619C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Apr 2022 19:52:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233101AbiDBTy0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 2 Apr 2022 15:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbiDBTyZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 2 Apr 2022 15:54:25 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6369BD1124
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Apr 2022 12:52:32 -0700 (PDT)
Message-ID: <487738da-49a7-90fc-7e22-5b60fb16af44@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1648929150;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T+y8G00mxctiWiizAWJUAuC7WjUIky4iOnCl7ar6vG8=;
        b=Ruv4zKhk+kCpN3U9lnyiD0bSumyM0njEarCxETyw76L+Bqjgtgg/3sRKEdJCQvsBqsSf/7
        xXDVZTjUestln07pONy9XvrUAIrPxl8lm2iEpHvwuWk37rAfJVeQnmK52JAbmYkGdGUxPf
        OT+FMEpZt5YQ1MrS6+aEJqOR8apcKMw=
Date:   Sat, 2 Apr 2022 22:52:29 +0300
MIME-Version: 1.0
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Vasily Averin <vasily.averin@linux.dev>
Subject: Re: troubles caused by conntrack overlimit in init_netns
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, kernel@openvz.org
References: <de70cc55-6c11-d772-8b08-e8994fd934a0@openvz.org>
 <80f0f13f-d671-20fb-ffe6-5903f653c9ed@gmail.com>
 <f0d8b097-a5bf-0093-650d-56f05ae7e65e@linux.dev>
 <CANn89iKy_2bQJw7_iyTTVA0yMvzkHkUp4DtriieNC3AV1D-SUw@mail.gmail.com>
In-Reply-To: <CANn89iKy_2bQJw7_iyTTVA0yMvzkHkUp4DtriieNC3AV1D-SUw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 4/2/22 21:50, Eric Dumazet wrote:
> On Sat, Apr 2, 2022 at 11:32 AM Vasily Averin <vasily.averin@linux.dev> wrote:
>>
>> On 4/2/22 20:12, Eric Dumazet wrote:
>>>
>>> On 4/2/22 03:33, Vasily Averin wrote:
>>>> Pablo, Florian,
>>>>
>>>> There is an old issue with conntrack limit on multi-netns (read container) nodes.
>>>>
>>>> Any connection to containers hosted on the node creates a conntrack in init_netns.
>>>> If the number of conntrack in init_netns reaches the limit, the whole node becomes
>>>> unavailable.
>>>
>>> Can you describe network topology ?
>>
>>               += veth1 <=> veth container1
>> ethX <=> brX =+= veth2 <=> veth container2
>>               += vethX <=> veth containerX
>>
> 
> Could you simply add an iptables rule in init_net to bypass conntrack
> for idev=veth* ?
> 
> iptables -t raw -I PREROUTING -i veth+ -j NOTRACK
> 
> (I have not worked with conntrack in recent years, this might be foolish...)

Great and simple idea.
Thank you very much, we'll investigate it.

	Vasily Averin
