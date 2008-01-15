From: Patrick McHardy <kaber@trash.net>
Subject: Re: snat local packets and arp
Date: Tue, 15 Jan 2008 17:32:34 +0100
Message-ID: <478CE022.8060703@trash.net>
References: <BAY103-DAV7CA14E24ECEE3A4B320ADB2470@phx.gbl> <478CD804.4060309@trash.net> <BAY103-DAV64218D9B751E58807E019B2470@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Marco Berizzi <pupilla@hotmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44108 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbYAOQcr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jan 2008 11:32:47 -0500
In-Reply-To: <BAY103-DAV64218D9B751E58807E019B2470@phx.gbl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Marco Berizzi wrote:
> Patrick McHardy wrote:
> 
>>> Running ping adsl.129 stop linux from arping the
>>> adsl.129 router.
>> I don't get it. You say this box is using adsl.129 as
>> nexthop for the locally generated squid packets.
> 
> Yes I'm using this dirty trick:
> 
> iptables -t mangle -I PREROUTING ... --dports 80,443 -j MARK
> --set-mark 1
> ip rule add fwmark 1 table adsl prio 400
> 
> #ip route sh table adsl
> default via adsl.129 dev eth0
> 
>> So whats wrong with sending arp queries for that router?
> 
> I don't understand why it is sending arp queries for
> the adsl router every minute and it doesn't send a single
> arp query for hours to the other hdsl router.

Do the routers send arp queries to the Linux box?
