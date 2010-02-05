From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 0/7] netfilter: ebtables: CONFIG_COMPAT support
Date: Fri, 05 Feb 2010 10:02:41 -0800 (PST)
Message-ID: <20100205.100241.17593999.davem@davemloft.net>
References: <alpine.LSU.2.01.1002050807580.16226@obet.zrqbmnf.qr>
	<20100205140021.GB21611@Chamillionaire.breakpoint.cc>
	<4B6C5231.7040702@pandora.be>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org
To: bdschuym@pandora.be
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42771
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933516Ab0BESC2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Feb 2010 13:02:28 -0500
In-Reply-To: <4B6C5231.7040702@pandora.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Bart De Schuymer <bdschuym@pandora.be>
Date: Fri, 05 Feb 2010 18:15:29 +0100

> At this time I am more in favor of fixing userland...

Compatability issues between 32-bit and 64-bit interfaces
when running on a 64-bit kernel should _always_ be handled
in the kernel via the compat layer.

Every attempt to do this in userspace somehow been ugly and has
utterly failed.
