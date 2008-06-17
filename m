From: Patrick McHardy <kaber@trash.net>
Subject: Re: Support NAT-ed expect entries from user space
Date: Tue, 17 Jun 2008 17:05:47 +0200
Message-ID: <4857D2CB.6070909@trash.net>
References: <20080616092148.GB2860@phoenix.home> <4856C8C6.3070309@netfilter.org> <4856D28C.3030302@trash.net> <20080616221759.GM2860@phoenix.home> <4856EC99.6070903@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: BORBELY Zoltan <bozo@andrews.hu>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34080 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757381AbYFQPFu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Jun 2008 11:05:50 -0400
In-Reply-To: <4856EC99.6070903@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> BORBELY Zoltan wrote:
>> On Mon, Jun 16, 2008 at 10:52:28PM +0200, Patrick McHardy wrote:
>>  
>>> I'm wondering, how is this expectation creation working at all?
>>> The NULL expectfn makes me think it will crash as soon as the
>>> expectation arrives. This *needs* support from the helpers to
>>> properly set the expectfn.
>>>     
>>
>> The nf_nat_follow_master did the trick for me if I set the expectation
>> entry from user space. With NULL expectfn it didn't work.
>>   
> 
> Yes, so the kernel is broken.


This turned out to be wrong, the expectfn is optional.

