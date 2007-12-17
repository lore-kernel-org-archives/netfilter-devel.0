From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Change xt_TOS v1 target to zero-out semantic
Date: Mon, 17 Dec 2007 14:04:24 +0100
Message-ID: <476673D8.50701@trash.net>
References: <Pine.LNX.4.64.0712151447250.22877@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57124 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571AbXLQNFL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 08:05:11 -0500
In-Reply-To: <Pine.LNX.4.64.0712151447250.22877@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> This patch changes the behavior of xt_TOS v1 so that the mask value
> one supplies means "zero out these bits" rather than "keep these
> bits". This is more easy on the user, as (I would assume) people
> keep more bits than zeroing, so, an example:
> 
> 	Action: Set bit 0x01.
> 	before: iptables -j TOS --set-tos 0x01/0xFE
> 	after:  iptables -j TOS --set-tos 0x01/0x01
> 
> This is not too "tragic" with xt_TOS, but where larger fields are
> used (e.g. proposed xt_MARK v2), `--set-xmark 0x01/0xFFFFFFFE` vs.
> `--set-xmark 0x01/0x01` is really a worthy difference.
> Other modules, such as xt_TPROXY also use &~ rather than &, so
> let's find a common ground.

I'm going to apply this, but only if we're going to have
an easier to use userspace extension for this.

I'd prefer:

--set-tos: set exact value, no mask
--or-tos: set single bits
--xor-tos: flip single bits
--and-tos: mask single bits
