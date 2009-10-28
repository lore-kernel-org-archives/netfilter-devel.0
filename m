From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] [BRIDGE-NETFILTER] make IP DNAT work on bridged vlan/pppoe
 packets
Date: Wed, 28 Oct 2009 16:50:03 +0100
Message-ID: <4AE8682B.4070807@trash.net>
References: <4AE2E8E5.3040605@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60265 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338AbZJ1PuF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 Oct 2009 11:50:05 -0400
In-Reply-To: <4AE2E8E5.3040605@pandora.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Bart De Schuymer wrote:
> Hi,
> 
> The attached patch makes IP DNAT work on bridged IP packets encapsulated
> in a VLAN/PPoE packet. I only tested that it works for VLAN, but the
> PPoE case should be fixed too.
> This bug was introduced by commit
> 2948d2ebbb98747b912ac6d0c864b4d02be8a6f5 on January 12, 2008.
> The patch also makes IP DNATing more transparent on a bridge: for
> bridged-and-dnated traffic, the source MAC address is no longer changed
> to the MAC address of the bridge port. If one wants, ebtables snat can
> be used to change the source MAC address in the POSTROUTING chain.

Applied, thanks Bart.
