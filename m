From: Alexander Duyck <alexander.h.duyck@redhat.com>
Subject: Re: [iptables PATCH] list: fix prefetch dummy
Date: Tue, 07 Apr 2015 10:45:32 -0700
Message-ID: <552417BC.6050807@redhat.com>
References: <20150406180541.7031.97131.stgit@nfdev2.cica.es> <552326ED.9040500@gmail.com> <alpine.LSU.2.20.1504071036001.29221@nerf40.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	netfilter-devel@vger.kernel.org, kaber@trash.net,
	pablo@netfilter.org
To: Jan Engelhardt <jengelh@inai.de>,
	Alexander Duyck <alexander.duyck@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40705 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752620AbbDGRpf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Apr 2015 13:45:35 -0400
In-Reply-To: <alpine.LSU.2.20.1504071036001.29221@nerf40.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On 04/07/2015 01:37 AM, Jan Engelhardt wrote:
> On Tuesday 2015-04-07 02:38, Alexander Duyck wrote:
>
>> On 04/06/2015 11:05 AM, Arturo Borrero Gonzalez wrote:
>>> linux_list.h:381:59: warning: right-hand operand of comma expression has no effect [-Wunused-value]
>>>    for (pos = list_entry((head)->next, typeof(*pos), member), \
>>>                                                             ^
>>> libiptc.c:552:2: note: in expansion of macro 'list_for_each_entry'
>>>    list_for_each_entry(c, &h->chains, list) {
>>>    ^
>>>
>>> [ Patch copied from one similar of Patrick McHardy on libnftnl ]
>>>
>>> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
>>> ---
>>>   libiptc/linux_list.h |    2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/libiptc/linux_list.h b/libiptc/linux_list.h
>>> index abdcf88..559e33c 100644
>>> --- a/libiptc/linux_list.h
>>> +++ b/libiptc/linux_list.h
>>> @@ -27,7 +27,7 @@
>>>   	1; \
>>>   })
>>>   
>>> -#define prefetch(x)		1
>>> +#define prefetch(x)		((void)0)
>>>   
>>>   /* empty define to make this work in userspace -HW */
>>>   #define smp_wmb()
>>>
>> Why not just use "do {} while (0)"?  I know that is what is used in the
>> kernel for functions that don't do anything.
> I may be getting the terms wrong, but:
> do{}while(0) is not an expression, it is a (block) control statement.
> In particular, do{}while(0) won't evaluate to an rvalue.

Right.  That is the point in this case.  I am assuming what Arturo is 
trying to accomplish since you shouldn't be able to evaluate ((void)0) 
as an rvalue either.

The prefetch(x) is an empty statement which is being cast as a void to 
avoid a compiler warning, so it falls into the first case as defined in: 
http://kernelnewbies.org/FAQ/DoWhile0

- Alex
