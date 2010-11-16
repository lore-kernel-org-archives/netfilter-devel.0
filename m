From: David Miller <davem@davemloft.net>
Subject: Re: iproute2: use automake
Date: Mon, 15 Nov 2010 17:59:28 -0800 (PST)
Message-ID: <20101115.175928.104078108.davem@davemloft.net>
References: <1289859785-3098-1-git-send-email-jengelh@medozas.de>
	<20101115142600.66a7e3c3@nehalam>
	<alpine.LNX.2.01.1011152327430.3784@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: shemminger@vyatta.com, stephen.hemminger@vyatta.com,
	netfilter-devel@vger.kernel.org
To: jengelh@medozas.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53353
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759167Ab0KPB7D (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Nov 2010 20:59:03 -0500
In-Reply-To: <alpine.LNX.2.01.1011152327430.3784@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jan Engelhardt <jengelh@medozas.de>
Date: Mon, 15 Nov 2010 23:30:46 +0100 (CET)

> Not using something standardized is an affront to distributors,
> and the build instructions just a sore for the eye:

Making the build take 10 times longer is more of an affront
than what you accuse iproute2 of doing.

Please do not do this, I absolutely hate working on source
trees that use this crap!
