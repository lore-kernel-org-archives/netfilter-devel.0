From: "Fischer, Anna" <anna.fischer@hp.com>
Subject: RE: ip_conntrack fails to track Windows Vista TCP connection
Date: Mon, 14 Jun 2010 18:09:00 +0000
Message-ID: <0199E0D51A61344794750DC57738F58E70B258E34D@GVW1118EXC.americas.hpqcorp.net>
References: <0199E0D51A61344794750DC57738F58E70B258E2B3@GVW1118EXC.americas.hpqcorp.net>
 <4C165596.8020700@trash.net>
 <alpine.LSU.2.01.1006141834280.7212@obet.zrqbmnf.qr>
 <0199E0D51A61344794750DC57738F58E70B258E346@GVW1118EXC.americas.hpqcorp.net>
 <alpine.LSU.2.01.1006141941160.23197@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: Patrick McHardy <kaber@trash.net>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from g1t0029.austin.hp.com ([15.216.28.36]:31692 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab0FNSJk convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Jun 2010 14:09:40 -0400
In-Reply-To: <alpine.LSU.2.01.1006141941160.23197@obet.zrqbmnf.qr>
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> Subject: RE: ip_conntrack fails to track Windows Vista TCP connection
> 
> 
> On Monday 2010-06-14 19:34, Fischer, Anna wrote:
> 
> >>>> [something about Vista and TCP Delayed ACK]
> >>>>
> >>>> Is this a known issue?
> >>>
> >>> You're mentioning ip_conntrack, which is obsoleted for multiple
> >>> years now. Which kernel version are you using?
> >>
> >> By definition of ip_conntrack, that must be older than 2.6.20.
> >
> >Yes, this is a 2.6.18 Xen kernel that I am using. Even if it is
> obsolete, can you let me know if you are aware of such a problem ever
> having caused any issues? I just want to get a feeling if I am at least
> roughly on the right track while figuring out what the problem is.
> 
> The 2.6.18 has a known problem with DSACK even when both
> endpoints are Linux.

My problem is really very specific to connection tracking and so the problem (bug?) is probably in the ip_conntrack_tcp module. TCP communication actually works fine, also connection tracking on (slow, non-bulk data) TCP traffic works. However, it fails with high throughput connections coming from newer Windows (Vista / 7) machines. If I switch those to TCP_NODELAY then it all works again. 
