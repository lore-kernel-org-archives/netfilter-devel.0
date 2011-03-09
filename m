From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 1/2] netfilter: ipt_addrtype: rename to xt_addrtype
Date: Wed, 9 Mar 2011 20:54:32 +0100
Message-ID: <20110309195432.GX8821@Chamillionaire.breakpoint.cc>
References: <1299341328-4663-1-git-send-email-fw@strlen.de>
 <4D76471E.8050503@trash.net>
 <alpine.LNX.2.01.1103092006131.9143@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:34139 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751320Ab1CITyd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Mar 2011 14:54:33 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1103092006131.9143@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt <jengelh@medozas.de> wrote:
> On Tuesday 2011-03-08 16:11, Patrick McHardy wrote:
> 
> >Am 05.03.2011 17:08, schrieb Florian Westphal:
> >> From: Florian Westphal <fwestphal@astaro.com>
> >> 
> >> followup patch will add ipv6 support.
> >> 
> >> Signed-off-by: Florian Westphal <fwestphal@astaro.com>
> >> ---
> >>  include/linux/netfilter/Kbuild                     |    1 +
> >>  .../ipt_addrtype.h => netfilter/xt_addrtype.h}     |   16 +++++-----
> >
> >Please keep this file and the original definitions for a while
> >(add to feature-removal-schedule) for compatibility. You can
> >redefine them to the xt_ values/structures so they can be used
> >inside the kernel.
> 
> Just like ipt_realm.h does, yeah.

Sorry, redefining structures and enums is really not my cup of tea.

If thats really what you would prefer (as opposed to keeping the file
as-is) I can send a V3 patch that includes xt_addrtype.h and then
re-defines the enums/structures with the ipt_ prefixes.

But personally I would prefer to just keep it as-is and then remove it
in a year or so.
