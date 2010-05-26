From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Help: Cycle through iptables rules
Date: Thu, 27 May 2010 00:13:12 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1005270010000.30857@obet.zrqbmnf.qr>
References: <AANLkTiliv-YLViJ9hgnRY_rnFYYIfjnupo-NOE9tru1y@mail.gmail.com> <1274861468.2672.9.camel@edumazet-laptop> <alpine.LSU.2.01.1005261142470.8695@obet.zrqbmnf.qr> <AANLkTilFXTT5kKPCTD7Re8Xzeg6UoKlDUJJvWPCGJXRd@mail.gmail.com>
 <alpine.LSU.2.01.1005262215010.30857@obet.zrqbmnf.qr> <1274905649.2542.1.camel@edumazet-laptop> <AANLkTikl9W9Ij6ODywJQQ2X-OHau7eCVPXRrP0P2hWBt@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Felipe W Damasio <felipewd@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:47319 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754736Ab0EZWNN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 May 2010 18:13:13 -0400
In-Reply-To: <AANLkTikl9W9Ij6ODywJQQ2X-OHau7eCVPXRrP0P2hWBt@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2010-05-26 23:49, Felipe W Damasio wrote:
>
>  Why did you suggest the "--tproxy-mark I/0xff" part on the first email?
>
>  Why can't I let the old "--tproxy-mark 0x1/0x1"?

I was not sure what you need the proxy mark for anyway,
but I just figured it was for local routing :>
