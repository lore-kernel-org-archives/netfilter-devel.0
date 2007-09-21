From: Patrick McHardy <kaber@trash.net>
Subject: Re: skb_over_panic arround  __nfa_fill
Date: Fri, 21 Sep 2007 14:36:13 +0200
Message-ID: <46F3BABD.6020500@trash.net>
References: <OFD318F7C8.DB5B1BFF-ONC125735C.0056DE41-C125735C.0057933B@mindspeed.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: laurent.brando@mindspeed.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63468 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710AbXIUMoC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Sep 2007 08:44:02 -0400
In-Reply-To: <OFD318F7C8.DB5B1BFF-ONC125735C.0056DE41-C125735C.0057933B@mindspeed.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

laurent.brando@mindspeed.com wrote:
> Hi Patrick,
> 
> Here is the 'magical' line:
> 
> skb_over_panic: text:bf1981c0 len:48 put:8 head:c080d000 data:c080d01c 
> tail:c080d014 end:c080df40 dev:<NULL>
> Internal error: Oops: 817 [#1]


skb_over_panic is only called when skb->tail > skb->end, in your case
there's still room for 3884 bytes. Are you using any external patches/
drivers/...? If so please try to reproduce without them, otherwise
please post the full oops and disassembly of __nfa_fill.
