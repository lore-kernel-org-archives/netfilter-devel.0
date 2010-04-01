From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: uisng L7 filter in ebtables commands
Date: Thu, 01 Apr 2010 08:51:38 +0200
Message-ID: <4BB4427A.3020706@pandora.be>
References: <x2v861e3bca1003311124sa0aa2ab6y94fa42c650ef16f8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: agashi shipora <gashipo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:56894 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045Ab0DAGvl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Apr 2010 02:51:41 -0400
In-Reply-To: <x2v861e3bca1003311124sa0aa2ab6y94fa42c650ef16f8@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

agashi shipora wrote:
> I want to use L7 filter with ebtables for setting a MARK on the packet
> similar to how it is being done with iptables today.
> 
> Using brouting the bridge packet can be re-directed to the routing
> path traversing the iptables.But all packets arriving on the interface
> enslaved to the bridge would have to be brouted.This may not be
> acceptable as a solution in my case.
> 
> example:
> Whats available:
> iptables -t filter -A FORWARD -m layer7 --l7proto edonkey -j MARK --set-mark 3
> 
> What needs to be supported:
> ebtables -t nat -A PRE-ROUTING -m layer7 --l7proto edonkey -j MARK --mark-set 3
> 
> Is any work going on to port L7 filter to ebtables or does this port
> of L7 filter already exist?
> 

You can use iptables to filter bridged IP traffic, so I don't see the
problem. Just make sure /proc/sys/net/bridge/bridge-nf-call-iptables
contains 1. No need for brouting.

cheers,
Bart


-- 
Bart De Schuymer
www.artinalgorithms.be
