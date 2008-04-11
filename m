From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Add new target in mangle table
Date: Fri, 11 Apr 2008 10:32:05 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0804111029500.21182@fbirervta.pbzchgretzou.qr>
References: <1207899903.8402.31.camel@mscheub-lapi.Simpsons>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Manu <manuprivat@gmx.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:47296 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757813AbYDKIcH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Apr 2008 04:32:07 -0400
In-Reply-To: <1207899903.8402.31.camel@mscheub-lapi.Simpsons>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2008-04-11 09:45, Manu wrote:

>Hi developers,
>
>I encountered difficulties during integrating a new target in mangle
>table (iptables-1.4.0 (from www.netfilter.org), kernel-2.6.23 (from
>www.kernel.org)). 
>I have a master from iptables-1.2.9 and kernel-2.6.3. But there were too
>many differences and changes be made.
>The idea behind to add the target is, that a user who has a fix-ip entry
>in his network settings can be handled from a gateway, for which the new
>targets should be implemented. for example:
>
># iptables -t mangle -I PREROUTING -i eth2 -s 192.168.0.168 -j SADDR
>--to-source 10.0.19.2


This looks pretty much like RAWNAT, as posted in 
http://marc.info/?l=netfilter-devel&m=120024054521550&w=2 .

