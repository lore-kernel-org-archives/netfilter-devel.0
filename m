From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [rfc] using xor in mark targets
Date: Mon, 3 Dec 2007 16:03:17 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711300120310.3089@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0711292335090.3089@fbirervta.pbzchgretzou.qr>
 <474F4AD4.5030502@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:54786 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbXLCPDS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Dec 2007 10:03:18 -0500
In-Reply-To: <474F4AD4.5030502@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Nov 30 2007 00:27, Patrick McHardy wrote:
>> I would have liked to do the same for MARK, but I suspect it is not
>> quite backwards-compatible with respect to user scripts and
>> iptables-save output. So what could be done?
>>  * -j MARK2 --set-mark 0x81/0x7F
>>  * -j MARK --set-mark-v2 0x81/0x7F
>> other ideas, thoughts, criticism?
>
> Check out:
>
> http://lists.netfilter.org/pipermail/netfilter-devel/2004-June/015718.html
>
> it can be done fully compatible and can express an arbitary amount of
> combined bit operations.
>

Well yes yes... but that was not what I was asking about.


I was asking what name I should give to the option that enables
"new-style" handling (origmark & ~mask ^ val):

	--set-extended-mark val/mask

because it is not sooo extended after all, just a different notation of 
what libxt_MARK takes right now.

