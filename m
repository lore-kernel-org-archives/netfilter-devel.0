From: Patrick McHardy <kaber@trash.net>
Subject: Re: Large packets received from the queue
Date: Wed, 14 May 2008 10:53:52 +0200
Message-ID: <482AA8A0.5090604@trash.net>
References: <001b01c8b4f8$bf9bb180$5c01a8c0@jimpc> <20080513.181548.155688952.davem@davemloft.net> <20080514084814.GA10392@khasse.inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
To: Eric Leblond <eric@inl.fr>, David Miller <davem@davemloft.net>,
	jameshough@bemac.com, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35617 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362AbYENIyb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 May 2008 04:54:31 -0400
In-Reply-To: <20080514084814.GA10392@khasse.inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> Hello,
> 
> On Tuesday, 2008 May 13 at 18:15:48 -0700, David Miller wrote:
>> From: "james hough" <jameshough@bemac.com>
>> Date: Tue, 13 May 2008 13:56:23 +0100
>>
>>> the problem I have is that my app is receiving larger than MTU packets off 
>>> the queue, often in excess of 2000bytes. The MTU is set to 1500 and the 
>>> problem only seems to occur on outbound traffic when doing file uploads. in 
>>> this case I am doing an FTP put.
>> These are TSO frames, and you must handle them.
> 
> Or maybe just loopback packet and as default loopback MTU is 16436 ;)


Actually we segment TSO frames before queuing because packet
modifications broke TSO. Packets that are going to be fragmented
are received before fragmentation, this shouldn't happen with
TCP however. Maybe there's rerouting involved or something like
that, which could cause TCP to use an incorrect MSS.

In any case Dave is correct, packets larger than the MTU need
to be handled by userspace.

