From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [ANNOUNCE] ipset-2.3.2
Date: Fri, 4 Jul 2008 16:01:12 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0807041600150.1890@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0807021449020.32444@blackhole.kfki.hu> <200807031044.37410.ludwig.nussel@suse.de> <Pine.LNX.4.64.0807031504180.1816@blackhole.kfki.hu> <200807041553.41535.ludwig.nussel@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Ludwig Nussel <ludwig.nussel@suse.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:53840 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840AbYGDOBP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Jul 2008 10:01:15 -0400
In-Reply-To: <200807041553.41535.ludwig.nussel@suse.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2008-07-04 15:53, Ludwig Nussel wrote:
>
>AFAICS one has to manually add PF_EXT_SLIB+=set SET to

Not in 1.4.1 and up, which is what you should be using.
Also, since you come from @suse.de, I might infer that ipset
is a candidate for the distro kernel in which case one would
rather want it as additional modules.

