From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2 v5] New netfilter target to trigger LED devices
Date: Mon, 16 Feb 2009 17:03:56 +0100
Message-ID: <49998E6C.2030504@trash.net>
References: <49934702.9060909@shikadi.net> <4993B34C.1020307@trash.net> <49940D58.3040404@shikadi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, rpurdie@linux.intel.com
To: Adam Nielsen <a.nielsen@shikadi.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62057 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbZBPQEB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Feb 2009 11:04:01 -0500
In-Reply-To: <49940D58.3040404@shikadi.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Adam Nielsen wrote:
> Kernel module providing implementation of LED netfilter target.  Each
> instance of the target appears as a led-trigger device, which can be
> associated with one or more LEDs in /sys/class/leds/
> 
> Signed-off-by: Adam Nielsen <a.nielsen@shikadi.net>
> 
> ---
> 
> Thanks for the feedback Patrick - here is the updated version with
> your suggestions:
> 
>  - Mutexes removed - I concede that missing a blink here and there
>    is acceptable :-)
>  - KERN_ERR used for non-critical errors, all KERN_NOTICEs removed
>  - Split assignment out from comparison in kzalloc()
> 
> Hope this one's okay!

Apart from some minor cosmetic issues that I'm simply going to
fix up when applying, it looks fine to me. If Richard is also
ok with this I'll apply it.
