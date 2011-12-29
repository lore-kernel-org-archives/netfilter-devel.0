From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: ebtables-2.0.9-2 libebetc PHONY
Date: Thu, 29 Dec 2011 18:34:36 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1112291833550.2463@frira.zrqbmnf.qr>
References: <20110609231131.GA6508@lemonhead.scabb>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Bertrand Jacquin <beber@meleeweb.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:46276 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204Ab1L2Rej (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Dec 2011 12:34:39 -0500
In-Reply-To: <20110609231131.GA6508@lemonhead.scabb>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2011-06-10 01:11, Bertrand Jacquin wrote:

>Hi,
>
>ebtables-v2.0.9-2 declare libebetc.so as PHONY. I'm wondering why. In my
>case I'm cross-compiling it and define CC only for compilation. So when
>running "make install" libebtc.so is one more time builded without CC
>defined, so it failed :

Indeed that does not make sense. Well, the PHONY mark is gone anyway in 
v2.0.10, so all the better :)


