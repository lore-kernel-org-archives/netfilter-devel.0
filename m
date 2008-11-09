From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 2/2] New netfilter target to trigger LED devices
Date: Sun, 9 Nov 2008 20:58:19 +0300
Message-ID: <20081109175819.GA3127@x200.localdomain>
References: <4916E4F0.8010507@shikadi.net> <20081109171039.GA3287@x200.localdomain> <alpine.LNX.1.10.0811091839580.22255@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Adam Nielsen <a.nielsen@shikadi.net>,
	netfilter-devel@vger.kernel.org,
	Richard Purdie <rpurdie@openedhand.com>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:18380 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755532AbYKIRy5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Nov 2008 12:54:57 -0500
Received: by ey-out-2122.google.com with SMTP id 6so811021eyi.37
        for <netfilter-devel@vger.kernel.org>; Sun, 09 Nov 2008 09:54:55 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0811091839580.22255@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Nov 09, 2008 at 06:40:39PM +0100, Jan Engelhardt wrote:
> 
> On Sunday 2008-11-09 18:10, Alexey Dobriyan wrote:
> 
> >On Sun, Nov 09, 2008 at 11:26:08PM +1000, Adam Nielsen wrote:
> >> +	/*noconst*/struct xt_led_info_internal *ledinternal =
> >>                        ledinfo->internal_data;
> >	  ^^^^^^^
> >What is this?
> 
> A C89-style comment?

I'm talking about noconst. Utterly pointless.
