Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DA33C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Apr 2022 18:32:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231178AbiDBSd6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 2 Apr 2022 14:33:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbiDBSd6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 2 Apr 2022 14:33:58 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D905F21809
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Apr 2022 11:32:05 -0700 (PDT)
Message-ID: <f0d8b097-a5bf-0093-650d-56f05ae7e65e@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1648924322;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sByHJwn3u9QXZzZQVigUNxN83Attc9aL0pWVantOGbY=;
        b=sInJ36ZWKHFm6+kMUWR3SFtSET/tDT6EZJuIpyv4lLzfAO7mgzRl+LCOdQAbqPBA6I7D7y
        CTdwMPLM6HoiMWjZhmP1W0ZHoq1GnFT4KY0PEqpRSeGZeZ2/mczHJMC/mD43M3jKSfbUvQ
        a7hMMEwO+rSYLnTz47zejCDi0QDQQjs=
Date:   Sat, 2 Apr 2022 21:32:00 +0300
MIME-Version: 1.0
Subject: Re: troubles caused by conntrack overlimit in init_netns
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>, edumazet@google.com
Cc:     netfilter-devel@vger.kernel.org, kernel@openvz.org
References: <de70cc55-6c11-d772-8b08-e8994fd934a0@openvz.org>
 <80f0f13f-d671-20fb-ffe6-5903f653c9ed@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Vasily Averin <vasily.averin@linux.dev>
In-Reply-To: <80f0f13f-d671-20fb-ffe6-5903f653c9ed@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 4/2/22 20:12, Eric Dumazet wrote:
> 
> On 4/2/22 03:33, Vasily Averin wrote:
>> Pablo, Florian,
>>
>> There is an old issue with conntrack limit on multi-netns (read container) nodes.
>>
>> Any connection to containers hosted on the node creates a conntrack in init_netns.
>> If the number of conntrack in init_netns reaches the limit, the whole node becomes
>> unavailable.
> 
> Can you describe network topology ?

              += veth1 <=> veth container1
ethX <=> brX =+= veth2 <=> veth container2
              += vethX <=> veth containerX

> Are you using macvlan, ipvlan, or something else ?

No, we dod not used it earlier, because it was not available in RHEL7, 
but now it looks like good solution for me.

Thank you for the hint,
	Vasily Averin
