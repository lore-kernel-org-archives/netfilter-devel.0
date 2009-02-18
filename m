From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2 v5] New netfilter target to trigger LED devices
Date: Wed, 18 Feb 2009 15:14:26 +0100
Message-ID: <499C17C2.9020502@trash.net>
References: <49934702.9060909@shikadi.net> <4993B34C.1020307@trash.net>	 <49940D58.3040404@shikadi.net>  <49998E6C.2030504@trash.net> <1234878654.5312.34.camel@dax.rpnet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Adam Nielsen <a.nielsen@shikadi.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Richard Purdie <rpurdie@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53702 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbZBROOa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Feb 2009 09:14:30 -0500
In-Reply-To: <1234878654.5312.34.camel@dax.rpnet.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Richard Purdie wrote:
> On Mon, 2009-02-16 at 17:03 +0100, Patrick McHardy wrote:
>> Adam Nielsen wrote:
>>> Kernel module providing implementation of LED netfilter target.  Each
>>> instance of the target appears as a led-trigger device, which can be
>>> associated with one or more LEDs in /sys/class/leds/
>>>
>>> Signed-off-by: Adam Nielsen <a.nielsen@shikadi.net>
>>>
>>> ---
>>>
>>> Thanks for the feedback Patrick - here is the updated version with
>>> your suggestions:
>>>
>>>  - Mutexes removed - I concede that missing a blink here and there
>>>    is acceptable :-)
>>>  - KERN_ERR used for non-critical errors, all KERN_NOTICEs removed
>>>  - Split assignment out from comparison in kzalloc()
>>>
>>> Hope this one's okay!
>> Apart from some minor cosmetic issues that I'm simply going to
>> fix up when applying, it looks fine to me. If Richard is also
>> ok with this I'll apply it.
> 
> Looks good to me.
> 
> Acked-by: Richard Purdie <rpurdie@linux.intel.com>

Thanks Richard.

Adam, I wanted to apply this, but I get rejects for every single
existing file. There appears to be some whitespace damage, please
resend as attachment.
