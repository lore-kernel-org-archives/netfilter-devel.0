From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH v2 5/6] netfilter: tarpit: Add IPv6 support
Date: Mon, 9 Jul 2012 20:46:42 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1207092016370.5417@frira.zrqbmnf.qr>
References: <1341771085-5771-1-git-send-email-johunt@akamai.com> <1341771085-5771-6-git-send-email-johunt@akamai.com> <alpine.LNX.2.01.1207082125590.11837@frira.zrqbmnf.qr> <4FFAE45D.6070603@akamai.com> <alpine.LNX.2.01.1207091855540.1876@frira.zrqbmnf.qr>
 <4FFB14B4.6040801@akamai.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Josh Hunt <johunt@akamai.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:42849 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981Ab2GISqn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Jul 2012 14:46:43 -0400
In-Reply-To: <4FFB14B4.6040801@akamai.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2012-07-09 19:28, Josh Hunt wrote:
>> I held it off; this is now all merged.
>
> Awesome, thanks!
>
> I know this just got accepted to xtables-addons, but I was wondering what the
> process is to possibly get this merged into Linus' tree?

You send the files that are in xtables-addons to whoever is taking care
of the Linux kernel business (currently that seems to be Pablo), of course
in a form that is acceptable for the Linux kernel (i.e. minus xtables-addons
lines).

>I know I've seen some things go from xtables-addons to his tree,
>xt_TEE comes to mind. Is tarpitting (the concept) something that
>would be accepted?

It certainly seems well-desired by $users. And normally, inclusion
is to follow demand (that's how squashfs got in, IIRC). Expect
to defend your case when making it upstream. Solicit more "we want
this opinions" :)
