From: Alexander Duyck <alexander.h.duyck@redhat.com>
Subject: Re: [iptables PATCH] list: fix prefetch dummy
Date: Tue, 07 Apr 2015 12:29:25 -0700
Message-ID: <55243015.8020402@redhat.com>
References: <20150406180541.7031.97131.stgit@nfdev2.cica.es> <552326ED.9040500@gmail.com> <alpine.LSU.2.20.1504071036001.29221@nerf40.vanv.qr> <552417BC.6050807@redhat.com> <alpine.LSU.2.20.1504072010530.17563@nerf40.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Alexander Duyck <alexander.duyck@gmail.com>,
	Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	netfilter-devel@vger.kernel.org, kaber@trash.net,
	pablo@netfilter.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40147 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906AbbDGT3h (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Apr 2015 15:29:37 -0400
In-Reply-To: <alpine.LSU.2.20.1504072010530.17563@nerf40.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 04/07/2015 11:17 AM, Jan Engelhardt wrote:
>
> On Tuesday 2015-04-07 19:45, Alexander Duyck wrote:
>>>>>   -#define prefetch(x)		1
>>>>> +#define prefetch(x)		((void)0)
>>>>>
>>>> Why not just use "do {} while (0)"?  I know that is what is used in the
>>>> kernel for functions that don't do anything.
>>> I may be getting the terms wrong, but:
>>> do{}while(0) is not an expression, it is a (block) control statement.
>>> In particular, do{}while(0) won't evaluate to an rvalue.
>>
>> Right.  That is the point in this case.  I am assuming what Arturo is trying to
>> accomplish since you shouldn't be able to evaluate ((void)0) as an rvalue
>> either.
>
> The difference is that
>
> 	int i;
> 	i = 1, (void)0;
>
> compiles, while
>
> 	i = 1, do{}while(0);
>

Okay, that explains it.  It is being used inside the init, condition, 
and post process sections of a for loop.  Thanks for explaining it.

- Alex
