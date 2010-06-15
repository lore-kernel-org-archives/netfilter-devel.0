From: "Fischer, Anna" <anna.fischer@hp.com>
Subject: RE: ip_conntrack fails to track Windows Vista TCP connection
Date: Tue, 15 Jun 2010 16:15:42 +0000
Message-ID: <0199E0D51A61344794750DC57738F58E70B258E939@GVW1118EXC.americas.hpqcorp.net>
References: <0199E0D51A61344794750DC57738F58E70B258E2B3@GVW1118EXC.americas.hpqcorp.net>
 <4C165596.8020700@trash.net>
 <alpine.LSU.2.01.1006141834280.7212@obet.zrqbmnf.qr>
 <0199E0D51A61344794750DC57738F58E70B258E346@GVW1118EXC.americas.hpqcorp.net>
 <4C16E405.40705@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: Jan Engelhardt <jengelh@medozas.de>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from g4t0015.houston.hp.com ([15.201.24.18]:19884 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820Ab0FOQSU convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jun 2010 12:18:20 -0400
In-Reply-To: <4C16E405.40705@trash.net>
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> Subject: Re: ip_conntrack fails to track Windows Vista TCP connection
> 
> Fischer, Anna wrote:
> >>> You're mentioning ip_conntrack, which is obsoleted for multiple
> >>> years now. Which kernel version are you using?
> >>>
> >> By definition of ip_conntrack, that must be older than 2.6.20.
> >>
> >
> > Yes, this is a 2.6.18 Xen kernel that I am using. Even if it is
> obsolete, can you let me know if you are aware of such a problem ever
> having caused any issues? I just want to get a feeling if I am at least
> roughly on the right track while figuring out what the problem is.
> >
> 
> We've had a couple of problems related to related to
> acknowledgement numbers in TCP conntrack, I'd suggest
> you check the nf_conntrack_proto_tcp.c changelogs,
> basically everything in there should also apply to
> the old version.

Thanks for your advice. Why would the problem be in nf_conntrack_proto_tcp and not in ip_conntrack_proto_tcp?
