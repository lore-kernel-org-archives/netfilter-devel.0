From: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: Re: [PATCH] netfilter: xt_socket: Restore mark from full sockets only
Date: Thu, 21 Sep 2017 15:45:21 -0600
Message-ID: <a8455bbfc89590fe4f6ca79d65092d07@codeaurora.org>
References: <1506028832-8981-1-git-send-email-subashab@codeaurora.org>
 <1506029567.29839.150.camel@edumazet-glaptop3.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40566 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751728AbdIUVpW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Sep 2017 17:45:22 -0400
In-Reply-To: <1506029567.29839.150.camel@edumazet-glaptop3.roam.corp.google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>> 
>>  		if (info->flags & XT_SOCKET_RESTORESKMARK && !wildcard &&
>> -		    transparent)
>> +		    transparent && sk_fullsock(sk))
>>  			pskb->mark = sk->sk_mark;
>> 
>>  		if (sk != skb->sk)
> 
> What about socket_mt6_v1_v2_v3() ?
> 
> Thanks.

Hi Eric

I missed that instance. I'll update it in v2.

-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a 
Linux Foundation Collaborative Project
