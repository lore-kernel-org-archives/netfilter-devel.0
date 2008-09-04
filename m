From: Patrick McHardy <kaber@trash.net>
Subject: Re: 5/7 [NETFILTER]: Introduce NFPROTO_* constants
Date: Thu, 04 Sep 2008 16:59:38 +0200
Message-ID: <48BFF7DA.9030808@trash.net>
References: <alpine.LNX.1.10.0808131925160.13154@fbirervta.pbzchgretzou.qr> <alpine.LNX.1.10.0808131935220.13154@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63712 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbYIDO7j (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Sep 2008 10:59:39 -0400
In-Reply-To: <alpine.LNX.1.10.0808131935220.13154@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Patrick McHardy wrote, I remember:
> 
>> What about PF_DECnet?
> 
> Good spot. Netfilter would have crashed when trying to access 
> nf_hooks[PF_DECnet], because the array was not big enough. Added 
> NFPROTO_DECNET which implies an increased NFPROTO_NUMPROTO so that the 
> out-of-bounds access is gone.
> 
> commit e3666c7f73328a3762136f07e29e52386d05d21e
> Author: Jan Engelhardt <jengelh@computergmbh.de>
> Date:   Wed Aug 13 19:38:42 2008 -0400
> 
> [NETFILTER]: Introduce NFPROTO_* constants
> 
> The netfilter subsystem only supports a handful of protocols (much
> less than PF_*) and even non-PF protocols like ARP and
> pseudo-protocols like PF_BRIDGE. By creating NFPROTO_*, we can earn a
> few memory savings on arrays that previously were always PF_MAX-sized
> and keep the pseudo-protocols to ourselves.

Looks great, applied.
