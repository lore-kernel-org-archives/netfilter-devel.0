From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 00/04]: Netfilter fixes
Date: Mon, 08 Sep 2008 14:44:16 +0200
Message-ID: <48C51E20.2040503@trash.net>
References: <20080904141553.6414.87829.sendpatchset@x2.localnet> <20080907.182330.201693956.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41073 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbYIHMoU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Sep 2008 08:44:20 -0400
In-Reply-To: <20080907.182330.201693956.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

David Miller wrote:
> From: Patrick McHardy <kaber@trash.net>
> Date: Thu,  4 Sep 2008 16:15:53 +0200 (MEST)
> 
>> following are four netfilter fixes for 2.6.27, containing:
>>
>> - fix for a accidentally introduced static variable in the SIP helper
>>   that was intended to be local from Alexey
>>
>> - a GRE helper keymap locking and list iteration fix from Alexey
>>
>> - a patch to make the IRC helpers' port parsing more robust against the
>>   issues pointed out by Alexey
> 
> I applied all of this.
> 
> Please limit the scope of anything you send in the future outside of
> the merge window.  The "kfree the list head instead of the object itself"
> doesn't fix anything, the code worked in it's current form.

Indeed, sorry. I was in catch-up mode and apparently didn't think
very much :)
