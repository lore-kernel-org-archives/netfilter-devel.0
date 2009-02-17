From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: iptables, ipsec, and host2host
Date: Tue, 17 Feb 2009 19:52:12 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902171946520.999@fbirervta.pbzchgretzou.qr>
References: <alpine.LRH.2.00.0902170903140.25041@q7.q7.com> <499B0097.4000505@trash.net> <alpine.LRH.2.00.0902171029560.25041@q7.q7.com> <alpine.LSU.2.00.0902171940330.999@fbirervta.pbzchgretzou.qr> <alpine.LRH.2.00.0902171044460.25041@q7.q7.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Joe Pruett <joey@clean.q7.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:58752 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbZBQSwO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Feb 2009 13:52:14 -0500
In-Reply-To: <alpine.LRH.2.00.0902171044460.25041@q7.q7.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2009-02-17 19:46, Joe Pruett wrote:
> On Tue, 17 Feb 2009, Jan Engelhardt wrote:
>
>> ipip is not used for ipsec.
>
> my reading of the code was that in tunnel mode, the next protocol
> header is ip and so the packet then gets handed off to the ip-ip
> handler.

Still the ipip.ko module (used for creating an explicit tunnel
interface) is not used nor required to be loaded.

When an ESP packet with IPv4 outer address is received, the function
ip_rcv() will eventually deal with it, moved to the xfrm decoder and
then reinjected by calling netif_rx (see xfrm_input.c) on the skb
with its decoded payload.

Also, do not confuse IP-in-ESP-over-IPv4 with IP-(in/over)-IP.
For about every router and subsystem other than xfrm, there
is no way to look into ESP payload and hence, it's just
ESP-on-IPv4 or ESP-on-IPv6.
