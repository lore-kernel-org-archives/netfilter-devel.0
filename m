From: Richard Purdie <rpurdie@linux.intel.com>
Subject: Re: [PATCH 2/2 v5] New netfilter target to trigger LED devices
Date: Tue, 17 Feb 2009 13:50:54 +0000
Message-ID: <1234878654.5312.34.camel@dax.rpnet.com>
References: <49934702.9060909@shikadi.net> <4993B34C.1020307@trash.net>
	 <49940D58.3040404@shikadi.net>  <49998E6C.2030504@trash.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Adam Nielsen <a.nielsen@shikadi.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:62625 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945AbZBQNsu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Feb 2009 08:48:50 -0500
In-Reply-To: <49998E6C.2030504@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Mon, 2009-02-16 at 17:03 +0100, Patrick McHardy wrote:
> Adam Nielsen wrote:
> > Kernel module providing implementation of LED netfilter target.  Each
> > instance of the target appears as a led-trigger device, which can be
> > associated with one or more LEDs in /sys/class/leds/
> > 
> > Signed-off-by: Adam Nielsen <a.nielsen@shikadi.net>
> > 
> > ---
> > 
> > Thanks for the feedback Patrick - here is the updated version with
> > your suggestions:
> > 
> >  - Mutexes removed - I concede that missing a blink here and there
> >    is acceptable :-)
> >  - KERN_ERR used for non-critical errors, all KERN_NOTICEs removed
> >  - Split assignment out from comparison in kzalloc()
> > 
> > Hope this one's okay!
> 
> Apart from some minor cosmetic issues that I'm simply going to
> fix up when applying, it looks fine to me. If Richard is also
> ok with this I'll apply it.

Looks good to me.

Acked-by: Richard Purdie <rpurdie@linux.intel.com>

-- 
Richard Purdie
Intel Open Source Technology Centre

