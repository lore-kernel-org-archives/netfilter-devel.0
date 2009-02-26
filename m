From: David Miller <davem@davemloft.net>
Subject: Re: [patch 5/7] make netfilter use strict integer types
Date: Wed, 25 Feb 2009 16:55:52 -0800 (PST)
Message-ID: <20090225.165552.32040707.davem@davemloft.net>
References: <20090225235138.062045835@arndb.de>
	<20090225235515.682333715@arndb.de>
	<alpine.LSU.2.00.0902260104220.20789@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: arnd@arndb.de, hpa@zytor.com, sam@ravnborg.org, kyle@infradead.org,
	mingo@elte.hu, jaswinderrajput@gmail.com, mingo@redhat.com,
	dwmw2@infradead.org, linux-kernel@vger.kernel.org,
	linux-arch@vger.kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
To: jengelh@medozas.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33959
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752321AbZBZA4J (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Feb 2009 19:56:09 -0500
In-Reply-To: <alpine.LSU.2.00.0902260104220.20789@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jan Engelhardt <jengelh@medozas.de>
Date: Thu, 26 Feb 2009 01:10:25 +0100 (CET)

> 
> On Thursday 2009-02-26 00:51, arnd@arndb.de wrote:
> 
> >Netfilter traditionally uses BSD integer types in its
> >interface headers. This changes it to use the Linux
> >strict integer types, like everyone else.
> 
> I _strongly disagree_ with this move. Userspace also has the uintX
> types via <stdint.h>/<cstdint>, and now you are adding a dependency
> on linux/types.h, not to mention that your step can lead to compile
> time piling up.
> 
> IMHO, __uXX should be replaced by uintX_t, but a move this great I
> will leave to future generations because there is just too much
> persisting opinions wrt. such proposal. As such I'd like to join
> and persist on my position and that uintX that we have should be kept.

Disagreed, I think we should have done what Arnd is doing
a long time ago.

Ending up with linux/types.h in userspace for these kinds of
interfaces is already a fore-gone conclusion, it happens
already whether you like it or not.

And existing apps will work just fine, since they are already
getting stdint.h

As for compile time, since you're already getting linux/types.h
in your apps it's a non-argument.  But even if it was, what
are you compiling netfilter utilities on?  A VAX?
