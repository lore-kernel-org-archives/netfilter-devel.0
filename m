From: Patrick McHardy <kaber@trash.net>
Subject: Re: [patch] netfilter: xt_LOG: do print MAC header on FORWARD
Date: Mon, 15 Nov 2010 11:24:58 +0100
Message-ID: <4CE10A7A.90808@trash.net>
References: <alpine.LNX.2.01.1011141901020.21430@obet.zrqbmnf.qr> <alpine.LNX.2.01.1011150229410.13295@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61655 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755393Ab0KOKY5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Nov 2010 05:24:57 -0500
In-Reply-To: <alpine.LNX.2.01.1011150229410.13295@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 15.11.2010 02:30, Jan Engelhardt wrote:
> netfilter: xt_LOG: do print MAC header on FORWARD
> 
> I am observing consistent behavior even with bridges, so let's unlock
> this. xt_mac is already usable in FORWARD, too. Section 9 of
> http://ebtables.sourceforge.net/br_fw_ia/br_fw_ia.html#section9 says
> the MAC source address is changed, but my observation does not match
> that claim -- the MAC header is retained.

I've checked the code and I think you're right, even IPsec tunnels
make sure to preserve the original MAC header.

Applied, thanks.
