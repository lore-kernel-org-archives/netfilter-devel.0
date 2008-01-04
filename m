From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 17/27] xt_pkttype: Add explicit check for IPv4
Date: Fri, 04 Jan 2008 16:24:48 +0100
Message-ID: <477E4FC0.40607@trash.net>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0801022130070.14900@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49438 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbYADP1v (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Jan 2008 10:27:51 -0500
In-Reply-To: <Pine.LNX.4.64.0801022130070.14900@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> commit 7843dd922e769bfadded963e59645a2e21e6fd34
> Author: Jan Engelhardt <jengelh@computergmbh.de>
> Date:   Wed Jan 2 18:24:19 2008 +0100
> 
>     [NETFILTER]: xt_pkttype: Add explicit check for IPv4
>     
>     In the PACKET_LOOPBACK case, the skb data was always interpreted as
>     IPv4, but that is not valid for IPv6, obviously. Fix this by adding an
>     extra condition to check for AF_INET.
>     
>     Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

Applied, thanks.
