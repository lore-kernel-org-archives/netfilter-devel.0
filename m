From: Patrick McHardy <kaber@trash.net>
Subject: Re: Whither xt_SYSRQ?
Date: Fri, 14 May 2010 12:23:00 +0200
Message-ID: <4BED2484.2000206@trash.net>
References: <4BE96A66.4040607@oracle.com> <4BE98E80.2000804@trash.net> <4BED1478.9090604@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Netfilter Core Team <coreteam@netfilter.org>
To: John Haxby <john.haxby@oracle.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41804 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab0ENKXC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 May 2010 06:23:02 -0400
In-Reply-To: <4BED1478.9090604@oracle.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

John Haxby wrote:
> On 11/05/10 18:06, Patrick McHardy wrote:
>> John Haxby wrote:
>>   
>>> The standalone module is troublesome.  If I was starting from scratch
>>> with that I'd be putting in filters and whatnot that match those
>>> provides by xtables anyway.  If everything apart from the actual
>>> function (sysrq) and password control is duplicated by xtables then
>>> you'd have to ask "why isn't this part of xtables?".
>>>      
>> The main point for putting it in a stand-alone module is that it
>> is providing a network service. You could still use netfilter to
>> filter packets of course. I don't see where the big trouble is,
>> instead of using netfilter for receiving packets, you open up
>> a socket. That's basically it.
>>
>>   
> 
> /me slaps forehead
> 
> Sometimes the obvious just fails to make it through.  Yes, that makes a
> good deal of sense, I'll see how it pans out.  I'm currently wondering
> what happens when a machine is locked up whether or not I can get the
> service scheduled (one way or another) -- the netfilter stuff seems to
> be pretty robust in the face of machines locking up quite hard.

Netfilter receive processing runs in BH context. Its a bit of a hack,
but you could run your code in the same context by using a UDP socket
and marking it as encapsulation socket, see udp_queue_rcv_skb().

>> Lets see what other netfilter developers think, I'm easy to convince:)
>> One thing I'd like to see in any case however is review of the crypto
>> parts by the crypto people.
>>    
> 
> I'd like to see that as well.  I _think_ I've got the crypto stuff right
> but I do know that self-review for anything security related is
> basically worthless.  (As Bruce Schneier said, paraphrased slightly: any
> fool can produce a security solution that they can't crack.)

I'd suggest to copy the linux-crypto list on the next submission and
ask for review.
