From: Vijay Tandeker <vijayt@india.tejasnetworks.com>
Subject: Re: Locally transmitted Multicast packets are being looped back,
 even if IP_MULTICAST_LOOP option is set to zero
Date: Wed, 5 Jun 2013 19:43:29 +0530
Message-ID: <51AF4789.9090807@india.tejasnetworks.com>
References: <51AF172C.9090803@india.tejasnetworks.com> <1370440003.24311.249.camel@edumazet-glaptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "netfilter@vger.kernel.org" <netfilter@vger.kernel.org>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.india.tejasnetworks.com ([164.164.94.83]:37992 "EHLO
	smtp.india.tejasnetworks.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755403Ab3FEOJD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Jun 2013 10:09:03 -0400
In-Reply-To: <1370440003.24311.249.camel@edumazet-glaptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thanks Eric for your quick reply. Sorry but in linux-2.6.32, IP_NODEFRAG 
option is not supported. Is this a new socket option to fix this problem ?

Regards,
Vijay

On Wednesday 05 June 2013 07:16 PM, Eric Dumazet wrote:
> On Wed, 2013-06-05 at 16:17 +0530, Vijay Tandeker wrote:
>
>    
>> My questions:-
>>    - Is this done intentionally ?
>>    - If No, please suggest the solution to restore skb->sk pointer.
>>    - If Yes, please suggest the solution to restore skb->sk pointer.
>>
>> Kindly let me know in case if the problem is not clear or you need any
>> more data.
>>
>>      
> Have you tried
>
> int one = 1;
> setsockopt(fd, SOL_IP, IP_NODEFRAG,&one, sizeof(one));
>
>
>    
