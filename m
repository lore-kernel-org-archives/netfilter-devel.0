From: Patrick McHardy <kaber@trash.net>
Subject: Re: TCP connection tracking timeout
Date: Tue, 29 Jul 2008 08:13:05 +0200
Message-ID: <488EB4F1.60806@trash.net>
References: <20080729030104.GA15915@gondor.apana.org.au> <488EA0F1.2050906@trash.net> <488EA3FE.7050503@trash.net> <20080729060105.GA16797@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40842 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbYG2GN6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jul 2008 02:13:58 -0400
In-Reply-To: <20080729060105.GA16797@gondor.apana.org.au>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Herbert Xu wrote:
> On Tue, Jul 29, 2008 at 07:00:46AM +0200, Patrick McHardy wrote:
>>> That sounds like a pretty neat idea. I'm testing a patch now, I'll
>>> send it over in a few minutes if it survives :)
>>>       
>
> Awesome! I'll try this out on my router.
>
>   
>> This seems to work. I'm wondering however if this will really help.
>> We already track retransmissions and decrease the timeout on the
>> 3rd retransmission, so this should only help if both the sender and
>> the receiver went down.
>>     
>
> The problem with requiring a 3rd retransmit is that once a socket
> is orphaned (closed) on Linux, we fast-track the retransmit timeout
> process.  In particular, if it's already maxed out the RTO prior
> to closing, we'll kill it straight away.
>
> This is in violation of the RFCs but it's an important optimisation.

Thanks for this explanation. Unless Jozsef sees something wrong with this
patch, I'll queue it with a proper changelog. Its small enough, so perhaps
we can even put this in 2.6.27.


