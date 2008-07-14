From: Patrick McHardy <kaber@trash.net>
Subject: Re: 04/14 [NETFILTER]: xt_recent: IPv6 support
Date: Mon, 14 Jul 2008 15:28:52 +0200
Message-ID: <487B5494.6040307@trash.net>
References: <alpine.LNX.1.10.0807101522400.27323@fbirervta.pbzchgretzou.qr> <alpine.LNX.1.10.0807101524590.27323@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44781 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbYGNNaU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Jul 2008 09:30:20 -0400
In-Reply-To: <alpine.LNX.1.10.0807101524590.27323@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> commit ffffffffffffffffffffffffffffffffffffffff
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Thu Jan 31 04:36:12 2008 +0100
> 
> [NETFILTER]: xt_recent: IPv6 support
> 
> This updates xt_recent to support the IPv6 address family.
> The new /proc/net/xt_recent directory must be used for this.


I'm still missing the config option for the old proc interface
I've asked for.
