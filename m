From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/3] bridge-netfilter: Fix MAC header handling with IP
 DNAT
Date: Thu, 15 Apr 2010 12:27:23 +0200
Message-ID: <4BC6EA0B.10604@trash.net>
References: <4BC5BFB0.8030305@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Stephen Hemminger <shemminger@linux-foundation.org>
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60578 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337Ab0DOK1Y (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Apr 2010 06:27:24 -0400
In-Reply-To: <4BC5BFB0.8030305@pandora.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Bart De Schuymer wrote:
> bridge-netfilter: Fix MAC header handling with IP DNAT
> 
> - fix IP DNAT on vlan- or pppoe-encapsulated traffic: The functions
> neigh_hh_output() or dst->neighbour->output() overwrite the complete
> Ethernet header, although we only need the destination MAC address.
> For encapsulated packets, they ended up overwriting the encapsulating
> header. The new code copies the Ethernet source MAC address and
> protocol number before calling dst->neighbour->output(). The Ethernet
> source MAC and protocol number are copied back in place in 
> br_nf_pre_routing_finish_bridge_slow(). This also makes the IP DNAT 
> more transparent because in the old scheme the source MAC of the 
> bridge was copied into the source address in the Ethernet header. We 
> also let skb->protocol equal ETH_P_IP resp. ETH_P_IPV6 during the 
> execution of the PF_INET resp. PF_INET6 hooks.
> - Speed up IP DNAT by calling neigh_hh_bridge() instead of
> neigh_hh_output(): if dst->hh is available, we already know the MAC
> address so we can just copy it.

Applied, thanks Bart.
