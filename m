From: Patrick McHardy <kaber@trash.net>
Subject: Re: [rfc] using xor in mark targets
Date: Fri, 30 Nov 2007 00:27:16 +0100
Message-ID: <474F4AD4.5030502@trash.net>
References: <Pine.LNX.4.64.0711292335090.3089@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59722 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757745AbXK2X1r (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Nov 2007 18:27:47 -0500
In-Reply-To: <Pine.LNX.4.64.0711292335090.3089@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> Hi,
>
>
> the usual MARK targets all have something like:
>
> 	newmark = (oldmark & ~mask) | newmark;
>
> in Fall 2007's tproxy patches, the following is used instead:
>
> 	newmark = (oldmark & ~mask) ^ newmark;
>
> this puzzled me at first but looks well-thought. The new xt_TOS
> already uses the XOR variant, to get that extra bit of expressive
> power[1].
>
> I would have liked to do the same for MARK, but I suspect it is not
> quite backwards-compatible with respect to user scripts and
> iptables-save output. So what could be done?
> 	* -j MARK2 --set-mark 0x81/0x7F
> 	* -j MARK --set-mark-v2 0x81/0x7F
> other ideas, thoughts, criticism?
>

Check out:

http://lists.netfilter.org/pipermail/netfilter-devel/2004-June/015718.html

it can be done fully compatible and can express an arbitary amount of
combined bit operations.
