From: Patrick McHardy <kaber@trash.net>
Subject: Re: Large packets received from the queue
Date: Wed, 14 May 2008 12:09:55 +0200
Message-ID: <482ABA73.5080109@trash.net>
References: <20080513.181548.155688952.davem@davemloft.net>	<20080514084814.GA10392@khasse.inl.fr>	<482AA8A0.5090604@trash.net> <20080514.030605.175448517.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: eric@inl.fr, jameshough@bemac.com, netfilter-devel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37498 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873AbYENKKf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 May 2008 06:10:35 -0400
In-Reply-To: <20080514.030605.175448517.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

David Miller wrote:
> From: Patrick McHardy <kaber@trash.net>
> Date: Wed, 14 May 2008 10:53:52 +0200
> 
>> Actually we segment TSO frames before queuing because packet
>> modifications broke TSO.
> 
> We fixed that, or at least I thought we did :)


Yes, by segmenting :) At least thats what I thought, James
observation seems to contradict this. I'll run some tests
myself if I can find some time ...

